import copy
from datetime import datetime

from openai import OpenAI
from pytz import timezone

from config import llm_api_key, llm_base_url, MODEL_DIALOGUE
from utils import time_date_prompt, save_session, finish_session
from dialogue_monitor.dialogue_monitor_agent import monitor_dialogue
from risk_assessment.risk_assessment_agent import risk_assessor
from personalization_engine.advice_agent import generate_advice
from dialogue_orchestrator.advice_communicator import transition_to_context
from personalization_engine.auxiliary import is_next_step, is_previous_step, need_contextualization

client = OpenAI(api_key=llm_api_key, base_url=llm_base_url)
LLM = MODEL_DIALOGUE


def api_caller(messages, **kwargs):
    # Remove any personally identifiable information before calling the LLM API.
    # messages = filter_information(messages)
    resp = client.chat.completions.create(
        model=LLM,
        messages=messages,
        **kwargs
    )
    return resp.choices[0].message.content


STATE_INQUIRY          = 'inquiry'
STATE_DIAGNOSIS        = 'diagnosis'
STATE_DELIVER_RISK     = 'deliver_risk'
STATE_GUIDENCE         = 'guidence'
STATE_DELIVER_ADVICE   = 'deliver_advice'
STATE_DONE             = 'done'


class DialogueOrchestrator:
    """State-machine controller that manages the conversation flow."""

    def __init__(self, session_id, session, user_profile, dialogue_agent):
        self.session_id = session_id
        self.session = session
        self.user_profile = user_profile
        self.ai = dialogue_agent
        self.state = STATE_INQUIRY
        self.report = None
        self.advice = None
        self.history = list(dialogue_agent.messages_base)


    @property
    def current_state(self):
        return self.state

    def set_state(self, new_state):
        self.state = new_state

    def is_terminal(self):
        return self.state == STATE_DONE

    def _persist(self):
        """Persist the conversation history to the session store."""
        self.session['history'] = self.history
        save_session(self.session_id, self.session)

    @staticmethod
    def _show_help():
        print()
        print("--- Commands ---")
        print("  Type to chat    : Chat with the assistant")
        print("  /help           : Show this help")
        print("  /quit           : Exit the program")
        print()
        print("The system performs the collaborative diagnostic guidance logic.")
        print()


    def _handle_inquiry(self, user_input):
        """Conduct information elicitation and manage the conversation."""

        self.history.append({'role': 'user', 'content': user_input})

        # Dialogue-monitor agent tracks assessment completeness and invokes
        # the risk assessment module when ready.
        unchecked = self.session['check_agent_fields']
        print("[monitor]: Evaluating interaction completeness...")
        verdict = monitor_dialogue(self.history, unchecked)
        self.history[-1]['monitor'] = verdict

        if verdict[0]:
            print("[monitor]: Proceeding to risk assessment...")
            self.state = STATE_DELIVER_RISK
            self._persist()
            return  # caller will continue the outer loop

        self.session['check_agent_fields'] = verdict[2]
        tip = f'Continue chatting, aspects: {verdict[1]}'
        self.history = list(filter(
            lambda x: not (x['role'] == 'system' and 'aspects' in x.get('content', '')),
            self.history
        ))
        self.history.append({'role': 'system', 'content': tip})
        print(f"[monitor]: check failed on: {verdict[1]}")

        print("[dialogue]:", flush=True)
        response = self.ai.handle_question(self.history)
        self.history.append({'role': 'assistant', 'content': response})
        print(f"Assistant: {response}")

    def _handle_deliver_risk(self):
        """Integrate outputs from downstream modules to deliver personalized risk feedback."""

        print("[risk assessment]: Presenting the risk feedback...", flush=True)
        self.report = risk_assessor(self.history, self.user_profile['register_info'])

        self.history.append({'role': 'assistant', 'content': self.report})
        self._persist()

        print(f"Assistant:\n{self.report}")
        user_input = input("You: ").strip()

        # Determine the next action based on the user's current interaction state during 
        # the communication of the assessment results.
        if is_next_step(user_input):
            self.history.append({'role': 'user', 'content': user_input})
            self.state = STATE_GUIDENCE
            self._persist()
        elif is_previous_step(user_input):
            self.history.append({'role': 'user', 'content': user_input})
            response = ""
            self.history.append({'role': 'assistant', 'content': response})
            self.state = STATE_INQUIRY
            self.report = None
            print(f"Assistant: {response}")
        else:
            self.history.append({'role': 'user', 'content': user_input})
            response = self.ai.handle_question(self.history)
            self.history.append({'role': 'assistant', 'content': response})
            print(f"Assistant: {response}")

    def _handle_guidence(self):
        """Integrate outputs from downstream modules to deliver tailored guidance."""

        self.advice = generate_advice(self.history, self.report, self.user_profile['register_info'])
        self.history.append({'role': 'assistant', 'content': self.advice})
        self._persist()

        print(f"Assistant:\n{self.advice}")
        print()

        user_input = input("You: ").strip()
        if not need_contextualization(user_input):
            # Session end
            self.history.append({'role': 'user', 'content': user_input})
            self.state = STATE_DONE
            self._persist()
        else:
            # Contextualization
            self.history = transition_to_context(self.history, self.advice)
            print("[dialogue]:", flush=True)
            response = self.ai.handle_question(self.history)
            self.history.append({'role': 'assistant', 'content': response})
            print(f"Assistant: {response}")



    def run(self):
        """Execute the main conversation loop."""

        greeting = self.ai.get_greeting()
        self.history.append({'role': 'assistant', 'content': greeting})
        self._persist()
        print(f"Assistant: {greeting}")
        print()
        self._show_help()

        while not self.is_terminal():
            try:
                user_input = input("You: ").strip()
            except (EOFError, KeyboardInterrupt):
                print("\n\nExiting...")
                break

            if not user_input:
                continue

            if user_input == '/quit':
                print("Assistant: Thank you for your willingness to chat with me!")
                self.state = STATE_DONE
                continue

            if user_input == '/help':
                self._show_help()
                continue

            if self.state == STATE_INQUIRY:
                self._handle_inquiry(user_input)
            elif self.state == STATE_DELIVER_RISK:
                self._handle_deliver_risk()
            elif self.state == STATE_GUIDENCE:
                self._handle_guidence()

            self._persist()
            print()

        if self.state == STATE_DONE:
            print("Session end.")
            finish_session(self.session_id)


class Assistant:

    def __init__(self, user_info):
        # Prompt codesigned through the community-engaged approach described in the Article.
        self.dialogue_agent_system_prompt = ""

        self.messages_base = [
            {'role': 'system', 'content': self.dialogue_agent_system_prompt}
        ]

    def get_greeting(self):
        hour = datetime.now().hour
        if 5 <= hour < 11:
            return "Good morning! How are you doing today?"
        elif 11 <= hour < 14:
            return "Good afternoon! How has your day been?"
        elif 14 <= hour < 18:
            return "Good afternoon! How are things going?"
        elif 18 <= hour < 24:
            return "Good evening! How was your day?"
        else:
            return "Hello! How are you doing tonight?"

    def handle_question(self, history):
        history = copy.deepcopy(history)
        return api_caller(history)

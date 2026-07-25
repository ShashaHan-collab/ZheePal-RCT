from openai import OpenAI

from config import llm_api_key, llm_base_url, MODEL_ADVICE
from utils import time_date_prompt
from personalization_engine.context_retriever import format_policy_context, retrieve_health_policies

client = OpenAI(api_key=llm_api_key, base_url=llm_base_url)
LLM_agent = MODEL_ADVICE


def generate_advice(chat: list, report: str, user_info: dict) -> str:
    related_context = format_policy_context(retrieve_health_policies(user_info))
    # Prompt codesigned through the community-engaged approach described in the Article.
    adive_prompt = ""

    advice += related_context
    
    chat_filtered = [msg for msg in chat if msg.get('role') != 'system']
    data = str(chat_filtered)

    message = [
        {'role': 'system', 'content': adive_prompt},
        {'role': 'user', 'content': f"```Conversation history:\n{data}\n\nRisk assessment report:\n{report}```"}
    ]

    # Remove personally identifiable information before calling the LLM API.
    # messages = filter_information(messages)
    response = client.chat.completions.create(
        model=LLM_agent,
        messages=message,
        temperature=0.2
    )
    return response.choices[0].message.content

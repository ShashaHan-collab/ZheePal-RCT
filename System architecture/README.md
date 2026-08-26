## Directory Structure

```
System architecture
│
├── main.py
│
├── config.py
│
├── utils.py
│
├── requirements.txt
│
├──  prompt_templates_examples.py
│
├── dialogue_orchestrator
│   │
│   ├── dialogue_orchestrator.py
│   │
│   └── advice_communicator.py
│
├── dialogue_monitor
│   │
│   └── dialogue_monitor_agent.py
│
├── risk_assessment
│   │
│   └── risk_assessment_agent.py
│
└── personalization_engine
    │
    ├── dialogue_adaption.py
    │
    ├── context_retriever.py
    │
    ├── advice_agent.py
    │
    ├── user_profile.py
    │
    └── auxiliary.py                                       
```

## File Descriptions

### entry point & configuration

| File | Role |
|---|---|
| `main.py` | Application entry point. |
| `config.py` | Central configuration – API keys, model names, and data paths. |
| `utils.py` | Session I/O utilities and helper functions. |
| `requirements.txt` | Python package dependencies. |

### dialogue_orchestrator/

| File | Role |
|---|---|
| `dialogue_orchestrator.py` | Manages the conversation flow and state transitions. |
| `advice_communicator.py` | Delivers tailored advice to the user at the appropriate stage. |

### dialogue_monitor/

| File | Role |
|---|---|
| `dialogue_monitor_agent.py` | Monitors the conversation and triggers an assessment based on its evaluation of the dialogue. |

### risk_assessment/

| File | Role |
|---|---|
| `risk_assessment_agent.py` | Conducts health risk assessment across the designated health domains. |

### personalization_engine/

| File | Role |
|---|---|
| `dialogue_adaption.py` | Shapes context-aware responses to match the user's background and conversation context. |
| `context_retriever.py` | Retrieves national and local health promotion policies and healthcare resources. |
| `advice_agent.py` | Generates personalized advice based on assessment results and user context. |
| `user_profile.py` | Manages user background. |
| `auxiliary.py` | Supporting functions for personalization and context handling. |

### prompt templates
prompt_templates_examples.py contains illustrative English prompt templates for the main agents, including `DIALOGUE_AGENT_PROMPT`, `MONITOR_PROMPT`, `RISK_ASSESSMENT_PROMPT`, `ADVICE_PROMPT`, `INTENT_PROMPT`. These examples are sufficient to run the demo.

**Important**:
These prompts are for demonstration only. They are not direct translations of the production prompts. The prompts used in the real-world trial were written in Chinese and developed through the community-engaged codesign process described in the Article.

## Demo Quick Start

### 1. Install Dependencies

Requires **Python 3.7+**.

```bash
cd "System architecture"
pip install -r requirements.txt
```

Only three packages are required: `openai`, `pytz`, `pydantic`.

### 2. Configure and Start the Program

(1) **Rename the example prompt file**:

```bash
mv prompt_templates_examples.py prompts.py
```

(2) **Configure `config.py`**:
   - `llm_api_key` / `llm_base_url` — your OpenAI-compatible API endpoint
   - `MODEL_*` — the model names used by the dialogue orchestrator, monitor, risk-assessment, and personalization agents

(3) **Launch the program**:

```bash
python main.py
```

On startup, the program collects a short registration profile (9 fields, `attr_1`–`attr_9`), creates a session, and the assistant greets you.

### 3. Chat, Exit, and Session Persistence

- **Chat**: type your message at the `You:` prompt and press Enter.
- **`/help`**: show the available commands.
- **`/quit`**: end the conversation and exit (Ctrl+C / Ctrl+D also exit).


### Ethics Statement

- This is a **research prototype for demonstration purposes only**. It is not a medical device and does not provide diagnosis, treatment, or professional cognitive or mental health care. The system is **not a substitute for professional help**. Individuals in distress or crisis should immediately seek support from qualified professionals or local emergency services.
- Demo data is stored locally on your machine. **Do not run this demo with real personal data**. Data collected in the real-world RCT is governed by the informed-consent and privacy framework described in the Article.



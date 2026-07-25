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

### Entry Point & Configuration

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




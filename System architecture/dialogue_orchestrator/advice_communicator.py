from openai import OpenAI

from config import llm_api_key, llm_base_url, MODEL_ADVICE
from prompts import CONTEXTUALIZATION_PROMPT

client = OpenAI(api_key=llm_api_key, base_url=llm_base_url)
LLM_agent = MODEL_ADVICE


def transition_to_context(chat: list, advice: str) -> list:
    chat = list(filter(lambda x: x['role'] != 'system', chat))

    new_history = chat.copy()
    new_history.append({'role': 'system', 'content': CONTEXTUALIZATION_PROMPT})
    return new_history

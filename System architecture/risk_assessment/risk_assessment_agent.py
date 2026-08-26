from openai import OpenAI

from config import llm_api_key, llm_base_url, MODEL_SCREENING
from prompts import RISK_ASSESSMENT_PROMPT

client = OpenAI(api_key=llm_api_key, base_url=llm_base_url)
LLM_agent = MODEL_SCREENING


def risk_assessor(chat: list, user_info: dict) -> str:
    data = str(chat)
    message = [
        {'role': 'system', 'content': RISK_ASSESSMENT_PROMPT},
        {'role': 'user', 'content': f"```{data}```"}
    ]

    # Remove personally identifiable information before calling the LLM API.
    # messages = filter_information(messages)
    response = client.chat.completions.create(
        model=LLM_agent,
        messages=message,
        temperature=0.2
    )
    return response.choices[0].message.content

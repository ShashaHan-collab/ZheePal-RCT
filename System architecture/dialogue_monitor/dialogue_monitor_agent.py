
from openai import OpenAI
from pydantic import BaseModel

from config import llm_api_key, llm_base_url, MODEL_JUDGE

client = OpenAI(api_key=llm_api_key, base_url=llm_base_url)
LLM_agent = MODEL_JUDGE

DIRC_MAP = {
    'field_1': 'Aspect 1',
    'field_2': 'Aspect 2',
    'field_3': 'Aspect 3',
    'field_4': 'Aspect 4',
    'field_5': 'Aspect 5',
    'field_6': 'Aspect 6',
    'field_7': 'Aspect 7',
    'field_8': 'Aspect 8',
    'field_9': 'Aspect 9'
} # Health dimensions identified through the co-design process.

class CoverageCheck(BaseModel):
    """Structured output indicating whether each health dimension has been covered (yes/no)."""
    field_1: str
    field_2: str
    field_3: str
    field_4: str
    field_5: str
    field_6: str
    field_7: str
    field_8: str
    field_9: str
    #  Health dimensions identified through the co-design process.


# Prompt codesigned through the community-engaged approach described in the Article.
MONITOR_PROMPT = ""


def _extract_false_fields(data: str) -> list:
    """Parse a string of field assignments and return field names where the value is 'no'."""
    fields = data.split()
    return [field.split('=')[0] for field in fields if "'no'" in field]


def monitor_dialogue(chat: list, raw_dirc: list) -> list:
    """Evaluate whether sufficient information has been gathered across all health dimensions.

    Args:
        chat: The conversation history.
        dimensions_to_check: List of dimension keys still needing coverage.

    Returns:
        A list containing [is_complete: bool, missing_dimensions_summary: str, missing_dimensions: list].
    """
    chat_filtered = [msg for msg in chat if msg.get('role') != 'system']
    data = str(chat_filtered)

    message = [
        {'role': 'system', 'content': MONITOR_PROMPT},
        {'role': 'user', 'content': f"```{data}```"}
    ]

    # Remove personally identifiable information before calling the LLM API. 
    # messages = filter(messages)
    response = client.beta.chat.completions.parse(
        model=LLM_agent,
        messages=message,
        response_format=CoverageCheck,
        temperature=0.2
    )
    res = str(response.choices[0].message.parsed)
    dirc = _extract_false_fields(res)
    dirc = list(set(dirc) & set(raw_dirc))
    dirc_str = ', '.join([DIRC_MAP[f] for f in dirc])

    if len(dirc) != 0:
        return [False, dirc_str, dirc]
    return [True, dirc_str, dirc]

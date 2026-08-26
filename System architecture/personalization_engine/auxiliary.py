from openai import OpenAI
from pydantic import BaseModel

from config import llm_api_key, llm_base_url, MODEL_INTENT
from prompts import INTENT_PROMPT

client = OpenAI(api_key=llm_api_key, base_url=llm_base_url)
LLM = MODEL_INTENT


class IntentResult(BaseModel):
    intent: str  
    confidence: str
    reason: str

def analyze_intent(user_input: str, context: str = "") -> IntentResult:
    """Classify user intent with LLM structured output."""
    context_hint = f"Conversation stage: {context}" if context else ""

    # De-identify sensitive information before invoke LLM API 
    # user_input = filter_information(user_input)
    
    message = [
        {'role': 'system', 'content': INTENT_PROMPT},
        {'role': 'user', 'content': f"{context_hint}\n\nUser message: \"{user_input}\""}
    ]
    response = client.beta.chat.completions.parse(
        model=LLM,
        messages=message,
        response_format=IntentResult,
        temperature=0.2
    )
    return response.choices[0].message.parsed


def is_next_step(text: str) -> bool:
    """Check if the user acknowledges the assessment and wants to proceed to the next step."""
    return analyze_intent(text, context="").intent == "next_step"


def is_previous_step(text: str) -> bool:
    """Check if the user wants to add or modify information before proceeding."""
    return analyze_intent(text, context="").intent == "previous_step" 


def need_contextualization(text: str) -> bool:
    """Check if the user wants wants to engage in simulation exercises or opts for practical applicability and contextual fit of the guidance."""
    return analyze_intent(text, context="").intent == "need_contextualization" 

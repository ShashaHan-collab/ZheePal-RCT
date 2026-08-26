from personalization_engine.user_profile import user_prompt
from prompts import ADAPTATION_TEMPLATE, USER_CONTEXT_INSTRUCTION

def build_adapted_system_prompt(
    user_info: dict,
    base_prompt: str = "",
) -> str:
    user_background = user_prompt(user_info)
    if not user_background.strip():
        return base_prompt

    return ADAPTATION_TEMPLATE.format(
        base_prompt=base_prompt,
        user_background=user_background,
    )


def inject_user_context(messages: list[dict], user_info: dict) -> list[dict]:
    user_background = user_prompt(user_info)

    context_block = (
        f"[USER BACKGROUND]\n"
        f"{user_background}\n\n"
        f"{USER_CONTEXT_INSTRUCTION}"
    )
    insert_at = 1 if len(messages) > 0 else 0
    messages.insert(insert_at, {"role": "system", "content": context_block})
    return messages

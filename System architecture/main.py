#!/usr/bin/env python3
"""
Entry point script: Initializes the session and runs the dialogue orchestrator.
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from dialogue_orchestrator.dialogue_orchestrator import Assistant, DialogueOrchestrator
from personalization_engine.context_retriever import format_policy_context, retrieve_health_policies
from prompts import RELATED_POLICIES_SECTION
from utils import create_session_by_user_id, load_session, load_user_info_by_session_id
from personalization_engine.user_profile import collect_user_info
from personalization_engine.dialogue_adaption import build_adapted_system_prompt


def banner():
    print("=" * 60)
    print("  Multi-agent health promotion system")
    print("=" * 60)
    print()


def main():
    banner()

    user_id = collect_user_info()
    print()

    session_id = create_session_by_user_id(user_id)
    session = load_session(session_id)
    user_profile = load_user_info_by_session_id(session_id)
    print(f"Session created: {session_id}")
    print()

    ai = Assistant(user_profile['register_info'])
    adapted_prompt = build_adapted_system_prompt(
        user_profile['register_info'],
        base_prompt=ai.dialogue_agent_system_prompt,
    )
    related_context = format_policy_context(retrieve_health_policies(user_profile['register_info']))
    adapted_prompt += RELATED_POLICIES_SECTION.format(context=related_context)
    ai.dialogue_agent_system_prompt = adapted_prompt
    ai.messages_base = [{'role': 'system', 'content': adapted_prompt}]

    orch = DialogueOrchestrator(session_id, session, user_profile, ai)
    orch.run()


if __name__ == '__main__':
    main()

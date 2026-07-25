from config import llm_api_key, llm_base_url


def retrieve_health_policies(user_info: dict) -> dict:
    """Retrieve national and local health promotion policies as well as the healthcare resources available in the individual’s specific setting.
    """
    region = user_info.get('attr_3', 'unknown')
    area_type = user_info.get('attr_4', 'unknown')

    return {
        'national_policies': [
            '[Stub] National health promotion guidelines',
            '[Stub] National dementia prevention plan',
        ],
        'local_policies': [
            f'[Stub] Regional policy for attr_3={region}',
        ],
        'healthcare_resources': [
            f'[Stub] Community health center — attr_4={area_type}',
            '[Stub] Telehealth consultation service',
        ],
    }


def format_policy_context(policies: dict) -> str:
    """Format retrieved information into a prompt-ready text block."""
    parts = []
    if policies.get('national_policies'):
        parts.append("National policies:\n- " + "\n- ".join(policies['national_policies']))
    if policies.get('local_policies'):
        parts.append("Local policies:\n- " + "\n- ".join(policies['local_policies']))
    if policies.get('healthcare_resources'):
        parts.append("Healthcare resources:\n- " + "\n- ".join(policies['healthcare_resources']))
    return "\n\n".join(parts) if parts else ""

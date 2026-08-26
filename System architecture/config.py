import os

llm_api_key = ""
llm_base_url = ""


# --- Model configuration ---
# Central dialogue orchestrator
MODEL_DIALOGUE = ''   # E.g., doubao-seed-1.6, deepseek-v4-pro, gpt-5, etc.

# Dialogue-monitor agent
MODEL_JUDGE = ''  # E.g., doubao-seed-1.6, deepseek-v4-pro, gpt-5, etc.

# Risk assessment agent
MODEL_SCREENING = ''  # E.g., doubao-seed-1.6, deepseek-v4-pro, gpt-5, etc.

# Personalization engine - advice agent
MODEL_ADVICE = ''  # E.g., doubao-seed-1.6, deepseek-v4-pro, gpt-5, etc.

# Personalization engine - intent classifier
MODEL_INTENT = ''  # E.g., doubao-seed-1.6, deepseek-v4-pro, gpt-5, etc.



# --- Data paths ---
project_root = os.path.dirname(os.path.abspath(__file__))
user_db_path = os.path.join(project_root, 'data', 'user_info')
chat_db_path = os.path.join(project_root, 'data', 'chat_history')

# Personalization engine data paths
policy_db_path = os.path.join(project_root, 'data', 'policies')
resource_db_path = os.path.join(project_root, 'data', 'healthcare_resources')

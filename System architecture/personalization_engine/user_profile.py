import os

from utils import json_save, generate_random_string
from config import user_db_path


def user_prompt(user_info):
     return "\n".join(
        f"{k}: {v}" for k, v in sorted(user_info.items())
        if k.startswith("attr_")
    )


def create_user_info(extra_info=None):
    while True:
        user_id = generate_random_string(10)
        if not os.path.exists(os.path.join(user_db_path, user_id + '.json')):
            break
    user_profile_dict = {
        'chats': [],
        'register_info': extra_info or {},
    }
    json_save(user_profile_dict, os.path.join(user_db_path, user_id + '.json'))
    return user_id


def collect_user_info(): 
    print()

    extra_info = {}
    for i in range(1, 10):
        key = f"attr_{i}"
        value = input(f"[{key}]: ").strip()
        extra_info[key] = value if value else "unknown"
        print()

    user_id = create_user_info(extra_info)
    print(f"User created. ID: {user_id}")
    return user_id

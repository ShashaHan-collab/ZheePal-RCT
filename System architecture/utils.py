import json
import os
import random
import time

from config import user_db_path, chat_db_path


def json_save(data, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    return True


def generate_random_string(length):
    random_str_seq = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    return ''.join(random.choice(random_str_seq) for _ in range(length))


def is_user_exist(user_id):
    return os.path.exists(os.path.join(user_db_path, user_id + '.json'))


def create_session_by_user_id(user_id):
    while True:
        session_id = generate_random_string(10)
        if not os.path.exists(os.path.join(chat_db_path, session_id + '.json')):
            break
    # Check agent fields are detailed in our original paper, # TODO: Shasha
    session_dict = {
        'user_id': user_id,
        'created_at': int(time.time()),
        'history': [],
        'check_agent_fields': [
            'field_1', 'field_2', 'field_3',
            'field_4', 'field_5', 'field_6',
            'field_7', 'field_8', 'field_9'
        ], # list of fields is varialbe length
        'finished': False,
        'end_at': None
    }
    json_save(session_dict, os.path.join(chat_db_path, session_id + '.json'))
    user_profile_path = os.path.join(user_db_path, user_id + '.json')
    with open(user_profile_path, 'r', encoding='utf-8') as f:
        user_profile_dict = json.load(f)
    user_profile_dict['session_id'] = session_id
    json_save(user_profile_dict, user_profile_path)
    return session_id


def load_session(session_id):
    session_path = os.path.join(chat_db_path, session_id + '.json')
    with open(session_path, 'r', encoding='utf-8') as f:
        return json.load(f)


def save_session(session_id, session_dict):
    session_path = os.path.join(chat_db_path, session_id + '.json')
    json_save(session_dict, session_path)


def load_user_info_by_session_id(session_id):
    session = load_session(session_id)
    user_id = session['user_id']
    user_profile_path = os.path.join(user_db_path, user_id + '.json')
    with open(user_profile_path, 'r', encoding='utf-8') as f:
        return json.load(f)


def finish_session(session_id):
    session = load_session(session_id)
    session['finished'] = True
    session['end_at'] = int(time.time())
    save_session(session_id, session)


def count_user_message(history):
    return sum(1 for m in history if m.get('role') == 'user')

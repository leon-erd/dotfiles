import requests

# Telegram variables
with open('/run/secrets/telegram/api_key', 'r') as f:
    API_KEY = f.read().strip()
with open('/run/secrets/telegram/main_chat_id', 'r') as f:
    CHAT_ID = f.read().strip()


def send_telegram_message(message: str):
    # Maximum allowed message length in Telegram
    max_length = 4096

    # Remove unallowed symbols
    allowed_chars = ''.join([c for c in message if c.isalnum() or c.isspace() or c in ['.', ',', '!', '?', '-', ':', ';', '$', '%', '(', ')', '*', '/', '<', '=', '>', '@', '[', ']', '^', '_', '{', '|', '}', '~']])

    # Truncate the message to the allowed size
    truncated_message = allowed_chars[:max_length]

    send_url = f'https://api.telegram.org/bot{API_KEY}/sendMessage?chat_id={CHAT_ID}&text={truncated_message}'
    response = requests.get(send_url)
    return response.json()

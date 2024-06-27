from flask import Flask, render_template, request, jsonify
import hmac
import hashlib
from urllib.parse import unquote

app = Flask(__name__)

def validate_init_data(init_data: str, bot_token: str):
    vals = {k: unquote(v) for k, v in [s.split('=', 1) for s in init_data.split('&')]}
    data_check_string = '\n'.join(f"{k}={v}" for k, v in sorted(vals.items()) if k != 'hash')

    secret_key = hmac.new("WebAppData".encode(), bot_token.encode(), hashlib.sha256).digest()
    h = hmac.new(secret_key, data_check_string.encode(), hashlib.sha256)
    return h.hexdigest() == vals['hash']

@app.route('/')
def main_page():
    return render_template('index.html')

@app.route('/process', methods=['POST'])
def validate_user():
    data = request.get_json()
    if data and 'value' in data:
        print(data['value'])
        is_valid = validate_init_data(data['value'], 'YOUR_BOT_TOKEN_HERE')  # Replace with your actual bot token
        print(is_valid)
        return jsonify(is_valid=is_valid)
    return jsonify(is_valid=False)

@app.route('/expand', methods=['POST'])
def expand():
    data = request.get_json()
    if data and 'init_data' in data:
        is_valid = validate_init_data(data['init_data'], 'YOUR_BOT_TOKEN_HERE')  # Replace with your actual bot token
        if is_valid:
            return jsonify(status='success')
        else:
            return jsonify(status='failure', message='Validation failed')
    else:
        return jsonify(status='failure', message='Invalid request')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

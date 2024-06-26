from telebot import TeleBot, types
import requests

bot = TeleBot('7088114691:AAEdEGNoY10GrDA5s5DdGGD-E1fWWvZHF8o')  # Replace with your actual bot token

def expand(message, init_data):
    # Validate the init_data
    response = requests.post('http://localhost:8080/expand', json={'init_data': init_data})
    if response.status_code == 200:
        data = response.json()
        if data['status'] == 'success':
            bot.send_message(chat_id=message.chat.id, text='MiniApp opened successfully.')
        else:
            bot.send_message(chat_id=message.chat.id, text='Failed to open MiniApp.')
    else:
        bot.send_message(chat_id=message.chat.id, text='Failed to communicate with server.')

@bot.message_handler(commands=['start'])
def start(message: types.Message):
    markup = types.InlineKeyboardMarkup()
    markup.row(types.InlineKeyboardButton(text='Earn with LordCoin🫰', callback_data='expand_miniapp'))
    bot.send_message(chat_id=message.chat.id, text='Discover the Power of Every Tap with LordCoin! 👌 Start Earning Now 💲💰', reply_markup=markup)

@bot.callback_query_handler(func=lambda call: call.data == 'expand_miniapp')
def handle_callback_query(call: types.CallbackQuery):
    expand(call.message, 'INIT_DATA_HERE')  # Replace with your actual initial data

if __name__ == '__main__':
    bot.polling(skip_pending=True)

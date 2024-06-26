#!/bin/bash

# به روز رسانی و نصب پیش‌نیازها
sudo apt update
sudo apt install python3 python3-pip python3-venv -y

# کلون کردن مخزن
git clone https://github.com/sofiya-i/telegram-bot-miniapp.git
cd telegram-bot-miniapp

# ایجاد محیط مجازی و نصب کتابخانه‌ها
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# یادآوری برای پیکربندی فایل config.py
echo "Please configure the config.py file with your bot token and other settings."

# اجرای ربات
echo "To run the bot, use: source venv/bin/activate && python bot.py"

# پایان
echo "Installation complete. Please configure the bot and run it."

#!/bin/bash

# به روز رسانی و نصب پیش‌نیازها
sudo apt update
sudo apt install python3 python3-pip git -y

# کلون کردن مخزن
git clone https://github.com/sofiya-i/telegram-bot-miniapp.git
cd telegram-bot-miniapp

# نصب کتابخانه‌ها به صورت global
pip3 install -r requirements.txt

# نصب ماژول pyTelegramBotAPI
pip3 install pyTelegramBotAPI

# یادآوری برای پیکربندی فایل config.py
echo "Please configure the config.py file with your bot token and other settings."

# اجرای ربات
echo "To run the bot, use: python3 bot.py"

# پایان
echo "Installation complete. Please configure the bot and run it."

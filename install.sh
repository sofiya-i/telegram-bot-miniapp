#!/bin/bash

install_bot() {
    read -p "Enter your domain (sub.domain.com or domain.com) without https: " domain
    read -p "Enter your email: " email
    read -p "Enter your bot token: " token
    read -p "Enter the numerical ID of admin from @userinfobot: " admin_id

    # به روز رسانی و نصب پیش‌نیازها
    sudo apt update
    sudo apt install python3 python3-pip git -y

    # کلون کردن مخزن
    git clone https://github.com/sofiya-i/telegram-bot-miniapp.git
    cd telegram-bot-miniapp

    # نصب کتابخانه‌ها به صورت global
    pip3 install -r requirements.txt
    pip3 install pyTelegramBotAPI Flask

    # تنظیم فایل‌های پیکربندی
    sed -i "s#http://YOUR_DOMAIN_HERE:8080/process#http://$domain:8080/process#g" index.html
    sed -i "s/YOUR_DOMAIN_HERE/$domain/g" bot.py
    sed -i "s/YOUR_BOT_TOKEN_HERE/$token/g" bot.py
    sed -i "s/YOUR_ADMIN_ID_HERE/$admin_id/g" bot.py

    # نصب Certbot و درخواست SSL
    sudo apt-get install certbot python3-certbot-nginx -y
    sudo certbot certonly --standalone --preferred-challenges http -d $domain

    # اضافه کردن تسک خودکار تجدید گواهی SSL
    (crontab -l 2>/dev/null; echo "0 0 1 * * sudo certbot renew --quiet") | crontab -

    # یادآوری برای پیکربندی فایل config.py
    echo "Please configure the config.py file with your bot token and other settings."

    # اجرای ربات
    echo "To run the bot, use: python3 bot.py"

    # پایان
    echo "Installation complete. Please configure the bot and run it."
}

update_bot() {
    cd ~/telegram-bot-miniapp
    git pull
    pip3 install --upgrade -r requirements.txt
    echo "Update complete."
}

uninstall_bot() {
    rm -rf ~/telegram-bot-miniapp
    pip3 uninstall -y -r ~/telegram-bot-miniapp/requirements.txt
    pip3 uninstall -y pyTelegramBotAPI Flask
    echo "Uninstallation complete. The project and its dependencies have been removed."
}

change_ip() {
    read -p "Enter the new IP or domain (sub.domain.com or domain.com) without https: " new_domain
    sed -i "s/YOUR_DOMAIN_HERE/$new_domain/g" ~/telegram-bot-miniapp/bot.py
    echo "IP/Domain updated."
}

main_menu() {
    echo "Select an option:"
    echo "1. Install"
    echo "2. Update"
    echo "3. Uninstall"
    echo "4. Change IP/Domain"
    echo "5. Exit"
    read -p "Enter your choice [1-5]: " choice

    case $choice in
        1) install_bot ;;
        2) update_bot ;;
        3) uninstall_bot ;;
        4) change_ip ;;
        5) exit ;;
        *) echo "Invalid choice, please select again." ;;
    esac
}

main_menu

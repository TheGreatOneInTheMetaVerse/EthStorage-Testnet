#!/bin/bash

WORKDIR=$(pwd)

echo -e "\033[1;34mCreating folder 'zun'...\033[0m"
echo
mkdir -p $WORKDIR/zun && cd $WORKDIR/zun || { echo "Failed to create or navigate to 'zun' folder"; exit 1; }
echo

echo -e "\033[1;34mCreating 'app.html' file...\033[0m"
echo
cat <<EOL > app.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Web3 Greeting</title>
    <style>
        body, html {
            height: 100%;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            background: url('https://github.com/dxzenith/fuel-contract-deploy/assets/161211651/19c0eb9f-2b1a-4dc9-88d6-fff3fa225aa0') no-repeat center center fixed;
            background-size: cover;
            color: white;
            font-family: Arial, sans-serif;
        }
        #content {
            background-color: rgba(0, 0, 0, 0.5);
            padding: 20px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        #loading {
            font-size: 20px;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0% {
                opacity: 0.2;
            }
            50% {
                opacity: 1;
            }
            100% {
                opacity: 0.2;
            }
        }
    </style>
    <script>
        async function fetchData() {
            const url = 'web3://0xf14e64285Db115D3711cC5320B37264708A47f89:11155111/greeting';
            const response = await fetch(url);
            const data = await response.text();
            document.getElementById('loading').style.display = 'none';
            document.getElementById('content').textContent = data;
        }
        window.onload = fetchData;
    </script>
</head>
<body>
    <div id="content">
        <div id="loading">Loading greeting...</div>
    </div>
</body>
</html>
EOL
echo

echo -e "\033[1;34mFolder 'zun' and file 'app.html' created successfully.\033[0m"
echo

echo -e "\033[1;34mInstalling ethfs-cli globally...\033[0m"
echo
npm i -g ethfs-cli || { echo "Failed to install ethfs-cli"; exit 1; }
echo

read -p 'Enter your private key: ' PRIVATE_KEY
echo

echo -e "\033[1;34mCreating a new filesystem with ethfs-cli...\033[0m"
echo
ethfs-cli create -p "$PRIVATE_KEY" -c 11155111 || { echo "Failed to create filesystem with ethfs-cli"; exit 1; }
echo

read -p 'Enter the flat directory address: ' FLAT_DIR_ADDRESS
echo

echo -e "\033[1;34mUploading 'zun' folder with ethfs-cli...\033[0m"
echo
ethfs-cli upload -f "$WORKDIR/zun" -a "$FLAT_DIR_ADDRESS" -c 11155111 -p "$PRIVATE_KEY" -t 1 || { echo "Failed to upload folder with ethfs-cli"; exit 1; }
echo

echo -e "\033[1;34mInstalling eth-blob-uploader globally...\033[0m"
echo
npm i -g eth-blob-uploader || { echo "Failed to install eth-blob-uploader"; exit 1; }
echo

read -p 'Enter any EVM wallet address: ' EVM_WALLET_ADDRESS
echo

echo -e "\033[1;34mUploading 'app.html' with eth-blob-uploader...\033[0m"
echo
eth-blob-uploader -r http://88.99.30.186:8545 -p "$PRIVATE_KEY" -f "$WORKDIR/zun/app.html" -t "$EVM_WALLET_ADDRESS" || { echo "Failed to upload app.html with eth-blob-uploader"; exit 1; }
echo

echo -e "\033[1;34mCreating a new filesystem again with ethfs-cli...\033[0m"
echo
ethfs-cli create -p "$PRIVATE_KEY" -c 11155111 || { echo "Failed to create filesystem with ethfs-cli"; exit 1; }
echo

read -p 'Enter the flat directory address: ' FLAT_DIR_ADDRESS2
echo

echo -e "\033[1;34mUploading 'zun' folder again with ethfs-cli...\033[0m"
echo
ethfs-cli upload -f "$WORKDIR/zun" -a "$FLAT_DIR_ADDRESS2" -c 11155111 -p "$PRIVATE_KEY" -t 2 || { echo "Failed to upload folder with ethfs-cli"; exit 1; }
echo

echo -e "\033[1;32mAll tasks completed successfully.\033[0m"
echo

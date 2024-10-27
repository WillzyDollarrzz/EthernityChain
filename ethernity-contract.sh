#!/bin/bash

echo "Initializing npm project..."
npm init -y

echo "Installing Necessary Dependencies..."
sudo apt update && sudo apt upgrade -y
npm install --save-dev hardhat @nomiclabs/hardhat-ethers ethers
npm install --save-dev typescript ts-node dotenv

echo "Setting up your hardhat project..."
npx hardhat init --typescript


echo "Configuring ethernity contract..."
rm -f contracts/Lock.sol
cat > contracts/Hello.sol <<EOL
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hello {
    function hi() public view returns (string memory) {
        return "Hi, I'm Willzy... thanks for using my guide!";
    }
}
EOL


echo "Modifying hardhat.config.ts file..."
cat > hardhat.config.ts <<EOL
import "@nomiclabs/hardhat-ethers";
import { HardhatUserConfig } from "hardhat/config";
import "dotenv/config";

const config: HardhatUserConfig = {
  networks: {
    "ethernity-testnet": {
      url: "https://testnet.ethernitychain.io",
      chainId: 233,
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
    }
  },
  solidity: "0.8.0",
};

export default config;
EOL


echo -n "Paste your private key here and press Enter: "
read PRIVATE_KEY
echo "Saving private key..."
echo "PRIVATE_KEY=$PRIVATE_KEY" > .env


echo "Creating deploy.ts script..."
mkdir -p scripts
cat > scripts/deploy.ts <<EOL
import { ethers } from "hardhat";
import { Contract } from "ethers";  

async function main() {
  const Hello = await ethers.getContractFactory("Hello");
  const hello = await Hello.deploy() as Contract;  
  await hello.deployed();
  console.log("Ethernity Contract deployed to:", hello.address);
}

main()
  .then(() => process.exit(0))
  .catch((error: any) => {  
    console.error(error);
    process.exit(1);
  });
EOL


echo "Deploying contract to Ethernity Testnet..."
npx hardhat run scripts/deploy.ts --network ethernity-testnet

echo "Follow @WillzyDollarrzz on X for more guides like this!"

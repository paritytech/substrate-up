#!/usr/bin/env bash

echo
echo -e "\e[39mPolkadot-JS Apps Setup...";
echo
echo -e "Usage: polkadot-js-apps-new"
echo
echo -e "\e[35mCloning Polkadot-JS Apps...\e[39m"
git clone https://github.com/polkadot-js/apps --branch master;
cd apps;
yarn; 
yarn run build;

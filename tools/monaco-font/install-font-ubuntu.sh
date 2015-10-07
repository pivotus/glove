#!/bin/bash

echo "Start install"
sudo mkdir -p /usr/share/fonts/truetype/custom

echo "Installing font"
sudo mv Monaco_Linux.ttf /usr/share/fonts/truetype/custom/

echo "Updating font cache"
sudo fc-cache -f -v

echo "Enjoy"

#!/bin/bash

apt update -y
apt upgrade -y

apt install openjdk-17-jre -y

useradd -m minecraft
cd /home/minecraft

wget https://piston-data.mojang.com/v1/objects/server.jar -O server.jar

echo "eula=true" > eula.txt

nohup java -Xmx2G -Xms2G -jar server.jar nogui &

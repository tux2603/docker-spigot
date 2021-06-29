#!/bin/sh

minRam="${1:-1}G"
maxRam="${2:-4}G"

echo "Starting a minecraft $MC_VERSION server in $PWD"

if [ -e /opt/spigot/spigot-$MC_VERSION.jar ]; then
    serverPath="/opt/spigot/spigot-$MC_VERSION.jar"
else
    serverPath=`ls /opt/spigot/spigot*.jar | awk '{print $1}'`
fi

java -Xms$minRam -Xmx$maxRam -XX:+UseG1GC -Dcom.mojang.eula.agree=true -jar $serverPath nogui
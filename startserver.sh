#!/bin/sh

minRam="${1:-1}G"
maxRam="${2:-4}G"

echo "Starting a minecraft $MC_VERSION server in $PWD"

java -Xms$minRam -Xmx$maxRam -XX:+UseG1GC -jar /opt/spigot/spigot-$MC_VERSION.jar nogui
#!/bin/sh

ram="${1:-4}"

if [[ $ram == *M ]]; then 
    ram="$(echo $ram | grep -o '[0-9]*')"
else
    ram="$( (echo $ram | grep -o '[0-9]*'; echo ' 1024 *p' ) | dc)"
fi

echo "Starting a minecraft $MC_VERSION server in $PWD"

if [[ -e /opt/spigot/spigot-$MC_VERSION.jar ]]; then
    serverPath="/opt/spigot/spigot-$MC_VERSION.jar"
else
    serverPath=`ls /opt/spigot/spigot*.jar | awk '{print $1}'`
fi

if [[ $ram -gt 12288 ]]; then
    java -Xms${ram}M -Xmx${ram}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions \ 
        -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M \ 
        -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 \ 
        -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \ 
        -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dcom.mojang.eula.agree=true \
        -jar $serverPath nogui
else
    java -Xms${ram}M -Xmx${ram}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions \ 
        -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M \ 
        -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 \ 
        -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem \ 
        -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -Dcom.mojang.eula.agree=true \
        -jar $serverPath nogui
fi
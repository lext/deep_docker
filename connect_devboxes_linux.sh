for scr in $(ls /tmp/uscreens/S-$USER)
do
    screen -X -S $scr quit
done

screen -dmS ssh_tunnel && screen -S ssh_tunnel -X stuff "ssh -N -L 1231:localhost:1231 $1@$2 >/dev/null 2>&1\n"
screen -dmS jupyter_tunnel && screen -S jupyter_tunnel -X stuff "ssh -N -L 1232:localhost:1232 $1@$2 >/dev/null 2>&1\n"
screen -dmS tboard_tunnel && screen -S tboard_tunnel -X stuff "ssh -N -L 1233:localhost:1233 $1@$2 >/dev/null 2>&1\n"

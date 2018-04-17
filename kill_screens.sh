for scr in $(ls /var/run/screen/S-$USER)
do
    screen -X -S $scr quit
done

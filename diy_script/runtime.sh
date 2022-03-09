swap_seconds ()
{
        SEC=$1
        (( SEC < 60 )) && echo -e "$SEC秒\c"
        (( SEC >= 60 && SEC < 3600 )) && echo -e "$(( SEC / 60 ))分$(( SEC % 60 ))秒\c"
        (( SEC > 3600 )) && echo -e "$(( SEC / 3600 ))小时$(( (SEC % 3600) / 60 ))分$(( (SEC % 3600) % 60 ))秒\c"
}
swap_seconds $*

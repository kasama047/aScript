#!/bin/fish

#fan speed
function fan_mode
    set fan_mode_list "1) normal" "2) silent" "3) gaming" "4) custom" "5) auto" "6) fixed"
    set _fan_mode_list normal silent gaming custom auto fixed

    set current_fan_mode (cat /sys/devices/platform/aorus_laptop/fan_mode)
    set _current_fan_mode (math $current_fan_mode + 1)
    echo "current fan mode: $_fan_mode_list[$_current_fan_mode]"

    echo ""

    echo "choose your fan_mode:"
    string join \n $fan_mode_list

    read fan_mode
    # set mode (string lower $mode)
    # 
    # set fan_mode (contains -i -- $mode $fan_mode_list; or echo 5)
    set fan_mode (math $fan_mode - 1)
    if test $fan_mode -lt 0 -o $fan_mode -gt 5
        set fan_mode 3
    end
    #echo $fan_mode
    echo $fan_mode | sudo tee /sys/devices/platform/aorus_laptop/fan_mode > /dev/null

    set current_fan_mode (cat /sys/devices/platform/aorus_laptop/fan_mode)
    set _current_fan_mode (math $current_fan_mode + 1)
    echo "current fan mode: $_fan_mode_list[$_current_fan_mode]"
    end

#changes brightness of screen
function brightness_of_screen
    echo "what brightness of screen in persents do you want?"

    read brightness

    echo $brightness | sudo tee /sys/class/backlight/nvidia_0/brightness
end

#change_TTL
function change_TTL
    set -l TTL_list "64" "65"

    echo -n "current TTL: "; cat /proc/sys/net/ipv4/ip_default_ttl
    
    echo "what TTL do you want?"
    echo "1) TTL=64"
    echo "2) TTL=65"

    read TTL

    if test $TTL=1 -o $TTL=2
        sudo sysctl -w net.ipv4.ip_default_ttl=$TTL_list[$TTL] > /dev/null
    end

    echo -n "current TTL: "; cat /proc/sys/net/ipv4/ip_default_ttl
    
end

#changes presets
function presets
    set -l list_of_presets "1) gaming" "2) standard" "3) power_efficiency" "4) GSU"
    set -l brightness "100" "100" "70" "70"
    set -l _fan_mode "Gaming" "Custom" "Silent" "Silent"
    set -l fan_mode "2" "3" "1" "1"
    set -l TTL "64" "64" "64" "65"
    echo "choose 1 of theese presets:"
    string join \n $list_of_presets
    read preset
    echo $fan_mode[$preset] | sudo tee /sys/devices/platform/aorus_laptop/fan_mode > /dev/null
    echo $brightness[$preset] | sudo tee /sys/class/backlight/nvidia_0/brightness > /dev/null
    sudo sysctl -w net.ipv4.ip_default_ttl=$TTL[$preset] > /dev/null
    echo  "Current fan_mode: $_fan_mode[$preset]"
    echo  "Current brightness: $brightness[$preset]" 
    echo  "Current TTL: $TTL[$preset]" 
end

#choose what option user wants to change
set list "1) presets" "2) fan_mode" "3) brightness_of_screen" "4) change_TTL"

echo "what do you want to change?"
string join \n $list

read option

switch $option
    case 1
    presets
    
    case 2
    fan_mode

    case 3
    brightness_of_screen

    case 4
    change_TTL
end
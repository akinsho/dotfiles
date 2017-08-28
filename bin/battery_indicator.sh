#!/bin/bash
# modified from http://ficate.com/blog/2012/10/15/battery-life-in-the-land-of-tmux/

HEART='♥'
TOTAL_SLOTS=10

# 1. find battery data
# for linux
if [[ $(uname) == 'Linux' ]]; then

	# check usual locations for battery folder
	if [[ -d $(echo /sys/class/power_supply/BAT?/ | cut -d " " -f 1) ]]
	then
		directory=$(echo /sys/class/power_supply/BAT?/ | cut -d " " -f 1)
	elif [[ -d $(echo /proc/acpi/battery/BAT?/ | cut -d " " -f 1) ]]
	then
		directory=$(echo /proc/acpi/battery/BAT?/ | cut -d " " -f 1)
	else
		exit 1
	fi

	# check different possibilities for storing the battery data
	if [[ -f "$directory"charge_now ]]
	then
		current_charge=$(cat "$directory"charge_now)
		total_charge=$(cat "$directory"charge_full)
		design_charge=$(cat "$directory"charge_full_design)
	elif [[ -f "$directory"energy_now ]]
	then
		current_charge=$(cat "$directory"energy_now)
		total_charge=$(cat "$directory"energy_full)
		design_charge=$(cat "$directory"energy_full_design)
	elif [[ -f "$directory"energy_now ]]
	then
		current_charge=$(grep "remaining capacity:" "$directory"state | cut -d " " -f 3)
		total_charge=$(grep "last full capacity:" "$directory"info | cut -d " " -f 4)
		design_charge=$(grep "design capacity:" "$directory"info | cut -d " " -f 3)
	else
		exit 2
	fi

# for apple (not tested)
else
	battery_info="$(ioreg -rc AppleSmartBattery)"
	current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | cut -d " " -f 3)
	total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | cut -d " " -f 3)
	design_charge=$(echo $battery_info | grep -o '"DesignCapacity" = [0-9]\+' | cut -d " " -f 3)
fi

# 2. calcuate slots
# ceil(x/y)=(x+y-1)/y with integer arithmetic
charged_slots=$(((current_charge*TOTAL_SLOTS+design_charge-1)/design_charge))

dead_slots=$((TOTAL_SLOTS-(total_charge*TOTAL_SLOTS+design_charge-1)/design_charge))
if [[ $dead_slots -lt 1 ]]; then
	dead_slots=0
fi

# 3. print hearts
if [[ $charged_slots -ge 1 ]]
then
	echo -n '#[fg=red]'
	for _ in $(seq 1 $charged_slots)
	do
		echo -n "$HEART"
	done
fi

if [[ $charged_slots -lt $TOTAL_SLOTS ]]
then
	echo -n '#[fg=white]'
	for _ in $(seq 1 $((TOTAL_SLOTS-(charged_slots+dead_slots))))
	do
		echo -n "$HEART"
	done
fi

if [[ $dead_slots -ge 1 ]]
then
	echo -n '#[fg=black]'
	for _ in $(seq 1 $dead_slots)
	do
		echo -n "$HEART"
	done
fi


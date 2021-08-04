#!/bin/sh

swaymsg -t get_tree |
	jq '.nodes[].nodes[].nodes[] | select(.nodes==[]),select(.nodes!=[]).nodes[] | (.id|tostring)+ " " + .name' |
	sed -e "s/\"//g" |
	wofi -d -s .config/sway/wofi.css |
	awk '{print "swaymsg \"[con_id=" $1 "]\" focus"}' |
	sh


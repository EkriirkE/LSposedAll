#!/bin/bash

#Userid list, apply to app in these profiles (0 is main, 10 and 11 are work profile and another profile on my phone)
ul="0 10 11"

#Whitelist in 'a','b','c' format, prevent & remove mods from this app (ex. mods on gms causes integrity to fail)
wl="'com.google.android.gms'"


db=/data/adb/lspd/config/modules_config.db
i=$(sqlite3 $db "SELECT mid FROM modules WHERE module_pkg_name IN ('fi.veetipaananen.android.disableflagsecure2','undercover.hide.mock','eu.faircode.xlua','taco.scoop','com.github.thepiemonster.hidemocklocation','com.android1500.gpssetter');")
pm list packages | sort | while read p; do
	p=${p:8}
	[[ $wl == *"'$p'"* ]] && continue
	echo $p
	q=""
	for m in $i; do 
		for u in $ul; do
			q=$q"INSERT INTO scope (mid,app_pkg_name,user_id) SELECT $m,'$p',$u WHERE NOT EXISTS (SELECT 1 FROM scope WHERE mid=$m AND app_pkg_name='$p' AND user_id=$u);"
		done
	done
	sqlite3 $db "$q"
done
sqlite3 $db "DELETE FROM scope WHERE app_pkg_name IN ($wl)"

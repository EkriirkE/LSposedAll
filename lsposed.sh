#!/bin/bash
db=/data/adb/lspd/config/modules_config.db
ul="0 10"
i=$(sqlite3 $db "SELECT mid FROM modules WHERE module_pkg_name IN ('fi.veetipaananen.android.disableflagsecure2','undercover.hide.mock','eu.faircode.xlua','taco.scoop');")
pm list packages | sort | while read p; do
	p=${p:8}
	echo $p
	q=""
	for m in $i; do 
		for u in $ul; do
			q=$q"INSERT INTO scope (mid,app_pkg_name,user_id) SELECT $m,\"$p\",$u WHERE NOT EXISTS (SELECT 1 FROM scope WHERE mid=$m AND app_pkg_name=\"$p\" AND user_id=$u);"
		done
	done
	sqlite3 $db "$q"
done


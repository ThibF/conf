#!/usr/bin/env bash
A=$(i3-msg -t get_workspaces | grep Dashboard)
lengthA=${#A}
i3-msg 'workspace F1:Dashboard;'
if [ $lengthA -lt 1 ]; 
then i3-msg 'append_layout ~/.i3/workspaceDashboard2.json;'
sleep 0.1
urxvt -e watch -c -d -n 60 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/statVersion1213"""  &
sleep 0.1
urxvt -e watch -c -d -n 60 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/statVersion""" &
sleep 0.1
urxvt -e watch -n 60 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/lastEvents""" &
sleep 0.1
urxvt -e watch -n 3600 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/gpsStatsVersion1213""" | tee -a ~/dashboard/stat11213Prod &
sleep 0.1
urxvt -e watch -n 3600 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/gpsStatsVersionL70R""" &
sleep 0.1
urxvt -e watch -n 60 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/lastTrips""" &
sleep 0.1
urxvt -e watch -c -d -n 60 """psql -h prdakodb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U user_drust_dev -d drustDb -p 9432 < ~/sqlRequest/statDeploiement""" &
sleep 0.1
i3-msg 'split h;'
urxvt -e watch -c -d -n 60 """psql -h devdrustdb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U drustMasterDB -d drustDb < ~/sqlRequest/statDeploiement""" &
sleep 0.1
i3-msg 'focus left;focus left; split v'
urxvt -e watch -c -d -n 60 """psql -h devdrustdb.ccgcxoagolkl.eu-west-1.rds.amazonaws.com -U drustMasterDB -d drustDb < ~/sqlRequest/lastDiagnostic""" &


fi;


#!/bin/bash
blue='\e[1;34m';
rojo='\e[1;31m';
verde='\e[1;32m';
restore='\e[0m';

if [ $# -eq 0 ]; then
	echo "USAGE"
	echo "apm.sh stop|start|status|restart all||(elasticsearch kibana apm-server  logstash)"
	exit $?
fi

action=$1
OPTION=$2;
epath="/opt/elasticsearch-6.4.2"
if [ $OPTION = "all" ]; then
        OPTION=( elasticsearch kibana apm-server logstash )
fi

startelastic (){
	cd $epath
    	nohup ./bin/elasticsearch -d -p pid  &
#    systemctl start elasticsearch
}
stopelastic() {
	cd $epath
	kill -9 $( cat pid)
	#systemctl stop elasticsearch
}
statuselastic(){
	cd $epath
	pid=$(cat pid)
	if [ -e /proc/$pid ]; then
		return 1
	else
		return 0
	fi
	#systemctl status elasticsearch
}
startkibana(){
	sudo /etc/init.d/kibana start
}
stopkibana(){
	sudo /etc/init.d/kibana stop
}
statuskibana(){
	sudo /etc/init.d/kibana status
}
startapm-server(){
	/etc/init.d/apm-server start
}
stopàpm-server(){
	/etc/init.d/apm-server stop
}
statusapm-server(){
	/etc/init.d/apm-server status
}
startlogstash(){
	systemctl start logstash
}
stoplogstash(){
	systemctl stop logstash
}
statuslogstash(){
	systemctl status logstash
}
echo MENU


echo  ${OPTION[@]}
#echo "Se va a proceder a iniciar los servicios"
for i in ${OPTION[@]} ; do

        case $i in
        		start|status|restart|stop)
				;;
                kibana)
                        
                        echo -e $blue "KIBANA" $restore
                        case $action in
                        	start)
								startkibana
								statuskibana
							;;
							stop)
								stopkibana
								statuskibana
							;;
							status)
								statuskibana
							;;
							restart)
								stopkibana
								startkibana
								statuskibana
							;;
						esac	

                ;;
                apm-server)
                        echo -e $blue apm-server  $restore
                        case $action in
                        	start)
								startapm-server
								statusapm-server
							;;
							stop)
								stopapm-server
								statusapm-server
							;;
							status)
								statusapm-server
							;;
							restart)
								stopapm-server
								startapm-server
								statusapm-server
							;;
						esac
                ;;
                elasticsearch)
                        echo -e $blue elastisearch $restore
                        if [ $action = "start" ] ; then
                        	cd $epath
                        	nohup ./bin -d -p es.pid & 
                        	startelastic
                        	statuselastic
                       
                        elif [ $action = "stop" ] ; then
                        	stopelastic
                        	statuselastic
                        
                    	elif [ $action = "status" ]; then
                    		statuselastic
                    		code=$?
                    		echo $code
                    		if [ $code -eq 1 ]; then
                    			echo -e "Elasticsearch Its" $verde"running"
                    		else
                    			echo -e "Elasticsearch Its" $rojo "not running"
                    		fi
                    		
                    	elif [ $action = "restart" ]; then
                    		stopelastic && startelastic &&  statuselastic
                    	fi


                ;;
                logstash)
                        echo -e $blue logstash $restore
                          case $action in
                        	start)
								startlogstash
								statuslogstash
							;;
							stop)
								stoplogstash
								statuslogstash
							;;
							status)
								statuslogstash
							;;
							restart)
								stoplogstash
								startlogstash
								statuslogstash
							;;
						esac
                ;;

                *)
                        echo ha introducido un valor incorrecto
                ;;
esac
done


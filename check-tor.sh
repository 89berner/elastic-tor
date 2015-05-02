#!/bin/bash
sleep 300 #in case we are building the image
docker ps|grep "0.0.0.0"

if [ $? -eq 0 ] ; then
	echo "No need to do anything"
else
	#echo first stop all running dockers
	docker stop $(docker ps -a -q);
	service docker stop
	service docker start
	ID=$(docker images|head -n2|tail -n1|awk '{print $3;}')
	docker run -d -p 0.0.0.0:9001:9001 -p 0.0.0.0:9051:9051 $ID
fi


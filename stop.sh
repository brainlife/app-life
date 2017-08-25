#!/bin/bash

if [ -f jobid ]; then
	jobid=`cat jobid`
	echo "running qdel $jobid"
	qdel $jobid
fi

if [ -f pid ]; then
	kill $(cat pid)
fi

#!/bin/bash

#return code 0 = running
#return code 1 = finished successfully
#return code 2 = failed
#return code 3 = unknown

if [ -f finished ]; then
    code=`cat finished`
    if [ $code -eq 0 ]; then
        echo "finished successfully"
        exit 1 #success!
    else
        echo "finished with code:$code"
        exit 2 #failed
    fi
fi

if [ -f slurmjobid ]; then
    jobid=`cat slurmjobid`
    jobstate=`squeue -h -j $jobid --Format=statecompact`
    if [ -z $jobstate ]; then
        echo "Job removed before completing - maybe timed out?" 
        exit 2
    fi
    if [ $jobstate == "PD" ]; then
        echo "Waiting in the queue"
        eststart=`showstart $jobid | grep start`
        #curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $PROGRESS_URL
        exit 0
    fi
    if [ $jobstate == "R" ]; then
	logname="slurm-$jobid.out"
	tail -1 $logname
        exit 0
    fi
    if [ $jobstate == "F" ]; then
        echo "Job failed"
        exit 2
    fi

    #assume failed for all other state
    echo "unknown state: $jobstate"
    exit 2
fi

if [ -f jobid ]; then
    jobid=`cat jobid`
    jobstate=`qstat -f $jobid | grep job_state | cut -b17`
    if [ -z $jobstate ]; then
        echo "Job removed before completing - maybe timed out?" 
        exit 2
    fi
    if [ $jobstate == "Q" ]; then
        echo "Waiting in the queue"
        eststart=`showstart $jobid | grep start`
        #curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Waiting in the PBS queue : $eststart\"}" $PROGRESS_URL
        exit 0
    fi
    if [ $jobstate == "R" ]; then
	subid=$(cat jobid | cut -d '.' -f 1)
	logname="app-life.o$subid"
	tail -1 $logname

        exit 0
    fi
    if [ $jobstate == "H" ]; then
        echo "Job held.. waiting"
        exit 0 
    fi

    #assume failed for all other state
    echo "Jobs failed - PBS job state: $jobstate"
    exit 2
fi

if [ -f pid ]; then
    if ps -p $(cat pid) > /dev/null
    then
	    tail -1 stdout.log
	    exit 0
    else
	    echo "no longer running but didn't finish"
	    exit 2
    fi
fi

echo "can't determine the status!"
exit 3



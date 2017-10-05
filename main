#!/bin/bash

#PBS -l nodes=1:ppn=6
#PBS -l walltime=10:00:00

if [ `which singularity` ]
then
    echo "running via singularity"
    time singularity run docker://brainlife/life
else
    module load matlab ccm
    export MATLABPATH=$MATLABPATH:$PWD

    if [ `which ccmrun` ]
    then
        echo "running matlab via ccmrun - on bigred2"
        time ccmrun matlab -nodisplay -nosplash -r main
    else
        echo "running matlab"
        time matlab -nodisplay -nosplash -r main
    fi
fi

#make sure output_fe.mat exists
if [ ! -s output_fe.mat ];
then
	echo "output_fe.mat missing"
	exit 1
fi



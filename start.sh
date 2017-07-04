#!/bin/bash

#allows test execution
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi

echo "clean up from previous run"
rm -f products.json
rm -f finished 

#########################################################################################
##
## Run as docker container on VM
## 

if [ $ENV == "SINGULARITY" ]; then
    nohup bash _run.sh > stdout.log 2> stderr.log &
    echo $! > pid
    
cat <<EOT > _run.sh
#time singularity run docker://brainlife/life
time singularity run /usr/local/brainlife_life.img

#check for output files
if [ -s output_fe.mat ];
then
	echo 0 > finished
else
	echo "output_fe.mat missing"
	echo 1 > finished
	exit 1
fi
EOT

    exit

fi

#########################################################################################
##
## All else.. submit to PBS
## 

#create pbs script
if [ $HPC == "KARST" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
##PBS -q preempt
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=3:00:00
EOT
fi

if [ $HPC == "CARBONATE" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
##PBS -q preempt
#PBS -l nodes=1:ppn=16
#PBS -l walltime=3:00:00
EOT
fi

if [ $HPC == "BIGRED2" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=3:00:00
#PBS -l gres=ccm
#PBS -m abe
EOT
fi

#common bits on all systems
cat <<EOT >> task.pbs
#PBS -N app-life
#PBS -V
[ \$PBS_O_WORKDIR ] && cd \$PBS_O_WORKDIR
EOT

#create pbs script
if [ $HPC == "KARST" ]; then
    cat <<EOT >> task.pbs
#export OMP_NUM_THREADS=16 #this doesn't make any difference (for openmp..)
module load matlab/2016a
export MATLABPATH=$MATLABPATH:$SERVICE_DIR
time matlab -nodisplay -nosplash -r main
EOT
fi

#create pbs script
if [ $HPC == "CARBONATE" ]; then
    cat <<EOT >> task.pbs
#export OMP_NUM_THREADS=16 #this doesn't make any difference (for openmp..)
module load matlab
export MATLABPATH=$MATLABPATH:$SERVICE_DIR
time matlab -nodisplay -nosplash -r main
EOT
fi

if [ $HPC == "BIGRED2" ]; then
    cat <<EOT >> task.pbs
module load matlab/2016a
module load ccm
export MATLABPATH=$MATLABPATH:$SERVICE_DIR
ccmrun matlab -nodisplay -nosplash -r main

#fix broken curl due to matlab
#export LD_LIBRARY_PATH=/usr/lib64/:\$LD_LIBRARY_PATH
unset LD_LIBRARY_PATH
EOT
fi

#rest is about the same for everyone
cat <<EOT >> task.pbs

#check for output files
if [ -s output_fe.mat ];
then
	echo 0 > finished
else
	echo "output_fe.mat missing"
	echo 1 > finished
	exit 1
fi
EOT

jobid=`qsub task.pbs`
echo $jobid > jobid

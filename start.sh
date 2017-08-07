#!/bin/bash

#allows test execution
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi

echo "clean up from previous run"
rm -f products.json
rm -f finished 
rm -f pid

#########################################################################################
##
## Run as docker container on VM
## 

if [ $ENV == "SINGULARITY" ]; then
    
cat <<EOT > _run.sh
#time singularity run /usr/local/images/brainlife_life.img
time singularity run docker://brainlife/life

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

    chmod +x _run.sh
    nohup ./_run.sh > stdout.log 2> stderr.log & echo $! > pid
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
#PBS -l walltime=10:00:00
EOT
fi

if [ $HPC == "CARBONATE" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
##PBS -q preempt
#PBS -l nodes=1:ppn=16
#PBS -l walltime=6:00:00
EOT
fi

if [ $HPC == "BIGRED2" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=8:00:00
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
EOT
fi

#rest is about the same for everyone
cat <<EOT >> task.pbs

if [ -f finished ];
then
	exit $(cat finished)
else
	echo "matlab failed"
	echo 1 > finished
	exit 1
fi
EOT

jobid=`qsub task.pbs`
echo $jobid > jobid
echo "submitted $jobid"



#!/bin/bash

#allows test execution
if [ -z $SERVICE_DIR ]; then export SERVICE_DIR=`pwd`; fi
if [ -z $ENV ]; then export ENV=IUHPC; fi

#patch libssl issue caused by some module overriding libpath
#unset LD_LIBRARY_PATH

#TODO - clean.sh?
echo "clean up from previous run"
rm -f products.json
rm -f finished 

#find out which environment we are in
#hostname | grep karst > /dev/null
#if [ $? -eq 0 ]; then
#    execenv=karst 
#fi
#echo $HOME | grep -i bigred > /dev/null
#if [ $? -eq 0 ]; then
#    execenv=bigred
#fi
#echo $HOME | grep -i carbonate > /dev/null
#if [ $? -eq 0 ]; then
#    execenv=carbonate
#fi

#create pbs script
if [ $HPC == "KARST" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
##PBS -q preempt
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=3:00:00
#PBS -N app-life
#PBS -V
EOT
fi

if [ $HPC == "CARBONATE" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
##PBS -q preempt
#PBS -l nodes=1:ppn=16
#PBS -l walltime=3:00:00
#PBS -N app-life
#PBS -V
EOT
fi

if [ $HPC == "BIGRED2" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
#PBS -l nodes=1:ppn=16:dc2

##normally, it should take about 3 hours but lindsey says it takes about 8 hours on HCP data
#PBS -l walltime=9:00:00

#PBS -l gres=ccm
#PBS -N app-life
#PBS -m abe
#PBS -V
EOT
fi

cat <<EOT >> task.pbs

if [ ! -z "\$PBS_O_WORKDIR" ]; then
    echo "resetting cwd"
    cd \$PBS_O_WORKDIR
fi

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

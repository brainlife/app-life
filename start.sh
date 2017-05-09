#!/bin/bash

#allows test execution
if [ -z $SCA_SERVICE_DIR ]; then
    export SCA_SERVICE_DIR=`pwd`
fi
if [ -z "$SCA_PROGRESS_URL" ]; then
    export SCA_PROGRESS_URL="https://soichi7.ppa.iu.edu/api/progress/status/_sca.test"
fi

#patch libssl issue caused by some module overriding libpath
unset LD_LIBRARY_PATH

#TODO - clean.sh?
echo "clean up from previous run"
rm -f products.json
rm -f finished 

#find out which environment we are in
hostname | grep karst > /dev/null
if [ $? -eq 0 ]; then
    execenv=karst 
fi
echo $HOME | grep -i bigred > /dev/null
if [ $? -eq 0 ]; then
    execenv=bigred
fi

#create pbs script
if [ $execenv == "karst" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
##PBS -q preempt
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=3:00:00
#PBS -N sca-service-life
#PBS -V
#Karst
EOT
fi

if [ $execenv == "bigred" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=3:00:00
#PBS -l gres=ccm
#PBS -N sca-service-life
#PBS -V
#BigRed2
EOT
fi

cat <<EOT >> task.pbs

#fixing .module sometimes causes curl / git to fail
unset LD_LIBRARY_PATH

curl -X POST -H "Content-Type: application/json" -d "{\"progress\": 0, \"status\": \"running\"}" $SCA_PROGRESS_URL

if [ ! -z "\$PBS_O_WORKDIR" ]; then
    echo "resetting cwd"
    cd \$PBS_O_WORKDIR
fi

EOT

#create pbs script
if [ $execenv == "karst" ]; then
    cat <<EOT >> task.pbs
curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"running matlab\"}" $SCA_PROGRESS_URL

#https://kb.iu.edu/d/bedc
#module load gnuplot
#module load collectl

#collectl -F1 -i10:10 -sZl --procfilt u\$UID -f collectl &

#this doesn't make any difference (for openmp..)
#export OMP_NUM_THREADS=16

module load matlab
export MATLABPATH=$MATLABPATH:$SCA_SERVICE_DIR
matlab -nodisplay -nosplash -r main

#fix LD_LIBRARY_PATH so that curl works
unset LD_LIBRARY_PATH

#stop collectl and generate plot
#collectl_stop.sh
#collectl_plot.sh collectl* .

EOT
fi

if [ $execenv == "bigred" ]; then
    cat <<EOT >> task.pbs
curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"running matlab with ccmrun\"}" $SCA_PROGRESS_URL

module load matlab
module load ccm
export MATLABPATH=$MATLABPATH:$SCA_SERVICE_DIR
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
curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"progress\": 0, \"msg\":\"Job: $jobid Waiting in PBS queue on $execenv\"}" $SCA_PROGRESS_URL


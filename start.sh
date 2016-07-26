#!/bin/bash

#make sure jq is installed on $SCA_SERVICE_DIR
if [ ! -f $SCA_SERVICE_DIR/jq ];
then
        echo "installing jq"
        wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O $SCA_SERVICE_DIR/jq
        chmod +x $SCA_SERVICE_DIR/jq
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
#PBS -l nodes=1:ppn=16:dc2
#PBS -l walltime=1:00:00
#PBS -N sca-service-life
#PBS -V
#Karst
EOT
fi

if [ $execenv == "bigred" ]; then
    cat <<EOT > task.pbs
#!/bin/bash
#PBS -l nodes=1:ppn=32:dc2
#PBS -l walltime=1:00:00
#PBS -l gres=ccm
#PBS -N lifedemo
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

#data might be already staged if user is rerunning this
#but.. sometime data could get corrupted.. so let's remove it for now.
rm -rf data

#if [ ! -d data ]
#then
    echo "untarring input data"
    input_task_id=`$SCA_SERVICE_DIR/jq -r '.input_task_id' config.json`
    filename=`$SCA_SERVICE_DIR/jq -r '.files[0] .filename' config.json`

    curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"Untarring \$filename\"}" $SCA_PROGRESS_URL
    tar -xzf ../\$input_task_id/\$filename
#fi
EOT

#create pbs script
if [ $execenv == "karst" ]; then
    cat <<EOT >> task.pbs
curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"running matlab\"}" $SCA_PROGRESS_URL

module load matlab
matlab -nodisplay -nosplash < $SCA_SERVICE_DIR/demo_life.m
ret=\$?
#fix LD_LIBRARY_PATH so that curl works
unset LD_LIBRARY_PATH
EOT
fi

if [ $execenv == "bigred" ]; then
    cat <<EOT >> task.pbs
curl -X POST -H "Content-Type: application/json" -d "{\"msg\":\"running matlab with ccmrun\"}" $SCA_PROGRESS_URL

module load matlab
module load ccm
ccmrun matlab -nodisplay -nosplash < $SCA_SERVICE_DIR/demo_life.m
ret=\$?
#fix broken curl due to matlab
#export LD_LIBRARY_PATH=/usr/lib64/:\$LD_LIBRARY_PATH
unset LD_LIBRARY_PATH
EOT
fi

#rest is about the same for everyone
cat <<EOT >> task.pbs

if [ \$ret -eq 0 ]
then
    status="finished"
    msg="Successfully ran lifedemo"

    #output products.json (should be part of the life_demo)
    cat <<EOTP > products.json
[
    {
        "type": "soichih/life/out",
        "graphs": {
             "error_distribution": {"filename": "figure1.png", "type": "image/png"},
             "error_ratio": {"filename": "figure2.png", "type": "image/png"},
             "fascicles": {"filename": "figure3.png", "type": "image/png"},
             "heat": {"filename": "figure4.png", "type": "image/png"},
             "evidence":  {"filename": "figure5.png", "type": "image/png"}
         }
    }
]
EOTP

else
    status="failed"
    msg="lifedemo returned code:\$ret"
fi

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"\$status\", \"msg\":\"\$msg\"}" $SCA_PROGRESS_URL

echo \$ret > finished
exit \$ret #tell pbs the return code?
EOT

jobid=`qsub task.pbs`
echo $jobid > jobid
curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"progress\": 0, \"msg\":\"Job: $jobid Waiting in PBS queue on $execenv\"}" $SCA_PROGRESS_URL


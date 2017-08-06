#mcc -m main -R -nodisplay -a /N/u/hayashis/BigRed2/git/encode-mexed/mexfiles -d msa
#docker build -t brainlife/life . && docker push brainlife/life

echo "publishing image to hcp singularity /images directory"
docker run \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /usr/local/images:/output \
	--privileged -t --rm \
	singularityware/docker2singularity \
	brainlife/life

#-v /mnt/auto/soft/cle5/singularity/images:/output \

#sudo singularity create -s 7200 life.img
#sudo singularity import life.img docker://brainlife/life

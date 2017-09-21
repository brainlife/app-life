
docker run --rm -it \
	-v /mnt/v1/testdata:/input \
	-v `pwd`/output:/output \
	brainlife/life 


docker run --rm -it \
	-v /mnt/auto/home/Karst/testdata/sca-service-life:/input \
	-v `pwd`:/output \
	brainlife/life

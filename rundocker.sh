
docker run --rm -it \
	-v /mnt/auto/home/Karst/testdata/app-life:/input \
	-v `pwd`:/output \
	brainlife/life

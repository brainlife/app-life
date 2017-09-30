
docker run --rm -it \
	-v `pwd`/../testdata:/input \
	-v `pwd`:/output \
	brainlife/life

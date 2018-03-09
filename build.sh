#!/bin/bash
module load matlab/2017a

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/encode'))
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/jsonlab'))
mcc -m -R -nodisplay -a /N/u/brlife/git/encode/mexfiles -d compiled main
exit
END
matlab -nodisplay -nosplash -r build && rm build.m

docker build . -t brainlife/life && \
	docker tag brainlife/life brainlife/life:1.3 && \
	docker push brainlife/life


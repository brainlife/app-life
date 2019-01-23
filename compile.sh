#!/bin/bash
module load matlab/2017a
#module load matlab/2018a

cat > build.m <<END

addpath(genpath('/N/u/brlife/git/encode'))
%addpath(genpath('/N/u/hayashis/git/encode'))
addpath(genpath('/N/u/brlife/git/vistasoft'))
addpath(genpath('/N/u/brlife/git/jsonlab'))

mcc -m -R -nodisplay -a /N/u/brlife/git/encode/mexfiles -d compiled main
%mcc -m -R -nodisplay -a /N/u/hayashis/git/encode/mexfiles -d compiled main

exit
END
time matlab -nodisplay -nosplash -r build && rm build.m


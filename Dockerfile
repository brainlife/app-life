
FROM brainlife/mcr:R2016a
MAINTAINER Soichi Hayashi <hayashis@iu.edu>

#for openmp
RUN apt update && apt -y install libgomp1

ADD /msa /msa

#we want all output to go here (config.json should also go here)
WORKDIR /output


ENTRYPOINT ["/msa/main"] 

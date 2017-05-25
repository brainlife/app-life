FROM brainlife/mcr:centos6-r2016a
MAINTAINER Soichi Hayashi <hayashis@iu.edu>

#for openmp
RUN yum update && yum -y install libgomp

ADD /msa /msa

#we want all output to go here (config.json should also go here)
WORKDIR /output

ENTRYPOINT ["/msa/main"] 

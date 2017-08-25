FROM brainlife/mcr:centos6-r2017a
MAINTAINER Soichi Hayashi <hayashis@iu.edu>

#for openmp
RUN yum -y update && yum install -y libgomp libXext libXt libXt

ADD /msa /msa

#we want all output to go here (config.json should also go here)
WORKDIR /output

#http://singularity.lbl.gov/docs-docker#be-practices
RUN ldconfig

ENTRYPOINT ["/msa/main"] 


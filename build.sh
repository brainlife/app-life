#!/bin/bash

docker build . -t brainlife/life && \
	docker tag brainlife/life brainlife/life:1.3 && \
	docker push brainlife/life


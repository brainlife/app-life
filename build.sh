
#mcc -m main -R -nodisplay -a /N/u/hayashis/brlife/git/encode/mexfiles -d msa-r2017a
docker build . -t brainlife/life && \
	docker tag brainlife/life brainlife/life:1.2 && \
	docker push brainlife/life



#mcc -m main -R -nodisplay -a /N/u/hayashis/BigRed2/git/encode-mexed/mexfiles -d msa

docker build . -t brainlife/life && \
	docker tag brainlife/life brainlife/life:1.2 && \
	docker push brainlife/life


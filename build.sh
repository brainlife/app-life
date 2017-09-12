
#mcc -m main -R -nodisplay -a /N/u/hayashis/BigRed2/git/encode-mexed/mexfiles -d msa-r2017a
docker build . -t brainlife/life && docker tag brainlife/life brainlife/life:1.1 && docker push brainlife/life


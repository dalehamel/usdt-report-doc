from ubuntu:18.10 as builder

#RUN apt-get update && apt-get install -y git wget gnupg && rm -rf /var/lib/apt/lists/*  && apt-get clean

RUN apt-get update
RUN apt-get install -y cabal-install dnsutils
RUN cabal update
RUN cabal install pandoc --constraint 'pandoc < 2.6'
RUN cabal install pandoc-include-code
RUN apt-get install -y ruby ruby-dev && apt-get clean

workdir /app

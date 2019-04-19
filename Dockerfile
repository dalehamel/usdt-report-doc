from ubuntu:18.10 as builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y git wget gnupg && apt-get clean
RUN apt-get install -y texlive-latex-base && apt-get clean
RUN apt-get install -y texlive-latex-extra  && apt-get clean
RUN apt-get install -y texlive-fonts-recommended && apt-get clean
RUN apt-get install -y texlive-fonts-extra && apt-get clean
RUN apt-get install -y librsvg2-bin
RUN apt-get install -y calibre && apt-get clean
RUN apt-get install -y ruby ruby-dev build-essential && apt-get clean
RUN gem install bundler

workdir /app

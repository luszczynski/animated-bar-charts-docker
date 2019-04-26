FROM r-base

RUN apt-get update && apt-get install libcurl4-openssl-dev libxml2-dev libssl-dev cargo ffmpeg -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo 'install.packages(c("ggplot2", "gganimate", "janitor", "scales", "curl", "xml2", "openssl", "httr", "rvest", "tidyverse", "gifski", "png"))' > dep.r && Rscript dep.r

VOLUME /input
VOLUME /output

COPY run.sh /run.sh

RUN chmod +x /run.sh

WORKDIR /

CMD [ "./run.sh" ]
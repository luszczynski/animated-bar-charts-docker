FROM r-base

RUN apt-get update && apt-get install libcurl4-openssl-dev libxml2-dev libssl-dev cargo ffmpeg -y && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo 'install.packages(c("ggplot2", "gganimate", "janitor", "scales", "curl", "xml2", "openssl", "httr", "rvest", "tidyverse", "gifski", "png"))' > dep.r

RUN echo dep.r

RUN Rscript dep.r

VOLUME /code

CMD [ "Rscript", "/code/script.r" ]

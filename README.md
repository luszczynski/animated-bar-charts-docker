# animated-bar-charts-docker

Source

* https://towardsdatascience.com/create-animated-bar-charts-using-r-31d09e5841da
* https://github.com/amrrs/animated_bar_charts_in_R

```bash
mkdir /tmp/my-code
touch /tmp/my-code/script.r
touch /tmp/my-code/data.csv
```

Create a file named `script.r` with the following content:

```R
library(janitor)
library(tidyverse)
library(gganimate)

gdp_tidy <- read_csv("/input/data.csv")

gdp_formatted <- gdp_tidy %>%
  group_by(year) %>%
  # Makes it possible to have non-integer ranks while sliding in million
  mutate(rank = rank(-value),
         Value_rel = value/value[rank==1],
         Value_lbl = format(round(value/1000000, digits = 2), nsmall =2)) %>%
  group_by(country_name) %>% 
  filter(rank <=10) %>%
  ungroup()
  staticplot = ggplot(gdp_formatted, aes(rank, group = country_name, 
                fill = as.factor(country_name), color = "black")) +
  geom_tile(aes(y = value/2,
                height = value,
                width = 0.9), alpha = 0.8, color = "black") +
  geom_text(aes(y = 0, label = paste(country_name, " ")), hjust = -0.1, color = "black", size = 5, fontface="bold") +
  geom_text(aes(y=value, label = Value_lbl), hjust=-0.1, color = "black", size = 5) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
         axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey"),
        panel.grid.minor.x = element_line( size=.1, color="grey"),
        plot.title=element_text(size=30, hjust=0.5, face="bold", color="black", vjust=-1),
        plot.subtitle=element_text(size=21, hjust=0.5, color="black", vjust=-1),
        plot.caption =element_text(size=16, hjust=0.5, face="italic", color="black"),
        plot.background=element_blank(),
       plot.margin = margin(2,2, 2, 4, "cm"))
anim = staticplot + transition_states(year, transition_length = 4, state_length = 1) +
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Ranking Banco Central do Brasil   {closest_state}',  
       subtitle  =  "Top 10 Conglomerados Financeiros e Instituições Independentes por Ativos (em milhões)",
       caption  = "By Luszczynski - Code shared in https://github.com/luszczynski - Data source in https://www.bcb.gov.br/estabilidadefinanceira/supervisao > IF.Data")
animate(anim, 200, fps = 5,  width = 1600, height = 1000, 
        renderer = gifski_renderer("/output/chart.gif"))
animate(anim, 200, fps = 3,  width = 1600, height = 1000, 
        renderer = ffmpeg_renderer()) -> for_mp4
anim_save("/output/chart.mp4", animation = for_mp4 )
```

Now run:

```bash
  docker run --rm -v /tmp/my-code:/input -v /tmp/output:/output docker.io/luszczynski/animated-bar-charts
```

This container will generate two files:

* chart.gif
* chart.mp4

You can find them inside `/tmp/output` folder.

### Bonus
library(ggplot2)
library(readr)
library(dplyr)
library(ggthemr)
library(tidyr)

tab <- read_csv("data/oim_data_latest.csv")
names(tab)[1] <- "Area"
glimpse(tab)


###
tab <- tab %>%
  gather(key = month, value = deaths, -Area)
### Final check
glimpse(tab)
summary(tab)

### Some ploting for fun
tab %>%
  filter(Area != "Total") %>%
  ggplot(aes(reorder(Area, deaths), deaths, fill = Area)) +
  geom_bar(stat = "identity") +
  labs(x = "", y = "Total deaths") +
  coord_flip() +
  theme(legend.position = "none")

ggsave("figs/deaths.png", last_plot())

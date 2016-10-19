### Bonus
library(ggplot2)
library(readr)
library(dplyr)
library(ggthemr)
library(tidyr)
ggthemr(palette = "dust")

tab <- read_csv("../data/oim_data_latest.csv")
names(tab)[1] <- "Country"
glimpse(tab)

## tab <- tab %>%
##   gather(key = month, value = deaths, -Country)
## tab$deaths <- as.integer(tab$deaths)

## ### Non breaking space
pattern <- paste0("\\,|\\*|", intToUtf8(160))


###
tab <- tab %>%
  gather(key = month, value = deaths, -Country) %>%
  mutate(deaths = as.integer(gsub(pattern, "", deaths))) %>%
  spread(key = month, value = deaths)

### Final check
glimpse(tab)
summary(tab)

### Some ploting for fun
tab %>%
  filter(Country != "Total") %>%
  ggplot(aes(reorder(Area, total), total, fill = Area)) +
  geom_bar(stat = "identity") +
  labs(x = "", y = "Total deaths") +
  coord_flip() +
  theme(legend.position = "none")

ggsave("deaths.png", last_plot())

library(tidyverse)

key <- fread("D:/Personal Projects/DataIO-2024/Data/cluster_bounds-1.csv")

key <- key %>%
  mutate(mid_lat = mean(c(`Min Latitude`, `Max Latitude`)),
         mid_long = mean(c(`Min Longitude`, `Max Longitude`)))

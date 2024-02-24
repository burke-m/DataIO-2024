library(tidyverse)
library(data.table)
library(gt)
library(gtExtras)


klustered <- fread("D:/Personal Projects/DataIO-2024/Data/KClusteredFile.csv")


all_months_simple <- all_months %>%
  select(ride_id, month)

klustered <- klustered %>%
  left_join(all_months_simple, by = "ride_id")

all_months_clusters <- klustered %>%
  group_by(month, member_casual) %>%
  mutate(total_rides = n()) %>%
  ungroup()

top_pairings <- all_months_clusters %>%
  group_by(month, start_cluster, end_cluster, member_casual) %>%
  summarize(num = n(),total_rides) %>%
  mutate(percent_of_grouping = round(num/total_rides*100,2)) %>%
  group_by(month, member_casual) %>%
  arrange(desc(num)) %>%
  slice(1) %>%
  ungroup()

months <- c("January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December")

t_s_gt <- top_pairings %>%
  mutate(month = factor(month, levels = months)) %>%
  arrange(month) %>%
  select(1,4,2,3,5,7,6) %>%
  gt() %>%
  tab_header(
    title = "Top Start and End Cluster Combinations per Month For Each User Type",
    subtitle = "Based on the number of rides taken"
  )

t_s_gt %>%
  gt_hulk_col_numeric(columns = c(num, percent_of_grouping,total_rides), trim = TRUE) %>%


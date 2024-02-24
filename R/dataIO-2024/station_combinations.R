library(tidyverse)
library(data.table)
library(gt)
library(gtExtras)

january <- fread("D:/Personal Projects/DataIO-2024/Data/January.csv") |>
  mutate(month = "January")
february <- fread("D:/Personal Projects/DataIO-2024/Data/February.csv") |>
  mutate(month = "February")
march <- fread("D:/Personal Projects/DataIO-2024/Data/March.csv") |>
  mutate(month = "March")
april <- fread("D:/Personal Projects/DataIO-2024/Data/April.csv") |>
  mutate(month = "April")
may <- fread("D:/Personal Projects/DataIO-2024/Data/May.csv") |>
  mutate(month = "May")
june <- fread("D:/Personal Projects/DataIO-2024/Data/June.csv") |>
  mutate(month = "June")
july <- fread("D:/Personal Projects/DataIO-2024/Data/July.csv") |>
  mutate(month = "July")
august <- fread("D:/Personal Projects/DataIO-2024/Data/August.csv") |>
  mutate(month = "August")
september <- fread("D:/Personal Projects/DataIO-2024/Data/September.csv") |>
  mutate(month = "September")
october <- fread("D:/Personal Projects/DataIO-2024/Data/October.csv") |>
  mutate(month = "October")
november <- fread("D:/Personal Projects/DataIO-2024/Data/November.csv") |>
  mutate(month = "November")
december <- fread("D:/Personal Projects/DataIO-2024/Data/December.csv") |>
  mutate(month = "December")

desired_total_size <- sum(c(nrow(january), nrow(february), nrow(march),
                            nrow(april), nrow(may), nrow(june), nrow(july),
                            nrow(august), nrow(september), nrow(october),
                            nrow(november), nrow(december)))


all_months <- rbind(january, february, march, april, may, june, july,
                    august, september, october, november, december)

all_months_stations <- all_months %>%
  group_by(month, start_station_name, end_station_name, member_casual) %>%
  filter((start_station_id != "") | (end_station_id != ""))

top_stations <- all_months_stations %>%
  count(month, start_station_name, end_station_name, member_casual, sort = TRUE) %>%
  group_by(month, member_casual) %>%
  mutate(percent_of_grouping = round(n/n()*100,2)) %>%
  slice(1) %>%
  ungroup()

months <- c("January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December")

t_s_gt <- top_stations %>%
  select(-c(start_station_id)) %>%
  mutate(month = factor(month, levels = months)) %>%
  arrange(month) %>%
  gt() %>%
  tab_header(
    title = "Top Start and End Station Combinations per Month For Each User Type",
    subtitle = "Based on the number of rides taken"
  )

t_s_gt %>%
  gt_hulk_col_numeric(columns = c(n, percent_of_grouping), trim = TRUE)



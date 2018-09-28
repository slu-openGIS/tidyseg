# download data on race in St. Louis

# load dependencies
library(tidycensus)
library(dplyr)
library(usethis)

# download race table for 2016 ACS
stlRace <- get_acs(state = 29, county = 510, geography = "tract", year = 2016, table = "B02001", output = "wide")

# rename variables, subset cols
stlRace %>%
  rename(totalPop = B02001_001E) %>%
  rename(totalPop_m = B02001_001M) %>%
  rename(white = B02001_002E) %>%
  rename(white_m = B02001_002M) %>%
  rename(black = B02001_003E) %>%
  rename(black_m = B02001_003M) %>%
  select(GEOID, NAME, totalPop, totalPop_m, white, white_m, black, black_m) -> stlRace

# save data
use_data(stlRace)

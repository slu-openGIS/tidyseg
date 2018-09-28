# download data on race in St. Louis

# load dependencies
library(tidycensus)
library(dplyr)
library(usethis)

# download race table for 2016 ACS
df <- get_acs(state = 29, county = 510, geography = "tract", year = 2016, table = "B02001", output = "wide")

# rename variables, subset cols
df %>%
  rename(totalPop = B02001_001E) %>%
  rename(totalPop_m = B02001_001M) %>%
  rename(white = B02001_002E) %>%
  rename(white_m = B02001_002M) %>%
  rename(black = B02001_003E) %>%
  rename(black_m = B02001_003M) %>%
  rename(aian = B02001_004E) %>%
  rename(aian_m = B02001_004M) %>%
  rename(asian = B02001_005E) %>%
  rename(asian_m = B02001_005M) %>%
  rename(nhpi = B02001_006E) %>%
  rename(nhpi_m = B02001_006M) %>%
  rename(otherRace = B02001_007E) %>%
  rename(otherRace_m = B02001_007M) %>%
  rename(twoRace = B02001_008E) %>%
  rename(twoRace_m = B02001_008M) %>%
  select(GEOID, NAME, totalPop, totalPop_m, white, white_m, black, black_m,
         aian, aian_m, asian, asian_m, nhpi, nhpi_m, otherRace, otherRace_m,
         twoRace, twoRace_m) -> stlRace

# save data
use_data(stlRace, overwrite = TRUE)

library(tidyverse)
library(dbplyr)

profiledata <- dbGetQuery(con,"SELECT * FROM processed.profiledata")

mekiki <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 1) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num")

freak <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 2) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num")

stoic <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 3) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num")

community <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 4) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num")

natural <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 5) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num")

rogical <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 6) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num")

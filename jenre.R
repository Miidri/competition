library(tidyverse)
library(dbplyr)

profiledata <- dbGetQuery(con,"SELECT * FROM processed.profiledata")

mekiki <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 1) %>% 
  distinct(house_num) %>%
  left_join(profiledata, by = "house_num") %>% 
  arrange(house_num, qu_genre_code, question_code)

freak <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 2) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num") %>% 
  arrange(house_num, qu_genre_code, question_code)

stoic <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 3) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num") %>% 
  arrange(house_num, qu_genre_code, question_code)

community <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 4) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num") %>% 
  arrange(house_num, qu_genre_code, question_code)

natural <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 5) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num") %>% 
  arrange(house_num, qu_genre_code, question_code)

rogical <- profiledata %>% 
  filter(qu_genre_code == 25, question_code == 1, answer_code == 6) %>% 
  distinct(house_num) %>% 
  left_join(profiledata, by = "house_num") %>% 
  arrange(house_num, qu_genre_code, question_code)

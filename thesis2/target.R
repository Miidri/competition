# タレント重視・コミュニティ同調
t_188 <- dbGetQuery(con,"
                    select
                    	action_datetime,
                    	action_day_week,
                    	station_code	
                    from
                    	processed.tv_play_p_cv
                    where
                    	house_num = 188
                    order by
                    	action_datetime;

                   ")

t_1092 <- dbGetQuery(con,"
                    select
                    	action_datetime,
                    	action_day_week,
                    	station_code	
                    from
                    	processed.tv_play_p_cv
                    where
                    	house_num = 1092
                    order by
                    	action_datetime;

                   ")

t_2016 <- dbGetQuery(con,"
                    select
                    	action_datetime,
                    	action_day_week,
                    	station_code	
                    from
                    	processed.tv_play_p_cv
                    where
                    	house_num = 2016
                    order by
                    	action_datetime;

                   ")

t_2796 <- dbGetQuery(con,"
                    select
                    	action_datetime,
                    	action_day_week,
                    	station_code	
                    from
                    	processed.tv_play_p_cv
                    where
                    	house_num = 2796
                    order by
                    	action_datetime;

                   ")

t_188 %>% 
  str()
t_1092 %>% 
  str()
t_2016 %>% 
  str()
t_2796%>% 
  str()






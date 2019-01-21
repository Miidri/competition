# EXTRACT(YEAR FROM br_start_datetime) AS year,
# EXTRACT(MONTH FROM br_start_datetime) AS month,


# タレント重視・コミュニティ同調
o_188 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 188
                      order by
                        br_start_datetime;
                    ")


o_1092 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 1092
                      order by
                        br_start_datetime;
                    ")

o_2016 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 2016
                      order by
                        br_start_datetime;
                    ")

o_2796 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 2796
                      order by
                        br_start_datetime;
                    ")

# タレント重視・トレンドフリーク
o_523 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 523
                      order by
                        br_start_datetime;
                     ")

o_1512 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 1512
                      order by
                        br_start_datetime;
                    ")

o_4231 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 4231
                      order by
                        br_start_datetime;
                    ")

o_5174 <- dbGetQuery(con,"
                      select
                     house_num,
                     br_start_datetime,
                     br_end_datetime,
                     br_day_week,
                     station_code,
                     data_agg_type
                     from
                     processed.tv_orgn_p_cv
                     where
                     house_num = 5174
                     order by
                     br_start_datetime;
                     ")

o_6913 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 6913
                      order by
                        br_start_datetime;
                    ")

# 機能実証派・トレンドフリーク
o_948 <- dbGetQuery(con,"
                      select
                        house_num,
                        br_start_datetime,
                        br_end_datetime,
                        br_day_week,
                        station_code,
                        data_agg_type
                      from
                        processed.tv_orgn_p_cv
                      where
                        house_num = 948
                      order by
                        br_start_datetime;
                    ")

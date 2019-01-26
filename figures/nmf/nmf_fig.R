# 時間
  dataset <- dbGetQuery(con,"
  SELECT
    EXTRACT(hour FROM br_start_datetime) AS hour,
    COUNT(*),
  data_agg_type_name
  FROM
    processed.tv_orgn_p_cv A
  LEFT JOIN
    sub_mst.data_agg_type_mst B
  ON
  A.data_agg_type = B.data_agg_type
  GROUP BY 1,3 ORDER BY 1")
  
  hour_all <- ggplot(dataset, aes(x= hour,y=count,fill= as.factor(data_agg_type_name)))+
    geom_bar(stat = "identity")+labs(fill="視聴方法")
  
  
  hour_tar <- o_hourly %>% 
    #  as_tibble() %>% 
    rename(hour = date_part) %>% 
    ggplot(aes(x = hour, y = count, fill = factor(data_agg_type)))+
    geom_bar(stat = "identity")+
    theme_bw()+labs(fill="視聴方法")


  grid.arrange(hour_tar, hour_all, ncol=2)


# 局
  dataset <- dbGetQuery(con,"
  SELECT
    station_jp,
    station_ab,
    COUNT(*),
    data_agg_type_name
  FROM
    processed.tv_orgn_p_cv AS A
  LEFT JOIN
    processed.sta_mst AS B
  ON
    A.station_code = B.station_code
  LEFT JOIN
    sub_mst.data_agg_type_mst AS C
  ON
    A.data_agg_type = C.data_agg_type
  GROUP BY
    1,2,4")
  
  sta_all <- ggplot(dataset,aes(x=station_jp,y=count,fill=data_agg_type_name))+
    geom_bar(stat = "identity")+xlab("テレビ局")+
    theme(axis.text.x = element_text(angle = 30, hjust = 1))+labs(fill="視聴方法")
  
  sta_tar <- o_sta %>%
    ggplot(aes(x=station_code, y=count, fill = factor(data_agg_type)))+
    geom_bar(stat = "identity")+
    xlab("テレビ局")+
    xlim(station_name)+labs(fill="視聴方法")+
    theme_bw()+
    theme(axis.text.x = element_text(angle = 30, hjust=1))
  
  grid.arrange(sta_tar, sta_all, ncol=2)

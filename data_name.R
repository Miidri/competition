#read read.me

# data
data1 <- dbGetQuery(con,"
                    SELECT
                    house_num,
                    question_code,
                    answer_code
                    FROM
                    processed.profiledata
                    WHERE
                    qu_genre_code = 3
                    and
                    question_code >= 4 
                    and
                    question_code <= 21
                    ORDER BY
                    house_num,
                    question_code,
                    answer_code
                    ;")

# data1をアンケート行列に変換
data1 <- data1 %>%
  tidyr::spread(key = question_code, value = answer_code)

# アンケート並び替え
data1 <- data1[,c(1,10,16,6,7,2,5,12,13,14,4,9,19,3,8,17,11,15,18)]
colnames(data1) <- c("house_num","I1","I2","I3","I4","I5","I6","I7","I8","I9","S1","S2","S3","S4","S5","S6","S7","S8","S9")

# 性別・未既婚・年齢を用意
data2 <-dbGetQuery(con,"
                   SELECT
                   distinct(P.house_num),
                   S.sex,
                   S.marriage,
                   S.age
                   FROM
                   processed.profiledata as P
                   LEFT JOIN
                   (SELECT
                   house_num,
                   sample_date,
                   age,
                   sex,
                   marriage
                   FROM
                   processed.tv_sample_p_cv
                   WHERE
                   (house_num, sample_date)
                   IN
                   (
                   SELECT
                   house_num,
                   min(sample_date) as sample_date
                   FROM
                   processed.tv_sample_p_cv
                   GROUP BY
                   house_num
                   )) as S
                   ON
                   S.house_num = P.house_num
                   WHERE
                   P.qu_genre_code = 3
                   and
                   P.question_code >= 4 
                   and
                   P.question_code <= 21
                   GROUP BY
                   P.house_num,
                   S.sex,
                   S.marriage,
                   S.age,
                   P.question_code,
                   P.answer_code
                   ORDER BY
                   house_num;")

# data1とdata2をくっつけてNをやっつける
data <- merge(data1, data2, by = "house_num")
table(is.na(data))
data[!complete.cases(data),]
data <- data[c(-1053,-4400,-4698),]
data1 <- data1[c(-1053,-4400,-4698),]
data2 <- data2[c(-1053,-4400,-4698),]

table(is.na(data))
dim(data)
dim(data1)
dim(data2)
# dataから男性だけ, 女性だけを用意
data_M <- subset(data, sex==1)
data_F <- subset(data, sex==2)

  
# 男性未婚MM
data_MM<- subset(data_M, marriage==2)
data_MM1 <- data_MM[,c(-20:-22)]

# 男性未婚MU
data_MU<- subset(data_M, marriage==1)
data_MU1 <- data_MU[,c(-20:-22)]

# 女性既婚FM
data_FM<- subset(data_F, marriage==2)
data_FM1 <- data_FM[,c(-20:-22)]

# 女性未婚FU
data_FU<- subset(data_F, marriage==1)
data_FU1 <- data_FU[,c(-20:-22)]

# 情報収集
dataI <-data[,-11:-19]
dataI1 <-data1[,-11:-19]

# 購買行動
dataS <-data[,-2:-10]
dataS1 <-data1[,-2:-10]

dataI_MM1 <- dataI %>% 
  dplyr::filter(dataI$sex == "1", dataI$marriage == "1") %>% 
  dplyr::select(house_num, I1, I2, I3, I4, I5, I6, I7, I8, I9)

dataS_MM1 <- dataS %>% 
  dplyr::filter(dataI$sex == "1", dataI$marriage == "1") %>% 
  dplyr::select(house_num, S1, S2, S3, S4, S5, S6, S7, S8, S9)

dataI_MU1 <- dataI %>% 
  dplyr::filter(dataI$sex == "1", dataI$marriage == "2") %>% 
  dplyr::select(house_num, I1, I2, I3, I4, I5, I6, I7, I8, I9)

dataS_MU1 <- dataS %>% 
  dplyr::filter(dataI$sex == "1", dataI$marriage == "2") %>% 
  dplyr::select(house_num, S1, S2, S3, S4, S5, S6, S7, S8, S9)

dataI_FM1 <- dataI %>% 
  dplyr::filter(dataI$sex == "2", dataI$marriage == "1") %>% 
  dplyr::select(house_num, I1, I2, I3, I4, I5, I6, I7, I8, I9)

dataS_FM1 <- dataS %>% 
  dplyr::filter(dataI$sex == "2", dataI$marriage == "1") %>% 
  dplyr::select(house_num, S1, S2, S3, S4, S5, S6, S7, S8, S9)

dataI_FU1 <- dataI %>% 
  dplyr::filter(dataI$sex == "2", dataI$marriage == "2") %>% 
  dplyr::select(house_num, I1, I2, I3, I4, I5, I6, I7, I8, I9)

dataS_FU1 <- dataS %>% 
  dplyr::filter(dataI$sex == "2", dataI$marriage == "2") %>% 
  dplyr::select(house_num, S1, S2, S3, S4, S5, S6, S7, S8, S9)

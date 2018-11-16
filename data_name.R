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
table(is.na(data))
dim(data)


# dataから男性だけ, 女性だけを用意
data_M <- subset(data, sex==1)
data_F <- subset(data, sex==2)

  
# 男性未婚MM
data_MM<- subset(data_M, marriage==2)

# 男性未婚MU
data_MU<- subset(data_M, marriage==1)

# 女性既婚FM
data_FM<- subset(data_F, marriage==2)

# 女性未婚FU
data_FU<- subset(data_F, marriage==1)


# 年齢を10歳刻みにした度数分布

age_freq10 <- cut(data$age, breaks=seq(10,70,10))
age_tab10 <- table(age_freq10)
age_tab10 <- data.frame(age_tab10)
ageX <-c("11-20","21-30","31-40","41-50","51-60","61-70")
age_tab10 <- cbind(age = ageX, count = age_tab10$Freq )
age_tab10 %>% 
  kable()

# クロス分析 of 性別・未既婚

# 男性1, 女性2：既婚1, 未婚2  
sex_marriage <- table(data$sex, data$marriage)
str(sex_marriage)
sex_marriage <- data.frame(sex_marriage)

sexN <- c("男性", "女性")
marriageN  <- c("既婚", "未婚")

sex_marriage%>% 
  kable()

# まとめ
# 全情報
head(data) %>% 
  kable()
# 全員アンケート
head(data1) %>% 
  kable()
# 全員標本
head(data2) %>% 
  kable()
# 既婚男性アンケート
head(data_MM) %>% 
  kable()
# 未婚男性アンケート
head(data_MU) %>% 
  kable()
# 既婚女性アンケート
head(data_FM) %>% 
  kable()
# 未婚女性アンケート
head(data_FU) %>% 
  kable()
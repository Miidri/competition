source("/home/midori/competition/psql.R")
#install.packages("tidyverse")
library(tidyverse)

data <- dbGetQuery(con,"
                   select
                   house_num,
                   sex,
                   marriage,
                   age
                   from 
                   processed.tv_sample_p_cv
                   group by
                   house_num,
                   sex, 
                   marriage,
                   age
                   order by
                   house_num
                   ")

dataIS<-dbGetQuery(con,"
                   select
                   house_num,
                   question_code,
                   answer_code
                   from 
                   processed.profiledata
                   where
                   qu_genre_code = 3 and
                   question_code >=4 and
                   question_code <=21
                   order by
                   house_num,
                   question_code
                   ")

genreIS<-dbGetQuery(con,"select
                    house_num,
                    answer_code
                    from
                    processed.profiledata
                    where
                    qu_genre_code = 25 and
                    question_code =1 
                    group by 
                    house_num,
                    answer_code
                    order by
                    house_num
                    ")

##
dataIS <- dataIS %>% 
  tidyr::spread(key = question_code, value = answer_code) %>% 
  arrange(house_num)

###
# 都合よくなるよう順番変えるよ
dataIS <- dataIS[,c(1,10,16,6,7,2,12,13,14,5,4,19,9,3,8,17,11,15,18)]

###
question_numIS<- c("house_num", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)

colnames(dataIS) <- question_numIS
#これでhouse_num+設問の行列完成. ただ,重複が3件！

#######
# 調理するよ
dataIS <- left_join(dataIS, data, by="house_num")
dim(dataIS)
# なんか多いぞ
dataIS[!complete.cases(dataIS),]
dataIS <- dataIS %>%
  group_by(house_num) %>% 
  dplyr::slice(1) %>% 
  ungroup() %>% 
  filter(!is.na(sex))
dataIS1 <- dataIS[,-20:-22]
# これで4712行. あとはindex系を追加する.後で.

##############
# genreISつけとくか
genreIS <- left_join(genreIS, data, by="house_num")
dim(genreIS)
genreIS[!complete.cases(genreIS),]
genreIS <- genreIS %>%
  group_by(house_num) %>% 
  dplyr::slice(1) %>% 
  ungroup() %>% 
  filter(!is.na(sex))
genreIS <- genreIS[, 2]
# クラスタ名にしちゃおう
for(i in 1:4712){
  if(genreIS$answer_code[i]==1){
    genreIS$answer_code[i]= "スマート目利き"}
  else if(genreIS$answer_code[i]==2){
    genreIS$answer_code[i]="トレンドフリーク" }
  else if(genreIS$answer_code[i]==3){
    genreIS$answer_code[i]="堅実ストイック" }
  else if(genreIS$answer_code[i]==4){
    genreIS$answer_code[i]="コミュニティ同調" }
  else if(genreIS$answer_code[i]==5){
    genreIS$answer_code[i]="ナチュラル低関与"}
  else{
    genreIS$answer_code[i]="雑学ロジカル"}
}
genreIS<- genreIS$answer_code
########
house_num <-dataIS$house_num
sex <- dataIS$sex
marriage <- dataIS$marriage
age <- dataIS$age
index <- c(rep(1,4712))
age_index <- c(rep(1,4712))

data2 <- cbind(house_num, sex, marriage,age, index, age_index, genreIS)
data2 <- as.data.frame(data2, stringsAsFactors = FALSE)

for(i in 1:4712){
  if((data2$sex[i]==1) && (data2$marriage[i]==1)){
    data2$index[i]="未婚男性"}
  else if((data2$sex[i]==1) && (data2$marriage[i]==2)){
    data2$index[i]="既婚男性" }
  else if((data2$sex[i]==2) && (data2$marriage[i]==1)){
    data2$index[i]="未婚女性"}
  else{
    data2$index[i]="既婚女性"}
}

for(i in 1:4712){
  if(data2$age[i]<=19){
    data2$age_index[i]="10代"}
  else if((data2$age[i]>=20) && (data2$age[i]<=29)){
    data2$age_index[i]="20代" }
  else if((data2$age[i]>=30) && (data2$age[i]<=39)){
    data2$age_index[i]="30代" }
  else if((data2$age[i]>=40) && (data2$age[i]<=49)){
    data2$age_index[i]="40代" }
  else if((data2$age[i]>=50) && (data2$age[i]<=59)){
    data2$age_index[i]="50代" }
  else{
    data2$age_index[i]="60代以上"}
}

for(i in 1:4712){
  if(data2$age[i]<=19){
    data2$age_index[i]="10代" }
  else if((data2$age[i]>=20) && (data2$age[i]<=29)){
    data2$age_index[i]="20代" }
  else if((data2$age[i]>=30) && (data2$age[i]<=39)){
    data2$age_index[i]="30代" }
  else if((data2$age[i]>=40) && (data2$age[i]<=49)){
    data2$age_index[i]="40代" }
  else if((data2$age[i]>=50) && (data2$age[i]<=59)){
    data2$age_index[i]="50代" }
  else{
    data2$age_index[i]="60代以上"}
}
for(i in 1:4712){
  if(data2$sex[i]==1){
    data2$sex[i]="男性" }
  else{
    data2$sex[i]="女性"}
}
for(i in 1:4712){
  if(data2$marriage[i]==1){
    data2$marriage[i]="未婚" }
  else{
    data2$marriage[i]="既婚"}
}

############
# ここからテキトーさん消す作業
only_I1 <- dataIS %>%
  filter(`1` == 1,
         `2` == 1,
         `3` == 1,
         `4` == 1,
         `5` == 1,
         `6` == 1,
         `7` == 1,
         `8` == 1,
         `9` == 1 ) %>% 
  dplyr::select(house_num)

only_I2 <- dataIS %>%
  filter(`1` == 2,
         `2` == 2,
         `3` == 2,
         `4` == 2,
         `5` == 2,
         `6` == 2,
         `7` == 2,
         `8` == 2,
         `9` == 2 ) %>% 
  dplyr::select(house_num)

only_I3 <- dataIS %>%
  filter(`1` == 3,
         `2` == 3,
         `3` == 3,
         `4` == 3,
         `5` == 3,
         `6` == 3,
         `7` == 3,
         `8` == 3,
         `9` == 3 ) %>% 
  dplyr::select(house_num)

only_I4 <- dataIS %>%
  filter(`1` == 4,
         `2` == 4,
         `3` == 4,
         `4` == 4,
         `5` == 4,
         `6` == 4,
         `7` == 4,
         `8` == 4,
         `9` == 4 ) %>% 
  dplyr::select(house_num)

only_I5 <- dataIS %>%
  filter(`1` == 5,
         `2` == 5,
         `3` == 5,
         `4` == 5,
         `5` == 5,
         `6` == 5,
         `7` == 5,
         `8` == 5,
         `9` == 5 ) %>% 
  dplyr::select(house_num)

only_S1 <- dataIS %>%
  filter(`10` == 1,
         `11` == 1,
         `12` == 1,
         `13` == 1,
         `14` == 1,
         `15` == 1,
         `16` == 1,
         `17` == 1,
         `18` == 1 ) %>% 
  dplyr::select(house_num)

only_S2 <- dataIS %>%
  filter(`10` == 2,
         `11` == 2,
         `12` == 2,
         `13` == 2,
         `14` == 2,
         `15` == 2,
         `16` == 2,
         `17` == 2,
         `18` == 2 ) %>% 
  dplyr::select(house_num)

only_S3 <- dataIS %>%
  filter(`10` == 3,
         `11` == 3,
         `12` == 3,
         `13` == 3,
         `14` == 3,
         `15` == 3,
         `16` == 3,
         `17` == 3,
         `18` == 3 ) %>% 
  dplyr::select(house_num)

only_S4 <- dataIS %>%
  filter(`10` == 4,
         `11` == 4,
         `12` == 4,
         `13` == 4,
         `14` == 4,
         `15` == 4,
         `16` == 4,
         `17` == 4,
         `18` == 4 ) %>% 
  dplyr::select(house_num)

only_S5 <- dataIS %>%
  filter(`10` == 5,
         `11` == 5,
         `12` == 5,
         `13` == 5,
         `14` == 5,
         `15` == 5,
         `16` == 5,
         `17` == 5,
         `18` == 5 ) %>% 
  dplyr::select(house_num)
only_I1 %>% count()+
  only_I2 %>% count()+
  only_I3 %>% count()+
  only_I4 %>% count()+
  only_I5 %>% count()

only_S1 %>% count()+
  only_S2 %>% count()+
  only_S3 %>% count()+
  only_S4 %>% count()+
  only_S5 %>% count()

# テキトーのhouse_num格納
only_all <- rbind(only_I1, only_I2, only_I3, only_I4, only_I5,
                  only_S1, only_S2, only_S3, only_S4, only_S5)  

# subは片方だけテキトーピープル
only_all_sub <- only_all %>% 
  arrange(house_num) %>%
  group_by(house_num) %>% 
  filter(n()==1)

# allはがちテキトーパーソン
only_all <- only_all %>% 
  arrange(house_num) %>%
  group_by(house_num) %>% 
  filter(n()>1) %>% 
  dplyr::slice(1)

# テキトーパーソンを抜いたdataIS作ろう
dataIS_new <- dataIS %>% 
  dplyr::select(house_num)
a <- c(rep(0,4712))
dataIS_new <- cbind(dataIS_new, a)  
for(i in 1:4712){
  for (j in 1:269) {
    if(dataIS_new$house_num[i]==only_all$house_num[j]){
      dataIS_new$a[i]= 1}
  }
}
dataIS_new <-  dataIS_new %>% 
  filter(a == 0) 
dataIS_new <- merge(dataIS_new, dataIS1)
dataIS_new <- dataIS_new[,-2]
dataIS_new %>% count()

## subもやるよ
dataIS_new_sub <- dataIS_new %>% 
  dplyr::select(house_num)
a <- c(rep(0,4443))
dataIS_new_sub <- cbind(dataIS_new_sub, a)  
for(i in 1:4443){
  for (j in 1:226) {
    if(dataIS_new_sub$house_num[i]==only_all_sub$house_num[j]){
      dataIS_new_sub$a[i]= 1}
  }
}

dataIS_new_sub <-  dataIS_new_sub %>% 
  filter(a == 0) 
dataIS_new_sub <- merge(dataIS_new_sub, dataIS_new)
dataIS_new_sub <- dataIS_new_sub[,-2]
dataIS_new_sub %>% count()

#################
dataIS1_new <- merge(dataIS_new, data2, by="house_num")
house_num <-dataIS1_new$house_num
sex <- dataIS1_new$sex
marriage <- dataIS1_new$marriage
age <- dataIS1_new$age
index <-dataIS1_new$index
age_index <-dataIS1_new$age_index
age <- age %>% as.integer()
genreIS <- dataIS1_new$genreIS

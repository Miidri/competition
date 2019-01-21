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


dataL <-  dbGetQuery(con,"
                     select
                     house_num,
                     question_code,
                     answer_code
                     from 
                     processed.profiledata
                     where
                     qu_genre_code = 3 and
                     question_code >=22 and
                     question_code <=51
                     order by
                     house_num,
                     question_code
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

genreL<-dbGetQuery(con,"select
                   house_num,
                   answer_code
                   from
                   processed.profiledata
                   where
                   qu_genre_code = 25 and
                   question_code =2 
                   group by 
                   house_num,
                   answer_code
                   order by
                   house_num
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
dataL <- dataL %>%
  tidyr::spread(key = question_code, value = answer_code) %>% 
  arrange(house_num)

dataIS <- dataIS %>% 
  tidyr::spread(key = question_code, value = answer_code) %>% 
  arrange(house_num)

###
# 都合よくなるよう順番変えるよ
dataL  <- dataL[,c(1,4,10,19,9,18,20,22,25,27,29,23,11,16,6,13,15,26,3,5,7,8,12,14,17,21,24,30,2,28,31)]
dataIS <- dataIS[,c(1,10,16,6,7,2,12,13,14,5,4,19,9,3,8,17,11,15,18)]

###
question_numL <- c("house_num", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30)
question_numIS<- c("house_num", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)

colnames(dataL) <- question_numL
colnames(dataIS) <- question_numIS
#これでhouse_num+設問の行列完成. ただ,重複が3件！

#######
# Lから調理
dataL <- left_join(dataL, data, by="house_num")
dim(dataL)
#なんか多いぞ
dataL[!complete.cases(dataL),]
dataL <- dataL %>%
  group_by(house_num) %>% 
  dplyr::slice(1) %>% 
  ungroup() %>% 
  filter(!is.na(sex))
dataL1 <- dataL[,-32:-34]
# これでLが4712行. あとはindex系をL1に追加する.後で.

#######
# ISも調理
dataIS <- left_join(dataIS, data, by="house_num")
dim(dataIS)
#もちろん多いぞ
dataIS[!complete.cases(dataIS),]
dataIS <- dataIS %>%
  group_by(house_num) %>% 
  dplyr::slice(1) %>% 
  ungroup() %>% 
  filter(!is.na(sex))
dataIS1 <- dataIS[,-20:-22]

#######
# genreLもやらなくては
genreL <- left_join(genreL, data, by="house_num")
dim(genreL)
genreL[!complete.cases(genreL),]
genreL <- genreL %>%
  group_by(house_num) %>% 
  dplyr::slice(1) %>% 
  ungroup() %>% 
  filter(!is.na(sex))
genreL <- genreL[, 2]
# クラスタ名にしちゃおう
for(i in 1:4712){
  if(genreL$answer_code[i]==1){
    genreL$answer_code[i]= "表現嗜好なし"}
  else if(genreL$answer_code[i]==2){
    genreL$answer_code[i]="ストーリー・感性" }
  else if(genreL$answer_code[i]==3){
    genreL$answer_code[i]="表現無頓着" }
  else if(genreL$answer_code[i]==4){
    genreL$answer_code[i]="タレント重視" }
  else if(genreL$answer_code[i]==5){
    genreL$answer_code[i]="シンプル嗜好"}
  else{
    genreL$answer_code[i]="機能実証派"}
}
genreL <- genreL$answer_code
#######
# genreISも同じく
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
# 
# 
# data2 <- data
# 
house_num <-dataL$house_num
sex <- dataL$sex
marriage <- dataL$marriage
age <- dataL$age
index <- c(rep(1,4712))
age_index <- c(rep(1,4712))

data2 <- cbind(house_num, sex, marriage,age, index, age_index, genreIS, genreL)
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



index <-data2$index
age_index <-data2$age_index
sex<-data2$sex
# rownames(sex1) <- house_num
# rownames(marriage) <- house_num
# rownames(age) <- house_num
# rownames(index) <- house_num
# rownames(age_index) <- house_num
# rownames(genreIS) <- house_num
# rownames(genreL) <- house_num




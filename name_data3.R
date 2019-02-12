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

dataL<-dbGetQuery(con,"
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
                     question_code")

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

##
dataL <- dataL %>% 
  tidyr::spread(key = question_code, value = answer_code) %>% 
  arrange(house_num)

###
# 都合よくなるよう順番変えるよ
dataL <- dataL[,c(1,4,10,19,9,18,20,22,25,27,29,23,11,16,6,13,15,26,3,5,7,8,12,14,17,21,24,30,2,28,31)]

###
question_num <- c("house_num", 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30)

colnames(dataL) <- question_num
#これでhouse_num+設問の行列完成. ただ,重複が3件！

#######
# 調理するよ
dataL <- left_join(dataL, data, by="house_num")
dim(dataL)
# なんか多いぞ
dataL[!complete.cases(dataL),]
dataL <- dataL %>%
  group_by(house_num) %>% 
  dplyr::slice(1) %>% 
  ungroup() %>% 
  filter(!is.na(sex))
dataL1 <- dataL[,-32:-34]
# これで4712行. あとはindex系を追加する.後で.

##############
# genreLつけとくか
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
########
house_num <-dataL$house_num
sex <- dataL$sex
marriage <- dataL$marriage
age <- dataL$age
index <- c(rep(1,4712))
age_index <- c(rep(1,4712))

data2 <- cbind(house_num, sex, marriage,age, index, age_index, genreL)
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
only_L1 <- dataL %>%
  filter(`1` == 1,
         `2` == 1,
         `3` == 1,
         `4` == 1,
         `5` == 1,
         `6` == 1,
         `7` == 1,
         `8` == 1,
         `9` == 1,
         `10` == 1,
         `11` == 1,
         `12` == 1,
         `13` == 1,
         `14` == 1,
         `15` == 1,
         `16` == 1,
         `17` == 1,
         `18` == 1,
         `19` == 1,
         `20` == 1,
         `21` == 1,
         `22` == 1,
         `23` == 1,
         `24` == 1,
         `25` == 1,
         `26` == 1,
         `27` == 1,
         `28` == 1,
         `29` == 1,
         `30` == 1
  ) %>% 
  dplyr::select(house_num)

only_L2 <- dataL %>%
  filter(`1` == 2,
         `2` == 2,
         `3` == 2,
         `4` == 2,
         `5` == 2,
         `6` == 2,
         `7` == 2,
         `8` == 2,
         `9` == 2,
         `10` == 2,
         `11` == 2,
         `12` == 2,
         `13` == 2,
         `14` == 2,
         `15` == 2,
         `16` == 2,
         `17` == 2,
         `18` == 2,
         `19` == 2,
         `20` == 2,
         `21` == 2,
         `22` == 2,
         `23` == 2,
         `24` == 2,
         `25` == 2,
         `26` == 2,
         `27` == 2,
         `28` == 2,
         `29` == 2,
         `30` == 2
  ) %>% 
  dplyr::select(house_num)

only_L3 <- dataL %>%
  filter(`1` == 3,
         `2` == 3,
         `3` == 3,
         `4` == 3,
         `5` == 3,
         `6` == 3,
         `7` == 3,
         `8` == 3,
         `9` == 3,
         `10` == 3,
         `11` == 3,
         `12` == 3,
         `13` == 3,
         `14` == 3,
         `15` == 3,
         `16` == 3,
         `17` == 3,
         `18` == 3,
         `19` == 3,
         `20` == 3,
         `21` == 3,
         `22` == 3,
         `23` == 3,
         `24` == 3,
         `25` == 3,
         `26` == 3,
         `27` == 3,
         `28` == 3,
         `29` == 3,
         `30` == 3
  ) %>% 
  dplyr::select(house_num)

only_L4 <- dataL %>%
  filter(`1` == 4,
         `2` == 4,
         `3` == 4,
         `4` == 4,
         `5` == 4,
         `6` == 4,
         `7` == 4,
         `8` == 4,
         `9` == 4,
         `10` == 4,
         `11` == 4,
         `12` == 4,
         `13` == 4,
         `14` == 4,
         `15` == 4,
         `16` == 4,
         `17` == 4,
         `18` == 4,
         `19` == 4,
         `20` == 4,
         `21` == 4,
         `22` == 4,
         `23` == 4,
         `24` == 4,
         `25` == 4,
         `26` == 4,
         `27` == 4,
         `28` == 4,
         `29` == 4,
         `30` == 4
  ) %>% 
  dplyr::select(house_num)

only_L5 <- dataL %>%
  filter(`1` == 5,
         `2` == 5,
         `3` == 5,
         `4` == 5,
         `5` == 5,
         `6` == 5,
         `7` == 5,
         `8` == 5,
         `9` == 5,
         `10` == 5,
         `11` == 5,
         `12` == 5,
         `13` == 5,
         `14` == 5,
         `15` == 5,
         `16` == 5,
         `17` == 5,
         `18` == 5,
         `19` == 5,
         `20` == 5,
         `21` == 5,
         `22` == 5,
         `23` == 5,
         `24` == 5,
         `25` == 5,
         `26` == 5,
         `27` == 5,
         `28` == 5,
         `29` == 5,
         `30` == 5
  ) %>% 
  dplyr::select(house_num)

only_L1 %>% count()+
  only_L2 %>% count()+
  only_L3 %>% count()+
  only_L4 %>% count()+
  only_L5 %>% count()

# テキトーのhouse_num格納
only_allL <- rbind(only_L1, only_L2, only_L3, only_L4, only_L5)  

# テキトーパーソンを抜いたdataL作ろう
dataL_new <- dataL %>% 
  dplyr::select(house_num)
a <- c(rep(0,4712))
dataL_new <- cbind(dataL_new, a)  
for(i in 1:4712){
  for (j in 1:381) {
    if(dataL_new$house_num[i]==only_allL$house_num[j]){
      dataL_new$a[i]= 1}
  }
}
dataL_new <-  dataL_new %>% 
  filter(a == 0) 
dataL_new <- merge(dataL_new, dataL1)
dataL_new <- dataL_new[,-2]
dataL_new %>% count()

#################
dataL1_new <- merge(dataL_new, data2, by="house_num")
house_num <-dataL1_new$house_num
sex <- dataL1_new$sex
marriage <- dataL1_new$marriage
age <- dataL1_new$age
index <-dataL1_new$index
age_index <-dataL1_new$age_index
age <- age %>% as.integer()
genreL <- dataL1_new$genreL

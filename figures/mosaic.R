resultAI <- pamL$clustering #clusL の clusL と同じ
resultSAS <- pamIS$clustering #clusIS の clusIS と同じ
segment1 <- data2$genreL #表現嗜好の正解ラベル
segment2 <- data2$genreIS # 情報選択の正解ラベル


# AI VR表現嗜好と答え合わせ
crossAI <- xtabs(~segment1 + resultAI) 
crossAI %>% 
  t() %>% 
  kable()
plot(crossAI,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="表現嗜好セグメント", ylab="Attention・Interest") 

# SAS VR情報選択と答え合わせ
crossSAS <- xtabs(~segment2 + resultSAS) 
crossSAS %>%
  t() %>% 
  kable()
plot(crossSAS,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="情報選択セグメント", ylab="Search・Action・Share") 
# VR モザイク
# cross0 <- xtabs(~segment1 + segment2) 
# cross0 %>% 
#   kable()
#plot(cross0,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
#     ,las=1, main="")

# AISAS モザイク
cross3 <- xtabs(~resultSAS + resultAI)
cross3 %>% 
  t() %>% 
  kable()
plot(cross3,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="Search・Action・Share", ylab="Attention・Interest")


# 男女 モザイク
cross_sex1 <- xtabs(~sex + resultAI)
cross_sex1 %>% 
  t() %>% 
  kable()
plot(cross_sex1,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="性別", ylab="Attention・Interest")

# 年齢 モザイク
cross_age1 <- xtabs(~age_index + resultAI)
cross_age1 %>% 
  t() %>% 
  kable()

plot(cross_age1,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="年齢", ylab="A・I")

# 男女 モザイク
cross_sex2 <- xtabs(~sex + resultSAS)
cross_sex2 %>% 
  t() %>% 
  kable()
plot(cross_sex2,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="性別", ylab="S・A・S")

# 年齢 モザイク
cross_age2 <- xtabs(~age_index + resultSAS)
cross_age2 %>% 
  t() %>% 
  kable()
plot(cross_age2,col=c("pink", "red", "orange", "yellow", "lightgreen",  "skyblue")
     ,las=1, main="", xlab="年齢", ylab="S・A・S")

   par(mfrow=c(1,1)) 
 par(mfrow=c(1,2)) 
setwd("~/Documents/PRDW/TeradataSQLFiles/analysis/analyse_horaire")
analyse=read.csv("analyse_horaire.csv",header=T,na.strings ="?")

fit1=lm(hour~likecount,data=analyse)
# pb de inference,classification

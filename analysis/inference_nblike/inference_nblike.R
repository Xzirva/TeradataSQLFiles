setwd("~/Documents/PRDW/TeradataSQLFiles/analysis/inference_nblike")

nblike=read.csv("nblike.csv",header=T,na.strings ="?")

#L'objectif de cet analyse est de trouver les variables qui ont un influence significatives sur 
#le nb de like de video

fit=lm(likecount ~ viewcount + channelsubscribercount + channelvideocount + commentcount + dislikecount,data=nblike)
summary(fit)


#d'apres les resultat de summary(fit), tous les coefficients sont significatifs
# viewcount + channelsubscribercount + channelvideocount + commentcount + dislikecount
# ont tous une influence sur le nb de like de video
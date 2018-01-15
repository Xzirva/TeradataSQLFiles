setwd("~/Documents/PRDW/TeradataSQLFiles/analysis/inference_nbview")

nbview=read.csv("nbview.csv",header=T,na.strings ="?")

#L'objectif de cet analyse est de trouver les variables qui ont un influence significatives sur 
#le nb de view de video

fit=lm(viewcount ~ likecount + channelsubscribercount + channelvideocount + commentcount + dislikecount,data=nbview)
summary(fit)


#d'apres les resultat de summary(fit), tous les coefficients sont significatifs
# likecount + channelsubscribercount + channelvideocount + commentcount + dislikecount
# ont tous une influence sur le nb de view de video
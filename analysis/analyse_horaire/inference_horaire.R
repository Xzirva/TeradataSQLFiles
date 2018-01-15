setwd("~/Documents/PRDW/TeradataSQLFiles/analysis/analyse_horaire")
analyse=read.csv("analyse_horaire.csv",header=T,na.strings ="?")

#dans analyse : 
#hour : l'horaire le plus tôt où le nombre de vue atteint max
#L'objectif de l'analyse est de voir quelle variable a une influence significatif sur l'horaire le plus tôt
#où le nombre de vue atteint max

#model 1 : simple linear regression l'ordre 1
fit1=lm(hour~likecount + channelsubscribercount + channelvideocount + commentcount + dislikecount,data=analyse)

summary(fit1)

#d'apres le resultat de summary(fit1), le coefficient significatifs sont likecount, commentcount et dislikecount

#model 2 : interaction
fit2=lm(hour~likecount + channelsubscribercount + channelvideocount + commentcount + dislikecount
        + likecount:commentcount:dislikecount,data=analyse)
fit3=lm(hour~likecount + channelsubscribercount + channelvideocount + commentcount + dislikecount
        + likecount:commentcount:dislikecount + channelsubscribercount:channelvideocount,data=analyse)
fit4=lm(hour~likecount + channelsubscribercount + channelvideocount + commentcount + dislikecount
        + likecount:dislikecount,data=analyse)
#j'ai aussi aussi essaye les autres differentes forms d'interaction, mais d'apres le summary le coefficient ne sont pas significatif
#Donc on peut deduire que il n'y a pas d'interaction entre les variables

#model 3 : non linear
fit5=lm(hour~I(likecount^2) +I( channelsubscribercount^2) + I(channelvideocount^2) + I(commentcount^2) + I(dislikecount^2),data=analyse)
#fit 5 : channelsubscribercount et channelvideocount sont significatifs
fit6=lm(hour~likecount+I( channelsubscribercount^2) + I(channelvideocount^2) + commentcount + dislikecount,data=analyse)
#fit 6: seul les variables avec l'ordre 1 : commentcount et dislikecount sont significatifs
#Donc on peut deduire que les coefficient des  variables avec l'ordre 2 ne sont pas significatifs 


#####conclusion :likecount de video, commentcount de video et dislikecount de video a une influence significatif sur l'horaire le plus tôt
#où le nombre de vue atteint max

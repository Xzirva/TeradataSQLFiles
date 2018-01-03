pd=read.csv("nbpositive_dislike.csv",header=T,na.strings ="?")

x <- pd[,2]
y <- pd[,3]

plot(x,y,xlab = 'Nombre de commentaires positives',ylab='Espérance de nombre de dislike')

pf=read.csv("nbpositive_favorite.csv",header=T,na.strings ="?")

x <- pf[,2]
y <- pf[,3]

plot(x,y,xlab = 'Nombre de commentaires positives',ylab='Espérance de nombre de favorite')



pl=read.csv("nbpositive_likecount.csv",header=T,na.strings ="?")

x <- pl[,2]
y <- pl[,3]

plot(x,y,xlab = 'Nombre de commentaires positives',ylab='Espérance de nombre de like')


nd=read.csv("nbnegative_dislike.csv",header=T,na.strings ="?")

x <- nd[,2]
y <- nd[,3]

plot(x,y,xlab = 'Nombre de commentaires négatives',ylab='Espérance de nombre de dislike')


nf=read.csv("nbnegative_favorite.csv",header=T,na.strings ="?")

x <- nf[,2]
y <- nf[,3]

plot(x,y,xlab = 'Nombre de commentaires négatives',ylab='Espérance de nombre de favorite')


nl=read.csv("nbnegative_like.csv",header=T,na.strings ="?")

x <- nl[,2]
y <- nl[,3]

plot(x,y,xlab = 'Nombre de commentaires négatives',ylab='Espérance de nombre de like')

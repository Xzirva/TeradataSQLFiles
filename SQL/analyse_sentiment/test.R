#pb de inference

## ok
pd=read.csv("nbpositive_dislike.csv",header=T,na.strings ="?")

pd <- pd[-57,]
pd <- pd[-106,]
x <- pd[,2]
y <- pd[,3]

plot(x,y,xlab = 'Nombre de commentaires positives',ylab='Espérance de nombre de dislike')
plot(fit.2)
fit.1=lm(X109.0000000000000000~X20,data=pd)
fit.2=lm(X109.0000000000000000~poly(X20,2),data=pd)
fit.3=lm(X109.0000000000000000~poly(X20,3),data=pd)
fit.4=lm(X109.0000000000000000~poly(X20,4),data=pd)
anova(fit.1,fit.2,fit.3,fit.4)
#y=x^2*(-99)+x*184+29
#fit.2=lm(X109.0000000000000000~poly(X20,2),data=pd) coeffient tres significatif
## ok

## ok
pf=read.csv("nbpositive_favorite.csv",header=T,na.strings ="?")

x <- pf[,2]
y <- pf[,3]

plot(x,y,xlab = 'Nombre de commentaires positives',ylab='Espérance de nombre de favorite')
#Espérance de nombre de favorite constant
## ok

## ok
pl=read.csv("nbpositive_likecount.csv",header=T,na.strings ="?")
pl <- pl[-119,]
pl <- pl[-38,]
x <- pl[,2]
y <- pl[,3]

plot(x,y,xlab = 'Nombre de commentaires positives',ylab='Espérance de nombre de like')
fit.1=lm(X134.0000000000000000~X8,data=pl)
fit.2=lm(X134.0000000000000000~poly(X8,2),data=pl)
fit.3=lm(X134.0000000000000000~poly(X8,3),data=pl)
fit.4=lm(X134.0000000000000000~poly(X8,4),data=pl)
anova(fit.1,fit.2,fit.3,fit.4)
# non relationship
## ok

## ok
nd=read.csv("nbnegative_dislike.csv",header=T,na.strings ="?")
nd <- nd[-42,]
x <- nd[,2]
y <- nd[,3]

plot(x,y,xlab = 'Nombre de commentaires négatives',ylab='Espérance de nombre de dislike')


fit.1=lm(X9.0000000000000000~X26,data=nd)
fit.2=lm(X9.0000000000000000~poly(X26,2),data=nd)
fit.3=lm(X9.0000000000000000~poly(X26,3),data=nd)
fit.4=lm(X9.0000000000000000~poly(X26,4),data=nd)
anova(fit.1,fit.2,fit.3,fit.4)

#y=x^2*(-174)+x*194+29
#fit.2=lm(X9.0000000000000000~poly(X26,2),data=nd) coeffient tres significatif
## ok

## ok
nf=read.csv("nbnegative_favorite.csv",header=T,na.strings ="?")

x <- nf[,2]
y <- nf[,3]

plot(x,y,xlab = 'Nombre de commentaires négatives',ylab='Espérance de nombre de favorite')
#Espérance de nombre de favorite constant
## ok

## ok
nl=read.csv("nbnegative_like.csv",header=T,na.strings ="?")
nl <- nl[-42,]
x <- nl[,2]
y <- nl[,3]

plot(x,y,xlab = 'Nombre de commentaires négatives',ylab='Espérance de nombre de like')

fit.1=lm(X134.0000000000000000~X26,data=nl)
fit.2=lm(X134.0000000000000000~poly(X26,2),data=nl)
fit.3=lm(X134.0000000000000000~poly(X26,3),data=nl)
fit.4=lm(X134.0000000000000000~poly(X26,4),data=nl)
anova(fit.1,fit.2,fit.3,fit.4)
#non relationship
## ok

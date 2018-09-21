# clear all
rm(list=ls())

# loading toolboxes needed
library(ggplot2) 
library(psych)
library(nFactors)
options(scipen = 999)

# set directory 
setwd("D:/Radicalism_Change_of_Mind/github/")
#loading data
mdata = readMat("CombinedData_Gorilla.mat")

# adding column names
mydata=mdata$Questionnaire.extract
colnames(mydata, do.NULL = FALSE)
heading<-matrix(0,1,length(mdata$Items.labels))
for (i in 1:length(mdata$Items.labels))
{
  heading[i]=mdata$Items.labels[[i]][[1]][,1]
}
colnames(mydata)=heading


# run the Cattell-Nelson-Gorsuch test to determine the number of factors
CNG=nCng(cor(mydata[1:344,]), cor=TRUE, model="factors", details=TRUE)
number_factors=CNG$nFactors 

#run the factor analysis
fa.results_Prestudy= fa(mydata[1:344,], nfactors = number_factors,rotate = "oblimin", fm="ml")

# extract factor loadings
loadings <- abs(fa.results$loadings)


# PLot the factor loadings (Figure 1A)
loadingsplot<- 0
loadingsplot = abs(data.frame(loadings[,1],loadings[,2],loadings[,3]))
loadingsplot$x <- factor(rownames(loadingsplot), levels = rownames(loadingsplot))
Questionnaires=c(rep("Self report",3), rep("Voting",3), rep("SECS",12), rep("RWA",12), rep("LWA",8), rep("Political Issues",9), rep("Belief Superiority",9), rep("Dog",22))
values=c(rep("#999999",3), rep("#E69F00",3), rep("#56B4E9",12), rep("#009E73",12), rep("#F0E442",8), rep("#0072B2",9), rep("#D55E00",9), rep("#CC79A7",22))

a<-ggplot(loadingsplot[1], aes(x = loadingsplot$x, y = loadingsplot$loadings...1, fill=Questionnaires)) + 
  geom_bar(stat = "identity", position=position_dodge()) + 
  scale_fill_manual(values=c("#999999", "#E69F00","#56B4E9", "#009E73","#F0E442","#0072B2","#D55E00", "#CC79A7"), name="Questionnaires", breaks=c("Self report", "Voting", "SECS", "RWA", "LWA", "Political Issues", "Belief Superiority", "Dog"),labels=c("Political Orientation", "Voting", "SECS", "RWA", "LWA", "Political Issues", "Belief Superiority", "Dogmatism"))+
  
  labs(title="Factor 1: Political orientation", x="", y = "Loadings") +  theme_classic(base_size = 18) +
  theme(axis.ticks = element_blank() ,axis.text.x = element_blank(),axis.line = element_blank())+
  expand_limits(y=c(-.9,.9))+theme(axis.text=element_text(size=18),axis.title=element_text(size=18))


b<-ggplot(loadingsplot[2], aes(x = loadingsplot$x, y = loadingsplot$loadings...2, fill=Questionnaires)) + 
  geom_bar(stat = "identity") + 
  scale_fill_manual(values=c("#999999", "#E69F00","#56B4E9", "#009E73","#F0E442","#0072B2","#D55E00", "#CC79A7"), name="Questionnaires", breaks=c("Self report", "Voting", "SECS", "RWA", "LWA", "Political Issues", "Belief Superiority", "Dog"),labels=c("Political Orientation", "Voting", "SECS", "RWA", "LWA", "Political Issues", "Belief Superiority", "Dogmatism"))+
  labs(title="Factor 2: Dogmatic intolerance", x="", y = "Loadings") +  theme_classic(base_size = 18)+
  theme(axis.ticks = element_blank() ,axis.text.x = element_blank(),axis.line = element_blank(),legend.title=element_blank())+
  expand_limits(y=c(-.9,.9))+theme(axis.text=element_text(size=18),axis.title=element_text(size=18))


c<-ggplot(loadingsplot[3], aes(x = loadingsplot$x, y = loadingsplot$loadings...3, fill=Questionnaires)) + 
  geom_bar(stat = "identity") + 
  scale_fill_manual(values=c("#999999", "#E69F00","#56B4E9", "#009E73","#F0E442","#0072B2","#D55E00", "#CC79A7"), name="Questionnaires", breaks=c("Self report", "Voting", "SECS", "RWA", "LWA", "Political Issues", "Belief Superiority", "Dog"),labels=c("Political Orientation", "Voting", "SECS", "RWA", "LWA", "Political Issues", "Belief Superiority", "Dogmatism"))+
  labs(title="Factor", x="Questions", y = "Loadings") +  theme_classic(base_size = 18) +
  theme(axis.ticks = element_blank() ,axis.text.x = element_blank(),axis.line = element_blank(),legend.title=element_blank())+
  expand_limits(y=c(-.9,.9))+theme(axis.text=element_text(size=18),axis.title=element_text(size=18))

grid.arrange(a,b,c, ncol=1,nrow=3)


#extract factor scores 
factorscores=fa.results_Prestudy$scores
factorscores_f1=scale(factorscores[1:344,1])
factorscores_f2=scale(factorscores[1:344,2])
factorscores_f3=scale(factorscores[1:344,3])

#conduct the regressions between factorscores

fit<-rlm(factorscores_f2 ~ factorscores_f1 + I(factorscores_f1^2))
fit<-rlm(factorscores_f3 ~ factorscores_f1 + I(factorscores_f1^2))
fit<-rlm(factorscores_f3 ~ factorscores_f2 )

# check whether rekation between political orientation and dogmatic intolerance is linear or quadratic
fit<-rlm(factorscores_f2 ~ factorscores_f1+ I(factorscores_f1^2))
BIC(fit)
summary(fit)
fit<-rlm(factorscores_f2 ~I(factorscores_f1^2))
BIC(fit)
summary(fit)
fit<-rlm(factorscores_f2 ~ factorscores_f1)
BIC(fit)
summary(fit)

# check whether rekation between political orientation and authoritarianism is linear or quadratic
fit<-rlm(factorscores_f3 ~ factorscores_f1+ I(factorscores_f1^2))
BIC(fit)
summary(fit)
fit<-rlm(factorscores_f3 ~ factorscores_f1)
BIC(fit)
summary(fit)
fit<-rlm(factorscores_f3 ~  I(factorscores_f1^2))
BIC(fit)
summary(fit)
fit<-rlm(factorscores_f3 ~ factorscores_f2)
summary(fit)


# Plot relationship between political orientation and dogmatic intolerance (Figure 1B)
df<-data.frame(x=factorscores_f1[1:344],y=factorscores_f2[1:344])
p<-ggplot(df, aes(x=x, y=y)) + geom_point(shape=19,color='darkblue', size = 1.5) + theme_classic(base_size = 35) + 
  stat_smooth(method = "lm", formula = y ~  I(x^2), size = 2.3, se = FALSE,color='darkblue')+
  xlab("left -political orientation- right")+ 
  ylab("dogmatic intolerance") +theme(axis.text=element_text(size=38), axis.title=element_text(size=38))
p


# Plot relationship between political orientation and authoritarianism (Figure 1C)
df<-data.frame(x=factorscores_f1[1:344],y=factorscores_f3[1:344])
p<-ggplot(df, aes(x=x, y=y)) + geom_point(shape=19,color='darkblue', size = 1.5) + theme_classic(base_size = 35) + 
  stat_smooth(method = "lm", formula = y ~  x, size = 2.3, se = FALSE,color='darkblue')+
  xlab("left -political orientation- right")+ 
  ylab("authoritarianism")  +theme(axis.text=element_text(size=38), axis.title=element_text(size=38))
p

# Plot relationship between dogmatic intolerance and authoritarianism (Figure 1D)
df<-data.frame(x=factorscores_f2[1:344],y=factorscores_f3[1:344])
p<-ggplot(df, aes(x=x, y=y)) + geom_point(shape=19,color='darkblue', size = 1.5) + theme_classic(base_size = 35) + 
  stat_smooth(method = "lm", formula = y ~  x, size = 2.3, se = FALSE,color='darkblue')+
  xlab("dogmatic intolerance")+ 
  ylab("authoritarianism")  +theme(axis.text=element_text(size=38), axis.title=element_text(size=38))
p




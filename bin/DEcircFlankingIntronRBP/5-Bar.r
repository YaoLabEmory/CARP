library(ggplot2)
library(reshape2)
library("scales")
data<-read.table(file="FlankingRBP")

names(data)<-c("RBP","CircRNA")
data$RBP <- factor(data$RBP, levels = data$RBP[order(-data$CircRNA)])
data<-data[data$CircRNA>=5,]
p<-ggplot(data, aes(x=RBP,y=CircRNA)) + 
    geom_bar(position=position_dodge(width = 0),stat="identity",aes(fill=CircRNA))+
    scale_fill_gradient(low="grey",high="steelblue")+ 
    theme_classic()+
  theme( axis.title.x = element_text(size = 0),
            axis.text.y = element_text(size = 26, colour="black"),
            axis.text.x = element_text(size = 26, colour="black"),
            axis.title.y = element_text(size =26))+
  theme(legend.position="none",
	legend.spacing.x = unit(0.5, 'cm'))+
  #theme(legend.title=element_text(size=0),
  #	legend.text=element_text(size=30))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5))+
  #theme(axis.title.x=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank(), axis.ticks.x=element_blank())+
  #theme( axis.line = element_line(colour = "darkblue", size = 1, linetype = "solid"))

pdf(file="FlankingRBP.pdf",12,4)
p
dev.off()


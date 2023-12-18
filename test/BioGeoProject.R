library('car')
library("lme4")
library("lmerTest")
library('sjPlot')
library('sjstats')
library("ggplot2")

bioGeo <- read.csv(file="C:/Users/Brandon Alveshere/Desktop/Biogeochemistry_dataset.csv")

bio0 = lm(X0_5CN ~ Cover_type, data = bioGeo)
qqnorm(resid(bio0))
plot(bio0)
plot(cooks.distance(bio0))
heteroskedastic(bio0)
anova(bio0)
summary(bio0)



# C:N ratios with smooth line 
kruskal.test(X0_5CN ~ Cover_type, data = bioGeo)
kruskal.test(X5_10CN ~ Cover_type, data = bioGeo)
kruskal.test(X0_5CN ~ Year_collected, data = bioGeo)
kruskal.test(X5_10CN ~ Year_collected, data = bioGeo)
pairwise.wilcox.test(bioGeo$X0_5CN, bioGeo$Year_collected, p.adjust.method="bonf", paired = FALSE )
pairwise.wilcox.test(bioGeo$X5_10CN, bioGeo$Year_collected, p.adjust.method="bonf", paired = FALSE )

p <- ggplot(bioGeo, aes(x=Year_collected, y=Organic_soilsCN)) + geom_point()+ geom_smooth(method=lm, formula = y~x, level = 0.90) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p + ggtitle("C:N ratios of organic forest soils collected over 20 years") +
  xlab("Year Collected") + ylab("C:N (Organic Soils)")

p1 <- ggplot(bioGeo, aes(x=Year_collected, y=X0_5CN)) + geom_point() + ylim(0,50) + geom_smooth(method=lm, formula = y~x, level = 0.90) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p1  + xlab("Year Collected") + ylab("C:N (0-5cm depth)")

p2 <- ggplot(bioGeo, aes(x=Year_collected, y=X5_10CN)) + geom_point() + ylim(0,50) + geom_smooth(method=lm, formula = y~x, level = 0.90) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p2  + xlab("Year Collected") + ylab("C:N (5-10cm depth)")

require(gridExtra)
plot1 <- p1 + xlab("Year Collected") + ylab("C:N (0-5cm depth)")
plot2 <- p2 + xlab("Year Collected") + ylab("C:N (5-10cm depth)")
grid.arrange(plot1, plot2, ncol=2)




# % nitrogen with smooth line
kruskal.test(X0_5TN ~ Cover_type, data = bioGeo)
kruskal.test(X5_10TN ~ Cover_type, data = bioGeo)
kruskal.test(X0_5TN ~ Year_collected, data = bioGeo)
kruskal.test(X5_10TN ~ Year_collected, data = bioGeo)
pairwise.wilcox.test(bioGeo$X0_5TN, bioGeo$Year_collected, p.adjust.method="bonf", paired = FALSE )
pairwise.wilcox.test(bioGeo$X5_10TN, bioGeo$Year_collected, p.adjust.method="bonf", paired = FALSE )

p <- ggplot(bioGeo, aes(x=Year_collected, y=Organic_soilsTN)) + geom_point()+ geom_smooth(method=lm, formula = y~x, level = 0.90) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
 panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p + ggtitle("% total nitrogen of organic forest soils collected over 15 years. Collections were made across all forest types.") +
  xlab("Year Collected") + ylab("% total nitrogen (Organic Soils)")

p3 <- ggplot(bioGeo, aes(x=Year_collected, y=X0_5TN)) + geom_point() + ylim(0,3) + geom_smooth(method=lm, formula = y~x, level = 0.90) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p3  + xlab("Year Collected") + ylab("% total nitrogen (0-5cm depth)")

p4 <- ggplot(bioGeo, aes(x=Year_collected, y=X5_10TN)) + geom_point() + ylim(0,3) + geom_smooth(method=lm, formula = y~x, level = 0.90) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p4  + xlab("Year Collected") + ylab("% total nitrogen (5-10cm depth)")

require(gridExtra)
plot1 <- p3 + xlab("Year Collected") + ylab("% total nitrogen (0-5cm depth)") + labs(tag = "A")
plot2 <- p4 + xlab("Year Collected") + ylab("% total nitrogen (5-10cm depth)") + labs(tag = "B")
grid.arrange(plot1, plot2, ncol=2)



# notched boxplots
p<-ggplot(data=bioGeo, aes(x=Cover_type, y=Organic_soilsCN)) + geom_boxplot(notch=TRUE) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                                                                                                             panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + ggtitle("C:N ratios of different forest types") +
  xlab("Forest Type") + ylab("C:N (Organic Soils)")

p<-ggplot(data=bioGeo, aes(x=Cover_type, y=X0_5CN)) + geom_boxplot(notch=TRUE) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                                                                                                    panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + ggtitle("C:N ratios of different forest types") +
  xlab("Forest Type") + ylab("C:N (0-5cm depth)")

p<-ggplot(data=bioGeo, aes(x=Cover_type, y=X5_10CN)) + geom_boxplot(notch=TRUE) + theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                                                                                                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
p + theme(axis.text.x = element_text(angle = 45, hjust = 1)) + ggtitle("C:N ratios of different forest types") +
  xlab("Forest Type") + ylab("C:N (5-10cm depth)")


# subsetting
foo <- subset(bioGeo, Year_collected == "2013_2017")
foo1 <- subset(bioGeo, Year_collected == "2008_2012")
foo2 <- subset(bioGeo, Year_collected == "2003_2007")
foo3 <- subset(bioGeo, Year_collected == "1998_2002")

summary(foo3)

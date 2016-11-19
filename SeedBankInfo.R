#Project:
#Accession rareness, allele specificity and core set selection with an information theory approach: application to wheat marker data
#Theory is in publication process
########
#Functions to calculate entropy
MyLog2p<-function(x){if(x==0) 0 else x*log(x,2)} #Defining x logx
entropy<-function(x){-sum(sapply(x,MyLog2p))} #x is a vector of probabilities
#######
#Basic function of accession rareness and allele specificity
#NAs allowed
#x is the binary matrix, where alleles are in rows and
#populations in columns
#Data are allele frequencies for each accession
#nlocus is the number of loci spanning those alleles
rare<-function(x,nlocus){
nalelos<-length(x[,1]);
nvar<-length(x[1,]);
#Calculate pi;
a<-NULL;length(a)<-nalelos;for (i in 1:nalelos){a[i]<-mean(as.numeric(as.vector(x[i,])),na.rm=TRUE)};
p.i<-a;
#Calculate specificity;
a<-NULL;length(a)<-nalelos;for (i in 1:nalelos){if(p.i[i]==0||is.na(p.i[i])==TRUE){a[i]<-0}else{m.vec<-x[i,][!is.na(x[i,])];a[i]<--entropy(as.numeric(as.vector(m.vec/p.i[i])))/length(m.vec)}};
specificity<-a
#Calculate rareness
a<-NULL;length(a)<-nvar;for(j in 1:nvar){a[j]<-sum(specificity*x[,j],na.rm=TRUE)};
rareness<-a/nlocus #This is because in the last row
#I am calculating the sum of specificities across loci
rarenessTab<-data.frame("pop"=names(x),"rareness"=rareness);
result<-list(specificity=specificity,rareness=rareness,table=rarenessTab);
return(result)
}

#  ^   ^
#  O   O
# (      )
#   A  A
#Humberto Reyes

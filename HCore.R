#Project:
#Accession rareness, allele specificity and core set selection with an information theory approach: application to wheat marker data
#Theory is un publication process
#This code is for analysis of biallelic loci
#Tables contain loci as rows and accessions as columns
#If the table is made with alleles as rows, use the function HalfOdd 
#to reduce it to loci (it will half the number of rows)
########
#Function for p*log(p), needed for entropy
My.Log2p<-function(x){if(x==0 || is.na(x)) 0 else x*log(x,2)} #Defining x logx
#Reduce a table to odd rows (loci)
HalfOdd<-function(x) x[seq(1,dim(x)[1],2),]
#Entangle two vectors (odds and even)
entangle<-function(xodd,xeven){a<-NA;length(a)<-2*length(xodd);a[c(seq(1,length(a),2),seq(2,length(a),2))]<-c(xodd,xeven);a}
#Specificity. x is a vector of allele frecuencies across accessions
spec<-function(x){
	ac<-sum(!is.na(x)) #Number of accessions without NA
	my.q<-mean(x,na.rm=T) #Row mean (q)
	if(my.q==0 || my.q==1 || ac == 0) {0} else 
	{(sum(sapply(x,My.Log2p))-log(my.q,2)*my.q*ac)/(ac*my.q)} 
	#my.q*ac is the row sum
	}
#Rarity. x is the column of allele frequencies across loci for the accession and sp are specificities
rarity<-function(x,sp){sum(entangle(x,1-x)*sp,na.rm=T)/(length(sp)/2)} #Last expression is the number of loci to take the average per locus
#Divergence. x is the column of allele frequencies across loci for the accession and my.q are mean allele frequencies for the collection
divergence<-function(x,my.q){x<-entangle(x,1-x)
	prods<-ifelse((my.q==0 | my.q==1), 0, 
my.q*sapply(x/my.q,My.Log2p))
	sum(prods,na.rm=T)/(length(x)[1]/2)
	}
#Function to calculate all parameters
#NAs allowed
#x is the binary matrix, where loci are in rows and
#populations in columns
#Data are allele frequencies for each accession
#Use first HalfOdd if alleles are in rows
####
scoreBiallelic<-function(x){
	spec.odd<-apply(x,1,spec) #odds specificity
	spec.comp<-function(x)spec(1-x) #function for even
	spec.even<-apply(x,1,spec.comp) #even specificity
	#Entangle the two vectors
	spec.vector<-entangle(spec.odd,spec.even) #Vector of specificities
	rm(spec.odd,spec.even) #Remove odds and evens
	#Calculate rarity
	rar.vector<-apply(x,2,function(x)rarity(x,spec.vector)) 
	#Calculate divergence
	my.q<-rowMeans(x,na.rm=T) #Odd frequencies
	my.q<-entangle(my.q,1-my.q)  #Even frequencies
	div.vector<-apply(x,2,function(x)divergence(x,my.q))
	#Table for accessions
	rarenessTab<-data.frame("pop"=names(x),"rareness"=rar.vector,
	"divergence"=div.vector,row.names=1:length(names(x)))
	#Final object
	result<-list("specificity"=spec.vector,"rareness"=rar.vector,
	"divergence"=div.vector,"table"=rarenessTab);
	return(result)
		
}

#Function for average divergence
Mean.Divergence<-function(x){
	my.q<-rowMeans(x,na.rm=T) #Odd frequencies
	my.q<-entangle(my.q,1-my.q)  #Add Even frequencies
	div.vector<-apply(x,2,function(x)divergence(x,my.q))
	mean(div.vector,na.rm=T)
}

#Functions for core subset selection

#Function to get the accession with maximum rareness from an object generated by
#scoreBiallelic
#sb is an object generated by scoreBiallelic
getMaxR<-function(sb){as.character(sb$table$pop[sb$table$divergence==max(sb$table$divergence)][1])}

#Function to get the accession that increases more rareness
#cset is a starting vector of accessions
#data is the dataframe of loci and accessions
getMaxDeltaR<-function(data,cset){
	#Define which accessions of data to add to cset
	accessions<-names(data)
	accessions<-accessions[!is.element(accessions,cset)]	
	#Obtain the average caused by each accession
	a<-c()
	length(a)<-length(accessions)
	for(i in 1:length(accessions)){
		ndat<-data[,c(cset,accessions[i])]
		a[i]<-Mean.Divergence(ndat)
		}
	#Accession that contributed most
	accessions[a==max(a)][1]
}

#Core set selection for the biallelic case. Each row is a locus.
#If a raw table is provided, reduce to loci by HalfOdd()
#H stands for Shannon entropy
HCore<-function(data,n){
	#Eliminante noninformative alleles
	myvar<-function(x){var(x,na.rm=T)} #to get variances with na removal
	variances<-apply(data,1,myvar) #variances of allele frequecies per locus
	data<-data[variances!=0,] #keep only variance > 0
	#Accession with maximum rareness
	sb<-scoreBiallelic(data) #rareness object
	core<-getMaxR(sb)
	print(1)
	for(i in 1:(n-1)){
		selected<-getMaxDeltaR(data,core)
		core<-c(core,selected)
		print(i+1)
	}
	core
}




#  ^   ^
#  O   O
# (      )
#   A  A
#Humberto Reyes

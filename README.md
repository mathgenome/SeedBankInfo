
### Use of the *rareness* function from the SeedBankInfo.R script

The script can be loaded in R through *source(“SeedBankInfo.R”)*. The data frame comprises alleles as rows and populations as columns. Data are allele frequencies for each accession. The variable *nlocus* is the number of loci spanning those alleles.


The data *toydat.csv* is a small subset of the wheat Mexican landrace accessions genotyped by SNPs, publicly available at http://data.cimmyt.org/dvn/dv/seedsofdiscoverydvn/. The first two columns are *marker* and *allele*. Assuming that the file is in the working directory, the following code is an example of the uso of the *rareness* function.


Reading the data

*dat<-read.csv("data/toyset.csv",head=T)*

Running the function

*x<-rare(dat[-c(1,2)],50)*

Look at the contents of the object

*names(x)*

The *table* element of the list contains the populations and they rareness values

*head(x$table)*

Creating a data frame with markers alleles and their specificities

*my.df<-data.frame(marker=dat$marker,allele=dat$allele,specificity=x$specificity)*

*head(my.df)*

Histogram for specificity

*hist(x$specificity)*

Histogram for rareness

*hist(x$rareness)*

### Script for locus-based biallelic data

To expedite the analytical functions, I developed a series of scripts that use a table loci x accessions, instead of alleles x accessions. This applies only to biallelic data, like SNPs. The table has half of the rows of the one based on alleles. The information parameters are calculated much faster than with the original script.

The script can be loaded in R through *source(“HCore.R”)*

As an example, I use the toydata.csv set, based on alleles and accessions.

Reading the data

*dat<-read.csv("data/toyset.csv",head=T)*

#### Estimate specificity, rarity and Kullback-Leibler divergence parameters.

Eliminate the first two columns

*sdat<-dat[,-c(1,2)]*

Table with loci as rows

*ndat<-HalfOdd(sdat)*

Obtain the object with information parameters

*x<-scoreBiallelic(ndat)*

*names(x)*

The *table* element of the list contains the populations and they rarity and Kulback  values

*head(x$table)*

The function *HCore(data, n)* is aimed to maximize the average Kullback-Leibler divergence from allele frequency *data* based on loci * accessions, to obtain a core subset of size *n*.

#### Core subset selection

To obtain a core subset of 10 accessions, use the following instruction:

*core<-HCore(ndat,10)*

The output is a vector of accession names.


### HCoreA is fast implementation of HCore for core subset selection with big data sets. Once loaded, the functions for parameter estimation are the same. However, to select core subsets, HCoreA is used instead of HCore. The method gives an approximate, albeit much faster core subset optimization towards maximum average rareness. It applies only to biallelic data.

To obtain a core subset of 10 accessions, use the following instruction:

*core<-HCoreA(ndat,10)*

The output is a vector of accession names.





>Note

	This is part of an ongoing joint MasAgro Biodiversidad project between Universidad Autónoma Agraria Antonio Narro and International Maize and Wheat Improvement Center (CIMMYT), in Mexico.









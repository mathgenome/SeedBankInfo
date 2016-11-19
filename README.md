
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


>Note

	This is part of an ongoing joint MasAgro Biodiversidad project between Universidad Autónoma Agraria Antonio Narro and International Maize and Wheat Improvement Center (CIMMYT), in Mexico.





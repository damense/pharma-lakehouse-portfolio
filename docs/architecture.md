# Layers
## Bronze layer
### What the layer contains
The raw files as downloaded from kaggle in .RData format
### What transformations happen
.Rdata is read and turned into a dataframe
### What the next layer consumes
The next layer consumes all 4 files

## Silver layer
### What the layer contains
A different table for each faulty run in which each of the variables has been averaged for all 500 simulations and sample number has been changed to relative time from start of the scenario. All of this is duplicate to keep training and testing tests separate.
### What transformations happen
The faulty dataframes will be split for each fault, the fault free dataframes will be renamed consistently with the other tables. Values for tha variables will be averaged for all simulations with the same sample and finaly, a new column will be generated to transform sample into relative time
Another table will be generated in which each variable in the fault-free dataset will be analyzed for normality and parameters such as average, standard deviation and the need for normlization will be given
### What the next layer consumes


## Golden layer
### What the layer contains and business questions
- Table 1-20: change in the process after each fault
- Table variability: What's the expected variability for each of the variables and what AC do we want to set to identify a drift
### What transformations happen
- the fault free df needs appending to each of the faulty tables
- for each variable in the fault-free dataset, a set of upper and lower limits within which the process works as expected.

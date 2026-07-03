# Layers
![Diagram of the different layers](./svg/Untitled%20Diagram.svg)

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
The faulty dataframes will be split for each fault, the fault free dataframes will be renamed consistently with the other tables. Values for the variables will be averaged for all simulations with the same sample and finally, a new column will be generated to transform sample into relative time
Another table will be generated in which each variable in the fault-free dataset will be analyzed for normality and parameters such as average, standard deviation and the need for normalization will be given
### What the next layer consumes


## Golden layer
### What the layer contains and business questions
- Table 1: 
    - Grain: one row per fault_id × variable, 
    - Columns: fault-free baseline mean, post-fault mean, absolute deviation, % deviation
    - Answers: "How does each fault affect each variable?" — your 20-table idea, collapsed into one
- Table 2: 
    - Grain: one row per variable
    - Columns: mean, std, UCL/LCL at ±2σ and ±3σ, is_normal, description, unit
    - Answers: "What are the expected operating ranges and where should alerts trigger?" — your variability/AC table


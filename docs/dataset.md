# Why this dataset
I've chosen this dataset since it's a widely used comprehensive manufacturing dataset that allows me to perform typical operations I'd do at work.

# What business question(s) it stands in for
What type of monitoring helps the most with fault prevention
Can process performance be predicted

# Known quality issues / known interesting facts
## Quality issues to be aware of:

- Temporal autocorrelation — samples are time-correlated. Treating rows as i.i.d. inflates model performance. 
- Asymmetric fault onset — in training files faults start at sample 20 (1 hour in); in test files at sample 160 (8 hours in). 
- Near-constant variables — variables 51 and 52 (cooling water outlet temperatures) show very low variance in many versions. 
- Version inconsistency — different research groups generated the dataset from slightly different versions of Ricker's Fortran simulation. 
- IDV(20) and IDV(21) may be missing — those two faults were added after the original Downs & Vogel (1993) paper. Some pre-packaged datasets only have 16 or 19 faults.

## Interesting facts:
- It's deliberately obfuscated — Eastman Chemical anonymised the components (A, B, C, D...) so competitors couldn't reverse-engineer their process. 
- Fault difficulty varies wildly — IDV(1) and IDV(2) are trivial to detect; IDV(3), IDV(9), and IDV(15) are notoriously hard and still challenge modern methods. 
- 52 variables split into two streams: 41 process measurements (XMEAS) and 11 manipulated variables (XMV) 
- Training runs are 500 samples (25h), test runs are 960 samples (48h) 
- It's a continuous process, not batch — reactor, condenser, compressor, separator, stripper in sequence. 

# Source link or generation script reference
https://data.mendeley.com/datasets/g2st27k8ww/1
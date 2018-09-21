# RollwageDolanFleming

This repository contains analysis code for the following paper:

Rollwage, Dolan & Fleming (2018) Metacognitive failure as a feature of those holding radical beliefs. Current Biology, in press. 

Fully anonymised data files are available from the corresponding author on reasonable request (max.rollwage.16@ucl.ac.uk). 
Analysis scripts of the questionnaire data (factor analysis), behavioral data and computational modelling are included in the repository: 

The script Factor_Analysis.R will reproduce the factor analysis of questionnaire data and the regressions between the 3 factorscores (Figure 1). 

The script Behavioral_Analysis.m will reproduce the regression analysis predicitng the questionnaire factorscores based on metacognitive variables (Figure 3). 

The script Computational_model_fitting.R will fit the three computational models to the data, and the models are specified in the text files Temporal_weighting.stan, Choice_weighting.stan and Choice_Bias.stan. 

The script Model_comparison.m will conduct the model comparison of the three computatiounal models (Figure 4A).

The script Posterior_Predictives.m will reproduce the posterior predicitives of the choice bias model (Figure 4B).

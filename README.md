# RollwageDolanFleming

This repository contains analysis code for the following paper:

Rollwage, Dolan & Fleming (2018) Metacognitive failure as a feature of those holding radical beliefs. Current Biology, in press. 

Fully anonymised data files are available from the corresponding author on reasonable request (max.rollwage.16@ucl.ac.uk). 
Scripts for analysing the questionnaire data (factor analysis), behavioral data and specifying computational models are included in the repository: 

The script Factor_Analysis.R reproduces the factor analysis of questionnaire data and the regressions between the 3 factor scores (Figure 1). 

The script Behavioral_Analysis.m reproduces the regression analysis predicting the questionnaire factor scores based on metacognitive variables (Figure 3). 

The script Fitting_models.R fits the three computational models to the data, as specified in the text files Temporal_Weighting.stan, Choice_Weighting.stan and Choice_Bias.stan. 

The script Model_comparison.m conducts a formal comparison of the three models (Figure 4A).

The script Posterior_Predictives.m reproduces the posterior predicitives of the choice bias model (Figure 4B).

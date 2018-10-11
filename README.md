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

**License**

This code is being released with a permissive open-source license. You should feel free to use or adapt the utility code as long as you follow the terms of the license, which are enumerated below. If you make use of or build on the computational models or behavioural/neuroimaging analyses, we would appreciate that you cite the paper.

Copyright (c) 2017, Stephen Fleming

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

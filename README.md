# Analysis of fMRI data with dealy discounting task
The codes for batch creating general linear model (GLM) and PPI models. 

The first GLM including hard- and easy-choice regressors with hard choices defined as those with similar subjective values for immediate and delayed reward options. The second GLM including choices for smaller immediate rewards (SIR) and choices for larger delayed rewards (LDR) regressors.

The PPI models comprised task regressors (i.e., hard and easy choices, or SIR and LDR conditions) (psychological variable), modeled via a boxcar function that convolved with the canonical hemodynamic response function, the average BOLD signal time course from the seed region (physiological activity), and the psychophysiological interaction term (PPI regressor) described as the cross-product of the physiological activity and psychological variable.

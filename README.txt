The code in this folder analyzes simple change detection data (N items in sample display, N in test display, 1 item has changed) using the variable-precision model (Keshvari, Van den Berg, Ma, PLOS Computational Biology 2014).

This code is useful if you do NOT control the magnitude of the change (for example, if you use a fixed set of "highly discriminable" colors, like in Luck and Vogel 1997).

The main code to run is CDsimple_modelfit.m, and it will call CDsimple_modelpred.m.

Put your data in a file data.mat, which should contain a matrix "data", with each row being a combination of subject and set size. The columns should be:

Column 1: Subject identifier (any integer)
Column 2: Set size for that subject
Column 3: Number of change trials at that set size for that subject
Column 4: Number of hit trials at that set size for that subject
Column 5: Number of no-change trials at that set size for that subject
Column 6: Number of false-alarm trials at that set size for that subject

If you want to see an example at work, uncomment lines 6 through 16 ("Synthetic data"). This part of the code will call CDsimple_generatedata.m to generate 10 hypothetical subject data according to the variable-precision model.

The code will produce an Excel spreadsheet pars.xlsx that contains the fitted parameters of the variable-precision model for each subject, and two plots showing the goodness of fit of the model.

To fit the model parameters, we use "patternsearch". The fitting can potentially be improved by playing with the options of this command, or by using a different algorithm.

For questions, please email Wei Ji Ma (weijima@nyu.edu)
June 23, 2014


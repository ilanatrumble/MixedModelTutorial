/*	Date:		January 27, 2022 
	Author:		Ilana Trumble
	Summary:	SAS code for fitting our recommended mixed model with 
				no random effects,
				an unstructured residual errors covariance matrix,
				and the improved Kenward and Rogers denominator degrees of freedom
*/			

libname outlib "INSERT YOUR DIRECTORY HERE";

/*	Look at data for first two study participants, with and without variable labels */
proc print data=outlib.bekelmandata (obs=8) label; run; 
proc print data=outlib.bekelmandata (obs=8); run;

/*	"cl" in the PROC MIXED statement requests confidence limits for variance and covariance parameters.

	The CLASS statement treats PID and critical period as categorical variables.

	In the MODEL statement, we specify a saturated model by including all interactions between predictors and critical period.
		"ddfm=kr2" in the MODEL options specifies the improved Kenward and Roger denominator degrees of freedom.
		"s" in the MODEL options requests fixed effect estimates, standard errors, test statistics, and p-values.
		"cl" in the MODEL options displays confidence limits for the fixed effects. 

	The REPEATED statement specifies which variable indicates the repeated measures.
		"type = UN" in the REPEATED options specifies an unstructured covariance structure for the residual errors.
		"subject=PID" in the REPEATED options specifies which variable indicates the study participants.
		"r=2" in the REPEATED statement print the estimated covariance matrix for the second participant.
		We print the covariance matrix for the second participant because the second subject has no missing data.
		The printed matrix for the first participant would exclude the variance and covariance parameters for the second measurement.
*/

PROC MIXED DATA=outlib.bekelmandata cl;
	CLASS PID Critical_Period; 
	MODEL BMI =	gest_diab*critical_period
				non_white_hispanic*critical_period
				income_50k_orless*critical_period  
				HEI_poor*critical_period 
			/ ddfm=kr2 s cl; 
	REPEATED critical_period / type = UN  subject = PID r=2;
run; 

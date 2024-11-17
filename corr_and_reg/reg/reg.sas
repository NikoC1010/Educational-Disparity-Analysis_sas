FILENAME myfile3 "/home/u63574852/group project/regression and corr/regression.xlsx"; 
PROC IMPORT DATAFILE = myfile3
			OUT = dataset2
			DBMS = XLSX REPLACE;
	        GETNAMES = YES;
RUN;
proc print data = dataset2;
run;

ODS GRAPHICS ON;

proc reg data = dataset2 PLOTS = (ALL) alpha=0.1;
model Enrolment = Birthrate_12 population_growth_rate;
OUTPUT OUT=reg_results PREDICTED=predicted_values;
title 'Regression Analysis: Enrolment with Crude birth rate and Population growth rate';
run;

proc print data = reg_results NOOBS LABEL;
LABEL Birthrate_12 = 'Crude Birth Rate';
LABEL population_growth_rate = 'Population growth rate';
LABEL predicted_values = 'The predicted value of Enrolment';
TITLE 'Multiple Linear Regression Result';
run;

PROC SGPLOT DATA=reg_results;
REG X=Birthrate_12 Y=Enrolment / LINEATTRS=(THICKNESS = 3 COLOR = 'BLUE');
LOESS X=Birthrate_12 Y=Enrolment / NOMARKERS;
REFLINE 1 / TRANSPARENCY= 0.1;
XAXIS LABEL='Crude Birth Rate' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='Enrolment' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Regression Analysis: Crude birth rate with Enrolment';
RUN;

PROC SGPLOT DATA=reg_results;
REG X=population_growth_rate Y=Enrolment / LINEATTRS=(THICKNESS = 3 COLOR = 'BLUE');
LOESS X=population_growth_rate Y=Enrolment / NOMARKERS;
REFLINE 1 / TRANSPARENCY= 0.1;
XAXIS LABEL='Population growth rate' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='Enrolment' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Regression Analysis: Population growth rate with Enrolment';
RUN;


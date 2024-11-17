PROC FORMAT;
	VALUE MISSDATA . = 'MISSING DATA';

data dataset;
infile '/home/u63574852/group project/plot table/report.dat' dlm=',';
input District:$50. All_Grades1 S1 All_Grades2 S2;
diffvalue = S1 - S2;
pctvalue = S1 / S2;
IF pctvalue > 0.85 THEN TYPE = 'Surplus';
ELSE IF pctvalue = . THEN DO; FORMAT pctvalue MISSDATA;  TYPE = 'MISSING DATA';END;
ELSE TYPE = 'Deficiency';

data dataset2;
set dataset;
FORMAT pctvalue MISSDATA.;

PROC REPORT DATA = dataset2;
   COLUMN TYPE District S1 S2 diffvalue pctvalue ;
   DEFINE TYPE / GROUP;
   DEFINE S1 / ANALYSIS SUM'Enrolment' FORMAT = MISSDATA.;
   DEFINE S2 / ANALYSIS SUM'Accommodation' FORMAT = MISSDATA.;
   DEFINE diffvalue / ANALYSIS 'Difference Value of Enrolment with Accommodation' FORMAT = MISSDATA.;
   DEFINE pctvalue / DISPLAY 'Percentage of Enrolment/Accommodation';
   
   /*BREAK AFTER TYPE / SUMMARIZE ol skip;*/
   TITLE  '2022 Accommodation and Enrolment Information';
   FOOTNOTE 'Surplus means observations with Enrolment/Accommodation percentage > 0.85.';
   FOOTNOTE2 'Deficiency means observations with an Enrolment/Accommodation percentage < 0.85.';
RUN;


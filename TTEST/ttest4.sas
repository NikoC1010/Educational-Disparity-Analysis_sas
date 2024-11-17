FILENAME myfile "/home/u63574852/group project/ttest/population loss rate(6).xlsx"; 
PROC IMPORT DATAFILE = myfile
			OUT = dataset3
			DBMS = XLSX REPLACE;
	        GETNAMES = YES;
RUN;

data final;
set dataset3;
diffvalue = Accommodation_2022_s1 - Enrolment_2021_p1;
Percentage = Enrolment_2021_p1 / Accommodation_2022_s1;
run;

data final1;
set final;
if Percentage > 0.85 then Type = 'b';
else Type = 'l';
run;

proc print data = final1;
run;

proc ttest data = final1 sides = l plots=all alpha=.1;
class Type;
var population_attrition_rate;
run;

proc sgplot data = final1;
vbar District / response=Percentage Group = Type;
refline  0.85 / label = '85%';
XAXIS VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='Percentage' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Percentage of Enrolment/Accommodation in various districts of Hong Kong';
run;




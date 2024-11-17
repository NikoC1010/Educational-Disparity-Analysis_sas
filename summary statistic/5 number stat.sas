*libname gp '/home/u63574852/group project';
FILENAME myfile "/home/u63574852/group project/school place summary/data.xlsx"; 
PROC IMPORT DATAFILE = myfile
			OUT = Enrolment
			DBMS = XLSX REPLACE;
	        GETNAMES = YES;
	        SHEET = 'Sheet1';
RUN;

PROC IMPORT DATAFILE = myfile
			OUT = Accommodation
			DBMS = XLSX REPLACE;
	        GETNAMES = YES;
	        SHEET = 'Sheet2';
RUN;


proc sort data=Enrolment sortseq = linguistic(numeric_collation = ON);
   by District;
run;
proc sort data= Accommodation sortseq = linguistic(numeric_collation = ON);
   by District;
run;
data merged_dataset1;
   merge Enrolment Accommodation;
   by District;
run;

data newdataset;
set merged_dataset1;
diffvalue = S2 - S1;
Percentage = Enrolment/Accommodation;

proc UNIVARIATE data = newdataset;
VAR diffvalue;
HISTOGRAM diffvalue/NORMAL;
PROBPLOT diffvalue;
title;
RUN;


PROC SGPLOT DATA = newdataset;
HISTOGRAM diffvalue / SHOWBINS;
DENSITY diffvalue;
DENSITY diffvalue / TYPE = KERNEL;
XAXIS LABEL = 'Difference in value' VALUES=(-500 TO 4000 BY 50) VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL = 'Percentage' VALUES=(0 TO 100 BY 20) VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Accommodation in Secondary Day Schools by District';
run;

*Extreme values affect the results;
PROC SGPLOT DATA = newdataset;
HBOX diffvalue;
XAXIS LABEL = 'Difference in value' VALUES=(-500 TO 4000 BY 200) VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Difference between the number of Accommodation and the number of students by district in Hong Kong';
RUN;








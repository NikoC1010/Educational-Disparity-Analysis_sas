*libname gp '/home/u63574852/group project';
FILENAME myfile2 "/home/u63574852/group project/regression and corr/data2.xlsx"; 
PROC IMPORT DATAFILE = myfile2
			OUT = dataset2
			DBMS = XLSX REPLACE;
	        GETNAMES = YES;
RUN;

data newdataset2;
set dataset2;
diffvalue = Accommodation - Enrolment;
run;

data birthrate;
infile '/home/u63574852/group project/regression and corr/crudebirthrate.dat' delimiter='	';
input Rate1 4.1 Year YEAR4.;
label Rate1 = 'Crude Birth Rate(per 1000 population)';
if year > 1998 then mergeyear2 = Year + 12;
File '/home/u63574852/group project/regression and corr/crudebirthrate.csv' print;
title 'Final data set';
PUT @3'Crude Birth Rate(per 1000 population):' Rate1
   //@3 'YEAR:' Year;
   PUT_PAGE_;
run;

data poprate;
infile '/home/u63574852/group project/regression and corr/population growth rate.csv' dlm=',';
input Year YEAR4. Rate2;
label Rate2 = 'Population growth rate';
if year > 1998 then mergeyear = Year + 12;
run;

proc sql;
  create table merged_dataset as
  select *
  from birthrate
  inner join poprate
  on birthrate.Year = poprate.Year;
quit;


proc sql;
  create table merged_dataset2 as
  select *
  from newdataset2
  inner join poprate
  on newdataset2.Year = poprate.mergeyear;
quit;


proc sql;
  create table merged_dataset3 as
  select *
  from newdataset2
  inner join birthrate
  on newdataset2.Year = birthrate.mergeyear2
  inner join poprate
  on newdataset2.Year = poprate.year;
quit;

*Correlation;
proc corr data = merged_dataset3 PLOTS = (SCATTER MATRIX);
var Rate1 Rate2;
with Enrolment;
title 'Correlation Analysis: Enrolment with Crude birth rate and Population growth rate';
run;

PROC SGPLOT DATA=merged_dataset;
REG X=Rate1 Y=Rate2 / LINEATTRS=(THICKNESS = 3 COLOR = 'BLUE');
LOESS X=Rate1 Y=Rate2 / NOMARKERS;
REFLINE 1 / TRANSPARENCY= 0.1;
XAXIS LABEL='Population growth rate' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='Crude birth rate' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Regression Analysis: Crude birth rate with Population growth rate';
RUN;

PROC SGPLOT DATA=merged_dataset;
pbspline X=Rate1 Y=Rate2/CLM NOLEGCLM LINEATTRS=(THICKNESS = 2 COLOR = 'BLACK');
XAXIS LABEL='Population growth rate' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='Crude birth rate' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Regression Analysis: Crude birth rate with Population growth rate';
RUN;


PROC SGPLOT DATA=merged_dataset;
SERIES X = YEAR Y = Rate1 / LINEATTRS=(THICKNESS = 3 COLOR = 'RED' PATTERN = DOT);
SERIES X = YEAR Y = Rate2 / LINEATTRS=(THICKNESS = 3 COLOR = 'BLUE' PATTERN = DASHDOTDOT);
XAXIS LABEL='YEAR' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='RATE' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Birth rate and population growth rate by year';
run;


PROC SGPLOT DATA=merged_dataset2;
SERIES X = YEAR Y = Accommodation / LINEATTRS=(THICKNESS = 3 COLOR = 'RED' PATTERN = DOT);
SERIES X = YEAR Y = Enrolment / LINEATTRS=(THICKNESS = 3 COLOR = 'BLUE' PATTERN = DASHDOTDOT);
XAXIS LABEL='YEAR' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
YAXIS LABEL='Numbers' VALUEATTRS=(SIZE = 12pt) LABELATTRS=(SIZE = 12pt STYLE = ITALIC WEIGHT = BOLD);
TITLE 'Number of Accommodation and Enrolment by year';
run;

* class5.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

%let path=c:/Users/simons/My Documents/SASUniversityEdition/myfolders/;

ods pdf file="&path/survival-lecture5/sas/class5.pdf";

libname survival
  "&path/data";

* Before you start, peek at the data to refresh
  you memory about what variables you have and
  how they are coded.
;

proc print
    data=survival.whas100(obs=5);
run;

* The covariate_values data set contains values
  for each independent variable. These values 
  are used for probability plotting.
;

proc lifereg
    data=survival.whas100;
  model time_ys*fstat(0)= / d=exponential;
  output out=qdata p=e q=0.01 to 0.99 by 0.01;
run;

proc print data=qdata;
run;

data covariate_values;
  input age gender bmi;
datalines;
65 0 25
run;



proc lifereg
    data=survival.whas100
    xdata=covariate_values;
  model time_yrs*fstat(0)=gender age bmi gender*age / d=exponential;
  probplot;
run;

ods pdf close;

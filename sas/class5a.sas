* class5a.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

%let xpath="c:/Users/simons/My Documents/SASUniversityEdition/myfolders/";
%let path=c:/Users/steve/Documents/SASUniversityEdition/myfolders;

ods pdf file="/folders/myfolders/survival-lecture5/sas/class5a.pdf";

libname survival
  "/folders/myfolders/data";

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

data covariate_values;
  input age gender bmi;
datalines;
65 0 25
run;


proc lifereg
    data=survival.whas100
    xdata=covariate_values
    outest=f;
  model time_yrs*fstat(0)= / d=exponential;
  output out=qdata xbeta=xb cres=cr;
run;

proc print data=f(obs=200);
run;

proc print data=qdata(obs=200);
run;


proc lifereg
    data=survival.whas100
    xdata=covariate_values;
  model time_yrs*fstat(0)=gender age bmi gender*age / d=exponential;
  probplot;
run;

ods pdf close;

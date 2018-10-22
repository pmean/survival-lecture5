* leaky_pipes.sas
  written by Steve Simon
  October 21, 2018;

** preliminaries **;

%let path=/folders/myfolders;
%let xpath=c:/Users/simons/Documents/SASUniversityEdition/myfolders;

ods pdf file="&path/survival-lecture5/sas/leaky_pipes.pdf";

libname survival
  "&path/data";
  
filename leaky "&path/data/leaky_pipes.xlsx";

proc import
    datafile=leaky
    dbms=xlsx
    out=survival.leaky_pipes;
run;

proc print
    data=survival.leaky_pipes(obs=5);
run;

data survival.leaky_pipes;
  set survival.leaky_pipes;
  if Year_leak="N/A" 
    then cens=0;
    else cens=1;
  time=Year_Leak - Year_Installed;
  if time=. then time=2018 - Year_Installed;
run;

proc lifetest
    notable
    plots=survival
    data=survival.leaky_pipes;
  time time*cens(0);
  title "Kaplan-Meier curve for leaky pipe data";
run;

proc freq
    data=survival.leaky_pipes;
  tables (Diameter Material_Type Soil_Type Static_Pressure_Type)*cens /
    norow nocol nopercent;
run;

proc lifetest
    notable
    plots=survival
    data=survival.leaky_pipes;
  time time*cens(0);
  strata Material_Type;
  title "Kaplan-Meier curve for leaky pipe data";
run;

proc phreg
    data=survival.leaky_pipes;
  model time*cens(0)=diameter;
run;


ods pdf close;

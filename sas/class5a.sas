* class5a.sas
  written by Steve Simon
  May 15, 2018;

** preliminaries **;

%let xpath=/folders/myfolders;
%let path=c:/Users/simons/Documents/SASUniversityEdition/myfolders;

ods pdf file="&path/survival-lecture5/sas/class5a.pdf";

libname survival
  "&path/data";

* Before you start, peek at the data to refresh
  you memory about what variables you have and
  how they are coded.
;

proc print
    data=survival.whas100(obs=5);
run;

* The cres option on the output statement produces
  the Cox-Snell residuals, which for this simple
  model is the same as the cumulative hazard
  function. There is a simple mathematical 
  relationship between the survival function (S)
  and the cumulative hazard function (LAMBDA):

  S(t) = exp(-LAMBDA(t)) or

  -log(S(t)) = LAMBDA(t).
;

proc lifereg
    data=survival.whas100;
  model time_yrs*fstat(0)= / d=exponential;
  output out=exp cres=LAMBDA_exp;
run;

* Let's calculate the estimated survival curve
  for the exponential fit using the relationship
  shown above.
;

data exp;
  set exp(keep=time_yrs LAMBDA_exp);
  S_exp = exp(-LAMBDA_exp);
  model = "exp";
run;

proc sort 
    data=exp;
  by time_yrs;
run;

proc print data=exp(obs=10);
run;

* You've already seen how the lifetest procedure
  can produce a survival curve. You can also
  output a new data set with the values of
  the Kaplan-Meier survival estimates.
;

proc lifetest
     notable
	 outsurv=km
     data=survival.whas100;
  time time_yrs*fstat(0);
  title "Kaplan-Meier curve for WHAS100 data";
run;

* Let's calculate the cumulative hazard function
  using the above equation.
;

data km;
  set km(keep=time_yrs SURVIVAL);
  LAMBDA_km = -log(SURVIVAL);
  rename SURVIVAL=S_km;
  model="km";
run;

proc print
    data=km(obs=10);
run;

data exp_km;
  set exp km;
  label 
    s_km="Kaplan-Meier"
	s_exp="Exponential"
run;

data myattrmap;
length linecolor $ 9;
input ID $ value $ linecolor $;
datalines;
myid  exp pink
myid  km  green
;
run;

proc sgplot
    dattrmap=myattrmap
    data=exp_km;
  step x=time_yrs y=s_km / justify=right;
  series x=time_yrs y=s_exp / attrid=myid group=model;
  yaxis values=(0 to 1 by 0.25);
run;

ods pdf close;

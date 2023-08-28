*************************************
* PROGRAM: NCHS Data Brief 368.sas  *
* DATE: 02/04/2022                  *
************************************;
options nodate pageno=1;
filename nhanes url 'https://raw.githubusercontent.com/Cubicle3253/SAS-Code/Main/Read_NHANES.sas';
%include nhanes;

%CreateDS(demo_i demo_j);
%CreateDS(ohxden_i ohxden_j);

data demo_ij;
  set demo_i(keep=seqn sddsrvyr riagendr ridageyr ridreth3 dmdeduc2 sdmvstra sdmvpsu wtmec2yr)
      demo_j(keep=seqn sddsrvyr riagendr ridageyr ridreth3 dmdeduc2 sdmvstra sdmvpsu wtmec2yr);
  if (ridreth3 in (1:2)) then race_ethnicity = 3;
  else if (ridreth3 = 3) then race_ethnicity = 1;
  else if (ridreth3 = 4) then race_ethnicity = 2;
  if (dmdeduc2 in (1:2)) then education = 1;
  else if (dmdeduc2 in (3:5)) then education = 2;

data ohxden_ij;
  set ohxden_i(keep=seqn ohx02tc--ohx15tc ohx18tc--ohx31tc) 
      ohxden_j(keep=seqn ohx02tc--ohx15tc ohx18tc--ohx31tc);
  tc = cats(of ohx02tc--ohx31tc);
  if (countc(tc, '12345') = 28) then edentulism = (countc(tc, '4') = 28);
  keep seqn tc edentulism;

data one;
  merge demo_ij ohxden_ij;
  by seqn;

proc format;
  value srvf
    1='1999-00' 2='2001-02' 3='2003-04' 4='2005-06' 5='2007-08' 6='2009-10' 7='2011-12' 8='2013-14' 9='2015-16' 10='2017-18';
  value genf 
    0='All' 1='Men' 2='Women';
  value agef
    0='All' 1='65-69' 2='70-74' 3='75 and over';
  value ref
    0='All' 1='Non-Hispanic white' 2='Non-Hispanic black' 3='Hispanic' ;
  value edf
    0='All' 1='Less than HS' 2='HS or greater';

proc descript data=one notsorted design=wr;
  subpopx ridageyr > 0;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class riagendr ridageyr race_ethnicity education/nofreq;
  recode ridageyr = (65 70 75);
  var edentulism;
  catlevel 1;
  table riagendr*(ridageyr race_ethnicity education);
  setenv labwidth=24;
  print nsum percent sepercent/style=nchs percentfmt=f8.1 sepercentfmt=f8.1;
rformat riagendr genf.;
rformat ridageyr agef.;
rformat race_ethnicity ref.;
rformat education edf.;

proc descript data=one notsorted design=wr;
  subpopx ridageyr > 0 and race_ethnicity = 3;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class riagendr ridageyr race_ethnicity education/nofreq;
  recode ridageyr = (65 70 75);
  var edentulism;
  catlevel 1;
  table ridageyr race_ethnicity education;
  pairwise riagendr/name="Gender";
  setenv labwidth=24;
  print nsum t_pct p_pct/style=nchs;
rformat riagendr genf.;
rformat ridageyr agef.;
rformat race_ethnicity ref.;
rformat education edf.;
run;

proc freq data=one;
  where ridageyr >= 65 and race_ethnicity = 3 and edentulism is not missing;
  table sdmvstra*sdmvpsu sdm:/nopercent norow nocol;
run;

proc descript data=one notsorted design=wr;
  subpopx ridageyr > 0;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class riagendr ridageyr race_ethnicity education/nofreq;
  recode ridageyr = (65 70 75);
  var edentulism;
  catlevel 1;
  table ridageyr race_ethnicity education;
  pairwise riagendr/name="Gender";
  setenv labwidth=24;
  print nsum t_pct p_pct/style=nchs;
rformat riagendr genf.;
rformat ridageyr agef.;
rformat race_ethnicity ref.;
rformat education edf.;

proc crosstab data=one notsorted design=wr deft1;
  subpopx ridageyr > 0;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class riagendr ridageyr race_ethnicity education edentulism/nofreq;
  recode ridageyr = (65 70 75);
  table race_ethnicity*riagendr*edentulism;
  test chisq/all;
  setenv labwidth=28;
  print nsum rowper serow/stest=default rowperfmt=f8.1 serowfmt=f8.1;
rformat riagendr genf.;
rformat ridageyr agef.;
rformat race_ethnicity ref.;
rformat education edf.;
run;


proc descript data=one notsorted design=wr;
  subpopx ridageyr > 0 and sddsrvyr in(9, 10);
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class riagendr ridageyr ridreth3 indfmpir dmdeduc2/nofreq;
  recode ridageyr = (65 70 75)
         ridreth3 = (1 3 4 6 7)
         indfmpir = (0 1 2)
         dmdeduc2 = (1 4 5);
  var Teeth_Missing;
  catlevel 28;
  table riagendr;
  pairwise ridageyr/name="Age";
  poly ridageyr=2/name="Age";
  pairwise ridreth3/name="Race/Ethnicity";
  pairwise indfmpir/name="FIPR";
  poly indfmpir=2/name="FIPR";
  pairwise dmdeduc2/name="Education";
  poly dmdeduc2=2/name="Education";
  setenv labwidth=58;
  print nsum t_pct p_pct/style=nchs percentfmt=f8.1;
rformat riagendr genf.;
rformat ridageyr agef.;
rformat ridreth3 ref.;
rformat indfmpir iprf.;
rformat dmdeduc2 edf.;

%CreateDS(demo demo_b demo_c demo_d demo_e demo_f demo_g demo_h);
%CreateDS(ohxdent ohxden_b ohxden_c ohx_d ohx_e ohxden_f ohxden_g ohxden_h);

data demo_ah;
  set demo(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
      demo_b(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
      demo_c(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
	  demo_d(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
	  demo_e(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
	  demo_f(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
	  demo_g(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr)
      demo_h(keep=seqn sddsrvyr riagendr ridageyr sdmvstra sdmvpsu wtmec2yr);

data ohxden_ah;
  set ohxdent
      ohxden_b(rename=(ohd02tc=ohx02tc ohd03tc=ohx03tc ohd04tc=ohx04tc ohd05tc=ohx05tc
                       ohd06tc=ohx06tc ohd07tc=ohx07tc ohd08tc=ohx08tc ohd09tc=ohx09tc
                       ohd10tc=ohx10tc ohd11tc=ohx11tc ohd12tc=ohx12tc ohd13tc=ohx13tc
                       ohd14tc=ohx14tc ohd15tc=ohx15tc ohd18tc=ohx18tc ohd19tc=ohx19tc
                       ohd20tc=ohx20tc ohd21tc=ohx21tc ohd22tc=ohx22tc ohd23tc=ohx23tc
                       ohd24tc=ohx24tc ohd25tc=ohx25tc ohd26tc=ohx26tc ohd27tc=ohx27tc
                       ohd28tc=ohx28tc ohd29tc=ohx29tc ohd30tc=ohx30tc ohd31tc=ohx31tc))
     ohxden_c
     ohx_d(rename=(ohx02htc=ohx02tc ohx03htc=ohx03tc ohx04htc=ohx04tc ohx05htc=ohx05tc
                   ohx06htc=ohx06tc ohx07htc=ohx07tc ohx08htc=ohx08tc ohx09htc=ohx09tc
                   ohx10htc=ohx10tc ohx11htc=ohx11tc ohx12htc=ohx12tc ohx13htc=ohx13tc
                   ohx14htc=ohx14tc ohx15htc=ohx15tc ohx18htc=ohx18tc ohx19htc=ohx19tc
                   ohx20htc=ohx20tc ohx21htc=ohx21tc ohx22htc=ohx22tc ohx23htc=ohx23tc
                   ohx24htc=ohx24tc ohx25htc=ohx25tc ohx26htc=ohx26tc ohx27htc=ohx27tc
                   ohx28htc=ohx28tc ohx29htc=ohx29tc ohx30htc=ohx30tc ohx31htc=ohx31tc))
     ohx_e(rename=(ohx02htc=ohx02tc ohx03htc=ohx03tc ohx04htc=ohx04tc ohx05htc=ohx05tc
                   ohx06htc=ohx06tc ohx07htc=ohx07tc ohx08htc=ohx08tc ohx09htc=ohx09tc
                   ohx10htc=ohx10tc ohx11htc=ohx11tc ohx12htc=ohx12tc ohx13htc=ohx13tc
                   ohx14htc=ohx14tc ohx15htc=ohx15tc ohx18htc=ohx18tc ohx19htc=ohx19tc
                   ohx20htc=ohx20tc ohx21htc=ohx21tc ohx22htc=ohx22tc ohx23htc=ohx23tc
                   ohx24htc=ohx24tc ohx25htc=ohx25tc ohx26htc=ohx26tc ohx27htc=ohx27tc
                   ohx28htc=ohx28tc ohx29htc=ohx29tc ohx30htc=ohx30tc ohx31htc=ohx31tc))
     ohxden_f
     ohxden_g
     ohxden_h;
  TC = cats(ohx02tc, ohx03tc, ohx04tc, ohx05tc, ohx06tc, ohx07tc, ohx08tc,
            ohx09tc, ohx10tc, ohx11tc, ohx12tc, ohx13tc, ohx14tc, ohx15tc,
            ohx18tc, ohx19tc, ohx20tc, ohx21tc, ohx22tc, ohx23tc, ohx24tc,
            ohx25tc, ohx26tc, ohx27tc, ohx28tc, ohx29tc, ohx30tc, ohx31tc);
  if (countc(TC, '12345') = 28) then Teeth_Missing = countc(TC, '4');
  keep seqn TC Teeth_Missing;

data one;
  merge demo_ah
        demo_ij
        ohxden_ah
        ohxden_ij;
  by seqn;

proc descript data=one notsorted design=wr;
  subpopx ridageyr >= 65;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class sddsrvyr riagendr/nofreq;
  var Teeth_Missing;
  catlevel 28;
  table riagendr*sddsrvyr;
  print nsum percent sepercent/style=nchs percentfmt=f8.1 sepercentfmt=f8.1;
rformat sddsrvyr srvf.;
rformat riagendr genf.;

proc descript data=one notsorted design=wr;
  subpopx ridageyr >= 65;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class sddsrvyr riagendr/nofreq;
  var Teeth_Missing;
  catlevel 28;
  table sddsrvyr;
  pairwise riagendr/name="Gender";
  setenv labwidth=24;
  print nsum t_pct p_pct/style=nchs percentfmt=f8.1;
rformat sddsrvyr srvf.;
rformat riagendr genf.;

proc rlogist data=one notsorted design=wr;
  subpopx ridageyr > 65;
  nest sdmvstra sdmvpsu;
  weight wtmec2yr;
  class sddsrvyr riagendr/nofreq;
  recode Teeth_Missing = (28);
  reflevel sddsrvyr = 1
           riagendr = 1;
  model Teeth_Missing = sddsrvyr riagendr;
  test satadjf;
  *print /tests=default;
run;

* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
********Projekt Mikrosimulation von Einkommensteuerreformen********
********************************************************************************
********************************************************************************

/*******************************Daten einlesen*******************************

GET
    FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation ESt\Splittingtabelle\est_splittingtabelle.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

/*Fortschreibung der monetären Größen bis 2020 mit der Annahme von 0,5% Geldentwertung pro Jahr*.

COMPUTE zve_neu=zve * 1.095.
COMPUTE zve_neu=zve_neu / 2.
EXE.

/***************Berechnung Einkommensteuertarif 2020 (Status Quo)*********************************.

COMPUTE y=(TRUNC(zve_neu) - 9408) / 10000.
COMPUTE z=(TRUNC(zve_neu) - 14532) / 10000.
COMPUTE x=TRUNC(zve_neu).
EXE.

DO IF (zve_neu LE 9408).
    COMPUTE st20=0.
ELSE IF (zve_neu GE 9169 AND zve_neu LE 14532).
    COMPUTE st20=(972.87 * y + 1400) * y.
    COMPUTE st20=TRUNC(st20).
    COMPUTE st20=st20 * 2.
ELSE IF (zve_neu GE 14533 AND zve_neu LE 57051).
    COMPUTE st20=(212.02 * z + 2397) * z + 972.79.
    COMPUTE st20=TRUNC(st20).
    COMPUTE st20=st20 * 2.
ELSE IF (zve_neu GE 57052 AND zve_neu LE 270500).
    COMPUTE st20=0.42 * x - 8963.74.
    COMPUTE st20=TRUNC(st20).
    COMPUTE st20=st20 * 2.
ELSE IF (zve_neu GE 270501).
    COMPUTE st20=0.45 * x - 17078.74.
    COMPUTE st20=TRUNC(st20).
   COMPUTE st20=st20 * 2.
END IF.
EXE.

/***************Simulation Einkommensteuertarif (Die Linke)*********************************.

COMPUTE y_s=(TRUNC(zve_neu) - 12600) / 10000.
COMPUTE z_s=(TRUNC(zve_neu) - 70000) / 10000.
COMPUTE x_s=TRUNC(zve_neu).
EXE.

DO IF (zve_neu LE 12600).
    COMPUTE st20_s=0.
ELSE IF (zve_neu GE 12601 AND zve_neu LE 70000).
    COMPUTE st20_s=(339.72 * y_s + 1400) * y_s.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
ELSE IF (zve_neu GE 70001 AND zve_neu LE 259999).
    COMPUTE st20_s=(184.21 * z_s + 5300) * z_s + 19228.42.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
ELSE IF (zve_neu GE 260000 AND zve_neu LE 999999).
    COMPUTE st20_s=0.6 * (x_s - 260000) + 186425.77.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
ELSE IF (zve_neu GE 1000000).
    COMPUTE st20_s=0.75 * (x_s - 1000000) + 630425.17.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
END IF.
EXE.

/***************************Analyse Steueraufkommen*******************.

COMPUTE diff=st20_s - st20.
EXE.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

DESCRIPTIVES VARIABLES=diff
  /STATISTICS=SUM.

 * FREQUENCIES VARIABLES=diff
    /FORMAT=NOTABLE
    /NTILES=10
    /STATISTICS=MEAN MEDIAN SUM
    /ORDER=ANALYSIS.

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************

* /************************Gewinn oder Überschuss********************************.

* RECODE c65101 c65102 c65121 c65122 c65141 c65142 c65161 c65162 c65221 c65222 c65241 c65242 c65261
    c65262 (SYSMIS=0).
* EXECUTE.

* COMPUTE gew=c65101+c65102+c65121+c65122+c65141+c65142.
* COMPUTE ue=c65161+c65162+c65221+c65222+c65241+c65242+c65261+c65262.
* EXECUTE.

* DO IF (gew GE ue).
*  COMPUTE ea=1.
* ELSE if (gew LT ue).
*  COMPUTE ea=2.
* END IF.
* EXE.

* MEANS TABLES=diff BY ea
    /CELLS=COUNT MEAN MEDIAN SUM.

/************************************************************************************
/*******************************Genderanalyse************************************
/************************************************************************************

 * /********************************Alle Einkommen**********************************

 * WEIGHT BY SamplingWeight.

 * DATASET ACTIVATE DataSet1.
 * ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

 * /****************************Hohe Einkommen*************************************.

 * /*****************************Perzentile*********************************************.

 * FREQUENCIES VARIABLES=gde
  /FORMAT=NOTABLE
  /PERCENTILES=90 99 99.9 99.99 
  /ORDER=ANALYSIS.

 * /********************Analyse Obere 10% (>= 49319 €)**************************. 

 * USE ALL.
 * COMPUTE filter_$=(gde GE 41319).
 * VARIABLE LABELS filter_$ 'gde GE 49319 (FILTER)'.
 * VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
 * FORMATS filter_$ (f1.0).
 * FILTER BY filter_$.
 * EXECUTE.

 * DATASET ACTIVATE DataSet1.
 * ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

 * /********************Analyse Obere 1% (>= 96990 €)**************************. 

 * USE ALL.
 * COMPUTE filter_$=(gde GE 96990).
 * VARIABLE LABELS filter_$ 'gde GE 96990 (FILTER)'.
 * VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
 * FORMATS filter_$ (f1.0).
 * FILTER BY filter_$.
 * EXECUTE.

 * DATASET ACTIVATE DataSet1.
 * ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

 * /********************Analyse Oberen 0,01% (>= 2000965 €)*********************. 

 * USE ALL.
 * COMPUTE filter_$=(gde GE 2000965).
 * VARIABLE LABELS filter_$ 'gde GE 2000965 (FILTER)'.
 * VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
 * FORMATS filter_$ (f1.0).
 * FILTER BY filter_$.
 * EXECUTE.

 * DATASET ACTIVATE DataSet1.
 * ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

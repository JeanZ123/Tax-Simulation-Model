* Encoding: UTF-8.
/************************************************************************************
*************************************************************************************
******************************Erstellung Grundtabelle ESt***********************
*************************************************************************************.

/********************************Einlesen der SPSS Datei***********************.

GET
  FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation ESt\cf_est01.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

/***********************************************************************************
*****************Prüfung der Datei an den Randauszählungen***************
************************************************************************************.

/******************************Stetige Merkmale*********************************.

DESCRIPTIVES VARIABLES=sde gde einkommen zve est_tarif est_fest
  /STATISTICS=MEAN STDDEV MIN MAX.

/******************************Diskrete Merkmale*********************************.

FREQUENCIES VARIABLES=EF8 tabelle alter_a kinder
  /ORDER=ANALYSIS.

/************************************Hochrechnung********************************.

WEIGHT BY SamplingWeight.

/**********************************Stetige Merkmale*******************************

DESCRIPTIVES VARIABLES=sde gde einkommen zve est_tarif est_fest
  /STATISTICS=MEAN STDDEV MIN MAX.

/******************************Diskrete Merkmale*********************************

FREQUENCIES VARIABLES=EF8 tabelle alter_a kinder
  /ORDER=ANALYSIS.

/**************************************************************************************
*********************Erstellen Datei Grundtabelle*********************************
 **************************************************************************************
DATASET ACTIVATE DataSet1.
DATASET COPY  est_grundtabelle.
DATASET ACTIVATE  est_grundtabelle.
FILTER OFF.
USE ALL.
SELECT IF (tabelle=1).
EXECUTE.
DATASET ACTIVATE  DataSet1.

SAVE OUTFILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation ESt\est_grundtabelle.sav'
  /COMPRESSED.

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************

/************************Analyse Gewinn- und Überschusseinkünfte**********

RECODE c65101 c65102 c65121 c65122 c65141 c65142 c65161 c65162 c65221 c65222 c65241 c65242 c65261
    c65262 (SYSMIS=0).
EXECUTE.

COMPUTE gew=c65101+c65102+c65121+c65122+c65141+c65142.
COMPUTE ue=c65161+c65162+c65221+c65222+c65241+c65242+c65261+c65262.
EXECUTE.

DO IF (gew GE ue).
    COMPUTE ea=1.
ELSE if (gew LT ue).
    COMPUTE ea=2.
END IF.
EXE.

MEANS TABLES=diff BY ea
    /CELLS=COUNT MEAN MEDIAN SUM.

/************************************************************************************
/*******************************Genderanalyse************************************
/************************************************************************************

/********************************Alle Einkommen**********************************

WEIGHT BY SamplingWeight.

DATASET ACTIVATE DataSet1.
ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

/****************************Hohe Einkommen*************************************.

/*****************************Perzentile*********************************************.

FREQUENCIES VARIABLES=gde
  /FORMAT=NOTABLE
  /PERCENTILES=90 99 99.9 99.99 
  /ORDER=ANALYSIS.

/********************Analyse Obere 10% (>= 49319 €)**************************. 

USE ALL.
COMPUTE filter_$=(gde GE 41319).
VARIABLE LABELS filter_$ 'gde GE 49319 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

DATASET ACTIVATE DataSet1.
ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

/********************Analyse Obere 1% (>= 96990 €)**************************. 

USE ALL.
COMPUTE filter_$=(gde GE 96990).
VARIABLE LABELS filter_$ 'gde GE 96990 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

DATASET ACTIVATE DataSet1.
ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.

/********************Analyse Oberen 0,01% (>= 2000965 €)*********************. 

USE ALL.
COMPUTE filter_$=(gde GE 2000965).
VARIABLE LABELS filter_$ 'gde GE 2000965 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

DATASET ACTIVATE DataSet1.
ONEWAY gde BY EF8
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS.
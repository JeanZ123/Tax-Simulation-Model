* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
********Projekt Mikrosimulation von Einkommensteuerreformen********
********************************************************************************
********************************************************************************

/*******************************Daten einlesen*******************************

GET
    FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Splittingtabelle\est_splittingtabelle.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

/*Fortschreibung der monetären Größen von 2001 bis 2020 mit der Annahme von 0,5% Geldentwertung pro Jahr*.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

COMPUTE sde=c65309.
COMPUTE zve=c65522.
COMPUTE zve_neu=zve * 1.07029.
COMPUTE zve_neu=zve_neu / 2.
COMPUTE zve_neu=TRUNC(zve_neu).

/***************Berechnung Einkommensteuertarif 2020 (Status Quo)*********************************.

COMPUTE y=(TRUNC(zve_neu) - 9408) / 10000.
COMPUTE z=(TRUNC(zve_neu) - 14532) / 10000.
COMPUTE x=TRUNC(zve_neu).

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

/***************Simulation Einkommensteuertarif (Die Linke)*********************************.

COMPUTE y_s=(TRUNC(zve_neu) - 12600) / 10000.
COMPUTE z_s=(TRUNC(zve_neu) - 70000) / 10000.
COMPUTE x_s=TRUNC(zve_neu).

DO IF (zve_neu LE 12600).
    COMPUTE st20_s=0.
ELSE IF (zve_neu GE 12601 AND zve_neu LE 70000).
    COMPUTE st20_s=(339.72 * y_s + 1400) * y_s.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
ELSE IF (zve_neu GE 70001 AND zve_neu LE 259999).
    COMPUTE st20_s=0.53 * (x_s - 70001) + 19228.42.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
ELSE IF (zve_neu GE 260000 AND zve_neu LE 999999).
    COMPUTE st20_s=0.6 * (x_s - 260000) + 119927.36.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
ELSE IF (zve_neu GE 1000000).
    COMPUTE st20_s=0.75 * (x_s - 1000000) + 563926.76.
    COMPUTE st20_s=TRUNC(st20_s).
    COMPUTE st20_s=st20_s * 2.
END IF.

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************

/***************************Analyse Steueraufkommen*************************

COMPUTE diff=st20_s - st20.

DESCRIPTIVES VARIABLES=diff
    /STATISTICS=SUM.
EXECUTE.
/***************************Analyse 10%-Einkommensperzentile************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.
    
FREQUENCIES VARIABLES=zve_neu
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_st20_s = SUM(st20_s).

DO IF (zve_neu GE 0 AND zve_neu LE 1887).
    COMPUTE p=1.  
ELSE IF (zve_neu GE 1888 AND zve_neu LE 5675).
     COMPUTE p=2.
ELSE IF (zve_neu GE 5676 AND zve_neu LE 9518).
    COMPUTE p=3.
ELSE IF (zve_neu GE 9519 AND zve_neu LE 13480).
   COMPUTE p=4.
ELSE IF (zve_neu GE 13481 AND zve_neu LE 18267).
   COMPUTE p=5.
ELSE IF (zve_neu GE 18268 AND zve_neu LE 23212).
    COMPUTE p=6.
ELSE IF (zve_neu GE 23213 AND zve_neu LE 28725).
    COMPUTE p=7.
ELSE IF (zve_neu GE 28726 AND zve_neu LE 34806).
    COMPUTE p=8.
ELSE IF (zve_neu GE 34807 AND zve_neu LE 46704).
    COMPUTE p=9.
ELSE IF (zve_neu GE 46705).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s=p_st20_s / g_st20_s.

/***************************Analyse Einkommensmillionäre************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=
    /g_st20_s = SUM(st20_s).

COMPUTE filter=(zve_neu GE 1000000).
VALUE LABELS filter 0 'Restliche Einkommensgruppen' 1 'Einkommensmillionäre'.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter
    /p_st20_s = SUM(st20_s).

COMPUTE anteil=p_st20_s / g_st20_s.
EXECUTE.

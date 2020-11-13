* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
    ********Projekt Mikrosimulation von Einkommensteuerreformen********
    *******************************************************************************
    *******************************************************************************

/*******************************Daten einlesen*******************************

GET
    FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Gesamttabelle\Berufe & Gewerbe\est_sim_fdp_gastgewerbe.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

/*Fortschreibung der monetären Größen bis 2020 aufgrund des Inflationsindex des Statistischen Bundesamts*.

COMPUTE sde=c65309.
COMPUTE zve=c65522.
COMPUTE zve_neu=zve * 1.07029.
COMPUTE sde_neu=sde * 1.07029.
COMPUTE zve_neu=TRUNC(zve_neu).

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************
/***********************************************************************************

/***************************Anteil der Einkommensteuer am Bruttoeinkommen************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.
    
FREQUENCIES VARIABLES=sde_neu
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

DO IF (sde_neu GE 0 AND sde_neu LE 5351).
    COMPUTE p=1.  
ELSE IF (sde_neu GE 5352 AND sde_neu LE 12060).
     COMPUTE p=2.
ELSE IF (sde_neu GE 12061 AND sde_neu LE 18377).
     COMPUTE p=3.
ELSE IF (sde_neu GE 18378 AND sde_neu LE 24884).
    COMPUTE p=4.
ELSE IF (sde_neu GE 24885 AND sde_neu LE 31642).
   COMPUTE p=5.
ELSE IF (sde_neu GE 31643 AND sde_neu LE 39828).
   COMPUTE p=6.
ELSE IF (sde_neu GE 39829 AND sde_neu LE 49567).
    COMPUTE p=7.
ELSE IF (sde_neu GE 49568 AND sde_neu LE 64220).
    COMPUTE p=8.
ELSE IF (sde_neu GE 64221 AND sde_neu LE 95978).
    COMPUTE p=9.
ELSE IF (sde_neu GE 95979).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_sde_neu = SUM(sde_neu).
    
AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s = p_st20_s / p_sde_neu.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_sde_neu = SUM(sde_neu).

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_st20_s = SUM(st20_s).

COMPUTE q_st20_s = g_st20_s / g_sde_neu.

***************************Analyse 10%-Einkommensperzentile****************

/***************************Sekundäre Einkommensverteilung*******************

WEIGHT OFF.
WEIGHT BY SamplingWeight.

COMPUTE einkommen_sek = zve_neu - st20_s.
    
FREQUENCIES VARIABLES=einkommen_sek
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_einkommen_sek = SUM(einkommen_sek).

DO IF (einkommen_sek GE 0 AND einkommen_sek LE 1887).
    COMPUTE p=1.  
ELSE IF (einkommen_sek GE 1888 AND einkommen_sek LE 5675).
     COMPUTE p=2.
ELSE IF (einkommen_sek GE 5676 AND einkommen_sek LE 9503).
    COMPUTE p=3.
ELSE IF (einkommen_sek GE 9504 AND einkommen_sek LE 12775).
   COMPUTE p=4.
ELSE IF (einkommen_sek GE 12776 AND einkommen_sek LE 16440).
   COMPUTE p=5.
ELSE IF (einkommen_sek GE 16441 AND einkommen_sek LE 20138).
    COMPUTE p=6.
ELSE IF (einkommen_sek GE 20139 AND einkommen_sek LE 24190).
    COMPUTE p=7.
ELSE IF (einkommen_sek GE 24191 AND einkommen_sek LE 28574).
    COMPUTE p=8.
ELSE IF (einkommen_sek GE 28575 AND einkommen_sek LE 36894).
    COMPUTE p=9.
ELSE IF (einkommen_sek GE 36895).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_einkommen_sek = SUM(einkommen_sek).

COMPUTE q_einkommen_sek=p_einkommen_sek  /  g_einkommen_sek.
EXE.

/***************************Verteilung Steuerlast************************

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

/***************************Verteilung Steuerlast************************************

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

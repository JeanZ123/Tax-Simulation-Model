* Encoding: UTF-8.
Encoding: UTF-8.

*******************************************************************************
    *******************************************************************************
    ********Projekt Mikrosimulation von Einkommensteuerreformen********
    ********************************************************************************
    ********************************************************************************

/*******************************Daten einlesen******************************

GET
    FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Gesamttabelle\Berufe & Gewerbe\est_sim_flat_tax_gesundheit.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************
/***********************************************************************************

/***************************Analyse Steueraufkommen*************************

COMPUTE diff=st20_s - st20.

DESCRIPTIVES VARIABLES=diff
    /STATISTICS=SUM.

/***************************Anteil der Einkommensteuer am Bruttoeinkommen************************

FREQUENCIES VARIABLES=sde_neu
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

DO IF (sde_neu GE 0 AND sde_neu LE 4371).
    COMPUTE p=1.
ELSE IF (sde_neu GE 4372 AND sde_neu LE 11292).
    COMPUTE p=2.
ELSE IF (sde_neu GE 11293 AND sde_neu LE 17192).
    COMPUTE p=3.
ELSE IF (sde_neu GE 17193 AND sde_neu LE 23389).
    COMPUTE p=4.
ELSE IF (sde_neu GE 23390 AND sde_neu LE 29757).
    COMPUTE p=5.
ELSE IF (sde_neu GE 29758 AND sde_neu LE 36652).
    COMPUTE p=6.
ELSE IF (sde_neu GE 36653 AND sde_neu LE 45283).
    COMPUTE p=7.
ELSE IF (sde_neu GE 45284 AND sde_neu LE 58177).
    COMPUTE p=8.
ELSE IF (sde_neu GE 58178 AND sde_neu LE 82578).
    COMPUTE p=9.
ELSE IF (sde_neu GE 82579).
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


*****************************************************.

FREQUENCIES VARIABLES=sde_neu
    /FORMAT=NOTABLE
    /PERCENTILES=99.0 99.99. 

DATASET ACTIVATE DataSet1.
USE ALL.
COMPUTE filter_$=(sde_neu  >= 831803).
VARIABLE LABELS filter_$ 'sde_neu  >= 831803 (FILTER)'. 
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'. 
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter_$ 
    /p_sde_neu = SUM(sde_neu).

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter_$ 
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s = p_st20_s / p_sde_neu.

DATASET ACTIVATE DataSet1.
USE ALL.
COMPUTE filter_$=(sde_neu  >= 3898925).
VARIABLE LABELS filter_$ 'sde_neu  >= 3898925 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter_$ 
    /p_sde_neu = SUM(sde_neu).
    
AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter_$ 
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s = p_st20_s / p_sde_neu.	
EXECUTE.
/***************************Sekundäre Einkommensverteilung*******************

COMPUTE einkommen_sek = zve_neu - st20_s.
SELECT IF einkommen_sek > 0.
FREQUENCIES VARIABLES=einkommen_sek
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_einkommen_sek = SUM(einkommen_sek).

DO IF (einkommen_sek GE 0 AND einkommen_sek LE 3187).
    COMPUTE p=1.
ELSE IF (einkommen_sek GE 3188 AND einkommen_sek LE 5898).
    COMPUTE p=2.
ELSE IF (einkommen_sek GE 5899 AND einkommen_sek LE 8186).
    COMPUTE p=3.
ELSE IF (einkommen_sek GE 8187 AND einkommen_sek LE 10184).
    COMPUTE p=4.
ELSE IF (einkommen_sek GE 10185 AND einkommen_sek LE 12335).
    COMPUTE p=5.
ELSE IF (einkommen_sek GE 12336 AND einkommen_sek LE 14828).
    COMPUTE p=6.
ELSE IF (einkommen_sek GE 14829 AND einkommen_sek LE 18506).
    COMPUTE p=7.
ELSE IF (einkommen_sek GE 18507 AND einkommen_sek LE 23422).
    COMPUTE p=8.
ELSE IF (einkommen_sek GE 23423 AND einkommen_sek LE 31390).
    COMPUTE p=9.
ELSE IF (einkommen_sek GE 31391).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_einkommen_sek = SUM(einkommen_sek).

COMPUTE q_einkommen_sek=p_einkommen_sek  /  g_einkommen_sek.
EXECUTE.

/***************************Verteilung Steuerlast************************

COMPUTE einkommen_sek = zve_neu - st20_s.
SELECT IF einkommen_sek > 0.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_st20_s = SUM(st20_s).

DO IF (einkommen_sek GE 0 AND einkommen_sek LE 3187).
    COMPUTE p=1.
ELSE IF (einkommen_sek GE 3188 AND einkommen_sek LE 5898).
    COMPUTE p=2.
ELSE IF (einkommen_sek GE 5899 AND einkommen_sek LE 8186).
    COMPUTE p=3.
ELSE IF (einkommen_sek GE 8187 AND einkommen_sek LE 10184).
    COMPUTE p=4.
ELSE IF (einkommen_sek GE 10185 AND einkommen_sek LE 12335).
    COMPUTE p=5.
ELSE IF (einkommen_sek GE 12336 AND einkommen_sek LE 14828).
    COMPUTE p=6.
ELSE IF (einkommen_sek GE 14829 AND einkommen_sek LE 18506).
    COMPUTE p=7.
ELSE IF (einkommen_sek GE 18507 AND einkommen_sek LE 23422).
    COMPUTE p=8.
ELSE IF (einkommen_sek GE 23423 AND einkommen_sek LE 31390).
    COMPUTE p=9.
ELSE IF (einkommen_sek GE 31391).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s=p_st20_s / g_st20_s.
EXECUTE.

Encoding: UTF-8.

*******************************************************************************
*******************************************************************************
****************Simulation of the FDP income tax reform for 2020***************
*******************************************************************************
*******************************************************************************

/*******************************Read in Dataset********************************

GET
    FILE='"...".sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

/******************************************************************************
/********Descriptive analysis of the effects on the income distribution********
/******************************************************************************

/***************************Calculating the global tax revenue***********************

COMPUTE diff=st20_s - st20.

DESCRIPTIVES VARIABLES=diff
    /STATISTICS=SUM.

/*Deciles indicating the income tax burden as a percentage of the gross income**

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
ELSE IF (sde_neu GE 82579 AND sde_neu LE 9999999999).
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

*****Same calculations as above for the 1%, 0.1% and 0.01% percentiles*****.

FREQUENCIES VARIABLES=sde_neu
    /FORMAT=NOTABLE
    /PERCENTILES=99.0 99.9 99.99. 
EXECUTE.
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

/*Deciles indicating the distribution of the secondary income (income after taxes)*****.

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

DO IF (einkommen_sek GE 0 AND einkommen_sek LE 4012).
    COMPUTE p=1.
ELSE IF (einkommen_sek GE 4013 AND einkommen_sek LE 9230).
    COMPUTE p=2.
ELSE IF (einkommen_sek GE 9231 AND einkommen_sek LE 13533).
    COMPUTE p=3.
ELSE IF (einkommen_sek GE 13534 AND einkommen_sek LE 17968).
    COMPUTE p=4.
ELSE IF (einkommen_sek GE 17969 AND einkommen_sek LE 22255).
    COMPUTE p=5.
ELSE IF (einkommen_sek GE 22256 AND einkommen_sek LE 26661).
    COMPUTE p=6.
ELSE IF (einkommen_sek GE 26662 AND einkommen_sek LE 32314).
    COMPUTE p=7.
ELSE IF (einkommen_sek GE 32315 AND einkommen_sek LE 40714).
    COMPUTE p=8.
ELSE IF (einkommen_sek GE 40715 AND einkommen_sek LE 53786).
    COMPUTE p=9.
ELSE IF (einkommen_sek GE 53787).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_einkommen_sek = SUM(einkommen_sek).

COMPUTE q_einkommen_sek=p_einkommen_sek  /  g_einkommen_sek.

/*Deciles indicating the distribution of the income tax burden*******.

COMPUTE einkommen_sek = zve_neu - st20_s.
SELECT IF einkommen_sek > 0.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=
    /g_st20_s = SUM(st20_s).

DO IF (einkommen_sek GE 0 AND einkommen_sek LE 4012).
    COMPUTE p=1.
ELSE IF (einkommen_sek GE 4013 AND einkommen_sek LE 9230).
    COMPUTE p=2.
ELSE IF (einkommen_sek GE 9231 AND einkommen_sek LE 13533).
    COMPUTE p=3.
ELSE IF (einkommen_sek GE 13534 AND einkommen_sek LE 17968).
    COMPUTE p=4.
ELSE IF (einkommen_sek GE 17969 AND einkommen_sek LE 22255).
    COMPUTE p=5.
ELSE IF (einkommen_sek GE 22256 AND einkommen_sek LE 26661).
    COMPUTE p=6.
ELSE IF (einkommen_sek GE 26662 AND einkommen_sek LE 32314).
    COMPUTE p=7.
ELSE IF (einkommen_sek GE 32315 AND einkommen_sek LE 40714).
    COMPUTE p=8.
ELSE IF (einkommen_sek GE 40715 AND einkommen_sek LE 53786).
    COMPUTE p=9.
ELSE IF (einkommen_sek GE 53787).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s=p_st20_s / g_st20_s.

EXECUTE.

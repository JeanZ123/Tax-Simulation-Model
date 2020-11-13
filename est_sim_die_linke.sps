* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
********Projekt Mikrosimulation von Einkommensteuerreformen********
********************************************************************************
********************************************************************************

 * /*******************************Daten einlesen*******************************

GET
    FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Grundtabelle\est_grundtabelle.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

/*Fortschreibung der monetären Größen bis 2020*

WEIGHT OFF.
WEIGHT BY SamplingWeight.

COMPUTE sde=c65309.
COMPUTE zve=c65522.
COMPUTE zve_neu=zve * 1.07029.
COMPUTE sde_neu=sde * 1.07029.
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
ELSE IF (zve_neu GE 14533 AND zve_neu LE 57051).
    COMPUTE st20=(212.02 * z + 2397) * z + 972.79.
    COMPUTE st20=TRUNC(st20).
ELSE IF (zve_neu GE 57052 AND zve_neu LE 270500).
    COMPUTE st20=0.42 * x - 8963.74.
    COMPUTE st20=TRUNC(st20).
ELSE IF (zve_neu GE 270501).
    COMPUTE st20=0.45 * x - 17078.74.
    COMPUTE st20=TRUNC(st20).
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
ELSE IF (zve_neu GE 70001 AND zve_neu LE 259999).
    COMPUTE st20_s= 0.53 * (x_s - 70001) + 19228.42.
    COMPUTE st20_s=TRUNC(st20_s).
ELSE IF (zve_neu GE 260000 AND zve_neu LE 999999).
    COMPUTE st20_s=0.6 * (x_s - 260000) + 119927.36.
    COMPUTE st20_s=TRUNC(st20_s).
ELSE IF (zve_neu GE 1000000).
    COMPUTE st20_s=0.75 * (x_s - 1000000) + 563926.76.
    COMPUTE st20_s=TRUNC(st20_s).
END IF.

/***************************Analyse Steueraufkommen*************************

COMPUTE diff=st20_s - st20.

DESCRIPTIVES VARIABLES=diff
    /STATISTICS=SUM.
EXECUTE.

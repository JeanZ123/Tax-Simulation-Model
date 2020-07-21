* Encoding: UTF-8.
*******************************************************************************
*******************************************************************************
********Projekt Mikrosimulation von Einkommensteuerreformen********
********************************************************************************
********************************************************************************

/*******************************Daten einlesen******************************

GET
  FILE='C:\Users\Marius\Desktop\Statistics\Projects\SPSS\Mikrosimulation_ESt\Grundtabelle\est_grundtabelle.sav'.
DATASET NAME DataSet1 WINDOW=ASIS.

/*Fortschreibung der monetären Größen bis 2020 mit der Annahme von 0,5% Geldentwertung pro Jahr*.

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

/***************Simulation Einkommensteuertarif (Flat Tax 28%)*********************************.

DO IF (sde LE 10000).
    COMPUTE st20_s=0.
ELSE IF (sde GE 10001).
    COMPUTE st20_s=sde * 0.28.
    COMPUTE st20_s=TRUNC(st20_s).
END IF.

/***********************************************************************************
/*****************************Deskriptive Analyse*******************************

/***************************Analyse Steueraufkommen*************************

COMPUTE diff=st20_s - st20.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

DESCRIPTIVES VARIABLES=diff
    /STATISTICS=SUM.

 * /***************************Analyse Einkommensperzentile************************

FREQUENCIES VARIABLES=sde_neu
    /FORMAT=NOTABLE
    /NTILES=10
    /ORDER=ANALYSIS.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=
    /g_st20_s = SUM(st20_s).

DO IF (sde_neu GE 0 AND sde_neu LE 963).
    COMPUTE p=1.  
ELSE IF (sde_neu GE 964 AND sde_neu LE 5508).
     COMPUTE p=2.
ELSE IF (sde_neu GE 5509 AND sde_neu LE 9778).
    COMPUTE p=3.
ELSE IF (sde_neu GE 9779 AND sde_neu LE 12843).
   COMPUTE p=4.
ELSE IF (sde_neu GE 12844 AND sde_neu LE 15565).
   COMPUTE p=5.
ELSE IF (sde_neu GE 15566 AND sde_neu LE 29034).
    COMPUTE p=6.
ELSE IF (sde_neu GE 29035 AND sde_neu LE 82007).
    COMPUTE p=7.
ELSE IF (sde_neu GE 82008 AND sde_neu LE 96114).
    COMPUTE p=8.
ELSE IF (sde_neu GE 96115 AND sde_neu LE 128889).
    COMPUTE p=9.
ELSE IF (sde_neu GE 128890).
    COMPUTE p=10.
END IF.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=p
    /p_st20_s = SUM(st20_s).

COMPUTE q_st20_s=p_st20_s / g_st20_s.

WEIGHT OFF.
WEIGHT BY SamplingWeight.

FORMATS p(f1.0).
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=p q_st20_s MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /COLORCYCLE COLOR1(85,150,230), COLOR2(215,0,51), COLOR3(41,134,38), COLOR4(243,103,42), 
    COLOR5(227,215,16), COLOR6(0,180,160), COLOR7(255,196,226), COLOR8(171,73,243), COLOR9(95,195,56), 
    COLOR10(63,90,168)
  /FRAME OUTER=NO INNER=NO
  /GRIDLINES XAXIS=NO YAXIS=YES.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: p=col(source(s), name("p"), unit.category())
  DATA: q_st20_s=col(source(s), name("q_st20_s"))
  GUIDE: axis(dim(1), label("Einkommensperzentile"))
  GUIDE: axis(dim(2), label("Anteil am Steueraufkommen (in %)"))
  GUIDE: text.title(label("Anteil von Einkommensgruppen an der gesamten Einkommensteuer"))
  GUIDE: text.subtitle(label("(Reformvorschlag Flat Tax, Stand: 2020)"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(p*q_st20_s), shape.interior(shape.square))
END GPL.

/***************************Analyse Einkommensmillionäre************************

WEIGHT OFF.
WEIGHT BY SamplingWeight.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=
    /g_st20_s = SUM(st20_s).

COMPUTE filter=(sde_neu GE 1000000).
VALUE LABELS filter 0 'Restliche Einkommensgruppen' 1 'Einkommensmillionäre'.

AGGREGATE
    /OUTFILE=*MODE=ADDVARIABLES OVERWRITE=YES
    /BREAK=filter
    /p_st20_s = SUM(st20_s).

COMPUTE anteil=p_st20_s / g_st20_s.

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=filter anteil MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: filter=col(source(s), name("filter"), unit.category())
  DATA: anteil=col(source(s), name("anteil"))
  GUIDE: axis(dim(1), label("Einkommensgruppe"))
  GUIDE: axis(dim(2), label("Anteil am Einkommensteueraufkommen (in %)"))
  GUIDE: text.title(label("Anteil der Einkommensmillionäre an der gesamten Einkommensteuer"))
  GUIDE: text.subtitle(label("(Reformvorschlag Flat Tax, Stand: 2020)"))
  SCALE: cat(dim(1), include("1.00", "0.00"), sort.values("1.00", "0.00"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: interval(position(filter*anteil), shape.interior(shape.square))
END GPL.
EXE.
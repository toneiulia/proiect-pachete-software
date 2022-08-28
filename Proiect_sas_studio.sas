libname proiect '/home/u61071921/proiect';
FILENAME REFFILE '/home/u61071921/proiect/baza_date.xlsm';
PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=proiect.baza_date replace;
	SHEET='Vanzari';
	GETNAMES=YES;
RUN;
TITLE "Baza de date";
PROC CONTENTS DATA=proiect.baza_date
RUN;



proc format;
value $judet 'Constanta' = 'CT'
'Bucuresti' = 'B'
'Dambovita' = 'DB' 'Ilfov' = 'IF';
run;

proc print data=proiect.baza_date; format Judet $judet. ;
run;



title "Frecventa de aparitie pentru fiecare judet"; proc FREQ data=proiect.baza_date;
TABLES Judet /nocum nopercent; FORMAT Judet $judet.;
run;



title "Comenzi de bauturi alcoolice si tigari care au cantitatea vanduta intre 100 si 200 de bucati";
proc print data=proiect.baza_date;
where Categorie eq 'Băuturi alcoolice şi ţigări' and (Cantitate_vanduta between 100 and 200);
var Data_comandarii Categorie Produs Cantitate_vanduta;
run;



data produseMinori replace;
set proiect.baza_Date;
length ConditieVanzare $16;
if Categorie eq 'Băuturi alcoolice şi ţigări' then
	do;
		ConditieVanzare="Persoana majora";
	end;
else
	do;
		ConditieVanzare="Orice persoana";
	end;
run;
title "Vanzarea de bauturi alcoolice si tutun catre minori";
proc print data=produseMinori;
var Data_comandarii Categorie Produs ConditieVanzare;
run;



DATA proiect.bucuresti; SET proiect.baza_date;
WHERE Oras eq 'Bucuresti' AND YEAR(Data_comandarii) eq 2021;
RUN;
DATA proiect.voluntari; SET proiect.baza_date;
WHERE Oras eq 'Voluntari' AND YEAR(Data_comandarii) eq 2021;
RUN;
DATA proiect.constanta; SET proiect.baza_date;
WHERE Oras eq 'Constanta' AND YEAR(Data_comandarii) eq 2021;
RUN;
DATA proiect.targoviste; SET proiect.baza_date;
WHERE Oras eq 'Targoviste' AND YEAR(Data_comandarii) eq 2021;
RUN;



PROC SORT DATA = proiect.baza_date; BY judet;
PROC PRINT DATA = proiect.baza_date sumlabel = 'Total #byval(judet)' grandtotal_label = 'Total';
BY judet;
SUM Cantitate_vanduta;
TITLE 'Numarul de produse vandute in fiecare judet'; RUN;



proc sort data=proiect.baza_date; where Categorie eq 'Dulciuri'; by Produs;
proc print data=proiect.baza_date
sumlabel="Total #byval(Produs)" grandtotal_label="Total";
by Produs;
sum Cantitate_vanduta;
title "Total cantitati de dulciuri vandute";
run;



PROC UNIVARIATE DATA=proiect.baza_date NEXTRVAL=5 NEXTROBS=0; VAR Cantitate_vanduta;
Title "Indicatori statistici cu valori limita distincte pentru cantitatile de produse vandute";
RUN;



TITLE "Distributia produselor vandute in Bucuresti"; PATTERN value = solid;
PROC GCHART data=proiect.bucuresti;
VBAR Produs / sumvar=Cantitate_vanduta
type=sum;
RUN;
QUIT;
TITLE "Distributia produselor vandute in Voluntari"; PATTERN value = solid;
PROC GCHART data=proiect.voluntari;
VBAR Produs / sumvar=Cantitate_vanduta
type=sum;
RUN;
QUIT;
TITLE "Distributia produselor vandute in Targoviste"; PATTERN value = solid;
PROC GCHART data=proiect.targoviste;
VBAR Produs / sumvar=Cantitate_vanduta
type=sum;
RUN;
QUIT;
TITLE "Distributia produselor vandute in Constanta"; PATTERN value = solid;
PROC GCHART data=proiect.constanta;
VBAR Produs / sumvar=Cantitate_vanduta
type=sum;
RUN;
QUIT;



DATA proiect.anul2021; SET proiect.baza_date;
WHERE YEAR(Data_comandarii) eq 2021;
RUN;
TITLE "Distribuita profitului final per categorie de produs pentru fiecare oras "; PATTERN value = solid;
AXIS1 order =("Bucuresti" "Voluntari" "Constanta" "Targoviste"); PROC GCHART data=proiect.anul2021;
VBAR Oras / sumvar=Profit_impozitat
subgroup=Categorie type=sum
maxis=axis1;
RUN;
QUIT;



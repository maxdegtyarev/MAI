//-------------------------------------------------------------------------------------------------------------
// Quine–McCluskey Algorithm
// =========================
//-------------------------------------------------------------------------------------------------------------
// English:
//-------------------------------------------------------------------------------------------------------------
// Description: Application to simplify boolean functions with Quine-McCluskey algorithm
// Date: 05/16/2012
// Author: Stefan Moebius (mail@stefanmoebius.de)
// Licence: Can be used_minterm freely (Public Domain)
//-------------------------------------------------------------------------------------------------------------
// German:
//-------------------------------------------------------------------------------------------------------------
// Beschreibung: Programm zur Vereinfachung von Booleschen Funktionen mit hilfe des Quine–McCluskey Verfahrens.
// Datum: 16.05.2012
// Author: Stefan Moebius (mail@stefanmoebius.de)
// Lizenz: darf frei verwendet werden (Public Domain)
//-------------------------------------------------------------------------------------------------------------
#include <stdio.h>
#include <string.h>
#pragma warning(disable:4996)
#define TRUE 1
#define FALSE 0
#define MAXVARS 9
#define MAX 2048

//Global fields: / Globale Felder:
char implicant[MAXVARS];
char getstring[MAXVARS];
int counter;
int minterm[MAX][MAX];
int all_minterm[MAX][MAX];		// all_minterm of minterm  /  all_minterme des Minterm
int used_minterm[MAX][MAX];		// minterm used_minterm  /  Minterm wurde verwendet
int result[MAX];		// results  /  Ergebnisse
int primall_minterm[MAX];		// all_minterm for prime implicants  /  all_minterme für Primimplikant
int prim[MAX];			// prime implicant  /  Primimplikant
int wprim[MAX];			// essential prime implicant (TRUE/FALSE)  /  wesentlicher Primimplikant (TRUE/FALSE)
int nwprim[MAX];		// needed not essential prime implicant  /  benötigter unwesentlicher Primimplikant
FILE *fout;
//Count all set bits of the integer number  /  Zählen der gesetzen Bits in einer Integerzahl
int popCount(unsigned x) { // Taken from book "Hackers Delight"  / Aus dem Buch "Hackers Delight" 
	x = x - ((x >> 1) & 0x55555555);
	x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
	x = (x + (x >> 4)) & 0x0F0F0F0F;
	x = x + (x >> 8);
	x = x + (x >> 16);
	return x & 0x0000003F;
}

//Calculate hamming weight/distance of two integer numbers  /  Berechnung der Hammingdistanz von 2 Integerzahlen
int hammingWeight(int v1, int v2) {
	return popCount(v1 ^ v2);
} 

//Output upper part of term in console  /  Oberer Teil des Terms in der Konsole ausgeben
//íîìåğ öèêëà, êîëè÷åñòâî ñòğîê, ÷èñëî ïåğåìåííûõ
void upperTerm(int bitfield, int all_minterm, int num) {
	//int implicant[num] = { 0 };
	for (int i = 0; i < MAXVARS; i++)
	{
		implicant[i] = 0;
	}
	if (all_minterm) {
		int z;
		for ( z = 0; z < num; z++) {
			if (all_minterm & (1 << z)) {      
				if (bitfield & (1 << z))
					implicant[z] = '0';
				else
					implicant[z] = '1';
			}
		} 
	}
}

//Output lower part of term in console  /  Unterer Teil des Terms in der Konsole ausgeben
void lowerTerm(int all_minterm, int num) {
	int *mas, i=0;
	mas = (int*)malloc(num*sizeof(int));
	for (i = 0; i < num; i++)
		mas[i] = -1;
	if (all_minterm) {
		int z;
		for (z = 0; z <num; z++) {
			if (all_minterm & (1 << z)) {
				mas[z] = z + 1;
			} 
		} 
	}
	for (i = 0; i < num; i++)
	{
		if (mas[i] == -1)
			fprintf(fout,"%d", i+1);
	}
	free(mas);
}

//Output a term to console  /  Ausgabe eines Terms in der Konsole
//íîìåğ öèêëà, êîëè÷åñòâî ñòğîê, ÷èñëî ïåğåìåííûõ
void outputTerm(int bitfield, int all_minterm, int num) {
	upperTerm(bitfield, all_minterm, num);
	//if (all_minterm) printf("\n");
	//lowerTerm(all_minterm, num);//êîë-âî ñòğîê, ÷èñëî ïåğåìåííûõ
}

//Determines whether "value" contains "part"  /  Bestimmt, ob "value" "part" beinhaltet
int contains(value, all_minterm, part, partall_minterm) {
	if ((value & partall_minterm) == (part & partall_minterm)) {
		if ((all_minterm & partall_minterm) ==  partall_minterm)
			return TRUE;
	}   
	return FALSE;
}

int main() {
	int num = 0; // Number of Variables  /  Anzahl Eingänge
	int pos = 0;
	int cur = 0;
	int reduction = 0; //reduction step  / Reduktionsschritt
	int maderedction = FALSE;
	int prim_count = 0;
	int term = 0;
	int termall_minterm = 0;
	int found = 0;
	int x = 0;
	int y = 0;
	int z = 0;
	int count = 0;
	int lastprim = 0; 
	int res = 0; // actual result  /  Ist-Ausgabe

	// Fill all arrays with default values / Alle Arrays mit Standardwert auffüllen
	for (x = 0; x < MAX; x++) {
		primall_minterm[x] = 0;
		prim[x] = 0;
		wprim[x] = FALSE;
		nwprim[x] = FALSE;
		result[x] = FALSE;
		nwprim[x] = TRUE; //unwesentliche Primimplikaten als benötigt markieren
		for (y = 0; y < MAX; y++) {
			all_minterm[x][y] = 0;
			minterm[x][y] = 0;
			used_minterm[x][y] = FALSE;
		}
	}


	char c = 0; int i;
	//printf("Please enter desired results: ( 0 or 1)\n\n");
	FILE *fin = fopen("sdnf.txt", "r");
	cur = 0; 
	//ÒÓÒ ÍÀÄÎ ÇÀÃĞÓÇÈÒÜ ÈÇ ÔÀÉËÀ
	while (fin!=EOF)
	{
		if (c == EOF) break;
		memset(getstring, 0, strlen(getstring));
		c = 0; 
		for (i = 0; i < MAXVARS; i++)
			getstring[i] = 0;
		i = 0;
		while (c != '\n')
		{
			c = fgetc(fin);
			if (c == '\n' || c==EOF)
			{
//				getstring[i] = 0;
				break;
			}
			getstring[i] = c;
			i++;
		}
		//printf("%d", strlen(getstring));
		num = i;
		pos = (1 << num);  // 2 ^ num
		for (x = 0; x < pos; x++) {
			int value = 0;
			outputTerm(x, pos - 1, num);//íîìåğ öèêëà, êîëè÷åñòâî ñòğîê, ÷èñëî ïåğåìåííûõ
			
			//printf("%s %s %d %d", getstring, implicant, strlen(implicant), strlen(getstring));
			//system("pause");
			if (strstr(implicant, getstring) != NULL)//åñëè íàøëè äèçúşíêòó
			{
				value = 1;
			}
				
			else
				value = 0;
			if (value) {
				all_minterm[cur][0] = ((1 << num) - 1);
				minterm[cur][0] = x;
				cur++;
				result[x] = 1; break;
			}
			//printf("\n");
		}
	}
	

	for (reduction = 0; reduction < MAX; reduction++) {
		cur = 0; 
		maderedction = FALSE;
		for (y=0; y < MAX; y++) {
			for (x=0; x < MAX; x++) {   
				if ((all_minterm[x][reduction]) && (all_minterm[y][reduction])) {      
					if (popCount(all_minterm[x][reduction]) > 1) { // Do not allow complete removal (problem if all terms are 1)  /  Komplette aufhebung nicht zulassen (sonst problem, wenn alle Terme = 1)
						if ((hammingWeight(minterm[x][reduction] & all_minterm[x][reduction], minterm[y][reduction] & all_minterm[y][reduction]) == 1) && (all_minterm[x][reduction] == all_minterm[y][reduction])) { // Simplification only possible if 1 bit differs  /  Vereinfachung nur möglich, wenn 1 anderst ist 
							term = minterm[x][reduction]; // could be mintern x or y /  egal ob mintern x oder minterm y 
							//e.g.:
							//1110
							//1111
							//Should result in all_minterm of 1110  /  Soll all_minterme von 1110 ergeben
							termall_minterm = all_minterm[x][reduction]  ^ (minterm[x][reduction] ^ minterm[y][reduction]); 
							term  &= termall_minterm;

							found = FALSE;		
							for ( z=0; z<cur; z++) {
								if ((minterm[z][reduction+1] == term) && (all_minterm[z][reduction+1] == termall_minterm) ) {							
									found = TRUE;
								}
							}

							if (found == FALSE) {
								minterm[cur][reduction+1] = term;
								all_minterm[cur][reduction+1] = termall_minterm;
								cur++; 
							}
							used_minterm[x][reduction] = TRUE;
							used_minterm[y][reduction] = TRUE;  
							maderedction = TRUE;
						}
					}
				} 
			}    
		}
		if (maderedction == FALSE)
			break; //exit loop early (speed optimisation)  /  Vorzeitig abbrechen (Geschwindigkeitsoptimierung)
	}

	prim_count = 0;
	//printf("\nprime implicants:\n");
	for ( reduction = 0 ; reduction < MAX; reduction++) {
		for ( x=0 ;x < MAX; x++) {		
			//Determine all not used_minterm minterms  /  Alle nicht verwendeten Minterme bestimmen
			if ((used_minterm[x][reduction] == FALSE) && (all_minterm[x][reduction]) ) {
				//Check if the same prime implicant is already in the list  /  Überprüfen, ob gleicher Primimplikant bereits in der Liste
				found = FALSE;
				for ( z=0; z < prim_count; z++) {
					if (((prim[z] & primall_minterm[z]) == (minterm[x][reduction] & all_minterm[x][reduction])) &&  (primall_minterm[z] == all_minterm[x][reduction]) )					
						found = TRUE;
				} 
				if (found == FALSE) {
					//outputTerm(minterm[x][reduction], all_minterm[x][reduction], num);
					//printf("\n");
					primall_minterm[prim_count] = all_minterm[x][reduction];
					prim[prim_count] = minterm[x][reduction];
					prim_count++;
				}     
			} 
		} 
	}  

	//find essential and not essential prime implicants  /  wesentliche und unwesentliche Primimplikanten finden
	//all alle prime implicants are set to "not essential" so far  /  Primimplikanten sind bisher auf "nicht wesentlich" gesetzt
	for (y=0; y < pos; y++) { //for all minterms  /  alle Minterme durchgehen 	
		count = 0;
		lastprim = 0;   
		if (all_minterm[y][0]) {
			for (x=0; x < prim_count; x++ ) { //for all prime implicants  /  alle Primimplikanten durchgehen  
				if (primall_minterm[x]) {
					// Check if the minterm contains prime implicant  /  the Überprüfen, ob der Minterm den Primimplikanten beinhaltet
					if (contains(minterm[y][0], all_minterm[y][0], prim[x], primall_minterm[x])) {					
						count++;
						lastprim = x;          
					}  
				} 		
			}
			// If count = 1 then it is a essential prime implicant /  Wenn Anzahl = 1, dann wesentlicher Primimplikant
			if (count == 1) {
				wprim[lastprim] = TRUE;
			}
		}
	}

	// successively testing if it is possible to remove prime implicants from the rest matrix  /  Nacheinander testen, ob es mögich ist, Primimplikaten der Restmatrix zu entfernen
	for ( z=0; z < prim_count; z++) {
		if (primall_minterm[z] ) {
			if ((wprim[z] == FALSE)) { // && (rwprim[z] == TRUE))
				nwprim[z] = FALSE; // mark as "not essential" /  als "nicht benötigt" markiert
				for ( y=0; y < pos; y++) { // for all possibilities  /  alle Möglichkeiten durchgehen 
					res = 0;
					for ( x=0; x < prim_count; x++) {
						if ( (wprim[x] == TRUE) || (nwprim[x] == TRUE)) {  //essential prime implicant or marked as required  /  wesentlicher Primimplikant oder als benötigt markiert
							if ((y & primall_minterm[x]) == (prim[x] & primall_minterm[x])) { //All bits must be 1  /  Es müssen alle Bits auf einmal auf 1 sein (da And-Verknüpfung)
								res = 1; 
								break;
							}
						}
					}
					//printf(" %d\t%d\n", result, result[y]);
					if (res == result[y]) {  // compare calculated result with input value /  Berechnetes ergebnis mit sollwert vergleichen				
						//printf("not needed\n"); //prime implicant not required  /  Primimplikant wird nicht benötigt
					}
					else {
						//printf("needed\n");
						nwprim[z] = TRUE; //prime implicant required  /  Primimplikant wird doch benötigt
					}
				}
			}
		}
	}
	//printf("Result:\n\n");
	// Output of essential and required prime implicants / Ausgabe der wesentlichen und restlichen benötigten Primimplikanten:
	count = 0;
	//for ( x = 0 ; x < prim_count; x++) {
	//	if (wprim[x] == TRUE) {
	//		//if (count > 0) printf("   ");
	//		upperTerm(prim[x], primall_minterm[x], num);
	//		count++;
	//	}
	//	else if ((wprim[x] == FALSE) && (nwprim[x] == TRUE)) {
	//		//if (count > 0) printf("   ");
	//		upperTerm(prim[x], primall_minterm[x], num);
	//		count++;
	//	}
	//}
	//printf("\n");
	count = 0;
	fout= fopen("out_dnf.txt", "w");
	for ( x = 0 ; x < prim_count; x++) {
		if (wprim[x] == TRUE) {
			if (count > 0) fprintf(fout, " + {");
			else fprintf(fout, "{");
			lowerTerm(primall_minterm[x], num); fprintf(fout, "}");
			count++;
		}
		else if ((wprim[x] == FALSE) && (nwprim[x] == TRUE)) {
			if (count > 0) fprintf(fout," + {");
			else fprintf(fout, "{");
			lowerTerm(primall_minterm[x], num); fprintf(fout, "}");
			count++;
		}
	}
	//printf("\n");
	//system("pause");
	return 0;
}


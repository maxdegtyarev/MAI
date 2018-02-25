#pragma once
/*
	2018, Maxim Degtyarev
	RC4 Release
	18.02.2018
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define N 256 //2^8 -> 256
char* TEMP;

void errorHandler(int n)
{
	switch (n)
	{
	case 1:
		printf("Error! Have not free RAM");
		exit;
	default:
		break;
	}
}

//Changing elements in array
void swap(unsigned char* A, unsigned char* B)
{
	char tmp = *A;
	*A = *B;
	*B = tmp;
}

//Initialisation S-block
void KSA(char* key, unsigned char* S)
{
	for (int i = 0; i < N; i++)
		S[i] = i;

	unsigned Length = strlen(key); //Length of key

	int j = 0;
	for (int i = 0; i < N; i++) {
		j = (j + S[i] + key[i % Length]) % N;
		swap(&S[i], &S[j]);
	}
}

//Generating special keyword for our S-block
void generate_KeyWord(char* string, unsigned char* S, unsigned char* K)
{
	int i = 0;
	int j = 0;
	for (unsigned n = 0, length = strlen(string); n < length; n++)
	{
		i = (i + 1) % N;
		j = (j + S[i]) % N;
		swap(&S[i], &S[j]);
		int R = ((S[i] + S[j]) % N);
		K[n] = S[R];
	}
}

/*
	Encrypting string
*/
char* RC4(char* string, char* key)
{
	//if (TEMP != NULL)
	 //free(TEMP);

	unsigned char S[N] = { 0 };
	unsigned char K[N] = { 0 };

	char* result = (char*)malloc(strlen(string) + 1);
	TEMP = result;

	for (int k = 0; k < strlen(string) + 1; k++)
		result[k] = 0;

	if (result == NULL) errorHandler(1);

	KSA(key,S); //Инициализируем блок
	generate_KeyWord(string, S, K); //Генерируем слово, которое будет XORиться с сообщением

	for (int i = 0; i < strlen(string); i++)
		result[i] = K[i] ^ string[i];

	return result;
}
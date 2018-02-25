#pragma once

#define _CRT_SECURE_NO_WARNINGS
#define MENU_NUMS 5
#include <stdio.h>
#include <locale.h>
#include <string.h>
#include <conio.h>
#include <time.h>
#include <Windows.h>

HANDLE hConsole;

enum Colors {
	Black = 0,
	Blue = 0x1,
	Green = 0x2,
	Cyan = 0x3,
	Red = 0x4,
	Magenta = 0x5,
	Brown = 0x6,
	LightGray = 0x7,
	DarkGray = 0x8,
	DarkBlue = 0x1F,
	LightBlue = 0x9,
	LightGreen = 0xA,
	LightCyan = 0xB,
	LightRed = 0xC,
	LightMagenta = 0xD,
	Yellow = 0xE,
	White = 0xF
};

int logCounter = 0;

void initialGraphics()
{
	hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
}
/*
	Default graphic message
*/
void graphicsMessage(char* text, unsigned wait, int dm)
{
	SetConsoleTextAttribute(hConsole, (WORD)((White << 4) | Blue));
	printf("\n======================================================");
	printf("\n%s\n", text);
	printf("======================================================\n");
	if (wait) getchar();
	if (dm) getMenu();
}

/*
	Graphics message with logo
*/
void tgraphicsMessage(char* logo, char* text, unsigned wait, int dm)
{
	SetConsoleTextAttribute(hConsole, (WORD)((White << 4) | Blue));
	printf("\n=================[%s]=================\n", logo);
	printf("\t%s", text);
	printf("\n======================================================");
	if (wait) getchar();
	if (dm) getMenu();
}

/*
Error Message Graphics message
*/
void errorMessage(char* text)
{
	SetConsoleTextAttribute(hConsole, (WORD)((White << 4) | Red));
	printf("\n======================[Ошибка!]=======================\n");
	printf("%s", text);
	printf("\n======================================================");
	getchar();
}

/*
	Информационное сообщение
*/
void infoMessage(char* text, unsigned wait, int dm)
{
	SetConsoleTextAttribute(hConsole, (WORD)((White << 4) | Blue));
	printf("\n=====================[!!Информация!!]=================\n\n");
	printf("\t%s", text);
	printf("\n======================================================");
	if (wait) getchar();
	if (dm) getMenu();

}

/*
	Логгирование
*/
void logMessage(char* text, char* dopinf)
{
	SetConsoleTextAttribute(hConsole, (WORD)((White << 4) | Green));
	printf("#[%d]> LOG >> %s %s\n", ++logCounter, text, dopinf);
}

/*
	Установка цвета окна
*/
void setWindowColor(int color)
{
	switch (color) {
	case 1:
		system("color 1F");
		break;
	case 2:
		system("color F0");
		break;
	case 3:
		system("color 0F");
		break;
	}
}

/*
	Очистка окна
*/
void cle()
{
	system("cls");
}


/*
	Циклическая отрисовка пустых символов
*/
void drawEmpty(int length)
{
	for (int i = 0; i < length; i++)
	{
		printf("\n");
	}
}

/*
	Отрисовка менюшки
*/
void drawMenu(int index)
{
	char* MP[10] = { "Об авторе", "Email автора", "Задание", "Помощь", "Выход" }; //Пункты менюшки

	//Проверка на корректность ввода
	if (index > MENU_NUMS-1 || index < 0)
		index == 0;

	//Чистим экран
	cle();

	drawEmpty(3);
	
	for (int i = 0; i < MENU_NUMS; i++)
	{
		if (i == index) {
			SetConsoleTextAttribute(hConsole, (WORD)((Blue << 4) | Yellow));
			printf("\t\t\t       ->%s<-", MP[i]);
		}
		else
			printf("\t\t\t\t %s", MP[i]);

		if (i % 2 != 0)
			drawEmpty(2);

		SetConsoleTextAttribute(hConsole, (WORD)((Blue << 4) | White));
	}
	drawEmpty(3);
	printf("F9 - помощь | F8 - закрыть программу");
}

/*
	Обработчик меню	
*/
int menuHander()
{
	char c;
	unsigned globalindex = 0; //Элемент меню, в котором мы сейчас находимся
	int ml = MENU_NUMS-1;
	
	
	setWindowColor(1);
	//Отрисовываем
	drawMenu(globalindex);

	do
	{
		c = _getch();

		switch (c)
		{
		case (0x48):
			if (globalindex != 0 && globalindex != 1)
				globalindex -= 2;
			else if (globalindex == 1)
				globalindex--;
			else if (globalindex == 0)
				globalindex++;

			drawMenu(globalindex);
			break;

		case (0x4b):
			if (globalindex != 0)
				globalindex--;
			else if (globalindex == 0)
				globalindex = 4;

			drawMenu(globalindex);
			break;

		case (0x50):
			if (globalindex != 4 && globalindex != 3)
				globalindex += 2;
			else if (globalindex == 4)
				globalindex = 0;
			else if (globalindex == 3)
				globalindex++;
			drawMenu(globalindex);
			break;

		case (0x4d):
			if (globalindex != 4)
				globalindex++;
			else
				globalindex = 0;
			drawMenu(globalindex);
			break;

		case 0xd:
			cle();
			return globalindex;
		}
	} while (1);

	return (-1);
}
#define _CRT_SECURE_NO_WARNINGS

#define FLAGS_NUM 9
#define ERR 50

#include "GraphicsApi.h";
#include "RC4.h";

int(*OpenCommand(int))();
unsigned usedFlags = 0;


void exitMod()
{
	cle();
	setWindowColor(2);
	logMessage("Программа готова к завершению. Нажмите Enter для выхода.", "");
	getchar();
	cle();
	setWindowColor(3);
	exit(-1);
}
/*
	Флаги, используемые в программе
*/
char *preparedFlags[] = {
"/s", "/a",
"/m", "/h",
"/z", "/c",
"/fin", "/fout",
"/fini"
}, **selFlag = preparedFlags;

/*
	Даём функции индекс флага - получаем число для побитовой операции
*/
int twoS[FLAGS_NUM] = { 0x01,0x02,0x04,0x08,0x10, 0x20, 0x40, 0x80,0x100};
int menuClicker[MENU_NUMS] = { 0,1,3,4,5 };

/*
	Обработка ошибок
*/
void Error(unsigned n)
{
	switch (n)
	{
	case 0:
		errorMessage("Вызов неизвестной функции");
		exit(0);
	case 1:
		errorMessage("Несуществующий файл!");
		exit(-1);
	case 2:
		errorMessage("Некорректный флаг!");
		exit(0);
	case 3:
		errorMessage("Несуществующий флаг!");
		exit(0);
	default:
		errorMessage("Неизвестная ошибка!");
		exit(0);
	}
}
	/*
			  [][NS]
			xxxx x
////		/s -  инфа о студенте
////		/@ почта студента (при наличии s)
////		/m - меню в виде таблички
////		/h - хелп
////		/z - задача. что решает программа
////		/{b - открытие мн-го коммента }e - закрытие
////		/#' однострочный коммент
////		/o => существует ещё /fo="filename"
////		/~s отмена информации о студенте
////
////		Если флажок неверный, то тогда вызываем функцию Error();
////		F1,F9, стрелочки, как понять, что мы там вводим
////
*/

/*
	Основные функции
*/
int getFIO(int dm)
{
	infoMessage("Дегтярёв Максим Эдуардович М80-112Б-17\n",1, dm);
	return 0;
}

int getEmail(int dm)
{
	infoMessage("max.degtyareff1234567890@gmail.com\n",1, dm);
	return 0;
}

int getHelp(int dm)
{
	infoMessage("Помощь пользователю\n",1, dm);
	return 0;
}

int getTask(int dm)
{
	infoMessage("Инфорация о задании\n",1, dm);
	return 0;
}

int getMenu()
{
	int ready = menuHander();
	setWindowColor(2);
	OpenCommand(menuClicker[ready])(1);
	return 0;
}

/*
	Взаимодействие с алгоритмом RC4
*/
int RC4_dialog(int dm)
{
	dm = 0;

	char fileName[100] = { 0 };
	char foutName[100] = { 0 };
	graphicsMessage("Укажите файл с исходными данными для шифрования", 0, dm);
	scanf("%s", fileName);
	graphicsMessage("Укажите файл для записи зашифрованных данных", 0, dm);
	scanf("%s", fileName);
	graphicsMessage("Укажите ключ шифрования", 0, dm);

	//Прочитали имя файла - идём дальше
	FILE* input;
	FILE* output;

	if (!(input = fopen(fileName, "r")))
		Error(1);
	if (!(output = fopen(foutName, "w")))
		Error(1);

	//Читаем данные в буффер. Передаём алгоритму шифрования. Записываем 
	
}
/*
	Функция, которая при получении id функции возвращает по нему саму функцию
*/
int(*OpenCommand(int n))(int)
{
	switch (n)
	{
	case 0:
		return getFIO;
	case 1:
		return getEmail;
	case 2:
		return getMenu;
	case 3:
		return getTask;
	case 4:
		return getHelp;
	case 5:
		exitMod();
	default:
		Error(0);
	}
}

/*
	Чтение флагов
*/
void readFlags(unsigned argc, char** argv)
{
	char **ptr = preparedFlags;
	int indexOfFlag = 0;
	for (int i = 1; i < argc; i++)
	{
		indexOfFlag = 0;
		//Checking flags for correct
		if (argv[i][0] != '{' && argv[i][0] != '}' && argv[i][0] != '#' && argv[i][0] != '/')
			Error(2);
		else
		{

				//Ищем подстроку
				for (ptr = selFlag; ptr - selFlag < FLAGS_NUM; ptr++)
					if (strstr(argv[i], *ptr) == argv[i])
						break;
					else
						indexOfFlag++;
				//Если подстроку не нашли
				if ((ptr - selFlag) == FLAGS_NUM)
					Error(3);

				usedFlags |= twoS[indexOfFlag];
				logMessage("Успешно прочитан флаг", *ptr);
		}
	}
}

void useFlags()
{
	unsigned copiedFlags = usedFlags;
	for (int i = 0; i < FLAGS_NUM; i++)
	{
		if (1 & (copiedFlags>>0))
		{
			OpenCommand(i)(0);
		}

		copiedFlags >>= 1;
	}

	cle();
}

char* toN(int value, char* forresult)
{
	int BASE = 2;
	char* f = forresult + ERR - 1 ;
	while (value)
	{
		*--f = (value % BASE <= 9) ? ((value % BASE) + '0') : ((value % BASE) + 'A' - 10);
		value /= BASE;
	}
	return f;
}

int main(unsigned argc, char* argv[])
{
	cle();
	setlocale(LC_ALL, "Rus");
	logMessage("Инициализируем графику", "");

	//Инициализируем графику и устанавливаем цвет окна
	initialGraphics();
	setWindowColor(2);
	logMessage("Графика инициализирована", "");

	logMessage("Читаем флаги", "");
	readFlags(argc, argv);

	logMessage("Выполняем флаги", "");
	useFlags();
	
	exitMod();
	return 0;
}
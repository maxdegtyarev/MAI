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
	logMessage("��������� ������ � ����������. ������� Enter ��� ������.", "");
	getchar();
	cle();
	setWindowColor(3);
	exit(-1);
}
/*
	�����, ������������ � ���������
*/
char *preparedFlags[] = {
"/s", "/a",
"/m", "/h",
"/z", "/c",
"/fin", "/fout",
"/fini"
}, **selFlag = preparedFlags;

/*
	��� ������� ������ ����� - �������� ����� ��� ��������� ��������
*/
int twoS[FLAGS_NUM] = { 0x01,0x02,0x04,0x08,0x10, 0x20, 0x40, 0x80,0x100};
int menuClicker[MENU_NUMS] = { 0,1,3,4,5 };

/*
	��������� ������
*/
void Error(unsigned n)
{
	switch (n)
	{
	case 0:
		errorMessage("����� ����������� �������");
		exit(0);
	case 1:
		errorMessage("�������������� ����!");
		exit(-1);
	case 2:
		errorMessage("������������ ����!");
		exit(0);
	case 3:
		errorMessage("�������������� ����!");
		exit(0);
	default:
		errorMessage("����������� ������!");
		exit(0);
	}
}
	/*
			  [][NS]
			xxxx x
////		/s -  ���� � ��������
////		/@ ����� �������� (��� ������� s)
////		/m - ���� � ���� ��������
////		/h - ����
////		/z - ������. ��� ������ ���������
////		/{b - �������� ��-�� �������� }e - ��������
////		/#' ������������ �������
////		/o => ���������� ��� /fo="filename"
////		/~s ������ ���������� � ��������
////
////		���� ������ ��������, �� ����� �������� ������� Error();
////		F1,F9, ���������, ��� ������, ��� �� ��� ������
////
*/

/*
	�������� �������
*/
int getFIO(int dm)
{
	infoMessage("������� ������ ���������� �80-112�-17\n",1, dm);
	return 0;
}

int getEmail(int dm)
{
	infoMessage("max.degtyareff1234567890@gmail.com\n",1, dm);
	return 0;
}

int getHelp(int dm)
{
	infoMessage("������ ������������\n",1, dm);
	return 0;
}

int getTask(int dm)
{
	infoMessage("��������� � �������\n",1, dm);
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
	�������������� � ���������� RC4
*/
int RC4_dialog(int dm)
{
	dm = 0;

	char fileName[100] = { 0 };
	char foutName[100] = { 0 };
	graphicsMessage("������� ���� � ��������� ������� ��� ����������", 0, dm);
	scanf("%s", fileName);
	graphicsMessage("������� ���� ��� ������ ������������� ������", 0, dm);
	scanf("%s", fileName);
	graphicsMessage("������� ���� ����������", 0, dm);

	//��������� ��� ����� - ��� ������
	FILE* input;
	FILE* output;

	if (!(input = fopen(fileName, "r")))
		Error(1);
	if (!(output = fopen(foutName, "w")))
		Error(1);

	//������ ������ � ������. ������� ��������� ����������. ���������� 
	
}
/*
	�������, ������� ��� ��������� id ������� ���������� �� ���� ���� �������
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
	������ ������
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

				//���� ���������
				for (ptr = selFlag; ptr - selFlag < FLAGS_NUM; ptr++)
					if (strstr(argv[i], *ptr) == argv[i])
						break;
					else
						indexOfFlag++;
				//���� ��������� �� �����
				if ((ptr - selFlag) == FLAGS_NUM)
					Error(3);

				usedFlags |= twoS[indexOfFlag];
				logMessage("������� �������� ����", *ptr);
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
	logMessage("�������������� �������", "");

	//�������������� ������� � ������������� ���� ����
	initialGraphics();
	setWindowColor(2);
	logMessage("������� ����������������", "");

	logMessage("������ �����", "");
	readFlags(argc, argv);

	logMessage("��������� �����", "");
	useFlags();
	
	exitMod();
	return 0;
}
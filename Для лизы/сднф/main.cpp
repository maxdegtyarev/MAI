#define _CRT_SECURE_NO_WARNINGS 

#include <cstdlib> 
#include <iostream> 
#include <fstream> 
#include <string> 
#include <queue> 
#include <Windows.h> 

#define MAX 500 

using namespace std;

int graph[MAX][MAX];
int N = 0;
string rezt = "";
string frr = "";

void GetData(char *argv[])
{
	ifstream in(argv[1]);
	in >> N;
	int i, j = 0;

	for (i = 0; i < N; i++)
	{
		for (j = 0; j < N; j++)
		{
			in >> graph[i][j];
		}
	}
	in.close();
}

void SendData(char *argv[], string Text)
{
	int i, j = 0;
	ofstream out;
	out.open(argv[1]);
	out.clear();
	char buffer[120];
	_itoa(N, buffer, 10);
	out << buffer << "\n";

	for (i = 0; i < N; i++) {
		for (j = 0; j < N; j++) {
			out << graph[i][j];
			if (j != N) out << " ";
		}
		if (i != N) out << "\n";
	}
	out << "\nText:\n";
	out << Text;
	out.close();
}

void toFile(char* argv[])
{
	string outp = argv[0];
	string kek = "";
	string lol = "";
	outp = outp;
	//int fls=0; 
	char c;
	char s[MAX] = { 0 }, *point = s;
	int i, j, alpha, fl = 0;
	for (i = 0; i < N; i++)
	{

		//*point++ = '*'; 
		fl = 0;
		for (j = 0; j < N; j++)
		{
			if (graph[i][j] == 1)
			{

				*point++ = '(';
				*point++ = i + 65;
				*point++ = '+';
				*point++ = j + 65;
				*point++ = ')';
				*point++ = '*';
			}


		}
	}
	*(--point) = 0;

	ofstream out;
	out.open("kurs.exe_temp.txt");
	out << s;
	out.close();
	//Шаг #2 - открываем преобразователь в СДНФ 
	kek = s;
	frr+= "Пивоварова Елизавета (8О-111Б-17) \n";
	for (int i = 0; i < kek.length(); i++)
	{
		if (isalpha(kek[i]))
		{
			kek[i] = kek[i] - 'A' + '0';
		}
	}
	kek += '\n';
	system("getsdnf.exe");

	//Шаг 3 - открываем программу Лизы 
	system("third.exe");


	frr += "\nФормула из матрицы смежности:\n ";
	frr += kek;
	//Шаг 4 - читаем файл 
	ifstream in("out_dnf.txt");
	frr += "Максимально внутренне устойчивые множества графа : \n";
	while (!in.eof())
	{
		in >> rezt;
		
		frr += rezt;
	}

}

int main(int argc, char* argv[])
{
	//Вводим данные в матрицу 
	GetData(argv);
	toFile(argv);
	SendData(argv, frr);


}
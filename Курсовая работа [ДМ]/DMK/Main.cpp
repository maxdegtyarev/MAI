#define _CRT_SECURE_NO_WARNINGS

#include <cstdlib>
#include <iostream>
#include <fstream>
#include <string>
#include <queue>

#define MAX 500
using namespace std;

int graph[MAX][MAX];

int bfstree[MAX][MAX]; //BFS ������

int vertex[MAX] = { 0 };
int lenght[MAX] = { 0 };
bool inq[MAX];
int p[MAX] = { 0 };
int marsh[MAX];
int R = 0;
int NUM = 0;
int N = 0;
int global[MAX] = { 0 };

string timepute = "";

/*
�������� ����� -> ������ �������
*/
void GetData(char *argv[])
{
	string BUFFER;
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
	
	while ((BUFFER != "Text:"))
	{
		in >> BUFFER;
	}

	//����� �� �����
	if (in.eof()) 
		NUM = 0;
	else
		in >> NUM;

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
			out << bfstree[i][j];
			if (j != N) out << " ";
		}
		if (i != N) out << "\n";
	}
	out << "\nText:\n";
	out << Text;
	out.close();
}

void print_way(int u) {
	if (p[u] != u) {
		print_way(p[u]);
	}
	timepute = timepute + "->" + to_string(u);
}

void init_pute(int u) {
	if (p[u] != u) {
		init_pute(p[u]);
	}
	marsh[R] = u; //�������� ������
	R++;
}

void zapolnen()
{
	if (R > 1) {
		for (int i = 0; i < R - 1; i++)
		{
			bfstree[marsh[i]][marsh[i + 1]] = graph[marsh[i]][marsh[i + 1]];
		}
	}
	else if (R == 1)
	{
		bfstree[marsh[0]][marsh[0]] = graph[marsh[0]][marsh[0]];
	}
}

string BFS(int from)
{
	string res = "";
	queue<int> Queue;
	res+= "{ ";

	int nodes[MAX]; // ������� �����
	for (int i = 0; i < N; i++)
		nodes[i] = 0; // ������� ��� ������� ����� 0
	Queue.push(from); // �������� � ������� ������ �������
	while (!Queue.empty())
	{ // ���� ������� �� �����
		int node = Queue.front(); // ��������� �������
		Queue.pop();
		nodes[node] = 2; // �������� �� ��� ����������
		global[node] = 1;
		res+= to_string(node) + ",";
		for (int j = 0; j < N; j++)
		{ // ��������� ��� ��� ��� ������� �������
			if (graph[node][j] > 0 && nodes[j] == 0)
			{ // ���� ������� ������� � �� ����������
				Queue.push(j); // ��������� �� � �������
				nodes[j] = 1; // �������� ������� ��� ������������ 
			}
		}
	}
	res.erase(res.length() - 1, 1);
	res += " }\n";
	return res;
}

int main(int argc, char *argv[])
{
	//������ ����� ������ - BFS ������ � ����������
	string rez = "";
	rez += "2018, ������ ��������. 80-112�-17\n";
	GetData(argv);

	for (int i = 0; i < N; i++)
	{
		lenght[i] = 1e+9;
	}

	int u = NUM;
	lenght[u] = 0;
	p[u] = u;
	queue<int> q;
	q.push(u);
	inq[u] = true;
	while (!q.empty())
	{
		int z = q.front();
		q.pop();
		inq[z] = false;
		for (int i = 0; i < N; i++)
		{
			if (graph[z][i] > 0) {
				int v = i;
				int len = graph[z][i];
				if (lenght[v] > lenght[z] + len)
				{
					p[v] = z;
					lenght[v] = lenght[z] + len; //����� ���������� �����
					if (!inq[v])
					{
						q.push(v);
						inq[v] = true;
					}
				}
			}
		}
	}

	rez += "����\n";
	for (int i = 0; i < N; i++)
	{
		print_way(i);
		rez += "�� �������: " + to_string(i) + " : "+ timepute + " �����: " + ((lenght[i] == 1e+9) ? ("��� ���� �� ������� " + to_string(NUM)) : (to_string(lenght[i]))) + " \n";
		timepute = "";
	}
	//����� ���������� - ������ ������. BFS ������ - ������ ����������� ���������� ����� ���������

	//������ BFS ������
	for (int i = 0; i < N; i++)
	{
		init_pute(i);
		zapolnen();
		R = 0;
	}
	//����������� ��, ��� �������� ��� ���������
	//������ ����� ������ - ���������� ���������
	
	rez += "���������� ���������\n";

	for (int i = 0; i < N; i++)
	{
		if (global[i] == 0)
		{
			rez += BFS(i);
		}
	}

	SendData(argv, rez);
	
	return 0;
}

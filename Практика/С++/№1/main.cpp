/*
	2018, ������ ��������
	8�-112�-17

	������:
		����������� ���������� ��������� ���������� � ��������� �������, ����������� � �������� ������ �� ���������� ��� ������� ����������������� ���������. ���������� ��� ������� ���������� �������������� ��������� � �������� ���������� (���� ���� ������� ����������� ��������� ���, ������� �� ����)
		������������� ��������� std::vector ��� std::list
		��������� ������ ���� ��������� ��� ������ � �����������

	�������������� �������:
		����������� ��� ����� std::list, ��� � ����� std::vector � �������� �� ������� �������� ���������� ��� ������ ��������� (� ����� ���������) [+1]
		P.S. ����� �������� ������������� ����� ��������� ��������� ���������, �� ������� ���������� ��������� �������
		����������� ��������� ��� ���� std::string (������ ������ ��� �� ������������ �������� �� 1 �� ���������� ���������� ���������) [+1]

	����������� ����������:
		���� ���������
		��� ����������� ���������� �� �����, �� �� ������� �������� ��� ����������������� ����������
*/

#include <iostream>
#include <list>
#include <string>
#include <time.h>
#include <cstdlib>
#include <algorithm>

using namespace std;

	//�������� ��� findUnic
template<class T>

	//������� ������ ��������
int findUnic(list<T>& tempList)
{
	int repeatsVals = 0; //���������� ��������
	list<T> copyList(tempList); //����� �����
	
	copyList.sort();
	copyList.unique();

	while (!copyList.empty()) //���� ����� ������ ������ �� ������, ������� ���������� �������� �� �����
	{
		cout << copyList.front() << " ";
		copyList.pop_front();
	}

	while (!tempList.empty()) //���� �������� ������ �� ����
	{
		T tempElement = tempList.front(); //��������� ������� ��� ���������
		tempList.pop_front();

		for (auto i : tempList) //������������� �� �����, ����������. 
		{						
			if (i == tempElement) //��� ���������� ������� ��� ������ ������ ��������, ������� ��������������
			{
				tempList.remove(i);
				repeatsVals++;
				break;
			}
		}
	}

	return repeatsVals;
}

/*
	�������� ���� - ���������� ���������
*/
int main()
{
	setlocale(0, "Rus"); //��������� ������� ����

	int numValues = 0; //������� ���������� ��������� � ���������
	int result = 0;
	string typeValues = ""; //������� ���

	cout << "������� ���: ";
	cin >> typeValues;
	cout << "������� �����: ";
	cin >> numValues;

	if (typeValues == "int") //���� ��� �������� - �������������
	{
		list<int> colValues;

		for (int i = 0; i < numValues; i++)
		{
			colValues.push_front(1 + (rand() % (40))); //������ �� [1;40)
			cout << colValues.front() << " "; //������� �������
		}

		cout << endl;
		result = findUnic(colValues);
	}
	else if (typeValues == "float") //���� ��� �������� - ������������
	{
		list<float> colValues;

		for (int i = 0; i < numValues; i++)
		{
			colValues.push_front((float)(10 + (rand() % (90)) / (float)(1 + rand() % 27))); //������ ����� [10;90) / [1;27)
			cout << colValues.front() << " "; //������� �������
		}
		cout << endl;
		result = findUnic(colValues);
	}
	else if (typeValues == "char") //���� ��� �������� - ����������
	{
		list<char> colValues;

		for (int i = 0; i < numValues; i++)
		{
			colValues.push_front(rand() % 25 + 65); //������ ���������� ���
			cout << colValues.front() << " "; //������� �������
		}
		cout << endl;
		result = findUnic(colValues);
	}
	else //���� ��� ���������
	{
		cout << "�� ������� ����";
		return 0;
	}

	cout << "\n" << result << " => ";

	if (result == 0) //������� ������� ����
		cout << ":)";
	else
		cout << ":(";

	getchar();
	getchar();
	return 0;
}
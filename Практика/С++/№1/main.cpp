/*
	2018, Максим Дегтярев
	8О-112Б-17

	Задача:
		Определение уникальной коллекции происходит в шаблонной функции, принимающей в качестве одного из параметров уже готовую рандомизированную коллекцию. Возвращает эта функция количество индивидуальных элементов в исходном контейнере (если один элемент повторяется несколько раз, считать за один)
		Использование коллекции std::vector или std::list
		Запрещено писать свои алгоритмы для работы с коллекциями

	Дополнительные условия:
		Реализовать как через std::list, так и через std::vector и сравнить по времени скорость выполнения для каждой коллекции (в одной программе) [+1]
		P.S. Время начинает отсчитывается после созданием рандомной коллекции, до момента выполнения шаблонной функции
		Реализовать программу для типа std::string (размер строки так же генерируется рандомно от 1 до выбранного количества элементов) [+1]

	Особенности выполнения:
		Ввод корректен
		Вид интерактива оставляете за собой, но вы обязаны соблюсти все вышеперечисленные требования
*/

#include <iostream>
#include <list>
#include <string>
#include <time.h>
#include <cstdlib>
#include <algorithm>

using namespace std;

	//Темплейт для findUnic
template<class T>

	//Функция поиска повторов
int findUnic(list<T>& tempList)
{
	int repeatsVals = 0; //Количество повторов
	list<T> copyList(tempList); //Копия листа
	
	copyList.sort();
	copyList.unique();

	while (!copyList.empty()) //Пока копия нашего списка не пустая, выводим поочередно элементы на экран
	{
		cout << copyList.front() << " ";
		copyList.pop_front();
	}

	while (!tempList.empty()) //Пока основной список не пуст
	{
		T tempElement = tempList.front(); //Временный элемент для сравнения
		tempList.pop_front();

		for (auto i : tempList) //Прогуливаемся по листу, сравниваем. 
		{						
			if (i == tempElement) //При совпадении удаляем все данные равные элементы, повторы инкрементируем
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
	Основной блок - исполнение программы
*/
int main()
{
	setlocale(0, "Rus"); //Установим русский язык

	int numValues = 0; //Будущее количество элементов в коллекции
	int result = 0;
	string typeValues = ""; //Будущий тип

	cout << "Ожидаем тип: ";
	cin >> typeValues;
	cout << "Ожидаем число: ";
	cin >> numValues;

	if (typeValues == "int") //Если тип значений - целочисленный
	{
		list<int> colValues;

		for (int i = 0; i < numValues; i++)
		{
			colValues.push_front(1 + (rand() % (40))); //Рандом от [1;40)
			cout << colValues.front() << " "; //Выведем элемент
		}

		cout << endl;
		result = findUnic(colValues);
	}
	else if (typeValues == "float") //Если тип значений - вещественный
	{
		list<float> colValues;

		for (int i = 0; i < numValues; i++)
		{
			colValues.push_front((float)(10 + (rand() % (90)) / (float)(1 + rand() % 27))); //Рандом флота [10;90) / [1;27)
			cout << colValues.front() << " "; //Выведем элемент
		}
		cout << endl;
		result = findUnic(colValues);
	}
	else if (typeValues == "char") //Если тип значений - символьный
	{
		list<char> colValues;

		for (int i = 0; i < numValues; i++)
		{
			colValues.push_front(rand() % 25 + 65); //Символ генерируем так
			cout << colValues.front() << " "; //Выведем элемент
		}
		cout << endl;
		result = findUnic(colValues);
	}
	else //Если тип неопознан
	{
		cout << "Не найдено типа";
		return 0;
	}

	cout << "\n" << result << " => ";

	if (result == 0) //Выводим реакцию Саши
		cout << ":)";
	else
		cout << ":(";

	getchar();
	getchar();
	return 0;
}
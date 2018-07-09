import mysql.connector

from threading import Lock
class _DataBase:
    def __connect(self):
        self.__db = mysql.connector.connect(host="localhost", database="example", user="root", password="")
        if self.__db.is_connected():
            self.__cursor = self.__db.cursor()
    def __init__(self):
        self.__connect()
        self.__mutex = Lock()
    def callFunction(self, nameFunction: str, *args):
        self.__mutex.acquire()
        result = None
        try:
            if not (self.__db.is_connected()):
                self.__connect()

            self.__cursor.callproc(nameFunction, args)
            result =[]
            for item in self.__cursor.stored_results():
                for item2 in item.fetchall():
                    result.append(item2)
            self.__db.commit()
        finally:
            self.__mutex.release()
        return result

Database = _DataBase()

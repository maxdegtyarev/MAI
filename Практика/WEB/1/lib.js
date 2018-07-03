/*
 2018, Maxim Degtyarev
 */
//Книги
function book() {
    let mass = [];
    this.addBook = function (bookname, author, izdat, year) {
        if ((this.findBook(bookname, author, izdat, year) === -1)) {
            mass.push({id: (mass.length) + 1, name: bookname, auth: author, izd: izdat, yer: year});
            return true;
        }
        else
            return false;
    };

    //Get list of book
    this.getList = function () {
        for (i = 0; i < mass.length; i++)
            console.log(`BookName: ${mass[i].name} | Year: ${mass[i].auth} | Izdat: ${mass[i].izd} | Year: ${mass[i].yer}`);
    };

    this.getListM = function()
    {
        return mass;
    }


    //Точный поиск кники по названию, году и тд
    this.findBook = function (bookname, author, izdat, year) {
        for (let i = 0; i < mass.length; i++) {
            if ((mass[i].name === bookname) && (mass[i].auth === author) && (mass[i].izd === izdat) && (mass[i].yer === year)) {
                return i;
            }
        }
        return -1;
    };


    //Find books by key
    this.findBooks = function (KEYCODE, KEY) {
        let searchBooks = mass.filter(function (value) {
            switch (KEYCODE) {
                case 1,'1':
                    return (value.name.indexOf(KEY) !== -1);
                case 2,'2':
                    return (value.auth.indexOf(KEY) !== -1);
                case 3,'3':
                    return (value.izd.indexOf(KEY) !== -1);
                case 4,'4':
                    return (value.yer.indexOf(KEY) !== -1);
            }
        });

        return searchBooks;
    };

    //Deleting book. True - deleted, false - not deleted;
    this.deleteBook = function (bookname, author, izdat, year) {
        let tempid = this.findBook(bookname, author, izdat, year);
        if (tempid !== -1) {
            mass.splice(tempid,1);
            return true;
        }
        else
            return false;
    };

    this.getSortedBooks = function(by,how)
    {
        by = Number(by);
        how = Number(how);
        switch (by)
        {
            case 1: {
                mass.sort(function(val1, val2){
                    if (how == 1)
                    {
                        if (val1.name >= val2.name)
                            return 1;
                        else
                            return -1;
                    }
                    else
                    {
                        if (val1.name <= val2.name)
                            return 1;
                        else
                            return -1;
                    }
                })
            }
            case 2:
            {
                mass.sort(function(val1, val2){
                    if (how == 1)
                    {
                        if (val1.auth >= val2.auth)
                            return 1;
                        else
                            return -1;
                    }
                    else
                    {
                        if (val1.auth <= val2.auth)
                            return 1;
                        else
                            return -1;
                    }
                })
            }
            case 3: {
                mass.sort(function (val1, val2) {
                    if (how == 1) {
                        if (val1.izd >= val2.izd)
                            return 1;
                        else
                            return -1;
                    }
                    else {
                        if (val1.izd <= val2.izd)
                            return 1;
                        else
                            return -1;
                    }
                })
            }
            case 4:
            {
                mass.sort(function(val1, val2){
                    if (how == 1)
                    {
                        if (val1.yer >= val2.yer)
                            return 1;
                        else
                            return -1;
                    }
                    else
                    {
                        if (val1.yer <= val2.yer)
                            return 1;
                        else
                            return -1;
                    }
                })
            }
        }

    }


}

let mass = new book();

function add(bookname, author, izdat, year)
{
    if (mass.addBook(bookname, author, izdat, year)) {
        console.log("Добавлено");
        alert("Добавлено!");
    }
    else {
        console.log("Ошибка добавления");
        alert("Ошибка");
    }

}

function deletefrombooks()
{
    let bkname = prompt("Укажите название книги:");
    let author = prompt("Укажите автора книги:");
    let izd = prompt("Укажите издательство книги:");
    let year = prompt("Укажите год книги:");
    if (mass.deleteBook(bkname,author,izd,year)) {
        alert("Успешно удалено!");
        console.log("Успешно удалено!");
    }
    else {
        alert("Не удалилось...");
        console.log("Неуспешно удалено!");
    }
}

function findbk() {
    let mode = prompt("Укажите номер поля, по которому будет поиск: \nимя книги-1\nавтор-2\nиздательство-3\nгод-4");
    let nm = prompt("Укажите данные, по которым будет происходить поиск");
    let tmp = mass.findBooks(mode,nm);
    let strmsg = "Название | Автор | Издательство | Год\n";
    for (let i = 0; i < tmp.length; i++)
    {
        strmsg += tmp[i].name + " | " + tmp[i].auth + " | " + tmp[i].izd + " | " + tmp[i].yer + "\n";
    }
    alert(strmsg);
    console.log(strmsg);
}

function sorter()
{
    let mode = prompt("Укажите номер поля, по которому будет сортировка: \nимя книги-1\nавтор-2\nиздательство-3\nгод-4");
    let nm = prompt("По какому принципу?\n1-по возрастанию,\n2-по убыванию");
    mass.getSortedBooks(mode,nm);
    let tmp = mass.getListM();
    let strm = "Название | Автор | Издательство | Год\n";
    for (let i = 0; i < tmp.length; i++)
    {
        strm += tmp[i].name + " | " + tmp[i].auth + " | " + tmp[i].izd + " | " + tmp[i].yer + "\n";
    }
    mass.getList();
    alert(strm);
}

function getall()
{
    let tmp = mass.getListM();
    let strm = "Название | Автор | Издательство | Год\n";
    for (let i = 0; i < tmp.length; i++)
    {
        strm += tmp[i].name + " | " + tmp[i].auth + " | " + tmp[i].izd + " | " + tmp[i].yer + "\n";
    }
    mass.getList();
    alert(strm);
}




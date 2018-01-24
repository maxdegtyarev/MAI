<?php

class UserInterface
{
    //Globals
    var $name;
    var $surname;
    var $otchestvo;
    var $birth;
    var $class;
    var $studyplace;
    var $phone;
    var $email;
    var $hashedPassword;

    //Constructor
    function __construct($Information)
    {
        //Checking eqv of passwords
        if ($Information['pass1'] != $Information['pass2']) {
            echo 'Password error!';
            exit();
        }
        //md5
        $this->hashedPassword = md5(htmlspecialchars($Information['pass1']));
        //Теперь идём дальше - пишем данные в наши глобальные переменные
        $this->name           = htmlspecialchars($Information['name']);
        $this->surname        = htmlspecialchars($Information['surname']);
        $this->otchestvo      = htmlspecialchars($Information['otchestvo']);
        $this->birth          = strtotime(htmlspecialchars($Information['birth']));
        $this->class          = htmlspecialchars($Information['class']);
        $this->studyplace     = htmlspecialchars($Information['study_place']);
        $this->email          = htmlspecialchars($Information['email']);
        $this->phone          = htmlspecialchars($Information['tel']);
        echo "All rigth<br>";
    }

    //Год поступления
    function enrollYear()
    {
        //Take today
        $today = getdate();
        return ($today[year] - $this->class); //Today year - class
    }

    //Сколько лет пользователю
    function nowAge()
    {
        if ($this->birth == "")
            return 0;
        $birthDate = strtotime($this->birth);
        $userAge   = date('Y') - date('Y', $birthDate);
        if (date('md', $birthDate) > date('md')) {
            $userAge;
        }

        return $userAge;
    }

    //Строка записи в бд
    function writeToDb()
    {
        return ("INSERT INTO `users`(`class`,`username`,`surname`,`otchestvo`,`pw`,`birthday`,`studyplace`,`email`,`phone`) VALUES('$this->class','$this->name', '$this->surname', '$this->otchestvo', '$this->hashedPassword' ,'$this->birth', '$this->studyplace', '$this->email', '$this->phone')");
    }

    //Год окончания школы
    function endYear()
    {
        return (enrollYear() + 11);
    }

    function

}

?>

<?php

class UserInterface
{
  //Globals
  var $name;
  var $surname;
  var $otchestvo;
  var $birth;
  var $class;
  var $studyPlace;
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
    $this->hashedPassword = md5($Information['pass1']);
    //Теперь идём дальше - пишем данные в наши глобальные переменные
    $this->name = $Information['name'];
    $this->surName = $Information['surname'];
    $this->otchestvo = $Information['otchestvo'];
    $this->birth = $Information['birth'];
    $this->class  = $Information['class'];
    $this->studyPlace = $Information['study_place'];
    $this->email  = $Information['email'];
    $this->phone = $Information['tel'];
    echo "All rigth<br>";
  }

  function enrollYear()
  {
    //Take today
    $today = getdate();
    return ($today[year] - $this->class); //Today year - class
  }

  function nowAge()
  {
    if ($this->birth == "")
      return 0;
    $birthDate = strtotime($this->birth);
    $userAge = date('Y') - date('Y', $birthDate);
      if (date('md', $birthDate) > date('md')) {
        $userAge;
      }

  return $userAge;
  }

}

?>

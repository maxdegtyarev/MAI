<?php
header('Access-Control-Allow-Origin:*');
//Сервер может что-то давать
include 'interface.php';

$UserObject = new UserInterface($_POST);

echo $UserObject->nowAge();
echo '<br>';
echo $UserObject->enrollYear();

unset($UserObject);
?>

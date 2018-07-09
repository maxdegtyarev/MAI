-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июл 09 2018 г., 19:27
-- Версия сервера: 10.1.33-MariaDB
-- Версия PHP: 7.2.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `example`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ex_addeq` (IN `equat` VARCHAR(128), IN `result` VARCHAR(500))  NO SQL
INSERT INTO ex_equations VALUES (0,equat,result)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ex_addlog` (IN `eqid` INT, IN `msg` VARCHAR(500) CHARSET utf8, IN `tm` TIME)  NO SQL
INSERT INTO `ex_logs` VALUES (0,eqid,msg,tm)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ex_getidbyeq` (IN `equat` VARCHAR(128))  NO SQL
SELECT id FROM ex_equations WHERE equation=equat$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `ex_equations`
--

CREATE TABLE `ex_equations` (
  `id` int(11) NOT NULL,
  `equation` varchar(128) NOT NULL,
  `result` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `ex_logs`
--

CREATE TABLE `ex_logs` (
  `id` int(11) NOT NULL,
  `equation_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `ex_equations`
--
ALTER TABLE `ex_equations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `equation` (`equation`),
  ADD KEY `id` (`id`);

--
-- Индексы таблицы `ex_logs`
--
ALTER TABLE `ex_logs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `equation_id` (`equation_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `ex_equations`
--
ALTER TABLE `ex_equations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT для таблицы `ex_logs`
--
ALTER TABLE `ex_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `ex_logs`
--
ALTER TABLE `ex_logs`
  ADD CONSTRAINT `ex_logs_ibfk_1` FOREIGN KEY (`equation_id`) REFERENCES `ex_equations` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

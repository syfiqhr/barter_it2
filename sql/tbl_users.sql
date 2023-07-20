-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 08:07 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit2_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_otp` int(5) NOT NULL,
  `user_coin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_datereg`, `user_otp`, `user_coin`) VALUES
(1, 'pikapizan@gmail.com', 'syafiqah', '0176263264', '6b33d4ff1705f64039ff956e51dd21afcd5c64df', '2023-07-01 22:47:46.383558', 10635, 0),
(4, 'jihoon@gmail.com', 'sya', '0183782661', '3020626733e3cf0565da7d76a52f2664265ffda0', '2023-07-05 12:58:17.614626', 49370, -32),
(5, 'rose@gmail.com', 'rose', '0183782661', '24bc32d01d83afa79796b67a69aab78f91eaf502', '2023-07-06 12:59:40.989820', 80678, 0),
(6, 'jennie@gmail.com', 'jennie', '01122334455', 'a17a52fc21ef19510f2a6cb00143780457599dbf', '2023-07-06 13:01:47.147319', 25310, 0),
(7, '', '', '', 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '2023-07-19 18:21:42.913495', 75927, 0),
(8, 'syafiqah@gmail.com', 'syafiqah', '0176263264', '144df8698a82f671b2eb46cd3ffc73a8667a4660', '2023-07-20 18:07:29.381909', 48533, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

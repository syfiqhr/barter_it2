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
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `item_name` varchar(30) NOT NULL,
  `item_desc` varchar(50) NOT NULL,
  `item_price` int(10) NOT NULL,
  `item_condition` varchar(10) NOT NULL,
  `item_qty` varchar(5) NOT NULL,
  `item_type` varchar(10) NOT NULL,
  `item_lat` varchar(50) NOT NULL,
  `item_long` varchar(50) NOT NULL,
  `item_state` varchar(50) NOT NULL,
  `item_locality` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_price`, `item_condition`, `item_qty`, `item_type`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES
(30, 4, 'Fujifilm Camera', 'white colour, new', 350, '', '1', 'Camera', '6.4318283', '100.4299967', 'Kedah', 'Changlun'),
(32, 6, 'H&M Women Blouse', 'H&M Aesthetic brown shirt. Used. Condition 8/10', 40, 'Used', '1', 'Shirt', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(33, 6, 'Butterfly Sandal', 'Butterfly Sandal from Zara. New ( 10/10 )', 50, 'New', '3', 'Shoe', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(34, 6, 'MJhosel Handbag', 'Green coloured handbag. ', 100, 'New', '1', 'Handbag', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(35, 6, 'Tyeso Bottle', 'Pastel Green Coloured Bottle. ', 20, 'New', '5', 'New', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(36, 6, 'YSL LE Cushion', 'New Cushion Foundation', 150, 'New', '10', 'Makeup', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(37, 6, 'Women Watch', 'H&M watch. Used once', 25, 'Used', '1', 'Watch', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(38, 6, 'Mini Lamp', 'New mini lamp with many colours', 5, 'New', '20', 'Lamp', '6.4318283', '100.4299967', 'Changlun', 'Kedah'),
(40, 4, 'Blue Handbag', 'New', 200, '', '1', 'Handbag', '6.4502267', '100.4958833', 'Kedah', 'Changlun'),
(41, 4, 'Pink Headphone', 'Used', 50, '', '1', 'Headphone', '6.4502267', '100.4958833', 'Kedah', 'Changlun'),
(42, 4, 'Gradient Watch', 'Used Once', 20, '', '1', 'Watch', '6.4502267', '100.4958833', 'Kedah', 'Changlun'),
(43, 4, 'Pink Sportsho', 'Nike Sport Shoe', 200, '', '1', 'Shoes', '6.4502267', '100.4958833', 'Kedah', 'Changlun'),
(44, 8, 'Bottle', 'new', 12, '', '5', 'Bottle', '6.4502267', '100.4958833', 'Kedah', 'Changlun');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

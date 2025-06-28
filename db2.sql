-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 28, 2025 at 12:12 PM
-- Server version: 10.11.11-MariaDB-ubu2204
-- PHP Version: 8.1.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bespokible`
--

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `id` int(11) NOT NULL,
  `company` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `subscription` varchar(50) DEFAULT NULL,
  `gateway` varchar(50) DEFAULT NULL,
  `gateway_id` varchar(50) DEFAULT NULL,
  `trial_end` datetime DEFAULT NULL,
  `created` timestamp NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `clients`
--
-- --------------------------------------------------------

--
-- Table structure for table `designs`
--

CREATE TABLE `designs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `design_no` varchar(25) NOT NULL,
  `design_name` varchar(100) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `collection` varchar(10) DEFAULT NULL,
  `category` varchar(10) DEFAULT NULL,
  `subcat` varchar(10) DEFAULT NULL,
  `khaka` varchar(10) DEFAULT NULL,
  `worktype` text DEFAULT NULL,
  `intensity` enum('light','heavy') DEFAULT NULL,
  `collar` varchar(10) DEFAULT NULL,
  `sleeve` varchar(10) DEFAULT NULL,
  `fabrics` text DEFAULT NULL,
  `editor` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `designs`
--

-- --------------------------------------------------------

--
-- Table structure for table `karigars`
--

CREATE TABLE `karigars` (
  `ID` int(5) UNSIGNED NOT NULL,
  `emp_code` int(5) DEFAULT NULL,
  `shift_hours` time DEFAULT NULL,
  `firstname` varchar(20) NOT NULL,
  `lastname` varchar(20) DEFAULT NULL,
  `aka` varchar(50) DEFAULT NULL,
  `mobile1` varchar(10) NOT NULL,
  `mobile2` varchar(10) DEFAULT NULL,
  `aadhaar` varchar(14) DEFAULT NULL,
  `address` varchar(300) DEFAULT NULL,
  `emergency` varchar(100) DEFAULT NULL,
  `expertise` mediumtext DEFAULT NULL,
  `doj` date DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `rate` varchar(255) DEFAULT NULL,
  `clid` varchar(50) DEFAULT NULL,
  `role` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karigars`
--

-- --------------------------------------------------------

--
-- Table structure for table `karigar_attendance`
--

CREATE TABLE `karigar_attendance` (
  `id` bigint(20) NOT NULL,
  `emp_code` int(11) NOT NULL,
  `karigar_id` int(5) UNSIGNED NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `punchin` datetime NOT NULL,
  `punchout` datetime NOT NULL,
  `duration` time DEFAULT NULL,
  `break` tinyint(1) NOT NULL DEFAULT 1,
  `break_time` int(3) DEFAULT NULL,
  `eow` tinyint(1) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL,
  `editor` int(11) DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `karigar_attendance`
--
DELIMITER $$
CREATE TRIGGER `calculate_duration` BEFORE INSERT ON `karigar_attendance` FOR EACH ROW BEGIN
    SET NEW.duration = TIMEDIFF(NEW.punchout, NEW.punchin);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `calculate_duration_update` BEFORE UPDATE ON `karigar_attendance` FOR EACH ROW BEGIN
    SET NEW.duration = TIMEDIFF(NEW.punchout, NEW.punchin);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `karigar_timesheet_app`
--

CREATE TABLE `karigar_timesheet_app` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `task_code` char(6) NOT NULL,
  `karigar_id` int(10) UNSIGNED NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `timespent` time DEFAULT NULL,
  `rw_type` char(6) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `productive` tinyint(1) DEFAULT 1,
  `editor` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `karigar_timesheet_app`
--

--
-- Triggers `karigar_timesheet_app`
--
DELIMITER $$
CREATE TRIGGER `before_insert_karigar_timesheet` BEFORE INSERT ON `karigar_timesheet_app` FOR EACH ROW BEGIN
  IF NEW.start_date IS NOT NULL AND NEW.end_date IS NOT NULL THEN
    SET NEW.timespent = SEC_TO_TIME(TIMESTAMPDIFF(SECOND, NEW.start_date, NEW.end_date));
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_karigar_timesheet` BEFORE UPDATE ON `karigar_timesheet_app` FOR EACH ROW BEGIN
  IF NEW.start_date IS NOT NULL AND NEW.end_date IS NOT NULL THEN
    SET NEW.timespent = SEC_TO_TIME(TIMESTAMPDIFF(SECOND, NEW.start_date, NEW.end_date));
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `measurements`
--

CREATE TABLE `measurements` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` smallint(6) DEFAULT NULL,
  `parameter` varchar(25) NOT NULL,
  `cat_code` char(5) DEFAULT NULL,
  `subcat_code` char(10) NOT NULL,
  `base` decimal(5,2) DEFAULT NULL,
  `scale` decimal(5,2) DEFAULT NULL,
  `editor` smallint(6) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `options`
--

CREATE TABLE `options` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `option_name` varchar(60) DEFAULT NULL,
  `option_value` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `options`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `customer` varchar(100) DEFAULT NULL,
  `order_ref` varchar(20) DEFAULT NULL,
  `is_parent` tinyint(1) NOT NULL DEFAULT 0,
  `item_code` varchar(50) NOT NULL,
  `item_name` varchar(255) DEFAULT NULL,
  `collection` varchar(100) NOT NULL,
  `category` varchar(50) NOT NULL,
  `intensity` enum('light','heavy') DEFAULT NULL,
  `custom_id` int(10) UNSIGNED DEFAULT NULL,
  `wc_order_id` varchar(10) DEFAULT NULL,
  `wc_item_id` varchar(10) DEFAULT NULL,
  `status` enum('draft','pending','on-hold','in-progress','ready-for-trial','quality-check','completed','ready-for-pickup','ready-to-ship','shipped','delivered','alteration-requested','archived') DEFAULT 'pending',
  `order_type` enum('production','alteration','sample') DEFAULT 'production',
  `due_date` date DEFAULT NULL,
  `editor_id` smallint(6) DEFAULT NULL,
  `edited` datetime DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

-- --------------------------------------------------------

--
-- Table structure for table `orders_meta`
--

CREATE TABLE `orders_meta` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `meta_key` varchar(50) NOT NULL,
  `meta_value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders_meta`
--

-- --------------------------------------------------------

--
-- Table structure for table `order_tasks`
--

CREATE TABLE `order_tasks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `task_code` char(6) NOT NULL,
  `task_name` varchar(50) DEFAULT NULL,
  `status` enum('pending','in-progress','completed','on-hold') DEFAULT 'pending',
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_tasks`
--

--
-- Triggers `order_tasks`
--
DELIMITER $$
CREATE TRIGGER `update_order_status` AFTER UPDATE ON `order_tasks` FOR EACH ROW BEGIN
    IF NEW.status = 'completed' AND (NEW.task_code IN ('FIN', 'RW', 'ALT')) THEN
        UPDATE orders
        SET status = 'quality-check'
        WHERE id = NEW.order_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_task_timesheet`
--

CREATE TABLE `order_task_timesheet` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `task_code` char(6) NOT NULL,
  `karigar_id` int(10) UNSIGNED NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `timespent` time DEFAULT NULL,
  `rw_type` char(6) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL,
  `productive` tinyint(1) NOT NULL DEFAULT 1,
  `editor` int(11) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_task_timesheet`
--


--
-- Triggers `order_task_timesheet`
--
DELIMITER $$
CREATE TRIGGER `before_insert_update_timespent` BEFORE INSERT ON `order_task_timesheet` FOR EACH ROW BEGIN
    SET NEW.timespent = SEC_TO_TIME(TIMESTAMPDIFF(SECOND, NEW.start_date, NEW.end_date));
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_timespent` BEFORE UPDATE ON `order_task_timesheet` FOR EACH ROW BEGIN
    SET NEW.timespent = SEC_TO_TIME(TIMESTAMPDIFF(SECOND, NEW.start_date, NEW.end_date));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_transactions`
--

CREATE TABLE `order_transactions` (
  `id` bigint(20) NOT NULL,
  `order_id` bigint(20) NOT NULL,
  `order_status` varchar(50) NOT NULL,
  `order_data` text DEFAULT NULL,
  `order_items` text DEFAULT NULL,
  `txn_amount` decimal(10,2) NOT NULL,
  `txn_method` varchar(50) NOT NULL,
  `order_total` decimal(10,2) DEFAULT NULL,
  `total_paid` decimal(10,2) NOT NULL,
  `total_due` decimal(10,2) NOT NULL,
  `cod_due` decimal(10,2) DEFAULT NULL,
  `link_due` decimal(10,2) DEFAULT NULL,
  `link_info` text DEFAULT NULL,
  `received` datetime DEFAULT NULL,
  `receiver` varchar(100) DEFAULT NULL,
  `note` varchar(100) DEFAULT NULL,
  `verifier` varchar(100) DEFAULT NULL,
  `verified` datetime DEFAULT NULL,
  `creator` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_transactions`
--


-- --------------------------------------------------------

--
-- Table structure for table `outsourcers`
--

CREATE TABLE `outsourcers` (
  `id` int(11) NOT NULL,
  `firstname` varchar(20) NOT NULL,
  `lastname` varchar(20) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `services` text DEFAULT NULL,
  `mobile1` varchar(10) NOT NULL,
  `mobile2` varchar(10) DEFAULT NULL,
  `address` text NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `user_id` int(11) NOT NULL,
  `editor` int(11) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `outsourcers`
--


-- --------------------------------------------------------

--
-- Table structure for table `outsource_orders`
--

CREATE TABLE `outsource_orders` (
  `id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `order_data` text NOT NULL,
  `task_type` varchar(50) NOT NULL,
  `rate_type` enum('meter','piece') NOT NULL,
  `rate` decimal(10,2) NOT NULL,
  `status` enum('generated','to be issued','issued','received','rejected','reissued','approved','completed') NOT NULL DEFAULT 'generated',
  `paid` tinyint(1) NOT NULL DEFAULT 0,
  `paid_by` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `issuer` int(11) DEFAULT NULL,
  `issued` datetime DEFAULT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `receiver` int(11) DEFAULT NULL,
  `received` datetime DEFAULT NULL,
  `editor` int(11) DEFAULT NULL,
  `created` timestamp NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payout_adjustment`
--

CREATE TABLE `payout_adjustment` (
  `id` bigint(20) NOT NULL,
  `karigar_id` int(5) UNSIGNED NOT NULL,
  `payout_id` int(11) DEFAULT NULL,
  `pay_day` date NOT NULL,
  `is_plus` tinyint(1) NOT NULL DEFAULT 0,
  `amount` decimal(10,2) NOT NULL,
  `remarks` varchar(100) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `editor` int(11) DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `wc_id` int(11) DEFAULT NULL,
  `type` enum('simple','variable','variation') DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `pair_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `sku` varchar(50) DEFAULT NULL,
  `size` varchar(5) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `status` enum('draft','pending','private','publish') DEFAULT NULL,
  `visibility` enum('visible','catalog','search','hidden') DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tasksdata`
--

CREATE TABLE `tasksdata` (
  `task_id` varchar(16) NOT NULL,
  `parent_id` varchar(16) DEFAULT NULL,
  `task_name` varchar(100) DEFAULT NULL,
  `collection` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `due_date` datetime DEFAULT NULL,
  `done_date` datetime DEFAULT NULL,
  `time_spent` varchar(20) DEFAULT NULL,
  `karigar` varchar(60) DEFAULT NULL,
  `fabric` varchar(60) DEFAULT NULL,
  `mtr` varchar(10) DEFAULT NULL,
  `fab_cost` varchar(10) DEFAULT NULL,
  `cut_cost` varchar(10) DEFAULT NULL,
  `me_cost` varchar(10) DEFAULT NULL,
  `he_cost` varchar(10) DEFAULT NULL,
  `st_cost` varchar(10) DEFAULT NULL,
  `fin_cost` varchar(10) DEFAULT NULL,
  `acc_cost` varchar(10) DEFAULT NULL,
  `oh_cost` varchar(10) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `intensity` varchar(20) DEFAULT NULL,
  `size` varchar(8) DEFAULT NULL,
  `wc_id` varchar(10) DEFAULT NULL,
  `item_id` varchar(10) DEFAULT NULL,
  `rw_date` datetime DEFAULT NULL,
  `measurements` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tasksdata`
--

-- --------------------------------------------------------

--
-- Table structure for table `taxonomies`
--

CREATE TABLE `taxonomies` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `taxonomy` varchar(50) NOT NULL,
  `alias` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `taxonomies`
--

-- --------------------------------------------------------

--
-- Table structure for table `taxonomy_terms`
--

CREATE TABLE `taxonomy_terms` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `parent_id` smallint(5) UNSIGNED DEFAULT NULL,
  `taxonomy_id` smallint(5) UNSIGNED NOT NULL,
  `user_id` smallint(6) NOT NULL,
  `code` char(10) NOT NULL,
  `thread` varchar(12) DEFAULT NULL,
  `label` varchar(100) NOT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `brand` varchar(25) DEFAULT NULL,
  `rate` text DEFAULT NULL,
  `spl_attr` tinyint(1) NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created` datetime NOT NULL DEFAULT current_timestamp(),
  `updated` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `taxonomy_terms`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` bigint(11) UNSIGNED NOT NULL,
  `client_id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `options` longtext DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role` varchar(20) DEFAULT NULL,
  `mobile` varchar(16) DEFAULT NULL,
  `pass_request` varchar(16) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--


-- --------------------------------------------------------

--
-- Table structure for table `user_permissions`
--

CREATE TABLE `user_permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` varchar(30) NOT NULL,
  `feature` varchar(30) NOT NULL,
  `can_view` tinyint(1) NOT NULL DEFAULT 0,
  `can_add` tinyint(1) NOT NULL DEFAULT 0,
  `can_edit` tinyint(1) NOT NULL DEFAULT 0,
  `can_delete` tinyint(1) NOT NULL DEFAULT 0,
  `editor_id` int(10) UNSIGNED DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_permissions`
--

-- --------------------------------------------------------

--
-- Table structure for table `user_sessions`
--

CREATE TABLE `user_sessions` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `session_token` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `fingerprint` text DEFAULT NULL,
  `created` datetime DEFAULT current_timestamp(),
  `updated` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_sessions`
--

--
-- Indexes for dumped tables
--

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `designs`
--
ALTER TABLE `designs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `karigars`
--
ALTER TABLE `karigars`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `karigar_attendance`
--
ALTER TABLE `karigar_attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `karigar_id` (`karigar_id`);

--
-- Indexes for table `karigar_timesheet_app`
--
ALTER TABLE `karigar_timesheet_app`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `measurements`
--
ALTER TABLE `measurements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `options`
--
ALTER TABLE `options`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_code` (`item_code`),
  ADD KEY `wc_order_id` (`wc_order_id`),
  ADD KEY `wc_item_id` (`wc_item_id`),
  ADD KEY `delivery` (`due_date`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `orders_meta`
--
ALTER TABLE `orders_meta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `meta_key_value` (`meta_key`,`meta_value`(100)),
  ADD KEY `order_id_meta_key_meta_value` (`order_id`,`meta_key`,`meta_value`(100));

--
-- Indexes for table `order_tasks`
--
ALTER TABLE `order_tasks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `start_date` (`start_date`),
  ADD KEY `end_date` (`end_date`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `order_task_timesheet`
--
ALTER TABLE `order_task_timesheet`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `task_name` (`task_code`),
  ADD KEY `karigar` (`karigar_id`),
  ADD KEY `start_date` (`start_date`),
  ADD KEY `end_date` (`end_date`);

--
-- Indexes for table `order_transactions`
--
ALTER TABLE `order_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outsourcers`
--
ALTER TABLE `outsourcers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `outsource_orders`
--
ALTER TABLE `outsource_orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_order_id` (`order_id`);

--
-- Indexes for table `payout_adjustment`
--
ALTER TABLE `payout_adjustment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `karigar_id` (`karigar_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tasksdata`
--
ALTER TABLE `tasksdata`
  ADD PRIMARY KEY (`task_id`);

--
-- Indexes for table `taxonomies`
--
ALTER TABLE `taxonomies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`taxonomy`);

--
-- Indexes for table `taxonomy_terms`
--
ALTER TABLE `taxonomy_terms`
  ADD PRIMARY KEY (`id`),
  ADD KEY `taxonomy_id` (`taxonomy_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `username_2` (`username`);

--
-- Indexes for table `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `role_feature` (`role`,`feature`);

--
-- Indexes for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_token` (`session_token`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `designs`
--
ALTER TABLE `designs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

--
-- AUTO_INCREMENT for table `karigars`
--
ALTER TABLE `karigars`
  MODIFY `ID` int(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `karigar_attendance`
--
ALTER TABLE `karigar_attendance`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3781;

--
-- AUTO_INCREMENT for table `karigar_timesheet_app`
--
ALTER TABLE `karigar_timesheet_app`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `measurements`
--
ALTER TABLE `measurements`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `options`
--
ALTER TABLE `options`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1150;

--
-- AUTO_INCREMENT for table `orders_meta`
--
ALTER TABLE `orders_meta`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9420;

--
-- AUTO_INCREMENT for table `order_tasks`
--
ALTER TABLE `order_tasks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8904;

--
-- AUTO_INCREMENT for table `order_task_timesheet`
--
ALTER TABLE `order_task_timesheet`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6943;

--
-- AUTO_INCREMENT for table `order_transactions`
--
ALTER TABLE `order_transactions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=540;

--
-- AUTO_INCREMENT for table `outsourcers`
--
ALTER TABLE `outsourcers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `outsource_orders`
--
ALTER TABLE `outsource_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=428;

--
-- AUTO_INCREMENT for table `payout_adjustment`
--
ALTER TABLE `payout_adjustment`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `taxonomies`
--
ALTER TABLE `taxonomies`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `taxonomy_terms`
--
ALTER TABLE `taxonomy_terms`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1742;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` bigint(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `user_permissions`
--
ALTER TABLE `user_permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `user_sessions`
--
ALTER TABLE `user_sessions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `karigar_attendance`
--
ALTER TABLE `karigar_attendance`
  ADD CONSTRAINT `karigar_attendance_ibfk_1` FOREIGN KEY (`karigar_id`) REFERENCES `karigars` (`ID`) ON DELETE CASCADE;

--
-- Constraints for table `orders_meta`
--
ALTER TABLE `orders_meta`
  ADD CONSTRAINT `orders_meta_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_tasks`
--
ALTER TABLE `order_tasks`
  ADD CONSTRAINT `order_tasks_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_task_timesheet`
--
ALTER TABLE `order_task_timesheet`
  ADD CONSTRAINT `order_task_timesheet_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `outsource_orders`
--
ALTER TABLE `outsource_orders`
  ADD CONSTRAINT `fk_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payout_adjustment`
--
ALTER TABLE `payout_adjustment`
  ADD CONSTRAINT `payout_adjustment_ibfk_1` FOREIGN KEY (`karigar_id`) REFERENCES `karigars` (`ID`) ON DELETE CASCADE;

--
-- Constraints for table `taxonomy_terms`
--
ALTER TABLE `taxonomy_terms`
  ADD CONSTRAINT `taxonomy_terms_ibfk_1` FOREIGN KEY (`taxonomy_id`) REFERENCES `taxonomies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `taxonomy_terms_ibfk_2` FOREIGN KEY (`parent_id`) REFERENCES `taxonomy_terms` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_sessions`
--
ALTER TABLE `user_sessions`
  ADD CONSTRAINT `user_sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`ID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

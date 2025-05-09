-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Generation Time: May 09, 2025 at 10:32 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `attendance_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `login_attempts` int(11) DEFAULT 0,
  `last_attempt` datetime DEFAULT NULL,
  `account_locked` tinyint(1) DEFAULT 0,
  `lock_until` datetime DEFAULT NULL,
  `last_failed_attempt_ip` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `password`, `email`, `created_at`, `login_attempts`, `last_attempt`, `account_locked`, `lock_until`, `last_failed_attempt_ip`) VALUES
(3, 'admin', '$2y$10$jl/sAqn1Faery8LpnSYWqerEP76ah6/YZiBl2uTSva1LZfP99AgrG', '', '2025-03-31 08:09:18', 0, NULL, 0, NULL, '::1');

-- --------------------------------------------------------

--
-- Table structure for table `admin_logs`
--

CREATE TABLE `admin_logs` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `target_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `professor_id` int(11) NOT NULL,
  `am_check_in` datetime DEFAULT NULL,
  `am_check_out` datetime DEFAULT NULL,
  `pm_check_in` datetime DEFAULT NULL,
  `pm_check_out` datetime DEFAULT NULL,
  `status` enum('present','absent','half-day') DEFAULT 'absent',
  `recorded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `checkin_date` date NOT NULL DEFAULT curdate(),
  `date` date DEFAULT NULL,
  `work_duration` time DEFAULT NULL,
  `is_late` tinyint(1) DEFAULT 0,
  `schedule_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `user` varchar(100) DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `logs`
--
DELIMITER $$
CREATE TRIGGER `enforce_log_terms` BEFORE INSERT ON `logs` FOR EACH ROW BEGIN
    SET NEW.action = REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(NEW.action, 'check-in', 'time-in'),
                'check-out', 'time-out'),
            'checked in', 'timed in'),
        'checked out', 'timed out');
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'time-in or time-out',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `notifications`
--
DELIMITER $$
CREATE TRIGGER `enforce_time_terms` BEFORE INSERT ON `notifications` FOR EACH ROW BEGIN
    SET NEW.message = REPLACE(
        REPLACE(NEW.message, 'checked in', 'timed in'),
        'checked out',
        'timed out'
    );
    SET NEW.type = REPLACE(
        REPLACE(NEW.type, 'check-in', 'time-in'),
        'check-out',
        'time-out'
    );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `professors`
--

CREATE TABLE `professors` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('active','pending') DEFAULT 'active',
  `approved_at` datetime DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `department` varchar(100) NOT NULL DEFAULT 'Computer Studies Department',
  `phone` varchar(20) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `login_attempts` int(11) DEFAULT 0,
  `last_attempt` datetime DEFAULT NULL,
  `account_locked` tinyint(1) DEFAULT 0,
  `lock_until` datetime DEFAULT NULL,
  `last_failed_attempt_ip` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `professors`
--

INSERT INTO `professors` (`id`, `name`, `email`, `designation`, `profile_image`, `created_at`, `status`, `approved_at`, `approved_by`, `department`, `phone`, `username`, `password`, `login_attempts`, `last_attempt`, `account_locked`, `lock_until`, `last_failed_attempt_ip`) VALUES
(1, 'Arnold B. Platon', 'johndoe@bup.edu.ph', 'Department Head', '', '2025-02-08 05:22:23', 'active', '2025-04-01 15:55:30', 3, 'Computer Studies Department', '0917283016', NULL, NULL, 0, NULL, 0, NULL, NULL),
(2, 'Vince Angelo E. Naz ', 'janesmith@bup.edu.ph', 'BSIT Program Coordinator', '', '2025-02-08 05:22:23', 'active', '2025-04-01 18:20:07', 3, 'Computer Studies Department', '0950475140', NULL, NULL, 0, NULL, 0, NULL, NULL),
(3, 'Jerry B. Agsunod', 'markdelacruz@bup.edu.ph', 'BSCS Program Coordinator', '', '2025-02-08 05:22:23', 'active', '2025-04-01 18:38:31', 3, 'Computer Studies Department', '0900526661', NULL, NULL, 0, NULL, 0, NULL, NULL),
(4, 'Paulo L. Perete', 'mariasantos@bup.edu.ph', 'BSIT-Animation Program Coordinator', '', '2025-02-08 06:17:30', 'active', '2025-04-03 14:10:31', 3, 'Computer Studies Department', '0951207890', NULL, NULL, 0, NULL, 0, NULL, NULL),
(5, 'Guillermo V. Red, Jr.', 'rafaelcruz@bup.edu.ph', 'BSIS Program Coordinator', '', '2025-02-08 06:17:30', 'active', '2025-04-03 14:41:12', 3, 'Computer Studies Department', '0954459468', NULL, NULL, 0, NULL, 0, NULL, NULL),
(6, 'Maria Charmy A. Arispe', 'angelareyes@bup.edu.ph', 'College IMO Coordinator', '', '2025-02-08 06:17:30', 'active', '2025-04-12 13:26:20', 3, 'Computer Studies Department', '0918673672', NULL, NULL, 0, NULL, 0, NULL, NULL),
(7, 'Blessica B. Dorosan', 'michaeltan@bup.edu.ph', 'Professor', '', '2025-02-08 06:17:30', 'active', '2025-04-17 10:31:34', 3, 'Computer Studies Department', '0929989963', NULL, NULL, 0, NULL, 0, NULL, NULL),
(8, 'Suzanne S. Causapin', 'sophiagomez@bup.edu.ph', 'Professor', '', '2025-02-08 06:17:30', 'active', '2025-04-26 10:09:16', 3, 'Computer Studies Department', '0993928801', NULL, NULL, 0, NULL, 0, NULL, NULL),
(9, 'Khristine A. Botin', 'carlosvillanueva@bup.edu.ph', 'Professor', '', '2025-02-08 06:17:30', 'active', '2025-04-26 10:09:46', 3, 'Computer Studies Department', '0979674122', NULL, NULL, 0, NULL, 0, NULL, NULL),
(10, 'Jorge Sulipicio S. Aganan', 'jessicalim@bup.edu.ph', 'Professor', '', '2025-02-08 06:17:30', 'active', '2025-04-26 10:20:54', 3, 'Computer Studies Department', '0916584207', NULL, NULL, 0, NULL, 0, NULL, NULL),
(11, 'Joseph L. Carinan', 'benedictchua@bup.edu.ph', 'College Document Custodian', '', '2025-02-08 06:17:30', 'active', '2025-04-26 10:31:41', 3, 'Computer Studies Department', '0943898675', NULL, NULL, 0, NULL, 0, NULL, NULL),
(12, 'Mary Antoniette S. Ariño', 'oliviamendoza@bup.edu.ph', 'College SIP Coordinator', '', '2025-02-08 06:17:30', 'active', '2025-04-26 10:56:41', 3, 'Computer Studies Department', '0969740758', NULL, NULL, 0, NULL, 0, NULL, NULL),
(60, 'Charls Emil C. Barquin', 'charls@gmail.com', 'Professor', NULL, '2025-05-03 07:43:15', 'active', NULL, NULL, 'Computer Studies Department', '09386090970', 'Charls', '$2y$10$4kd/HlvXsb33ytHPJKPiuuQ1IXDHqzWHPaUNLysaA.nH0Kz9beO2m', 0, NULL, 0, NULL, NULL),
(61, 'Asher Caubang', 'ash@gmail.com', 'Professor', NULL, '2025-05-03 07:49:00', 'active', NULL, NULL, 'Computer Studies Department', '0938293719373', 'Ash', '$2y$10$TQ33.8fgufN6TYUQhZvZBeiwCyzPHwL0UwgFPzLgNJKsqjvS8QVzq', 0, NULL, 0, NULL, NULL),
(62, 'Mark Guillermo', 'mark@gmail.com', 'Professor', NULL, '2025-05-03 14:16:40', 'active', NULL, NULL, 'Computer Studies Department', '09736283638', 'Mark', '$2y$10$6UZbHdRTOzhTdkQ83/7ijuaTMqZ4M99UAPcxRELzbXK2Hkb0qzoH6', 0, NULL, 0, NULL, NULL);

--
-- Triggers `professors`
--
DELIMITER $$
CREATE TRIGGER `after_professor_insert` AFTER INSERT ON `professors` FOR EACH ROW BEGIN
    INSERT INTO logs (action, user, timestamp)
    VALUES (CONCAT('New professor registered: ', NEW.name), 'system', NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `professor_schedules`
--

CREATE TABLE `professor_schedules` (
  `id` int(11) NOT NULL,
  `professor_id` int(11) NOT NULL,
  `day_id` int(11) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `room` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `professor_schedules`
--

INSERT INTO `professor_schedules` (`id`, `professor_id`, `day_id`, `start_time`, `end_time`, `subject`, `room`, `created_at`, `updated_at`) VALUES
(187, 61, 1, '13:00:00', '15:00:00', 'MMW', 'CL 3', '2025-05-03 07:51:04', '2025-05-03 07:51:04'),
(188, 61, 2, '14:30:00', '17:30:00', 'SADD', 'CL 4', '2025-05-03 07:51:04', '2025-05-03 07:51:04'),
(189, 61, 3, '07:30:00', '09:00:00', 'NSTP', 'ECB 202', '2025-05-03 07:51:04', '2025-05-03 07:51:04'),
(190, 61, 4, '15:00:00', '17:00:00', 'DSA', 'CL 4', '2025-05-03 07:51:04', '2025-05-03 07:51:04'),
(191, 61, 5, '09:00:00', '12:00:00', 'IM', 'CL 6', '2025-05-03 07:51:04', '2025-05-03 07:51:04'),
(192, 61, 6, '15:30:00', '17:00:00', 'PATHFIT', 'GYM 5', '2025-05-03 07:51:04', '2025-05-03 07:51:04'),
(219, 62, 1, '07:00:00', '09:00:00', 'MMW', 'SB 3', '2025-05-03 16:07:48', '2025-05-03 16:07:48'),
(220, 62, 1, '09:00:00', '12:00:00', 'mmw', 'cl3', '2025-05-03 16:07:48', '2025-05-03 16:07:48'),
(221, 62, 2, '09:00:00', '12:00:00', 'IM', 'CL 3', '2025-05-03 16:07:48', '2025-05-03 16:07:48'),
(222, 62, 3, '10:00:00', '12:00:00', 'SADD', 'CL 3', '2025-05-03 16:07:48', '2025-05-03 16:07:48'),
(223, 62, 5, '13:00:00', '15:00:00', 'DSA', 'CL 4', '2025-05-03 16:07:48', '2025-05-03 16:07:48'),
(224, 62, 6, '17:30:00', '19:30:00', 'PATHFIT', 'GYM 5', '2025-05-03 16:07:48', '2025-05-03 16:07:48'),
(534, 60, 1, '07:00:00', '09:00:00', 'STS', 'ECB 202', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(535, 60, 1, '10:00:00', '12:00:00', 'MMW', 'CL 4', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(536, 60, 2, '10:30:00', '12:00:00', 'IM', 'CL 6', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(537, 60, 2, '12:00:00', '15:00:00', 'SADD', 'CL 4', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(538, 60, 3, '10:00:00', '12:00:00', 'SADD', 'CL 3', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(539, 60, 4, '09:00:00', '12:00:00', 'DSA', 'CL 3', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(540, 60, 5, '15:00:00', '17:30:00', 'PATHFIT', 'GYM 5', '2025-05-04 03:41:43', '2025-05-04 03:41:43'),
(541, 60, 6, '16:00:00', '19:00:00', 'COMPROG', 'CL 4', '2025-05-04 03:41:43', '2025-05-04 03:41:43');

-- --------------------------------------------------------

--
-- Table structure for table `schedule_days`
--

CREATE TABLE `schedule_days` (
  `id` int(11) NOT NULL,
  `day_name` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedule_days`
--

INSERT INTO `schedule_days` (`id`, `day_name`) VALUES
(1, 'Monday'),
(2, 'Tuesday'),
(3, 'Wednesday'),
(4, 'Thursday'),
(5, 'Friday'),
(6, 'Saturday');

-- --------------------------------------------------------

--
-- Table structure for table `security_policies`
--

CREATE TABLE `security_policies` (
  `id` int(11) NOT NULL,
  `policy_name` varchar(100) NOT NULL,
  `policy_value` varchar(255) NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `security_policies`
--

INSERT INTO `security_policies` (`id`, `policy_name`, `policy_value`, `description`) VALUES
(1, 'max_login_attempts', '5', 'Maximum allowed failed login attempts before lockout'),
(2, 'account_lock_duration', '30', 'Lockout duration in minutes');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(11) NOT NULL,
  `timezone` varchar(50) NOT NULL DEFAULT 'Asia/Manila',
  `am_cutoff` time DEFAULT '12:00:00',
  `pm_cutoff` time DEFAULT '17:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `timezone`, `am_cutoff`, `pm_cutoff`) VALUES
(1, 'Asia/Manila', '12:00:00', '17:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `professor_id` (`professor_id`),
  ADD KEY `schedule_id` (`schedule_id`),
  ADD KEY `idx_professor_date` (`professor_id`,`date`),
  ADD KEY `idx_attendance_professor_date` (`professor_id`,`checkin_date`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_read` (`user`,`is_read`),
  ADD KEY `idx_timestamp` (`timestamp`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_type_created` (`type`,`created_at`),
  ADD KEY `idx_is_read` (`is_read`);

--
-- Indexes for table `professors`
--
ALTER TABLE `professors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_professors_approved_by` (`approved_by`);

--
-- Indexes for table `professor_schedules`
--
ALTER TABLE `professor_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `professor_id` (`professor_id`),
  ADD KEY `day_id` (`day_id`),
  ADD KEY `idx_professor_day` (`professor_id`,`day_id`),
  ADD KEY `idx_schedules_professor_day` (`professor_id`,`day_id`);

--
-- Indexes for table `schedule_days`
--
ALTER TABLE `schedule_days`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `security_policies`
--
ALTER TABLE `security_policies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `policy_name` (`policy_name`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=759;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=215;

--
-- AUTO_INCREMENT for table `professors`
--
ALTER TABLE `professors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `professor_schedules`
--
ALTER TABLE `professor_schedules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=542;

--
-- AUTO_INCREMENT for table `schedule_days`
--
ALTER TABLE `schedule_days`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `security_policies`
--
ALTER TABLE `security_policies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD CONSTRAINT `admin_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`);

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`schedule_id`) REFERENCES `professor_schedules` (`id`);

--
-- Constraints for table `professors`
--
ALTER TABLE `professors`
  ADD CONSTRAINT `fk_professors_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `admins` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `professor_schedules`
--
ALTER TABLE `professor_schedules`
  ADD CONSTRAINT `professor_schedules_ibfk_1` FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `professor_schedules_ibfk_2` FOREIGN KEY (`day_id`) REFERENCES `schedule_days` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

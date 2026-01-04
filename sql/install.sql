-- RP-Alpha Housing System
-- SQL Schema for house ownership

CREATE TABLE IF NOT EXISTS `rpa_housing` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `house_id` VARCHAR(50) NOT NULL UNIQUE,
    `citizenid` VARCHAR(50) NOT NULL,
    `purchase_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `metadata` JSON DEFAULT NULL,
    INDEX `idx_citizenid` (`citizenid`),
    INDEX `idx_house_id` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- MySQL dump 10.13  Distrib 8.0.42, for macos15 (arm64)
--
-- Host: 10.10.1.81    Database: asterisk
-- ------------------------------------------------------
-- Server version	5.5.5-10.11.11-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

/*
Create asterisk database and vici specific users
*/


/* Create users only if they don't exist */
CREATE USER IF NOT EXISTS cron@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS custom@'%' IDENTIFIED BY 'custom1234';
CREATE USER IF NOT EXISTS custom@'localhost' IDENTIFIED BY 'custom1234';
CREATE USER IF NOT EXISTS cron@'localhost' IDENTIFIED BY '1234';

/* Grant privileges */
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES ON asterisk.* TO cron@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES ON asterisk.* TO cron@'localhost';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES ON asterisk.* TO custom@'%';
GRANT SELECT,INSERT,UPDATE,DELETE,LOCK TABLES ON asterisk.* TO custom@'localhost';

/*-------------------------------------------*/


GRANT RELOAD ON *.* TO cron@'%';
GRANT RELOAD ON *.* TO cron@localhost;
GRANT RELOAD ON *.* TO custom@'%';
GRANT RELOAD ON *.* TO custom@localhost;
flush privileges;
use asterisk;



--
-- Table structure for table `audio_store_details`
--


/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `audio_store_details` (
  `audio_filename` varchar(250) NOT NULL,
  `audio_format` varchar(10) DEFAULT 'unknown',
  `audio_filesize` bigint(20) unsigned DEFAULT 0,
  `audio_epoch` bigint(20) unsigned DEFAULT 0,
  `audio_length` int(10) unsigned DEFAULT 0,
  `wav_format_details` varchar(255) DEFAULT '',
  `wav_asterisk_valid` enum('','GOOD','BAD','NA') DEFAULT '',
  UNIQUE KEY `audio_filename` (`audio_filename`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audio_store_details`
--

--
-- Table structure for table `call_log`
--


/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `call_log` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `number_dialed` varchar(15) DEFAULT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `start_epoch` int(10) DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `end_epoch` int(10) DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `length_in_min` double(8,2) DEFAULT NULL,
  PRIMARY KEY (`uniqueid`),
  KEY `caller_code` (`caller_code`),
  KEY `server_ip` (`server_ip`),
  KEY `channel` (`channel`),
  KEY `start_time` (`start_time`),
  KEY `end_time` (`end_time`),
  KEY `time` (`start_time`,`end_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `call_log`
--

/*!40000 ALTER TABLE `call_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `call_log` ENABLE KEYS */;

--
-- Table structure for table `call_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `call_log_archive` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `number_dialed` varchar(15) DEFAULT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `start_epoch` int(10) DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `end_epoch` int(10) DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `length_in_min` double(8,2) DEFAULT NULL,
  PRIMARY KEY (`uniqueid`),
  KEY `caller_code` (`caller_code`),
  KEY `server_ip` (`server_ip`),
  KEY `channel` (`channel`),
  KEY `start_time` (`start_time`),
  KEY `end_time` (`end_time`),
  KEY `time` (`start_time`,`end_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `call_log_archive`
--

/*!40000 ALTER TABLE `call_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `call_log_archive` ENABLE KEYS */;

--
-- Table structure for table `callcard_accounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `callcard_accounts` (
  `card_id` varchar(20) NOT NULL,
  `pin` varchar(10) NOT NULL,
  `status` enum('GENERATE','PRINT','SHIP','HOLD','ACTIVE','USED','EMPTY','CANCEL','VOID') DEFAULT 'GENERATE',
  `balance_minutes` smallint(5) DEFAULT 3,
  `inbound_group_id` varchar(20) DEFAULT '',
  PRIMARY KEY (`card_id`),
  KEY `pin` (`pin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callcard_accounts`
--

/*!40000 ALTER TABLE `callcard_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `callcard_accounts` ENABLE KEYS */;

--
-- Table structure for table `callcard_accounts_details`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `callcard_accounts_details` (
  `card_id` varchar(20) NOT NULL,
  `run` varchar(4) DEFAULT '',
  `batch` varchar(5) DEFAULT '',
  `pack` varchar(5) DEFAULT '',
  `sequence` varchar(5) DEFAULT '',
  `status` enum('GENERATE','PRINT','SHIP','HOLD','ACTIVE','USED','EMPTY','CANCEL','VOID') DEFAULT 'GENERATE',
  `balance_minutes` smallint(5) DEFAULT 3,
  `initial_value` varchar(6) DEFAULT '0.00',
  `initial_minutes` smallint(5) DEFAULT 3,
  `note_purchase_order` varchar(20) DEFAULT '',
  `note_printer` varchar(20) DEFAULT '',
  `note_did` varchar(18) DEFAULT '',
  `inbound_group_id` varchar(20) DEFAULT '',
  `note_language` varchar(10) DEFAULT 'English',
  `note_name` varchar(20) DEFAULT '',
  `note_comments` varchar(255) DEFAULT '',
  `create_user` varchar(20) DEFAULT '',
  `activate_user` varchar(20) DEFAULT '',
  `used_user` varchar(20) DEFAULT '',
  `void_user` varchar(20) DEFAULT '',
  `create_time` datetime DEFAULT NULL,
  `activate_time` datetime DEFAULT NULL,
  `used_time` datetime DEFAULT NULL,
  `void_time` datetime DEFAULT NULL,
  PRIMARY KEY (`card_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callcard_accounts_details`
--

/*!40000 ALTER TABLE `callcard_accounts_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `callcard_accounts_details` ENABLE KEYS */;

--
-- Table structure for table `callcard_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `callcard_log` (
  `uniqueid` varchar(20) NOT NULL,
  `card_id` varchar(20) DEFAULT NULL,
  `balance_minutes_start` smallint(5) DEFAULT 3,
  `call_time` datetime DEFAULT NULL,
  `agent_time` datetime DEFAULT NULL,
  `dispo_time` datetime DEFAULT NULL,
  `agent` varchar(20) DEFAULT '',
  `agent_dispo` varchar(6) DEFAULT '',
  `agent_talk_sec` mediumint(8) DEFAULT 0,
  `agent_talk_min` mediumint(8) DEFAULT 0,
  `phone_number` varchar(18) DEFAULT NULL,
  `inbound_did` varchar(18) DEFAULT NULL,
  PRIMARY KEY (`uniqueid`),
  KEY `card_id` (`card_id`),
  KEY `call_time` (`call_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `callcard_log`
--

/*!40000 ALTER TABLE `callcard_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `callcard_log` ENABLE KEYS */;

--
-- Table structure for table `cid_channels_recent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `cid_channels_recent` (
  `caller_id_name` varchar(30) NOT NULL,
  `connected_line_name` varchar(30) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `channel` varchar(100) DEFAULT '',
  `dest_channel` varchar(100) DEFAULT '',
  `linkedid` varchar(20) DEFAULT '',
  `dest_uniqueid` varchar(20) DEFAULT '',
  `uniqueid` varchar(20) DEFAULT '',
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cid_channels_recent`
--

/*!40000 ALTER TABLE `cid_channels_recent` DISABLE KEYS */;
/*!40000 ALTER TABLE `cid_channels_recent` ENABLE KEYS */;

--
-- Table structure for table `clr_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `clr_log` (
  `clr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL,
  `begin_range` datetime DEFAULT NULL,
  `range_minutes` smallint(5) unsigned DEFAULT 0,
  `phase` varchar(40) DEFAULT '',
  `records_ct` mediumint(7) unsigned DEFAULT 0,
  `length_in_sec` mediumint(8) unsigned DEFAULT 0,
  `options` varchar(100) DEFAULT '',
  `server_ip` varchar(15) DEFAULT '',
  `processing_log` text DEFAULT NULL,
  PRIMARY KEY (`clr_id`),
  KEY `start_time` (`start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clr_log`
--

/*!40000 ALTER TABLE `clr_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `clr_log` ENABLE KEYS */;

--
-- Table structure for table `conferences`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `conferences` (
  `conf_exten` int(7) unsigned NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `extension` varchar(100) DEFAULT NULL,
  UNIQUE KEY `extenserver` (`conf_exten`,`server_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conferences`
--

/*!40000 ALTER TABLE `conferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `conferences` ENABLE KEYS */;

--
-- Table structure for table `contact_information`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `contact_information` (
  `contact_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) DEFAULT '',
  `last_name` varchar(50) DEFAULT '',
  `office_num` varchar(20) DEFAULT '',
  `cell_num` varchar(20) DEFAULT '',
  `other_num1` varchar(20) DEFAULT '',
  `other_num2` varchar(20) DEFAULT '',
  `bu_name` varchar(100) DEFAULT '',
  `department` varchar(100) DEFAULT '',
  `group_name` varchar(100) DEFAULT '',
  `job_title` varchar(100) DEFAULT '',
  `location` varchar(100) DEFAULT '',
  PRIMARY KEY (`contact_id`),
  KEY `ci_first_name` (`first_name`),
  KEY `ci_last_name` (`last_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_information`
--

/*!40000 ALTER TABLE `contact_information` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_information` ENABLE KEYS */;

--
-- Table structure for table `dialable_inventory_snapshots`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `dialable_inventory_snapshots` (
  `snapshot_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `snapshot_time` datetime DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `list_name` varchar(30) DEFAULT NULL,
  `list_description` varchar(255) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `list_lastcalldate` varchar(20) DEFAULT NULL,
  `list_start_inv` mediumint(8) unsigned DEFAULT NULL,
  `dialable_count` mediumint(8) unsigned DEFAULT NULL,
  `dialable_count_nofilter` mediumint(8) unsigned DEFAULT NULL,
  `dialable_count_oneoff` mediumint(8) unsigned DEFAULT NULL,
  `dialable_count_inactive` mediumint(8) unsigned DEFAULT NULL,
  `average_call_count` decimal(3,1) DEFAULT NULL,
  `penetration` decimal(5,2) DEFAULT NULL,
  `shift_data` text DEFAULT NULL,
  `time_setting` enum('LOCAL','SERVER') DEFAULT NULL,
  PRIMARY KEY (`snapshot_id`),
  UNIQUE KEY `snapshot_date_list_key` (`snapshot_time`,`list_id`,`time_setting`),
  KEY `snapshot_date_key` (`snapshot_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dialable_inventory_snapshots`
--

/*!40000 ALTER TABLE `dialable_inventory_snapshots` DISABLE KEYS */;
/*!40000 ALTER TABLE `dialable_inventory_snapshots` ENABLE KEYS */;

--
-- Table structure for table `gateway_recording_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `gateway_recording_log` (
  `gateway_recording_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recording_log_id` int(10) unsigned DEFAULT 0,
  `call_direction` enum('INBOUND','OUTBOUND','NA') DEFAULT 'NA',
  `call_id` varchar(40) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `uniqueid` varchar(20) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `caller_id_number` varchar(18) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `length_in_sec` mediumint(8) unsigned DEFAULT 0,
  `filename` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`gateway_recording_id`),
  KEY `start_time` (`start_time`),
  KEY `call_id` (`call_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gateway_recording_log`
--

/*!40000 ALTER TABLE `gateway_recording_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `gateway_recording_log` ENABLE KEYS */;

--
-- Table structure for table `groups_alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `groups_alias` (
  `group_alias_id` varchar(30) NOT NULL,
  `group_alias_name` varchar(50) DEFAULT NULL,
  `caller_id_number` varchar(20) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'N',
  `user_group` varchar(20) DEFAULT '---ALL---',
  PRIMARY KEY (`group_alias_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_alias`
--

/*!40000 ALTER TABLE `groups_alias` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups_alias` ENABLE KEYS */;

--
-- Table structure for table `hci_logs`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `hci_logs` (
  `date` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT '',
  `lead_id` int(9) unsigned NOT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  KEY `date` (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hci_logs`
--

/*!40000 ALTER TABLE `hci_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `hci_logs` ENABLE KEYS */;

--
-- Table structure for table `help_documentation`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `help_documentation` (
  `help_id` varchar(100) NOT NULL DEFAULT '',
  `help_title` text DEFAULT NULL,
  `help_text` text DEFAULT NULL,
  PRIMARY KEY (`help_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `help_documentation`
--

/*!40000 ALTER TABLE `help_documentation` DISABLE KEYS */;
/*!40000 ALTER TABLE `help_documentation` ENABLE KEYS */;

--
-- Table structure for table `inbound_disabled_entries`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `inbound_disabled_entries` (
  `interval_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `start_datetime` datetime DEFAULT NULL,
  `end_datetime` datetime DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `message` varchar(100) DEFAULT NULL,
  `message_type` enum('MEETING','CLOSED','WEATHER','CUSTOM') DEFAULT NULL,
  `status` enum('ACTIVE','LIVE','COMPLETED','CANCELLED') DEFAULT 'ACTIVE',
  `user` varchar(20) DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modified_by` varchar(20) DEFAULT NULL,
  `holiday_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`interval_id`),
  KEY `inbound_disabled_entries_key` (`start_datetime`,`end_datetime`,`location`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbound_disabled_entries`
--

/*!40000 ALTER TABLE `inbound_disabled_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `inbound_disabled_entries` ENABLE KEYS */;

--
-- Table structure for table `inbound_email_attachments`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `inbound_email_attachments` (
  `attachment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_row_id` int(10) unsigned DEFAULT NULL,
  `filename` varchar(250) NOT NULL DEFAULT '',
  `file_type` varchar(100) DEFAULT NULL,
  `file_encoding` varchar(20) DEFAULT NULL,
  `file_size` varchar(45) DEFAULT NULL,
  `file_extension` varchar(5) NOT NULL DEFAULT '',
  `file_contents` longblob NOT NULL,
  PRIMARY KEY (`attachment_id`),
  KEY `attachments_email_id_key` (`email_row_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbound_email_attachments`
--

/*!40000 ALTER TABLE `inbound_email_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `inbound_email_attachments` ENABLE KEYS */;

--
-- Table structure for table `inbound_numbers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `inbound_numbers` (
  `extension` varchar(30) NOT NULL,
  `full_number` varchar(30) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `inbound_name` varchar(30) DEFAULT NULL,
  `department` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbound_numbers`
--

/*!40000 ALTER TABLE `inbound_numbers` DISABLE KEYS */;
/*!40000 ALTER TABLE `inbound_numbers` ENABLE KEYS */;

--
-- Table structure for table `leave_vm_message_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `leave_vm_message_groups` (
  `leave_vm_message_group_id` varchar(40) NOT NULL,
  `leave_vm_message_group_notes` varchar(255) DEFAULT '',
  `active` enum('Y','N') DEFAULT 'Y',
  `user_group` varchar(20) DEFAULT '---ALL---',
  PRIMARY KEY (`leave_vm_message_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_vm_message_groups`
--

/*!40000 ALTER TABLE `leave_vm_message_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `leave_vm_message_groups` ENABLE KEYS */;

--
-- Table structure for table `leave_vm_message_groups_entries`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `leave_vm_message_groups_entries` (
  `leave_vm_message_group_id` varchar(40) NOT NULL,
  `audio_filename` varchar(255) NOT NULL,
  `audio_name` varchar(255) DEFAULT '',
  `rank` smallint(5) DEFAULT 0,
  `time_start` varchar(4) DEFAULT '0000',
  `time_end` varchar(4) DEFAULT '2400'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_vm_message_groups_entries`
--

/*!40000 ALTER TABLE `leave_vm_message_groups_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `leave_vm_message_groups_entries` ENABLE KEYS */;

--
-- Table structure for table `live_channels`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `live_channels` (
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `channel_data` varchar(100) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_channels`
--

/*!40000 ALTER TABLE `live_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_channels` ENABLE KEYS */;

--
-- Table structure for table `live_inbound`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `live_inbound` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id` varchar(30) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `phone_ext` varchar(40) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `acknowledged` enum('Y','N') DEFAULT 'N',
  `inbound_number` varchar(20) DEFAULT NULL,
  `comment_a` varchar(50) DEFAULT NULL,
  `comment_b` varchar(50) DEFAULT NULL,
  `comment_c` varchar(50) DEFAULT NULL,
  `comment_d` varchar(50) DEFAULT NULL,
  `comment_e` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_inbound`
--

/*!40000 ALTER TABLE `live_inbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_inbound` ENABLE KEYS */;

--
-- Table structure for table `live_inbound_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `live_inbound_log` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id` varchar(30) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `phone_ext` varchar(40) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `acknowledged` enum('Y','N') DEFAULT 'N',
  `inbound_number` varchar(20) DEFAULT NULL,
  `comment_a` varchar(50) DEFAULT NULL,
  `comment_b` varchar(50) DEFAULT NULL,
  `comment_c` varchar(50) DEFAULT NULL,
  `comment_d` varchar(50) DEFAULT NULL,
  `comment_e` varchar(50) DEFAULT NULL,
  KEY `uniqueid` (`uniqueid`),
  KEY `phone_ext` (`phone_ext`),
  KEY `start_time` (`start_time`),
  KEY `comment_a` (`comment_a`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_inbound_log`
--

/*!40000 ALTER TABLE `live_inbound_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_inbound_log` ENABLE KEYS */;

--
-- Table structure for table `live_sip_channels`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `live_sip_channels` (
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `channel_data` varchar(100) DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `live_sip_channels`
--

/*!40000 ALTER TABLE `live_sip_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `live_sip_channels` ENABLE KEYS */;

--
-- Table structure for table `nanpa_prefix_exchanges_fast`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nanpa_prefix_exchanges_fast` (
  `ac_prefix` char(7) DEFAULT '',
  `type` char(1) DEFAULT '',
  KEY `nanpaacprefix` (`ac_prefix`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nanpa_prefix_exchanges_fast`
--

/*!40000 ALTER TABLE `nanpa_prefix_exchanges_fast` DISABLE KEYS */;
/*!40000 ALTER TABLE `nanpa_prefix_exchanges_fast` ENABLE KEYS */;

--
-- Table structure for table `nanpa_prefix_exchanges_master`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nanpa_prefix_exchanges_master` (
  `areacode` char(3) DEFAULT '',
  `prefix` char(4) DEFAULT '',
  `source` char(1) DEFAULT '',
  `type` char(1) DEFAULT '',
  `tier` varchar(20) DEFAULT '',
  `postal_code` varchar(20) DEFAULT '',
  `new_areacode` char(3) DEFAULT '',
  `tzcode` varchar(4) DEFAULT '',
  `region` char(2) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nanpa_prefix_exchanges_master`
--

/*!40000 ALTER TABLE `nanpa_prefix_exchanges_master` DISABLE KEYS */;
/*!40000 ALTER TABLE `nanpa_prefix_exchanges_master` ENABLE KEYS */;

--
-- Table structure for table `nanpa_wired_to_wireless`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nanpa_wired_to_wireless` (
  `phone` char(10) NOT NULL,
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nanpa_wired_to_wireless`
--

/*!40000 ALTER TABLE `nanpa_wired_to_wireless` DISABLE KEYS */;
/*!40000 ALTER TABLE `nanpa_wired_to_wireless` ENABLE KEYS */;

--
-- Table structure for table `nanpa_wireless_to_wired`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `nanpa_wireless_to_wired` (
  `phone` char(10) NOT NULL,
  PRIMARY KEY (`phone`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nanpa_wireless_to_wired`
--

/*!40000 ALTER TABLE `nanpa_wireless_to_wired` DISABLE KEYS */;
/*!40000 ALTER TABLE `nanpa_wireless_to_wired` ENABLE KEYS */;

--
-- Table structure for table `park_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `park_log` (
  `uniqueid` varchar(20) DEFAULT '',
  `status` varchar(10) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `parked_time` datetime DEFAULT NULL,
  `grab_time` datetime DEFAULT NULL,
  `hangup_time` datetime DEFAULT NULL,
  `parked_sec` int(10) DEFAULT NULL,
  `talked_sec` int(10) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT 0,
  `campaign_id` varchar(20) DEFAULT '',
  KEY `parked_time` (`parked_time`),
  KEY `lead_id` (`lead_id`),
  KEY `campaign_id` (`campaign_id`),
  KEY `uniqueid_park` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `park_log`
--

/*!40000 ALTER TABLE `park_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `park_log` ENABLE KEYS */;

--
-- Table structure for table `park_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `park_log_archive` (
  `uniqueid` varchar(20) DEFAULT '',
  `status` varchar(10) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `parked_time` datetime DEFAULT NULL,
  `grab_time` datetime DEFAULT NULL,
  `hangup_time` datetime DEFAULT NULL,
  `parked_sec` int(10) DEFAULT NULL,
  `talked_sec` int(10) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT 0,
  `campaign_id` varchar(20) DEFAULT '',
  UNIQUE KEY `uniqueidtime_park` (`uniqueid`,`parked_time`),
  KEY `parked_time` (`parked_time`),
  KEY `lead_id` (`lead_id`),
  KEY `campaign_id` (`campaign_id`),
  KEY `uniqueid_park` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `park_log_archive`
--

/*!40000 ALTER TABLE `park_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `park_log_archive` ENABLE KEYS */;

--
-- Table structure for table `parked_channels`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `parked_channels` (
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `parked_by` varchar(100) DEFAULT NULL,
  `parked_time` datetime DEFAULT NULL
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parked_channels`
--

/*!40000 ALTER TABLE `parked_channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `parked_channels` ENABLE KEYS */;

--
-- Table structure for table `parked_channels_recent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `parked_channels_recent` (
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `park_end_time` datetime DEFAULT NULL,
  KEY `channel_group` (`channel_group`),
  KEY `park_end_time` (`park_end_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parked_channels_recent`
--

/*!40000 ALTER TABLE `parked_channels_recent` DISABLE KEYS */;
/*!40000 ALTER TABLE `parked_channels_recent` ENABLE KEYS */;

--
-- Table structure for table `phone_favorites`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `phone_favorites` (
  `extension` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extensions_list` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phone_favorites`
--

/*!40000 ALTER TABLE `phone_favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_favorites` ENABLE KEYS */;

--
-- Table structure for table `phones`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `phones` (
  `extension` varchar(100) DEFAULT NULL,
  `dialplan_number` varchar(20) DEFAULT NULL,
  `voicemail_id` varchar(10) DEFAULT NULL,
  `phone_ip` varchar(15) DEFAULT NULL,
  `computer_ip` varchar(15) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `login` varchar(15) DEFAULT NULL,
  `pass` varchar(100) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `phone_type` varchar(50) DEFAULT NULL,
  `fullname` varchar(50) DEFAULT NULL,
  `company` varchar(10) DEFAULT NULL,
  `picture` varchar(19) DEFAULT NULL,
  `messages` int(4) DEFAULT NULL,
  `old_messages` int(4) DEFAULT NULL,
  `protocol` enum('SIP','PJSIP','Zap','IAX2','EXTERNAL') DEFAULT 'SIP',
  `local_gmt` varchar(6) DEFAULT '-5.00',
  `ASTmgrUSERNAME` varchar(20) DEFAULT 'cron',
  `ASTmgrSECRET` varchar(20) DEFAULT '1234',
  `login_user` varchar(20) DEFAULT NULL,
  `login_pass` varchar(100) DEFAULT NULL,
  `login_campaign` varchar(10) DEFAULT NULL,
  `park_on_extension` varchar(10) DEFAULT '8301',
  `conf_on_extension` varchar(10) DEFAULT '8302',
  `VICIDIAL_park_on_extension` varchar(10) DEFAULT '8301',
  `VICIDIAL_park_on_filename` varchar(10) DEFAULT 'park',
  `monitor_prefix` varchar(10) DEFAULT '8612',
  `recording_exten` varchar(10) DEFAULT '8309',
  `voicemail_exten` varchar(10) DEFAULT '8501',
  `voicemail_dump_exten` varchar(20) DEFAULT '85026666666666',
  `ext_context` varchar(20) DEFAULT 'default',
  `dtmf_send_extension` varchar(100) DEFAULT 'local/8500998@default',
  `call_out_number_group` varchar(100) DEFAULT 'Zap/g2/',
  `client_browser` varchar(100) DEFAULT '/usr/bin/mozilla',
  `install_directory` varchar(100) DEFAULT '/usr/local/perl_TK',
  `local_web_callerID_URL` varchar(255) DEFAULT 'http://www.vicidial.org/test_callerid_output.php',
  `VICIDIAL_web_URL` varchar(255) DEFAULT 'http://www.vicidial.org/test_VICIDIAL_output.php',
  `AGI_call_logging_enabled` enum('0','1') DEFAULT '1',
  `user_switching_enabled` enum('0','1') DEFAULT '1',
  `conferencing_enabled` enum('0','1') DEFAULT '1',
  `admin_hangup_enabled` enum('0','1') DEFAULT '0',
  `admin_hijack_enabled` enum('0','1') DEFAULT '0',
  `admin_monitor_enabled` enum('0','1') DEFAULT '1',
  `call_parking_enabled` enum('0','1') DEFAULT '1',
  `updater_check_enabled` enum('0','1') DEFAULT '1',
  `AFLogging_enabled` enum('0','1') DEFAULT '1',
  `QUEUE_ACTION_enabled` enum('0','1') DEFAULT '1',
  `CallerID_popup_enabled` enum('0','1') DEFAULT '1',
  `voicemail_button_enabled` enum('0','1') DEFAULT '1',
  `enable_fast_refresh` enum('0','1') DEFAULT '0',
  `fast_refresh_rate` int(5) DEFAULT 1000,
  `enable_persistant_mysql` enum('0','1') DEFAULT '0',
  `auto_dial_next_number` enum('0','1') DEFAULT '1',
  `VDstop_rec_after_each_call` enum('0','1') DEFAULT '1',
  `DBX_server` varchar(15) DEFAULT NULL,
  `DBX_database` varchar(15) DEFAULT 'asterisk',
  `DBX_user` varchar(15) DEFAULT 'cron',
  `DBX_pass` varchar(15) DEFAULT '1234',
  `DBX_port` int(6) DEFAULT 3306,
  `DBY_server` varchar(15) DEFAULT NULL,
  `DBY_database` varchar(15) DEFAULT 'asterisk',
  `DBY_user` varchar(15) DEFAULT 'cron',
  `DBY_pass` varchar(15) DEFAULT '1234',
  `DBY_port` int(6) DEFAULT 3306,
  `outbound_cid` varchar(20) DEFAULT NULL,
  `enable_sipsak_messages` enum('0','1') DEFAULT '0',
  `email` varchar(100) DEFAULT NULL,
  `template_id` varchar(15) NOT NULL,
  `conf_override` text DEFAULT NULL,
  `phone_context` varchar(20) DEFAULT 'default',
  `phone_ring_timeout` smallint(3) DEFAULT 60,
  `conf_secret` varchar(100) DEFAULT 'test',
  `delete_vm_after_email` enum('N','Y') DEFAULT 'N',
  `is_webphone` enum('Y','N','Y_API_LAUNCH') DEFAULT 'N',
  `use_external_server_ip` enum('Y','N') DEFAULT 'N',
  `codecs_list` varchar(100) DEFAULT '',
  `codecs_with_template` enum('0','1') DEFAULT '0',
  `webphone_dialpad` enum('Y','N','TOGGLE','TOGGLE_OFF') DEFAULT 'Y',
  `on_hook_agent` enum('Y','N') DEFAULT 'N',
  `webphone_auto_answer` enum('Y','N') DEFAULT 'Y',
  `voicemail_timezone` varchar(30) DEFAULT 'eastern',
  `voicemail_options` varchar(255) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `voicemail_greeting` varchar(100) DEFAULT '',
  `voicemail_dump_exten_no_inst` varchar(20) DEFAULT '85026666666667',
  `voicemail_instructions` enum('Y','N') DEFAULT 'Y',
  `on_login_report` enum('Y','N') NOT NULL DEFAULT 'N',
  `unavail_dialplan_fwd_exten` varchar(40) DEFAULT '',
  `unavail_dialplan_fwd_context` varchar(100) DEFAULT '',
  `nva_call_url` text DEFAULT NULL,
  `nva_search_method` varchar(40) DEFAULT 'NONE',
  `nva_error_filename` varchar(255) DEFAULT '',
  `nva_new_list_id` bigint(14) unsigned DEFAULT 995,
  `nva_new_phone_code` varchar(10) DEFAULT '1',
  `nva_new_status` varchar(6) DEFAULT 'NVAINS',
  `webphone_dialbox` enum('Y','N') DEFAULT 'Y',
  `webphone_mute` enum('Y','N') DEFAULT 'Y',
  `webphone_volume` enum('Y','N') DEFAULT 'Y',
  `webphone_debug` enum('Y','N') DEFAULT 'N',
  `outbound_alt_cid` varchar(20) DEFAULT '',
  `conf_qualify` enum('Y','N') DEFAULT 'Y',
  `webphone_layout` varchar(255) DEFAULT '',
  `mohsuggest` varchar(100) DEFAULT '',
  `peer_status` enum('UNKNOWN','REGISTERED','UNREGISTERED','REACHABLE','LAGGED','UNREACHABLE') NOT NULL DEFAULT 'UNKNOWN',
  `ping_time` smallint(6) DEFAULT NULL,
  `webphone_settings` varchar(40) DEFAULT 'VICIPHONE_SETTINGS',
  UNIQUE KEY `extenserver` (`extension`,`server_ip`),
  KEY `server_ip` (`server_ip`),
  KEY `voicemail_id` (`voicemail_id`),
  KEY `dialplan_number` (`dialplan_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phones`
--

/*!40000 ALTER TABLE `phones` DISABLE KEYS */;
/*!40000 ALTER TABLE `phones` ENABLE KEYS */;

--
-- Table structure for table `phones_alias`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `phones_alias` (
  `alias_id` varchar(20) NOT NULL,
  `alias_name` varchar(50) DEFAULT NULL,
  `logins_list` varchar(255) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  PRIMARY KEY (`alias_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phones_alias`
--

/*!40000 ALTER TABLE `phones_alias` DISABLE KEYS */;
/*!40000 ALTER TABLE `phones_alias` ENABLE KEYS */;

--
-- Table structure for table `quality_control_checkpoint_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `quality_control_checkpoint_log` (
  `qc_checkpoint_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qc_log_id` int(10) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `qc_scorecard_id` varchar(20) DEFAULT NULL,
  `checkpoint_row_id` int(10) unsigned DEFAULT NULL,
  `checkpoint_text` text DEFAULT NULL,
  `checkpoint_text_presets` text DEFAULT NULL,
  `checkpoint_rank` tinyint(3) unsigned DEFAULT NULL,
  `checkpoint_points` tinyint(3) unsigned DEFAULT NULL,
  `instant_fail` enum('Y','N') DEFAULT 'N',
  `instant_fail_value` enum('Y','N') DEFAULT 'N',
  `checkpoint_points_earned` tinyint(5) unsigned DEFAULT NULL,
  `qc_agent` varchar(20) DEFAULT NULL,
  `checkpoint_comment_agent` text DEFAULT NULL,
  PRIMARY KEY (`qc_checkpoint_log_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quality_control_checkpoint_log`
--

/*!40000 ALTER TABLE `quality_control_checkpoint_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `quality_control_checkpoint_log` ENABLE KEYS */;

--
-- Table structure for table `quality_control_checkpoints`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `quality_control_checkpoints` (
  `checkpoint_row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qc_scorecard_id` varchar(20) DEFAULT NULL,
  `checkpoint_text` text DEFAULT NULL,
  `checkpoint_text_presets` text DEFAULT NULL,
  `checkpoint_rank` int(3) unsigned DEFAULT NULL,
  `checkpoint_points` tinyint(3) unsigned DEFAULT NULL,
  `instant_fail` enum('Y','N') DEFAULT 'N',
  `admin_notes` text DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `campaign_ids` text DEFAULT NULL,
  `ingroups` text DEFAULT NULL,
  `list_ids` text DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `create_user` varchar(10) DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `modify_user` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`checkpoint_row_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quality_control_checkpoints`
--

/*!40000 ALTER TABLE `quality_control_checkpoints` DISABLE KEYS */;
/*!40000 ALTER TABLE `quality_control_checkpoints` ENABLE KEYS */;

--
-- Table structure for table `quality_control_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `quality_control_queue` (
  `qc_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `qc_display_method` enum('CALL','LEAD') DEFAULT 'CALL',
  `lead_id` int(10) unsigned DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `agent_log_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `scorecard_source` enum('CAMPAIGN','INGROUP','LIST') DEFAULT 'CAMPAIGN',
  `qc_web_form_address` varchar(255) DEFAULT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  `recording_id` int(10) unsigned DEFAULT NULL,
  `qc_scorecard_id` varchar(20) DEFAULT NULL,
  `qc_agent` varchar(20) DEFAULT NULL,
  `qc_user_group` varchar(20) DEFAULT NULL,
  `qc_status` varchar(20) DEFAULT NULL,
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `date_claimed` datetime DEFAULT NULL,
  `date_completed` datetime DEFAULT NULL,
  PRIMARY KEY (`qc_log_id`),
  UNIQUE KEY `quality_control_queue_agent_log_id_key` (`agent_log_id`),
  KEY `quality_control_queue_lead_id_key` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quality_control_queue`
--

/*!40000 ALTER TABLE `quality_control_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `quality_control_queue` ENABLE KEYS */;

--
-- Table structure for table `quality_control_scorecards`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `quality_control_scorecards` (
  `qc_scorecard_id` varchar(20) NOT NULL,
  `scorecard_name` varchar(255) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'Y',
  `passing_score` smallint(5) unsigned DEFAULT 0,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`qc_scorecard_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quality_control_scorecards`
--

/*!40000 ALTER TABLE `quality_control_scorecards` DISABLE KEYS */;
/*!40000 ALTER TABLE `quality_control_scorecards` ENABLE KEYS */;

--
-- Table structure for table `recording_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `recording_log` (
  `recording_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` mediumint(8) unsigned DEFAULT NULL,
  `length_in_min` double(8,2) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`recording_id`),
  KEY `filename` (`filename`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `vicidial_id` (`vicidial_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recording_log`
--

/*!40000 ALTER TABLE `recording_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording_log` ENABLE KEYS */;

--
-- Table structure for table `recording_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `recording_log_archive` (
  `recording_id` int(10) unsigned NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` mediumint(8) unsigned DEFAULT NULL,
  `length_in_min` double(8,2) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  UNIQUE KEY `recording_id` (`recording_id`),
  KEY `filename` (`filename`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `vicidial_id` (`vicidial_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recording_log_archive`
--

/*!40000 ALTER TABLE `recording_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording_log_archive` ENABLE KEYS */;

--
-- Table structure for table `recording_log_deletion_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `recording_log_deletion_queue` (
  `recording_id` int(9) unsigned NOT NULL,
  `lead_id` int(10) unsigned DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `date_queued` datetime DEFAULT NULL,
  `date_deleted` datetime DEFAULT NULL,
  PRIMARY KEY (`recording_id`),
  KEY `date_deleted` (`date_deleted`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recording_log_deletion_queue`
--

/*!40000 ALTER TABLE `recording_log_deletion_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording_log_deletion_queue` ENABLE KEYS */;

--
-- Table structure for table `recording_log_stereo`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `recording_log_stereo` (
  `recording_id` int(10) unsigned NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `length_in_sec` mediumint(8) unsigned DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `options` varchar(100) DEFAULT NULL,
  `processing_log` text DEFAULT NULL,
  PRIMARY KEY (`recording_id`),
  KEY `filename` (`filename`),
  KEY `lead_id` (`lead_id`),
  KEY `start_time` (`start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recording_log_stereo`
--

/*!40000 ALTER TABLE `recording_log_stereo` DISABLE KEYS */;
/*!40000 ALTER TABLE `recording_log_stereo` ENABLE KEYS */;

--
-- Table structure for table `routing_initiated_recordings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `routing_initiated_recordings` (
  `recording_id` int(10) unsigned NOT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `launch_time` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `processed` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`recording_id`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `processed` (`processed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routing_initiated_recordings`
--

/*!40000 ALTER TABLE `routing_initiated_recordings` DISABLE KEYS */;
/*!40000 ALTER TABLE `routing_initiated_recordings` ENABLE KEYS */;

--
-- Table structure for table `server_live_drives`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `server_live_drives` (
  `update_time` datetime NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `drive_order` tinyint(3) unsigned DEFAULT 0,
  `drive_device` varchar(100) DEFAULT '',
  `read_sec` decimal(8,2) DEFAULT 0.00,
  `write_sec` decimal(8,2) DEFAULT 0.00,
  `kb_read_sec` decimal(12,2) DEFAULT 0.00,
  `kb_write_sec` decimal(12,2) DEFAULT 0.00,
  `util_pct` decimal(7,2) DEFAULT 0.00,
  UNIQUE KEY `livedrives` (`server_ip`,`drive_device`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_live_drives`
--

/*!40000 ALTER TABLE `server_live_drives` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_live_drives` ENABLE KEYS */;

--
-- Table structure for table `server_live_partitions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `server_live_partitions` (
  `update_time` datetime NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `partition_order` tinyint(3) unsigned DEFAULT 0,
  `partition_path` varchar(100) DEFAULT '',
  `partition_filesystem` varchar(100) DEFAULT '',
  `use_pct` tinyint(3) unsigned DEFAULT 0,
  `mb_used` bigint(14) DEFAULT 0,
  `mb_available` bigint(14) DEFAULT 0,
  UNIQUE KEY `livepartitions` (`server_ip`,`partition_path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_live_partitions`
--

/*!40000 ALTER TABLE `server_live_partitions` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_live_partitions` ENABLE KEYS */;

--
-- Table structure for table `server_live_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `server_live_stats` (
  `update_time` datetime NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `server_name` varchar(100) NOT NULL,
  `cpu_count` smallint(5) unsigned DEFAULT 0,
  `loadavg_1` decimal(8,2) DEFAULT 0.00,
  `loadavg_5` decimal(8,2) DEFAULT 0.00,
  `loadavg_15` decimal(8,2) DEFAULT 0.00,
  `freeram` int(9) DEFAULT 0,
  `usedram` int(9) DEFAULT 0,
  `processes` smallint(4) DEFAULT 0,
  `system_uptime` varchar(255) DEFAULT '',
  `cpu_user_percent` decimal(6,2) DEFAULT 0.00,
  `cpu_sys_percent` decimal(6,2) DEFAULT 0.00,
  `cpu_idle_percent` decimal(6,2) DEFAULT 0.00,
  `cpu_iowait_percent` decimal(6,2) DEFAULT 0.00,
  `cpu_vm_percent` decimal(6,2) DEFAULT 0.00,
  `disk_reads` int(9) unsigned DEFAULT 0,
  `disk_writes` int(9) unsigned DEFAULT 0,
  `asterisk_channels_total` smallint(4) unsigned DEFAULT 0,
  `asterisk_agents_total` smallint(4) unsigned DEFAULT 0,
  `mysql_uptime` varchar(20) DEFAULT '0',
  `mysql_queries_per_second` int(9) unsigned DEFAULT 0,
  `mysql_connections` mediumint(7) unsigned DEFAULT 0,
  UNIQUE KEY `liveservers` (`server_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_live_stats`
--

/*!40000 ALTER TABLE `server_live_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_live_stats` ENABLE KEYS */;

--
-- Table structure for table `server_performance`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `server_performance` (
  `start_time` datetime NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `sysload` int(6) NOT NULL,
  `freeram` smallint(5) unsigned NOT NULL,
  `usedram` smallint(5) unsigned NOT NULL,
  `processes` smallint(4) unsigned NOT NULL,
  `channels_total` smallint(4) unsigned NOT NULL,
  `trunks_total` smallint(4) unsigned NOT NULL,
  `clients_total` smallint(4) unsigned NOT NULL,
  `clients_zap` smallint(4) unsigned NOT NULL,
  `clients_iax` smallint(4) unsigned NOT NULL,
  `clients_local` smallint(4) unsigned NOT NULL,
  `clients_sip` smallint(4) unsigned NOT NULL,
  `live_recordings` smallint(4) unsigned NOT NULL,
  `cpu_user_percent` smallint(3) unsigned NOT NULL DEFAULT 0,
  `cpu_system_percent` smallint(3) unsigned NOT NULL DEFAULT 0,
  `cpu_idle_percent` smallint(3) unsigned NOT NULL DEFAULT 0,
  `disk_reads` mediumint(7) DEFAULT NULL,
  `disk_writes` mediumint(7) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_performance`
--

/*!40000 ALTER TABLE `server_performance` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_performance` ENABLE KEYS */;

--
-- Table structure for table `server_updater`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `server_updater` (
  `server_ip` varchar(15) NOT NULL,
  `last_update` datetime DEFAULT NULL,
  `db_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `serverip` (`server_ip`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `server_updater`
--

/*!40000 ALTER TABLE `server_updater` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_updater` ENABLE KEYS */;

--
-- Table structure for table `servers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `servers` (
  `server_id` varchar(10) NOT NULL,
  `server_description` varchar(255) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `asterisk_version` varchar(20) DEFAULT '1.4.21.2',
  `max_vicidial_trunks` smallint(4) DEFAULT 23,
  `telnet_host` varchar(20) NOT NULL DEFAULT 'localhost',
  `telnet_port` int(5) NOT NULL DEFAULT 5038,
  `ASTmgrUSERNAME` varchar(20) NOT NULL DEFAULT 'cron',
  `ASTmgrSECRET` varchar(20) NOT NULL DEFAULT '1234',
  `ASTmgrUSERNAMEupdate` varchar(20) NOT NULL DEFAULT 'updatecron',
  `ASTmgrUSERNAMElisten` varchar(20) NOT NULL DEFAULT 'listencron',
  `ASTmgrUSERNAMEsend` varchar(20) NOT NULL DEFAULT 'sendcron',
  `local_gmt` varchar(6) DEFAULT '-5.00',
  `voicemail_dump_exten` varchar(20) NOT NULL DEFAULT '85026666666666',
  `answer_transfer_agent` varchar(20) NOT NULL DEFAULT '8365',
  `ext_context` varchar(20) NOT NULL DEFAULT 'default',
  `sys_perf_log` enum('Y','N') DEFAULT 'N',
  `vd_server_logs` enum('Y','N') DEFAULT 'Y',
  `agi_output` enum('NONE','STDERR','FILE','BOTH') DEFAULT 'FILE',
  `vicidial_balance_active` enum('Y','N') DEFAULT 'N',
  `balance_trunks_offlimits` smallint(5) unsigned DEFAULT 0,
  `recording_web_link` enum('SERVER_IP','ALT_IP','EXTERNAL_IP') DEFAULT 'SERVER_IP',
  `alt_server_ip` varchar(100) DEFAULT '',
  `active_asterisk_server` enum('Y','N') DEFAULT 'Y',
  `generate_vicidial_conf` enum('Y','N') DEFAULT 'Y',
  `rebuild_conf_files` enum('Y','N') DEFAULT 'Y',
  `outbound_calls_per_second` smallint(3) unsigned DEFAULT 5,
  `sysload` int(6) NOT NULL DEFAULT 0,
  `channels_total` smallint(4) unsigned NOT NULL DEFAULT 0,
  `cpu_idle_percent` smallint(3) unsigned NOT NULL DEFAULT 0,
  `disk_usage` varchar(255) DEFAULT '1',
  `sounds_update` enum('Y','N') DEFAULT 'N',
  `vicidial_recording_limit` mediumint(8) DEFAULT 60,
  `carrier_logging_active` enum('Y','N') DEFAULT 'Y',
  `vicidial_balance_rank` tinyint(3) unsigned DEFAULT 0,
  `rebuild_music_on_hold` enum('Y','N') DEFAULT 'Y',
  `active_agent_login_server` enum('Y','N') DEFAULT 'Y',
  `conf_secret` varchar(100) DEFAULT 'test',
  `external_server_ip` varchar(100) DEFAULT '',
  `custom_dialplan_entry` text DEFAULT NULL,
  `active_twin_server_ip` varchar(15) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `audio_store_purge` text DEFAULT NULL,
  `svn_revision` int(9) DEFAULT 0,
  `svn_info` text DEFAULT NULL,
  `system_uptime` varchar(255) DEFAULT '',
  `auto_restart_asterisk` enum('Y','N') DEFAULT 'N',
  `asterisk_temp_no_restart` enum('Y','N') DEFAULT 'N',
  `voicemail_dump_exten_no_inst` varchar(20) DEFAULT '85026666666667',
  `gather_asterisk_output` enum('Y','N') DEFAULT 'N',
  `web_socket_url` varchar(255) DEFAULT '',
  `conf_qualify` enum('Y','N') DEFAULT 'Y',
  `routing_prefix` varchar(10) DEFAULT '13',
  `external_web_socket_url` varchar(255) DEFAULT '',
  `conf_engine` enum('MEETME','CONFBRIDGE') DEFAULT 'MEETME',
  `conf_update_interval` smallint(6) NOT NULL DEFAULT 60,
  `ara_url` text DEFAULT NULL,
  UNIQUE KEY `server_id` (`server_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servers`
--

/*!40000 ALTER TABLE `servers` DISABLE KEYS */;
/*!40000 ALTER TABLE `servers` ENABLE KEYS */;

--
-- Table structure for table `system_settings`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `system_settings` (
  `version` varchar(50) DEFAULT NULL,
  `install_date` varchar(50) DEFAULT NULL,
  `use_non_latin` enum('0','1') DEFAULT '0',
  `webroot_writable` enum('0','1') DEFAULT '1',
  `enable_queuemetrics_logging` enum('0','1') DEFAULT '0',
  `queuemetrics_server_ip` varchar(15) DEFAULT NULL,
  `queuemetrics_dbname` varchar(50) DEFAULT NULL,
  `queuemetrics_login` varchar(50) DEFAULT NULL,
  `queuemetrics_pass` varchar(50) DEFAULT NULL,
  `queuemetrics_url` varchar(255) DEFAULT NULL,
  `queuemetrics_log_id` varchar(10) DEFAULT 'VIC',
  `queuemetrics_eq_prepend` varchar(255) DEFAULT 'NONE',
  `vicidial_agent_disable` enum('NOT_ACTIVE','LIVE_AGENT','EXTERNAL','ALL') DEFAULT 'ALL',
  `allow_sipsak_messages` enum('0','1') DEFAULT '0',
  `admin_home_url` varchar(255) DEFAULT '../vicidial/welcome.php',
  `enable_agc_xfer_log` enum('0','1') DEFAULT '0',
  `db_schema_version` int(8) unsigned DEFAULT 0,
  `auto_user_add_value` int(9) unsigned DEFAULT 101,
  `timeclock_end_of_day` varchar(4) DEFAULT '0000',
  `timeclock_last_reset_date` date DEFAULT NULL,
  `vdc_header_date_format` varchar(50) DEFAULT 'MS_DASH_24HR  2008-06-24 23:59:59',
  `vdc_customer_date_format` varchar(50) DEFAULT 'AL_TEXT_AMPM  OCT 24, 2008 11:59:59 PM',
  `vdc_header_phone_format` varchar(50) DEFAULT 'US_PARN (000)000-0000',
  `vdc_agent_api_active` enum('0','1') DEFAULT '0',
  `qc_last_pull_time` datetime DEFAULT NULL,
  `enable_vtiger_integration` enum('0','1') DEFAULT '0',
  `vtiger_server_ip` varchar(15) DEFAULT NULL,
  `vtiger_dbname` varchar(50) DEFAULT NULL,
  `vtiger_login` varchar(50) DEFAULT NULL,
  `vtiger_pass` varchar(50) DEFAULT NULL,
  `vtiger_url` varchar(255) DEFAULT NULL,
  `qc_features_active` enum('1','0') DEFAULT '0',
  `outbound_autodial_active` enum('1','0') DEFAULT '1',
  `outbound_calls_per_second` smallint(3) unsigned DEFAULT 10,
  `enable_tts_integration` enum('0','1') DEFAULT '0',
  `agentonly_callback_campaign_lock` enum('0','1') DEFAULT '1',
  `sounds_central_control_active` enum('0','1') DEFAULT '0',
  `sounds_web_server` varchar(50) DEFAULT '127.0.0.1',
  `sounds_web_directory` varchar(255) DEFAULT '',
  `active_voicemail_server` varchar(15) DEFAULT '',
  `auto_dial_limit` varchar(5) DEFAULT '4',
  `user_territories_active` enum('0','1') DEFAULT '0',
  `allow_custom_dialplan` enum('0','1') DEFAULT '1',
  `db_schema_update_date` datetime DEFAULT NULL,
  `enable_second_webform` enum('0','1') DEFAULT '1',
  `default_webphone` enum('1','0') DEFAULT '0',
  `default_external_server_ip` enum('1','0') DEFAULT '0',
  `webphone_url` varchar(255) DEFAULT '',
  `static_agent_url` varchar(255) DEFAULT '',
  `default_phone_code` varchar(8) DEFAULT '1',
  `enable_agc_dispo_log` enum('0','1') DEFAULT '0',
  `custom_dialplan_entry` text DEFAULT NULL,
  `queuemetrics_loginout` enum('STANDARD','CALLBACK','NONE') DEFAULT 'STANDARD',
  `callcard_enabled` enum('1','0') DEFAULT '0',
  `queuemetrics_callstatus` enum('0','1') DEFAULT '1',
  `default_codecs` varchar(100) DEFAULT '',
  `custom_fields_enabled` enum('0','1') DEFAULT '0',
  `admin_web_directory` varchar(255) DEFAULT 'vicidial',
  `label_title` varchar(60) DEFAULT '',
  `label_first_name` varchar(60) DEFAULT '',
  `label_middle_initial` varchar(60) DEFAULT '',
  `label_last_name` varchar(60) DEFAULT '',
  `label_address1` varchar(60) DEFAULT '',
  `label_address2` varchar(60) DEFAULT '',
  `label_address3` varchar(60) DEFAULT '',
  `label_city` varchar(60) DEFAULT '',
  `label_state` varchar(60) DEFAULT '',
  `label_province` varchar(60) DEFAULT '',
  `label_postal_code` varchar(60) DEFAULT '',
  `label_vendor_lead_code` varchar(60) DEFAULT '',
  `label_gender` varchar(60) DEFAULT '',
  `label_phone_number` varchar(60) DEFAULT '',
  `label_phone_code` varchar(60) DEFAULT '',
  `label_alt_phone` varchar(60) DEFAULT '',
  `label_security_phrase` varchar(60) DEFAULT '',
  `label_email` varchar(60) DEFAULT '',
  `label_comments` varchar(60) DEFAULT '',
  `slave_db_server` varchar(50) DEFAULT '',
  `reports_use_slave_db` varchar(4000) DEFAULT '',
  `webphone_systemkey` varchar(100) DEFAULT '',
  `first_login_trigger` enum('Y','N') DEFAULT 'N',
  `hosted_settings` varchar(100) DEFAULT '',
  `default_phone_registration_password` varchar(100) DEFAULT 'test',
  `default_phone_login_password` varchar(100) DEFAULT 'test',
  `default_server_password` varchar(100) DEFAULT 'test',
  `admin_modify_refresh` smallint(5) unsigned DEFAULT 0,
  `nocache_admin` enum('0','1') DEFAULT '1',
  `generate_cross_server_exten` enum('0','1') DEFAULT '0',
  `queuemetrics_addmember_enabled` enum('0','1') DEFAULT '0',
  `queuemetrics_dispo_pause` varchar(6) DEFAULT '',
  `label_hide_field_logs` varchar(6) DEFAULT 'Y',
  `queuemetrics_pe_phone_append` enum('0','1') DEFAULT '0',
  `test_campaign_calls` enum('0','1') DEFAULT '0',
  `agents_calls_reset` enum('0','1') DEFAULT '1',
  `voicemail_timezones` text DEFAULT NULL,
  `default_voicemail_timezone` varchar(30) DEFAULT 'eastern',
  `default_local_gmt` varchar(6) DEFAULT '-5.00',
  `noanswer_log` enum('Y','N') DEFAULT 'N',
  `alt_log_server_ip` varchar(50) DEFAULT '',
  `alt_log_dbname` varchar(50) DEFAULT '',
  `alt_log_login` varchar(50) DEFAULT '',
  `alt_log_pass` varchar(50) DEFAULT '',
  `tables_use_alt_log_db` varchar(2000) DEFAULT '',
  `did_agent_log` enum('Y','N') DEFAULT 'N',
  `campaign_cid_areacodes_enabled` enum('0','1') DEFAULT '1',
  `pllb_grouping_limit` smallint(5) DEFAULT 100,
  `did_ra_extensions_enabled` enum('0','1') DEFAULT '0',
  `expanded_list_stats` enum('0','1') DEFAULT '1',
  `contacts_enabled` enum('0','1') DEFAULT '0',
  `svn_version` varchar(100) DEFAULT '',
  `call_menu_qualify_enabled` enum('0','1') DEFAULT '0',
  `admin_list_counts` enum('0','1') DEFAULT '1',
  `allow_voicemail_greeting` enum('0','1') DEFAULT '0',
  `audio_store_purge` text DEFAULT NULL,
  `svn_revision` int(9) DEFAULT 0,
  `queuemetrics_socket` varchar(20) DEFAULT 'NONE',
  `queuemetrics_socket_url` text DEFAULT NULL,
  `enhanced_disconnect_logging` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `allow_emails` enum('0','1') DEFAULT '0',
  `level_8_disable_add` enum('0','1') DEFAULT '0',
  `pass_hash_enabled` enum('0','1') DEFAULT '0',
  `pass_key` varchar(100) DEFAULT '',
  `pass_cost` tinyint(2) unsigned DEFAULT 2,
  `disable_auto_dial` enum('0','1') DEFAULT '0',
  `queuemetrics_record_hold` enum('0','1') DEFAULT '0',
  `country_code_list_stats` enum('0','1') DEFAULT '0',
  `reload_timestamp` datetime DEFAULT NULL,
  `queuemetrics_pause_type` enum('0','1') DEFAULT '0',
  `frozen_server_call_clear` enum('0','1') DEFAULT '0',
  `callback_time_24hour` enum('0','1') DEFAULT '0',
  `active_modules` text DEFAULT NULL,
  `allow_chats` enum('0','1') DEFAULT '0',
  `enable_languages` enum('0','1') DEFAULT '0',
  `language_method` varchar(20) DEFAULT 'DISABLED',
  `meetme_enter_login_filename` varchar(255) DEFAULT '',
  `meetme_enter_leave3way_filename` varchar(255) DEFAULT '',
  `enable_did_entry_list_id` enum('0','1') DEFAULT '0',
  `enable_third_webform` enum('0','1') DEFAULT '0',
  `chat_url` varchar(255) DEFAULT NULL,
  `chat_timeout` int(3) unsigned DEFAULT NULL,
  `agent_debug_logging` varchar(20) DEFAULT '0',
  `default_language` varchar(100) DEFAULT 'default English',
  `agent_whisper_enabled` enum('0','1') DEFAULT '0',
  `user_hide_realtime_enabled` enum('0','1') DEFAULT '0',
  `custom_reports_use_slave_db` varchar(2000) DEFAULT '',
  `usacan_phone_dialcode_fix` enum('0','1') DEFAULT '0',
  `cache_carrier_stats_realtime` enum('0','1') DEFAULT '0',
  `oldest_logs_date` datetime DEFAULT NULL,
  `log_recording_access` enum('0','1') DEFAULT '0',
  `report_default_format` enum('TEXT','HTML') DEFAULT 'TEXT',
  `alt_ivr_logging` enum('0','1') DEFAULT '0',
  `admin_row_click` enum('0','1') DEFAULT '1',
  `admin_screen_colors` varchar(20) DEFAULT 'default',
  `ofcom_uk_drop_calc` enum('1','0') DEFAULT '0',
  `agent_screen_colors` varchar(20) DEFAULT 'default',
  `script_remove_js` enum('1','0','2','3','4','5','6') DEFAULT '1',
  `manual_auto_next` enum('1','0') DEFAULT '0',
  `user_new_lead_limit` enum('1','0') DEFAULT '0',
  `agent_xfer_park_3way` enum('1','0') DEFAULT '0',
  `rec_prompt_count` int(9) unsigned DEFAULT 0,
  `agent_soundboards` enum('1','0') DEFAULT '0',
  `web_loader_phone_length` varchar(10) DEFAULT 'DISABLED',
  `agent_script` varchar(50) DEFAULT 'vicidial.php',
  `vdad_debug_logging` enum('1','0') DEFAULT '0',
  `agent_chat_screen_colors` varchar(20) DEFAULT 'default',
  `enable_auto_reports` enum('1','0') DEFAULT '0',
  `enable_pause_code_limits` enum('1','0') DEFAULT '0',
  `enable_drop_lists` enum('0','1','2') DEFAULT '0',
  `allow_ip_lists` enum('0','1','2') DEFAULT '0',
  `system_ip_blacklist` varchar(30) DEFAULT '',
  `agent_push_events` enum('0','1') DEFAULT '0',
  `agent_push_url` text DEFAULT NULL,
  `hide_inactive_lists` enum('0','1') DEFAULT '0',
  `allow_manage_active_lists` enum('0','1') DEFAULT '0',
  `expired_lists_inactive` enum('0','1') DEFAULT '0',
  `did_system_filter` enum('0','1') DEFAULT '0',
  `anyone_callback_inactive_lists` enum('default','NO_ADD_TO_HOPPER','KEEP_IN_HOPPER') DEFAULT 'default',
  `enable_gdpr_download_deletion` enum('0','1','2') DEFAULT '0',
  `source_id_display` enum('0','1') DEFAULT '0',
  `help_modification_date` varchar(20) DEFAULT '0',
  `agent_logout_link` enum('0','1','2','3','4') DEFAULT '1',
  `manual_dial_validation` enum('0','1','2','3','4') DEFAULT '0',
  `mute_recordings` enum('1','0') DEFAULT '0',
  `user_admin_redirect` enum('1','0') DEFAULT '0',
  `list_status_modification_confirmation` enum('1','0') DEFAULT '0',
  `sip_event_logging` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `call_quota_lead_ranking` enum('0','1','2') DEFAULT '0',
  `enable_second_script` enum('0','1') DEFAULT '0',
  `enable_first_webform` enum('0','1') DEFAULT '1',
  `recording_buttons` varchar(30) DEFAULT 'START_STOP',
  `opensips_cid_name` enum('0','1') DEFAULT '0',
  `require_password_length` tinyint(3) unsigned DEFAULT 0,
  `user_account_emails` enum('DISABLED','SEND_NO_PASS','SEND_WITH_PASS') DEFAULT 'DISABLED',
  `outbound_cid_any` enum('DISABLED','API_ONLY') DEFAULT 'DISABLED',
  `entries_per_page` smallint(5) unsigned DEFAULT 0,
  `browser_call_alerts` enum('0','1','2') DEFAULT '0',
  `queuemetrics_pausereason` enum('STANDARD','EVERY_NEW','EVERY_NEW_ADMINCALL','EVERY_NEW_ALLCALL') DEFAULT 'STANDARD',
  `inbound_answer_config` enum('0','1','2','3','4','5') DEFAULT '0',
  `enable_international_dncs` enum('0','1') DEFAULT '0',
  `web_loader_phone_strip` varchar(10) DEFAULT 'DISABLED',
  `manual_dial_phone_strip` varchar(10) DEFAULT 'DISABLED',
  `daily_call_count_limit` enum('0','1') DEFAULT '0',
  `allow_shared_dial` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `agent_search_method` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `phone_defaults_container` varchar(40) DEFAULT '---DISABLED---',
  `qc_claim_limit` tinyint(3) unsigned DEFAULT 3,
  `qc_expire_days` tinyint(3) unsigned DEFAULT 3,
  `two_factor_auth_hours` smallint(5) DEFAULT 0,
  `two_factor_container` varchar(40) DEFAULT '---DISABLED---',
  `agent_hidden_sound` varchar(20) DEFAULT 'click_quiet',
  `agent_hidden_sound_volume` tinyint(3) unsigned DEFAULT 25,
  `agent_hidden_sound_seconds` tinyint(3) unsigned DEFAULT 0,
  `agent_screen_timer` varchar(20) DEFAULT 'setTimeout',
  `label_lead_id` varchar(60) DEFAULT '',
  `label_list_id` varchar(60) DEFAULT '',
  `label_entry_date` varchar(60) DEFAULT '',
  `label_gmt_offset_now` varchar(60) DEFAULT '',
  `label_source_id` varchar(60) DEFAULT '',
  `label_called_since_last_reset` varchar(60) DEFAULT '',
  `label_status` varchar(60) DEFAULT '',
  `label_user` varchar(60) DEFAULT '',
  `label_date_of_birth` varchar(60) DEFAULT '',
  `label_country_code` varchar(60) DEFAULT '',
  `label_last_local_call_time` varchar(60) DEFAULT '',
  `label_called_count` varchar(60) DEFAULT '',
  `label_rank` varchar(60) DEFAULT '',
  `label_owner` varchar(60) DEFAULT '',
  `label_entry_list_id` varchar(60) DEFAULT '',
  `call_limit_24hour` enum('0','1') DEFAULT '0',
  `call_limit_24hour_reset` datetime DEFAULT '2000-01-01 00:00:01',
  `allowed_sip_stacks` enum('SIP','PJSIP','SIP_and_PJSIP') DEFAULT 'SIP',
  `agent_hide_hangup` enum('1','0','2','3','4','5','6') DEFAULT '0',
  `allow_web_debug` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `max_logged_in_agents` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `user_codes_admin` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `login_kickall` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `abandon_check_queue` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `agent_notifications` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `demographic_quotas` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `log_latency_gaps` enum('0','1','2','3','4','5','6','7') DEFAULT '1',
  `inbound_credits` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `weekday_resets` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `two_factor_auth_agent_hours` smallint(5) DEFAULT 0,
  `highest_lead_id` varchar(20) DEFAULT '0',
  `hopper_hold_inserts` enum('0','1','2','3','4','5','6','7') DEFAULT '0',
  `coldstorage_server_ip` varchar(50) DEFAULT '',
  `coldstorage_dbname` varchar(50) DEFAULT '',
  `coldstorage_login` varchar(50) DEFAULT '',
  `coldstorage_pass` varchar(50) DEFAULT '',
  `coldstorage_port` varchar(10) DEFAULT '',
  `stereo_recording` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `enhanced_agent_monitoring` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `agent_hide_dial_fail` enum('0','1','2','3','4','5','6') DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` 
SELECT '2.14b0.5','2025-06-23','0','1','0',NULL,NULL,NULL,NULL,NULL,'VIC','NONE','ALL','0','../vicidial/welcome.php','0',1726,101,'0000','2025-06-23','MS_DASH_24HR  2008-06-24 23:59:59','AL_TEXT_AMPM  OCT 24, 2008 11:59:59 PM','US_PARN (000)000-0000','1','2025-06-23 12:43:09','0',NULL,NULL,NULL,NULL,NULL,'0','1',10,'0','1','0','127.0.0.1','','','4','0','1','2025-06-23 12:43:10','1','0','0','https://phone.viciphone.com/v3.0/viciphone.php','','1','0',NULL,'STANDARD','0','1','','0','vicidial','','','','','','','','','','','','','','','','','','','','','','','Y','','HhFabkkE5bAvb8V','test','feZGKCmQ4o9x7Hh',0,'1','0','0','','Y','0','0','1','newzealand=Pacific/Auckland\naustraliaeast=Australia/Sydney\naustraliacentral=Australia/Adelaide\naustraliawest=Australia/Perth\njapan=Asia/Tokyo\nphilippines=Asia/Manila\nchina=Asia/Shanghai\nmalaysia=Asia/Kuala_Lumpur\nthailand=Asia/Bangkok\nindia=Asia/Calcutta\npakistan=Asia/Karachi\nrussiaeast=Europe/Moscow\nkenya=Africa/Nairobi\neuropeaneast=Europe/Kiev\nsouthafrica=Africa/Johannesburg\neuropean=Europe/Copenhagen\nnigeria=Africa/Lagos\nuk=Europe/London\nbrazil=America/Sao_Paulo\nnewfoundland=Canada/Newfoundland\ncarribeaneast=America/Santo_Domingo\natlantic=Canada/Atlantic\nchile=America/Santiago\neastern=America/New_York\nperu=America/Lima\ncentral=America/Chicago\nmexicocity=America/Mexico_City\nmountain=America/Denver\narizona=America/Phoenix\nsaskatchewan=America/Saskatchewan\npacific=America/Los_Angeles\nalaska=America/Anchorage\nhawaii=Pacific/Honolulu\neastern24=America/New_York\ncentral24=America/Chicago\nmountain24=America/Denver\npacific24=America/Los_Angeles\nmilitary=Zulu\n','eastern','-5.00','N','','','','','','N','1',100,'0','1','0','','0','1','0',NULL,3927,'NONE',NULL,'0','0','0','0','',2,'0','0','0','2025-06-23 12:43:10','0','0','0',NULL,'0','0','DISABLED','','','0','0',NULL,NULL,'0','default English','0','0','','0','0',NULL,'0','TEXT','0','1','default','0','default','1','0','0','0',0,'0','DISABLED','vicidial.php','0','default','0','0','0','0','','0',NULL,'0','0','0','0','default','0','0','0','1','0','0','0','0','0','0','0','1','START_STOP','0',0,'DISABLED','DISABLED',0,'0','STANDARD','0','0','DISABLED','DISABLED','0','0','0','---DISABLED---',3,3,0,'---DISABLED---','click_quiet',25,0,'setTimeout','','','','','','','','','','','','','','','','0','2000-01-01 00:00:01','SIP_and_PJSIP','0','0','0','0','0','0','0','0','1','0','0',0,'0','0','','','','','','0','0','0'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM system_settings);
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;

--
-- Table structure for table `twoday_call_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `twoday_call_log` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `channel_group` varchar(30) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `number_dialed` varchar(15) DEFAULT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `start_epoch` int(10) DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `end_epoch` int(10) DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `length_in_min` double(8,2) DEFAULT NULL,
  PRIMARY KEY (`uniqueid`),
  KEY `caller_code` (`caller_code`),
  KEY `server_ip` (`server_ip`),
  KEY `channel` (`channel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twoday_call_log`
--

/*!40000 ALTER TABLE `twoday_call_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `twoday_call_log` ENABLE KEYS */;

--
-- Table structure for table `twoday_recording_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `twoday_recording_log` (
  `recording_id` int(10) unsigned NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` mediumint(8) unsigned DEFAULT NULL,
  `length_in_min` double(8,2) DEFAULT NULL,
  `filename` varchar(50) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`recording_id`),
  KEY `filename` (`filename`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `vicidial_id` (`vicidial_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twoday_recording_log`
--

/*!40000 ALTER TABLE `twoday_recording_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `twoday_recording_log` ENABLE KEYS */;

--
-- Table structure for table `twoday_vicidial_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `twoday_vicidial_agent_log` (
  `agent_log_id` int(9) unsigned NOT NULL,
  `user` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `event_time` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `pause_epoch` int(10) unsigned DEFAULT NULL,
  `pause_sec` smallint(5) unsigned DEFAULT 0,
  `wait_epoch` int(10) unsigned DEFAULT NULL,
  `wait_sec` smallint(5) unsigned DEFAULT 0,
  `talk_epoch` int(10) unsigned DEFAULT NULL,
  `talk_sec` smallint(5) unsigned DEFAULT 0,
  `dispo_epoch` int(10) unsigned DEFAULT NULL,
  `dispo_sec` smallint(5) unsigned DEFAULT 0,
  `status` varchar(6) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `comments` varchar(20) DEFAULT NULL,
  `sub_status` varchar(6) DEFAULT NULL,
  `dead_epoch` int(10) unsigned DEFAULT NULL,
  `dead_sec` smallint(5) unsigned DEFAULT 0,
  `processed` enum('Y','N') DEFAULT 'N',
  `uniqueid` varchar(20) DEFAULT '',
  PRIMARY KEY (`agent_log_id`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `event_time` (`event_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twoday_vicidial_agent_log`
--

/*!40000 ALTER TABLE `twoday_vicidial_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `twoday_vicidial_agent_log` ENABLE KEYS */;

--
-- Table structure for table `twoday_vicidial_closer_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `twoday_vicidial_closer_log` (
  `closecallid` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `queue_seconds` decimal(7,2) DEFAULT 0.00,
  `user_group` varchar(20) DEFAULT NULL,
  `xfercallid` int(9) unsigned DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','HOLDRECALLXFER','HOLDTIME','NOAGENT','NONE','MAXCALLS','ACFILTER') DEFAULT 'NONE',
  `uniqueid` varchar(20) NOT NULL DEFAULT '',
  `agent_only` varchar(20) DEFAULT '',
  `queue_position` smallint(4) unsigned DEFAULT 1,
  `called_count` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`closecallid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `campaign_id` (`campaign_id`),
  KEY `uniqueid` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twoday_vicidial_closer_log`
--

/*!40000 ALTER TABLE `twoday_vicidial_closer_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `twoday_vicidial_closer_log` ENABLE KEYS */;

--
-- Table structure for table `twoday_vicidial_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `twoday_vicidial_log` (
  `uniqueid` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','NONE','SYSTEM') DEFAULT 'NONE',
  `alt_dial` varchar(6) DEFAULT 'NONE',
  PRIMARY KEY (`uniqueid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twoday_vicidial_log`
--

/*!40000 ALTER TABLE `twoday_vicidial_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `twoday_vicidial_log` ENABLE KEYS */;

--
-- Table structure for table `twoday_vicidial_xfer_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `twoday_vicidial_xfer_log` (
  `xfercallid` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `closer` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`xfercallid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `twoday_vicidial_xfer_log`
--

/*!40000 ALTER TABLE `twoday_vicidial_xfer_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `twoday_vicidial_xfer_log` ENABLE KEYS */;

--
-- Table structure for table `user_call_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `user_call_log` (
  `user_call_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `call_type` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `number_dialed` varchar(30) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `group_alias_id` varchar(30) DEFAULT NULL,
  `preset_name` varchar(40) DEFAULT '',
  `campaign_id` varchar(20) DEFAULT '',
  `customer_hungup` enum('BEFORE_CALL','DURING_CALL','') DEFAULT '',
  `customer_hungup_seconds` smallint(5) unsigned DEFAULT 0,
  `xfer_hungup` varchar(20) DEFAULT '',
  `xfer_hungup_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`user_call_log_id`),
  KEY `user` (`user`),
  KEY `call_date` (`call_date`),
  KEY `group_alias_id` (`group_alias_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_call_log`
--

/*!40000 ALTER TABLE `user_call_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_call_log` ENABLE KEYS */;

--
-- Table structure for table `user_call_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `user_call_log_archive` (
  `user_call_log_id` int(9) unsigned NOT NULL,
  `user` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `call_type` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `number_dialed` varchar(30) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `group_alias_id` varchar(30) DEFAULT NULL,
  `preset_name` varchar(40) DEFAULT '',
  `campaign_id` varchar(20) DEFAULT '',
  `customer_hungup` enum('BEFORE_CALL','DURING_CALL','') DEFAULT '',
  `customer_hungup_seconds` smallint(5) unsigned DEFAULT 0,
  `xfer_hungup` varchar(20) DEFAULT '',
  `xfer_hungup_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`user_call_log_id`),
  KEY `user` (`user`),
  KEY `call_date` (`call_date`),
  KEY `group_alias_id` (`group_alias_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_call_log_archive`
--

/*!40000 ALTER TABLE `user_call_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_call_log_archive` ENABLE KEYS */;

--
-- Table structure for table `verm_custom_report_holder`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `verm_custom_report_holder` (
  `custom_report_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `report_name` varchar(100) DEFAULT NULL,
  `report_parameters` text DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`custom_report_id`),
  UNIQUE KEY `verm_custom_report_holder_pkey` (`user`,`report_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verm_custom_report_holder`
--

/*!40000 ALTER TABLE `verm_custom_report_holder` DISABLE KEYS */;
/*!40000 ALTER TABLE `verm_custom_report_holder` ENABLE KEYS */;

--
-- Table structure for table `vicibox`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicibox` (
  `server_id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `server` varchar(32) NOT NULL,
  `server_ip` varchar(32) NOT NULL,
  `server_type` enum('Database','Web','Telephony','Archive') NOT NULL DEFAULT 'Telephony',
  `field1` varchar(64) DEFAULT NULL,
  `field2` varchar(64) DEFAULT NULL,
  `field3` varchar(64) DEFAULT NULL,
  `field4` varchar(64) DEFAULT NULL,
  `field5` varchar(64) DEFAULT NULL,
  `field6` varchar(64) DEFAULT NULL,
  `field7` varchar(64) DEFAULT NULL,
  `field8` varchar(64) DEFAULT NULL,
  `field9` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`server_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicibox`
--

/*!40000 ALTER TABLE `vicibox` DISABLE KEYS */;
INSERT INTO `vicibox`  select 1,'vicibox12','10.10.1.81','Database','0','asterisk','3927','cron','1234','custom','custom1234','slave','slave1234' as data WHERE NOT EXISTS (SELECT 1 FROM vicibox);
/*!40000 ALTER TABLE `vicibox` ENABLE KEYS */;

--
-- Table structure for table `vicidial_3way_press_live`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_3way_press_live` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `call_3way_id` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `dialstring` varchar(28) DEFAULT NULL,
  `outbound_cid` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `session_id` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `session_id_3way` varchar(20) DEFAULT '',
  `status` varchar(40) DEFAULT NULL,
  `call_channel` varchar(100) DEFAULT '',
  `agent_heartbeat` datetime DEFAULT NULL,
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `call_3way_id` (`call_3way_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_3way_press_live`
--

/*!40000 ALTER TABLE `vicidial_3way_press_live` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_3way_press_live` ENABLE KEYS */;

--
-- Table structure for table `vicidial_3way_press_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_3way_press_log` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `call_3way_id` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `dialstring` varchar(28) DEFAULT NULL,
  `outbound_cid` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `session_id` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `session_id_3way` varchar(20) DEFAULT '',
  `result` text DEFAULT NULL,
  `call_channel` varchar(100) DEFAULT '',
  `call_transfer` enum('N','Y') DEFAULT 'N',
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `call_3way_id` (`call_3way_id`),
  KEY `lead_id` (`lead_id`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_3way_press_log`
--

/*!40000 ALTER TABLE `vicidial_3way_press_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_3way_press_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_3way_press_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_3way_press_log_archive` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `call_3way_id` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `dialstring` varchar(28) DEFAULT NULL,
  `outbound_cid` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `session_id` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `session_id_3way` varchar(20) DEFAULT '',
  `result` text DEFAULT NULL,
  `call_channel` varchar(100) DEFAULT '',
  `call_transfer` enum('N','Y') DEFAULT 'N',
  UNIQUE KEY `vdpla` (`call_date`,`caller_code`,`user`),
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `call_3way_id` (`call_3way_id`),
  KEY `lead_id` (`lead_id`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_3way_press_log_archive`
--

/*!40000 ALTER TABLE `vicidial_3way_press_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_3way_press_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_3way_press_multi`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_3way_press_multi` (
  `user` varchar(20) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `phone_numbers` varchar(255) DEFAULT '',
  `phone_numbers_ct` tinyint(3) DEFAULT 0,
  `status` varchar(40) DEFAULT '',
  PRIMARY KEY (`user`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_3way_press_multi`
--

/*!40000 ALTER TABLE `vicidial_3way_press_multi` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_3way_press_multi` ENABLE KEYS */;

--
-- Table structure for table `vicidial_abandon_check_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_abandon_check_queue` (
  `abandon_check_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT '',
  `call_id` varchar(40) DEFAULT '',
  `abandon_time` datetime DEFAULT NULL,
  `dispo` varchar(6) DEFAULT NULL,
  `check_status` enum('NEW','REJECT','QUEUE','PROCESSING','COMPLETE','CONNECTED','ARCHIVE') DEFAULT 'NEW',
  `reject_reason` varchar(40) DEFAULT '',
  `source` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`abandon_check_id`),
  KEY `abandon_time` (`abandon_time`),
  KEY `phone_number` (`phone_number`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_abandon_check_queue`
--

/*!40000 ALTER TABLE `vicidial_abandon_check_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_abandon_check_queue` ENABLE KEYS */;

--
-- Table structure for table `vicidial_abandon_check_queue_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_abandon_check_queue_archive` (
  `abandon_check_id` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT '',
  `call_id` varchar(40) DEFAULT '',
  `abandon_time` datetime DEFAULT NULL,
  `dispo` varchar(6) DEFAULT NULL,
  `check_status` enum('NEW','REJECT','QUEUE','PROCESSING','COMPLETE','CONNECTED','ARCHIVE') DEFAULT 'NEW',
  `reject_reason` varchar(40) DEFAULT '',
  `source` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`abandon_check_id`),
  KEY `abandon_time` (`abandon_time`),
  KEY `phone_number` (`phone_number`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_abandon_check_queue_archive`
--

/*!40000 ALTER TABLE `vicidial_abandon_check_queue_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_abandon_check_queue_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_admin_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_admin_log` (
  `admin_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `event_date` datetime NOT NULL,
  `user` varchar(20) NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `event_section` varchar(30) NOT NULL,
  `event_type` enum('ADD','COPY','LOAD','RESET','MODIFY','DELETE','SEARCH','LOGIN','LOGOUT','CLEAR','OVERRIDE','EXPORT','OTHER') DEFAULT 'OTHER',
  `record_id` varchar(50) NOT NULL,
  `event_code` varchar(255) NOT NULL,
  `event_sql` mediumtext DEFAULT NULL,
  `event_notes` mediumtext DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  PRIMARY KEY (`admin_log_id`),
  KEY `user` (`user`),
  KEY `event_section` (`event_section`),
  KEY `record_id` (`record_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_admin_log`
--

/*!40000 ALTER TABLE `vicidial_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_admin_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_dial_campaigns`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_dial_campaigns` (
  `campaign_id` varchar(8) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `validate_time` datetime DEFAULT NULL,
  `dial_time` datetime DEFAULT NULL,
  UNIQUE KEY `vadc_key` (`campaign_id`,`user`),
  KEY `user` (`user`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_dial_campaigns`
--

/*!40000 ALTER TABLE `vicidial_agent_dial_campaigns` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_dial_campaigns` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_function_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_function_log` (
  `agent_function_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `agent_log_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `function` varchar(20) DEFAULT NULL,
  `event_time` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `caller_code` varchar(30) DEFAULT '',
  `comments` varchar(40) DEFAULT '',
  `stage` varchar(40) DEFAULT '',
  `uniqueid` varchar(20) DEFAULT '',
  PRIMARY KEY (`agent_function_log_id`),
  KEY `event_time` (`event_time`),
  KEY `caller_code` (`caller_code`),
  KEY `user` (`user`),
  KEY `lead_id` (`lead_id`),
  KEY `stage` (`stage`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_function_log`
--

/*!40000 ALTER TABLE `vicidial_agent_function_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_function_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_function_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_function_log_archive` (
  `agent_function_log_id` int(9) unsigned NOT NULL,
  `agent_log_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `function` varchar(20) DEFAULT NULL,
  `event_time` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `caller_code` varchar(30) DEFAULT '',
  `comments` varchar(40) DEFAULT '',
  `stage` varchar(40) DEFAULT '',
  `uniqueid` varchar(20) DEFAULT '',
  PRIMARY KEY (`agent_function_log_id`),
  KEY `event_time` (`event_time`),
  KEY `caller_code` (`caller_code`),
  KEY `user` (`user`),
  KEY `lead_id` (`lead_id`),
  KEY `stage` (`stage`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_function_log_archive`
--

/*!40000 ALTER TABLE `vicidial_agent_function_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_function_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_latency_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_latency_log` (
  `user` varchar(20) NOT NULL,
  `log_date` datetime DEFAULT NULL,
  `latency` mediumint(7) DEFAULT 0,
  `web_ip` varchar(45) DEFAULT '',
  KEY `user` (`user`),
  KEY `log_date` (`log_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_latency_log`
--

/*!40000 ALTER TABLE `vicidial_agent_latency_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_latency_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_latency_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_latency_log_archive` (
  `user` varchar(20) NOT NULL,
  `log_date` datetime DEFAULT NULL,
  `latency` mediumint(7) DEFAULT 0,
  `web_ip` varchar(45) DEFAULT '',
  UNIQUE KEY `vdalla` (`user`,`log_date`),
  KEY `user` (`user`),
  KEY `log_date` (`log_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_latency_log_archive`
--

/*!40000 ALTER TABLE `vicidial_agent_latency_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_latency_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_latency_summary_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_latency_summary_log` (
  `user` varchar(20) NOT NULL,
  `log_date` datetime DEFAULT NULL,
  `web_ip` varchar(45) DEFAULT '',
  `latency_avg` mediumint(7) DEFAULT 0,
  `latency_peak` mediumint(7) DEFAULT 0,
  `latency_count` smallint(4) DEFAULT 0,
  KEY `user` (`user`),
  KEY `log_date` (`log_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_latency_summary_log`
--

/*!40000 ALTER TABLE `vicidial_agent_latency_summary_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_latency_summary_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_latency_summary_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_latency_summary_log_archive` (
  `user` varchar(20) NOT NULL,
  `log_date` datetime DEFAULT NULL,
  `web_ip` varchar(45) DEFAULT '',
  `latency_avg` mediumint(7) DEFAULT 0,
  `latency_peak` mediumint(7) DEFAULT 0,
  `latency_count` smallint(4) DEFAULT 0,
  UNIQUE KEY `vdalsla` (`user`,`log_date`,`web_ip`),
  KEY `user` (`user`),
  KEY `log_date` (`log_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_latency_summary_log_archive`
--

/*!40000 ALTER TABLE `vicidial_agent_latency_summary_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_latency_summary_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_log` (
  `agent_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `event_time` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `pause_epoch` int(10) unsigned DEFAULT NULL,
  `pause_sec` smallint(5) unsigned DEFAULT 0,
  `wait_epoch` int(10) unsigned DEFAULT NULL,
  `wait_sec` smallint(5) unsigned DEFAULT 0,
  `talk_epoch` int(10) unsigned DEFAULT NULL,
  `talk_sec` smallint(5) unsigned DEFAULT 0,
  `dispo_epoch` int(10) unsigned DEFAULT NULL,
  `dispo_sec` smallint(5) unsigned DEFAULT 0,
  `status` varchar(6) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `comments` varchar(20) DEFAULT NULL,
  `sub_status` varchar(6) DEFAULT NULL,
  `dead_epoch` int(10) unsigned DEFAULT NULL,
  `dead_sec` smallint(5) unsigned DEFAULT 0,
  `processed` enum('Y','N') DEFAULT 'N',
  `uniqueid` varchar(20) DEFAULT '',
  `pause_type` enum('UNDEFINED','SYSTEM','AGENT','API','ADMIN') DEFAULT 'UNDEFINED',
  PRIMARY KEY (`agent_log_id`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `event_time` (`event_time`),
  KEY `time_user` (`event_time`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_log`
--

/*!40000 ALTER TABLE `vicidial_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_log_archive` (
  `agent_log_id` int(9) unsigned NOT NULL,
  `user` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `event_time` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `pause_epoch` int(10) unsigned DEFAULT NULL,
  `pause_sec` smallint(5) unsigned DEFAULT 0,
  `wait_epoch` int(10) unsigned DEFAULT NULL,
  `wait_sec` smallint(5) unsigned DEFAULT 0,
  `talk_epoch` int(10) unsigned DEFAULT NULL,
  `talk_sec` smallint(5) unsigned DEFAULT 0,
  `dispo_epoch` int(10) unsigned DEFAULT NULL,
  `dispo_sec` smallint(5) unsigned DEFAULT 0,
  `status` varchar(6) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `comments` varchar(20) DEFAULT NULL,
  `sub_status` varchar(6) DEFAULT NULL,
  `dead_epoch` int(10) unsigned DEFAULT NULL,
  `dead_sec` smallint(5) unsigned DEFAULT 0,
  `processed` enum('Y','N') DEFAULT 'N',
  `uniqueid` varchar(20) DEFAULT '',
  `pause_type` enum('UNDEFINED','SYSTEM','AGENT','API','ADMIN') DEFAULT 'UNDEFINED',
  PRIMARY KEY (`agent_log_id`),
  KEY `lead_id` (`lead_id`),
  KEY `user` (`user`),
  KEY `event_time` (`event_time`),
  KEY `time_user` (`event_time`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_log_archive`
--

/*!40000 ALTER TABLE `vicidial_agent_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_notifications`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_notifications` (
  `notification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entry_date` datetime DEFAULT current_timestamp(),
  `recipient` varchar(20) DEFAULT NULL,
  `recipient_type` enum('USER','USER_GROUP','CAMPAIGN','ALT_DISPLAY') DEFAULT NULL,
  `notification_date` datetime DEFAULT current_timestamp(),
  `notification_retry` enum('Y','N') DEFAULT 'N',
  `notification_text` text DEFAULT NULL,
  `text_size` tinyint(3) unsigned DEFAULT 12,
  `text_font` varchar(30) DEFAULT 'Arial',
  `text_weight` varchar(30) DEFAULT 'bold',
  `text_color` varchar(15) DEFAULT NULL,
  `show_confetti` enum('Y','N') DEFAULT 'N',
  `confetti_options` varchar(15) DEFAULT NULL,
  `notification_status` enum('QUEUED','READY','SENT','DEAD') DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `recipient` (`recipient`),
  KEY `notification_date` (`notification_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_notifications`
--

/*!40000 ALTER TABLE `vicidial_agent_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_notifications` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_notifications_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_notifications_archive` (
  `notification_id` int(10) unsigned NOT NULL,
  `entry_date` datetime DEFAULT current_timestamp(),
  `recipient` varchar(20) DEFAULT NULL,
  `recipient_type` enum('USER','USER_GROUP','CAMPAIGN','ALT_DISPLAY') DEFAULT NULL,
  `notification_date` datetime DEFAULT current_timestamp(),
  `notification_retry` enum('Y','N') DEFAULT 'N',
  `notification_text` text DEFAULT NULL,
  `text_size` tinyint(3) unsigned DEFAULT 12,
  `text_font` varchar(30) DEFAULT 'Arial',
  `text_weight` varchar(30) DEFAULT 'bold',
  `text_color` varchar(15) DEFAULT NULL,
  `show_confetti` enum('Y','N') DEFAULT 'N',
  `confetti_options` varchar(15) DEFAULT NULL,
  `notification_status` enum('QUEUED','READY','SENT','DEAD') DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `recipient` (`recipient`),
  KEY `notification_date` (`notification_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_notifications_archive`
--

/*!40000 ALTER TABLE `vicidial_agent_notifications_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_notifications_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_notifications_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_notifications_queue` (
  `queue_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `notification_id` int(10) unsigned DEFAULT NULL,
  `queue_date` datetime DEFAULT current_timestamp(),
  `user` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`queue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_notifications_queue`
--

/*!40000 ALTER TABLE `vicidial_agent_notifications_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_notifications_queue` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_skip_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_skip_log` (
  `user_skip_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT '',
  `previous_status` varchar(6) DEFAULT '',
  `previous_called_count` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`user_skip_log_id`),
  KEY `user` (`user`),
  KEY `event_date` (`event_date`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_skip_log`
--

/*!40000 ALTER TABLE `vicidial_agent_skip_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_skip_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_sph`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_sph` (
  `campaign_group_id` varchar(20) NOT NULL,
  `stat_date` date NOT NULL,
  `shift` varchar(20) NOT NULL,
  `role` enum('FRONTER','CLOSER') DEFAULT 'FRONTER',
  `user` varchar(20) NOT NULL,
  `calls` mediumint(8) unsigned DEFAULT 0,
  `sales` mediumint(8) unsigned DEFAULT 0,
  `login_sec` mediumint(8) unsigned DEFAULT 0,
  `login_hours` decimal(5,2) DEFAULT 0.00,
  `sph` decimal(6,2) DEFAULT 0.00,
  KEY `campaign_group_id` (`campaign_group_id`),
  KEY `stat_date` (`stat_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_sph`
--

/*!40000 ALTER TABLE `vicidial_agent_sph` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_sph` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_visibility_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_visibility_log` (
  `db_time` datetime NOT NULL,
  `event_start_epoch` int(10) unsigned DEFAULT NULL,
  `event_end_epoch` int(10) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `visibility` enum('VISIBLE','HIDDEN','LOGIN','NONE') DEFAULT 'NONE',
  `agent_log_id` int(9) unsigned DEFAULT NULL,
  UNIQUE KEY `visibleuser` (`user`,`visibility`,`event_end_epoch`),
  KEY `db_time` (`db_time`),
  KEY `agent_log_id` (`agent_log_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_visibility_log`
--

/*!40000 ALTER TABLE `vicidial_agent_visibility_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_visibility_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_visibility_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_visibility_log_archive` (
  `db_time` datetime NOT NULL,
  `event_start_epoch` int(10) unsigned DEFAULT NULL,
  `event_end_epoch` int(10) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `visibility` enum('VISIBLE','HIDDEN','LOGIN','NONE') DEFAULT 'NONE',
  `agent_log_id` int(9) unsigned DEFAULT NULL,
  UNIQUE KEY `visibleuser` (`user`,`visibility`,`event_end_epoch`),
  KEY `db_time` (`db_time`),
  KEY `agent_log_id` (`agent_log_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_visibility_log_archive`
--

/*!40000 ALTER TABLE `vicidial_agent_visibility_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_visibility_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_agent_vmm_overrides`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_agent_vmm_overrides` (
  `call_date` datetime DEFAULT NULL,
  `caller_code` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT '',
  `vm_message` varchar(255) DEFAULT '',
  KEY `caller_code` (`caller_code`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_agent_vmm_overrides`
--

/*!40000 ALTER TABLE `vicidial_agent_vmm_overrides` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_agent_vmm_overrides` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ajax_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ajax_log` (
  `user` varchar(20) DEFAULT '',
  `start_time` datetime NOT NULL,
  `db_time` datetime NOT NULL,
  `run_time` varchar(20) DEFAULT '0',
  `php_script` varchar(40) NOT NULL,
  `action` varchar(100) DEFAULT '',
  `lead_id` int(10) unsigned DEFAULT 0,
  `stage` varchar(100) DEFAULT '',
  `session_name` varchar(40) DEFAULT '',
  `last_sql` text DEFAULT NULL,
  KEY `ajax_dbtime_key` (`db_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ajax_log`
--

/*!40000 ALTER TABLE `vicidial_ajax_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ajax_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_amd_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_amd_log` (
  `call_date` datetime DEFAULT NULL,
  `caller_code` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT '',
  `channel` varchar(100) DEFAULT '',
  `server_ip` varchar(60) NOT NULL,
  `AMDSTATUS` varchar(10) DEFAULT '',
  `AMDRESPONSE` varchar(20) DEFAULT '',
  `AMDCAUSE` varchar(30) DEFAULT '',
  `run_time` varchar(20) DEFAULT '0',
  `AMDSTATS` varchar(100) DEFAULT '',
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_amd_log`
--

/*!40000 ALTER TABLE `vicidial_amd_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_amd_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_amd_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_amd_log_archive` (
  `call_date` datetime DEFAULT NULL,
  `caller_code` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT '',
  `channel` varchar(100) DEFAULT '',
  `server_ip` varchar(60) NOT NULL,
  `AMDSTATUS` varchar(10) DEFAULT '',
  `AMDRESPONSE` varchar(20) DEFAULT '',
  `AMDCAUSE` varchar(30) DEFAULT '',
  `run_time` varchar(20) DEFAULT '0',
  `AMDSTATS` varchar(100) DEFAULT '',
  UNIQUE KEY `amd_unq_key` (`uniqueid`,`call_date`,`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_amd_log_archive`
--

/*!40000 ALTER TABLE `vicidial_amd_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_amd_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_amm_multi`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_amm_multi` (
  `amm_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` varchar(20) NOT NULL,
  `entry_type` enum('campaign','ingroup','list','') DEFAULT '',
  `active` enum('Y','N') DEFAULT 'N',
  `amm_field` varchar(30) DEFAULT 'vendor_lead_code',
  `amm_rank` smallint(5) DEFAULT 1,
  `amm_wildcard` varchar(100) DEFAULT '',
  `amm_filename` varchar(255) DEFAULT '',
  `amm_description` varchar(255) DEFAULT '',
  PRIMARY KEY (`amm_id`),
  KEY `vicidial_AMM_multi_campaign_id_key` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_amm_multi`
--

/*!40000 ALTER TABLE `vicidial_amm_multi` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_amm_multi` ENABLE KEYS */;

--
-- Table structure for table `vicidial_api_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_api_log` (
  `api_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) NOT NULL,
  `api_date` datetime DEFAULT NULL,
  `api_script` varchar(10) DEFAULT NULL,
  `function` varchar(20) NOT NULL,
  `agent_user` varchar(20) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  `result_reason` varchar(255) DEFAULT NULL,
  `source` varchar(20) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `run_time` varchar(20) DEFAULT '0',
  `webserver` smallint(5) unsigned DEFAULT 0,
  `api_url` int(9) unsigned DEFAULT 0,
  PRIMARY KEY (`api_id`),
  KEY `api_date` (`api_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_api_log`
--

/*!40000 ALTER TABLE `vicidial_api_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_api_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_api_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_api_log_archive` (
  `api_id` int(9) unsigned NOT NULL,
  `user` varchar(20) NOT NULL,
  `api_date` datetime DEFAULT NULL,
  `api_script` varchar(10) DEFAULT NULL,
  `function` varchar(20) NOT NULL,
  `agent_user` varchar(20) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `result` varchar(10) DEFAULT NULL,
  `result_reason` varchar(255) DEFAULT NULL,
  `source` varchar(20) DEFAULT NULL,
  `data` text DEFAULT NULL,
  `run_time` varchar(20) DEFAULT '0',
  `webserver` smallint(5) unsigned DEFAULT 0,
  `api_url` int(9) unsigned DEFAULT 0,
  PRIMARY KEY (`api_id`),
  KEY `api_date` (`api_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_api_log_archive`
--

/*!40000 ALTER TABLE `vicidial_api_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_api_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_api_urls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_api_urls` (
  `api_id` int(9) unsigned NOT NULL,
  `api_date` datetime DEFAULT NULL,
  `remote_ip` varchar(50) DEFAULT NULL,
  `url` mediumtext DEFAULT NULL,
  PRIMARY KEY (`api_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_api_urls`
--

/*!40000 ALTER TABLE `vicidial_api_urls` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_api_urls` ENABLE KEYS */;

--
-- Table structure for table `vicidial_api_urls_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_api_urls_archive` (
  `api_id` int(9) unsigned NOT NULL,
  `api_date` datetime DEFAULT NULL,
  `remote_ip` varchar(50) DEFAULT NULL,
  `url` mediumtext DEFAULT NULL,
  PRIMARY KEY (`api_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_api_urls_archive`
--

/*!40000 ALTER TABLE `vicidial_api_urls_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_api_urls_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_areacode_filters`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_areacode_filters` (
  `group_id` varchar(20) NOT NULL,
  `areacode` varchar(6) NOT NULL,
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_areacode_filters`
--

/*!40000 ALTER TABLE `vicidial_areacode_filters` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_areacode_filters` ENABLE KEYS */;

--
-- Table structure for table `vicidial_asterisk_output`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_asterisk_output` (
  `server_ip` varchar(15) NOT NULL,
  `sip_peers` mediumtext DEFAULT NULL,
  `iax_peers` mediumtext DEFAULT NULL,
  `asterisk` mediumtext DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  UNIQUE KEY `server_ip` (`server_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_asterisk_output`
--

/*!40000 ALTER TABLE `vicidial_asterisk_output` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_asterisk_output` ENABLE KEYS */;

--
-- Table structure for table `vicidial_auto_calls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_auto_calls` (
  `auto_call_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `server_ip` varchar(15) NOT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `status` enum('SENT','RINGING','LIVE','XFER','PAUSED','CLOSER','BUSY','DISCONNECT','IVR') DEFAULT 'PAUSED',
  `lead_id` int(9) unsigned NOT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `call_time` datetime DEFAULT NULL,
  `call_type` enum('IN','OUT','OUTBALANCE') DEFAULT 'OUT',
  `stage` varchar(20) DEFAULT 'START',
  `last_update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `queue_priority` tinyint(2) DEFAULT 0,
  `agent_only` varchar(20) DEFAULT '',
  `agent_grab` varchar(20) DEFAULT '',
  `queue_position` smallint(4) unsigned DEFAULT 1,
  `extension` varchar(100) DEFAULT '',
  `agent_grab_extension` varchar(100) DEFAULT '',
  PRIMARY KEY (`auto_call_id`),
  KEY `uniqueid` (`uniqueid`),
  KEY `callerid` (`callerid`),
  KEY `call_time` (`call_time`),
  KEY `last_update_time` (`last_update_time`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_auto_calls`
--

/*!40000 ALTER TABLE `vicidial_auto_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_auto_calls` ENABLE KEYS */;

--
-- Table structure for table `vicidial_automated_reports`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_automated_reports` (
  `report_id` varchar(30) NOT NULL,
  `report_name` varchar(100) DEFAULT NULL,
  `report_last_run` datetime DEFAULT NULL,
  `report_last_length` smallint(5) DEFAULT 0,
  `report_server` varchar(30) DEFAULT 'active_voicemail_server',
  `report_times` varchar(255) DEFAULT '',
  `report_weekdays` varchar(7) DEFAULT '',
  `report_monthdays` varchar(100) DEFAULT '',
  `report_destination` enum('EMAIL','FTP') DEFAULT 'EMAIL',
  `email_from` varchar(255) DEFAULT '',
  `email_to` varchar(255) DEFAULT '',
  `email_subject` varchar(255) DEFAULT '',
  `ftp_server` varchar(255) DEFAULT '',
  `ftp_user` varchar(255) DEFAULT '',
  `ftp_pass` varchar(255) DEFAULT '',
  `ftp_directory` varchar(255) DEFAULT '',
  `report_url` text DEFAULT NULL,
  `run_now_trigger` enum('N','Y') DEFAULT 'N',
  `active` enum('N','Y') DEFAULT 'N',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `filename_override` varchar(255) DEFAULT '',
  UNIQUE KEY `report_id` (`report_id`),
  KEY `report_times` (`report_times`),
  KEY `run_now_trigger` (`run_now_trigger`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_automated_reports`
--

/*!40000 ALTER TABLE `vicidial_automated_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_automated_reports` ENABLE KEYS */;

--
-- Table structure for table `vicidial_avatar_audio`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_avatar_audio` (
  `avatar_id` varchar(100) NOT NULL,
  `audio_filename` varchar(255) NOT NULL,
  `audio_name` text DEFAULT NULL,
  `rank` smallint(5) DEFAULT 0,
  `h_ord` smallint(5) DEFAULT 1,
  `level` smallint(5) DEFAULT 1,
  `parent_audio_filename` varchar(255) DEFAULT '',
  `parent_rank` varchar(2) DEFAULT '',
  `button_type` varchar(40) DEFAULT 'button',
  `font_size` varchar(3) DEFAULT '2',
  KEY `avatar_id` (`avatar_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_avatar_audio`
--

/*!40000 ALTER TABLE `vicidial_avatar_audio` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_avatar_audio` ENABLE KEYS */;

--
-- Table structure for table `vicidial_avatars`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_avatars` (
  `avatar_id` varchar(100) NOT NULL,
  `avatar_name` varchar(100) DEFAULT NULL,
  `avatar_notes` text DEFAULT NULL,
  `avatar_api_user` varchar(20) DEFAULT '',
  `avatar_api_pass` varchar(100) DEFAULT '',
  `active` enum('Y','N') DEFAULT 'Y',
  `audio_functions` varchar(100) DEFAULT 'PLAY-STOP-RESTART',
  `audio_display` varchar(100) DEFAULT 'FILE-NAME',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `soundboard_layout` varchar(40) DEFAULT 'default',
  `columns_limit` smallint(5) DEFAULT 5,
  PRIMARY KEY (`avatar_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_avatars`
--

/*!40000 ALTER TABLE `vicidial_avatars` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_avatars` ENABLE KEYS */;

--
-- Table structure for table `vicidial_bench_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_bench_agent_log` (
  `lead_id` int(9) unsigned DEFAULT NULL,
  `bench_date` datetime DEFAULT NULL,
  `absent_agent` varchar(20) DEFAULT NULL,
  `bench_agent` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  KEY `bench_date` (`bench_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_bench_agent_log`
--

/*!40000 ALTER TABLE `vicidial_bench_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_bench_agent_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_call_menu`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_call_menu` (
  `menu_id` varchar(50) NOT NULL,
  `menu_name` varchar(100) DEFAULT NULL,
  `menu_prompt` varchar(255) DEFAULT NULL,
  `menu_timeout` smallint(2) unsigned DEFAULT 10,
  `menu_timeout_prompt` varchar(255) DEFAULT 'NONE',
  `menu_invalid_prompt` varchar(255) DEFAULT 'NONE',
  `menu_repeat` tinyint(1) unsigned DEFAULT 0,
  `menu_time_check` enum('0','1') DEFAULT '0',
  `call_time_id` varchar(20) DEFAULT '',
  `track_in_vdac` enum('0','1') DEFAULT '1',
  `custom_dialplan_entry` text DEFAULT NULL,
  `tracking_group` varchar(20) DEFAULT 'CALLMENU',
  `dtmf_log` enum('0','1') DEFAULT '0',
  `dtmf_field` varchar(50) DEFAULT 'NONE',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `qualify_sql` text DEFAULT NULL,
  `alt_dtmf_log` enum('0','1') DEFAULT '0',
  `question` int(11) DEFAULT NULL,
  `answer_signal` enum('Y','N') DEFAULT 'Y',
  PRIMARY KEY (`menu_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_call_menu`
--

/*!40000 ALTER TABLE `vicidial_call_menu` DISABLE KEYS */;
INSERT INTO `vicidial_call_menu` (
  menu_id, menu_name, menu_prompt, menu_timeout, menu_timeout_prompt, menu_invalid_prompt,
  menu_repeat, menu_time_check, call_time_id, track_in_vdac, custom_dialplan_entry,
  tracking_group, dtmf_log, dtmf_field, user_group, qualify_sql, alt_dtmf_log, question, answer_signal
)
SELECT 'defaultlog', 'logging of all outbound calls from agent phones', 'sip-silence', 20, 'NONE', 'NONE', 0, '0', '', '0',
       'exten => _X.,1,AGI(agi-NVA_recording.agi,BOTH------Y---Y---Y)\nexten => _X.,n,Goto(default,${EXTEN},1)', '', '0', 'NONE', '---ALL---', NULL, '0', NULL, 'Y'
FROM DUAL WHERE NOT EXISTS (
  SELECT 1 FROM vicidial_call_menu WHERE menu_id = 'defaultlog'
)
UNION ALL
SELECT 'default---agent', 'agent phones restricted to only internal extensions', 'sip-silence', 20, 'NONE', 'NONE', 0, '0', '', '0',
       'include => vicidial-auto-internal\ninclude => vicidial-auto-phones\n', '', '0', 'NONE', '---ALL---', NULL, '0', NULL, 'Y'
FROM DUAL WHERE NOT EXISTS (
  SELECT 1 FROM vicidial_call_menu WHERE menu_id = 'default---agent'
)
UNION ALL
SELECT '2FA_say_auth_code', '2FA_say_auth_code', 'sip-silence|hello|your|access-code|is|cm_speak_var.agi,say_digits---access_code---DP', 1, 'NONE', 'NONE', 1, '0', '24hours', '1',
       '', 'CALLMENU', '0', 'NONE', '---ALL---', '', '0', 0, 'Y'
FROM DUAL WHERE NOT EXISTS (
  SELECT 1 FROM vicidial_call_menu WHERE menu_id = '2FA_say_auth_code'
);
/*!40000 ALTER TABLE `vicidial_call_menu` ENABLE KEYS */;

--
-- Table structure for table `vicidial_call_menu_options`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_call_menu_options` (
  `menu_id` varchar(50) NOT NULL,
  `option_value` varchar(20) NOT NULL DEFAULT '',
  `option_description` varchar(255) DEFAULT '',
  `option_route` varchar(20) DEFAULT NULL,
  `option_route_value` varchar(255) DEFAULT NULL,
  `option_route_value_context` varchar(1000) DEFAULT NULL,
  UNIQUE KEY `menuoption` (`menu_id`,`option_value`),
  KEY `menu_id` (`menu_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_call_menu_options`
--

/*!40000 ALTER TABLE `vicidial_call_menu_options` DISABLE KEYS */;
INSERT INTO `vicidial_call_menu_options` (menu_id, option_value, option_description, option_route, option_route_value, option_route_value_context)
SELECT 'defaultlog', 'TIMEOUT', 'hangup', 'HANGUP', 'vm-goodbye', ''
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM vicidial_call_menu_options WHERE menu_id = 'defaultlog' AND option_value = 'TIMEOUT')
UNION ALL
SELECT 'default---agent', 'TIMEOUT', 'hangup', 'HANGUP', 'vm-goodbye', ''
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM vicidial_call_menu_options WHERE menu_id = 'default---agent' AND option_value = 'TIMEOUT')
UNION ALL
SELECT '2FA_say_auth_code', 'TIMEOUT', '', 'HANGUP', '', ''
FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM vicidial_call_menu_options WHERE menu_id = '2FA_say_auth_code' AND option_value = 'TIMEOUT');
/*!40000 ALTER TABLE `vicidial_call_menu_options` ENABLE KEYS */;

--
-- Table structure for table `vicidial_call_notes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_call_notes` (
  `notesid` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `order_id` varchar(20) DEFAULT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_time` time DEFAULT NULL,
  `call_notes` text DEFAULT NULL,
  PRIMARY KEY (`notesid`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_call_notes`
--

/*!40000 ALTER TABLE `vicidial_call_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_call_notes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_call_notes_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_call_notes_archive` (
  `notesid` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `vicidial_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `order_id` varchar(20) DEFAULT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_time` time DEFAULT NULL,
  `call_notes` text DEFAULT NULL,
  PRIMARY KEY (`notesid`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_call_notes_archive`
--

/*!40000 ALTER TABLE `vicidial_call_notes_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_call_notes_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_call_time_holidays`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_call_time_holidays` (
  `holiday_id` varchar(30) NOT NULL,
  `holiday_name` varchar(100) NOT NULL,
  `holiday_comments` varchar(255) DEFAULT '',
  `holiday_date` date DEFAULT NULL,
  `holiday_status` enum('ACTIVE','INACTIVE','EXPIRED') DEFAULT 'INACTIVE',
  `ct_default_start` smallint(4) unsigned NOT NULL DEFAULT 900,
  `ct_default_stop` smallint(4) unsigned NOT NULL DEFAULT 2100,
  `default_afterhours_filename_override` varchar(255) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `holiday_method` varchar(40) DEFAULT 'REPLACE',
  PRIMARY KEY (`holiday_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_call_time_holidays`
--

/*!40000 ALTER TABLE `vicidial_call_time_holidays` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_call_time_holidays` ENABLE KEYS */;

--
-- Table structure for table `vicidial_call_times`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_call_times` (
  `call_time_id` varchar(10) NOT NULL,
  `call_time_name` varchar(30) NOT NULL,
  `call_time_comments` varchar(255) DEFAULT '',
  `ct_default_start` smallint(4) unsigned NOT NULL DEFAULT 900,
  `ct_default_stop` smallint(4) unsigned NOT NULL DEFAULT 2100,
  `ct_sunday_start` smallint(4) unsigned DEFAULT 0,
  `ct_sunday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_monday_start` smallint(4) unsigned DEFAULT 0,
  `ct_monday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_tuesday_start` smallint(4) unsigned DEFAULT 0,
  `ct_tuesday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_wednesday_start` smallint(4) unsigned DEFAULT 0,
  `ct_wednesday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_thursday_start` smallint(4) unsigned DEFAULT 0,
  `ct_thursday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_friday_start` smallint(4) unsigned DEFAULT 0,
  `ct_friday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_saturday_start` smallint(4) unsigned DEFAULT 0,
  `ct_saturday_stop` smallint(4) unsigned DEFAULT 0,
  `ct_state_call_times` text DEFAULT NULL,
  `default_afterhours_filename_override` varchar(255) DEFAULT '',
  `sunday_afterhours_filename_override` varchar(255) DEFAULT '',
  `monday_afterhours_filename_override` varchar(255) DEFAULT '',
  `tuesday_afterhours_filename_override` varchar(255) DEFAULT '',
  `wednesday_afterhours_filename_override` varchar(255) DEFAULT '',
  `thursday_afterhours_filename_override` varchar(255) DEFAULT '',
  `friday_afterhours_filename_override` varchar(255) DEFAULT '',
  `saturday_afterhours_filename_override` varchar(255) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `ct_holidays` text DEFAULT NULL,
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`call_time_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_call_times`
--

/*!40000 ALTER TABLE `vicidial_call_times` DISABLE KEYS */;
INSERT INTO `vicidial_call_times` 
(call_time_id, call_time_name, call_time_comments, ct_default_start, ct_default_stop, 
ct_sunday_start, ct_sunday_stop, ct_monday_start, ct_monday_stop, ct_tuesday_start, 
ct_tuesday_stop, ct_wednesday_start, ct_wednesday_stop, ct_thursday_start, ct_thursday_stop, 
ct_friday_start, ct_friday_stop, ct_saturday_start, ct_saturday_stop, ct_state_call_times, 
default_afterhours_filename_override, sunday_afterhours_filename_override, 
monday_afterhours_filename_override, tuesday_afterhours_filename_override, 
wednesday_afterhours_filename_override, thursday_afterhours_filename_override, 
friday_afterhours_filename_override, saturday_afterhours_filename_override, 
user_group, ct_holidays, modify_stamp)
SELECT * FROM (
    SELECT '24hours' as call_time_id,'default 24 hours calling' as call_time_name,'' as call_time_comments,0 as ct_default_start,2400 as ct_default_stop,0 as ct_sunday_start,0 as ct_sunday_stop,0 as ct_monday_start,0 as ct_monday_stop,0 as ct_tuesday_start,0 as ct_tuesday_stop,0 as ct_wednesday_start,0 as ct_wednesday_stop,0 as ct_thursday_start,0 as ct_thursday_stop,0 as ct_friday_start,0 as ct_friday_stop,0 as ct_saturday_start,0 as ct_saturday_stop,NULL as ct_state_call_times,'' as default_afterhours_filename_override,'' as sunday_afterhours_filename_override,'' as monday_afterhours_filename_override,'' as tuesday_afterhours_filename_override,'' as wednesday_afterhours_filename_override,'' as thursday_afterhours_filename_override,'' as friday_afterhours_filename_override,'' as saturday_afterhours_filename_override,'---ALL---' as user_group,NULL as ct_holidays,'2025-06-23 16:43:09' as modify_stamp
    UNION ALL
    SELECT '9am-9pm','default 9am to 9pm calling','',900,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,'','','','','','','','','---ALL---',NULL,'2025-06-23 16:43:09'
    UNION ALL
    SELECT '9am-5pm','default 9am to 5pm calling','',900,1700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,'','','','','','','','','---ALL---',NULL,'2025-06-23 16:43:09'
    UNION ALL
    SELECT '12pm-5pm','default 12pm to 5pm calling','',1200,1700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,'','','','','','','','','---ALL---',NULL,'2025-06-23 16:43:09'
    UNION ALL
    SELECT '12pm-9pm','default 12pm to 9pm calling','',1200,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,'','','','','','','','','---ALL---',NULL,'2025-06-23 16:43:09'
    UNION ALL
    SELECT '5pm-9pm','default 5pm to 9pm calling','',1700,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,'','','','','','','','','---ALL---',NULL,'2025-06-23 16:43:09'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_call_times);
/*!40000 ALTER TABLE `vicidial_call_times` ENABLE KEYS */;

--
-- Table structure for table `vicidial_callbacks`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_callbacks` (
  `callback_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `entry_time` datetime DEFAULT NULL,
  `callback_time` datetime DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user` varchar(20) DEFAULT NULL,
  `recipient` enum('USERONLY','ANYONE') DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `lead_status` varchar(6) DEFAULT 'CALLBK',
  `email_alert` datetime DEFAULT NULL,
  `email_result` enum('SENT','FAILED','NOT AVAILABLE') DEFAULT NULL,
  `customer_timezone` varchar(100) DEFAULT '',
  `customer_timezone_diff` varchar(6) DEFAULT '',
  `customer_time` datetime DEFAULT NULL,
  PRIMARY KEY (`callback_id`),
  KEY `lead_id` (`lead_id`),
  KEY `status` (`status`),
  KEY `callback_time` (`callback_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_callbacks`
--

/*!40000 ALTER TABLE `vicidial_callbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_callbacks` ENABLE KEYS */;

--
-- Table structure for table `vicidial_callbacks_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_callbacks_archive` (
  `callback_id` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `entry_time` datetime DEFAULT NULL,
  `callback_time` datetime DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user` varchar(20) DEFAULT NULL,
  `recipient` enum('USERONLY','ANYONE') DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `lead_status` varchar(6) DEFAULT 'CALLBK',
  `email_alert` datetime DEFAULT NULL,
  `email_result` enum('SENT','FAILED','NOT AVAILABLE') DEFAULT NULL,
  `customer_timezone` varchar(100) DEFAULT '',
  `customer_timezone_diff` varchar(6) DEFAULT '',
  `customer_time` datetime DEFAULT NULL,
  PRIMARY KEY (`callback_id`),
  KEY `lead_id` (`lead_id`),
  KEY `status` (`status`),
  KEY `callback_time` (`callback_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_callbacks_archive`
--

/*!40000 ALTER TABLE `vicidial_callbacks_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_callbacks_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_agents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_agents` (
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `campaign_rank` tinyint(1) DEFAULT 0,
  `campaign_weight` tinyint(1) DEFAULT 0,
  `calls_today` smallint(5) unsigned DEFAULT 0,
  `group_web_vars` varchar(255) DEFAULT '',
  `campaign_grade` tinyint(2) unsigned DEFAULT 1,
  `hopper_calls_today` smallint(5) unsigned DEFAULT 0,
  `hopper_calls_hour` smallint(5) unsigned DEFAULT 0,
  UNIQUE KEY `vlca_user_campaign_id` (`user`,`campaign_id`),
  KEY `campaign_id` (`campaign_id`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_agents`
--

/*!40000 ALTER TABLE `vicidial_campaign_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_agents` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_cid_areacodes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_cid_areacodes` (
  `campaign_id` varchar(20) NOT NULL,
  `areacode` varchar(5) NOT NULL,
  `outbound_cid` varchar(20) DEFAULT NULL,
  `active` enum('Y','N','') DEFAULT '',
  `cid_description` varchar(50) DEFAULT NULL,
  `call_count_today` mediumint(7) DEFAULT 0,
  UNIQUE KEY `campareacode` (`campaign_id`,`areacode`,`outbound_cid`),
  KEY `campaign_id` (`campaign_id`),
  KEY `areacode` (`areacode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_cid_areacodes`
--

/*!40000 ALTER TABLE `vicidial_campaign_cid_areacodes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_cid_areacodes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_dnc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_dnc` (
  `phone_number` varchar(18) NOT NULL,
  `campaign_id` varchar(8) NOT NULL,
  UNIQUE KEY `phonecamp` (`phone_number`,`campaign_id`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_dnc`
--

/*!40000 ALTER TABLE `vicidial_campaign_dnc` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_dnc` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_hotkeys`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_hotkeys` (
  `status` varchar(6) NOT NULL,
  `hotkey` varchar(1) NOT NULL,
  `status_name` varchar(30) DEFAULT NULL,
  `selectable` enum('Y','N') DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_hotkeys`
--

/*!40000 ALTER TABLE `vicidial_campaign_hotkeys` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_hotkeys` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_hour_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_hour_counts` (
  `campaign_id` varchar(8) DEFAULT NULL,
  `date_hour` datetime DEFAULT NULL,
  `next_hour` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `type` varchar(8) DEFAULT 'CALLS',
  `calls` mediumint(6) unsigned DEFAULT 0,
  `hr` tinyint(2) DEFAULT 0,
  UNIQUE KEY `vchc_camp_hour` (`campaign_id`,`date_hour`,`type`),
  KEY `campaign_id` (`campaign_id`),
  KEY `date_hour` (`date_hour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_hour_counts`
--

/*!40000 ALTER TABLE `vicidial_campaign_hour_counts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_hour_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_hour_counts_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_hour_counts_archive` (
  `campaign_id` varchar(8) DEFAULT NULL,
  `date_hour` datetime DEFAULT NULL,
  `next_hour` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `type` varchar(8) DEFAULT 'CALLS',
  `calls` mediumint(6) unsigned DEFAULT 0,
  `hr` tinyint(2) DEFAULT 0,
  UNIQUE KEY `vchc_camp_hour` (`campaign_id`,`date_hour`,`type`),
  KEY `campaign_id` (`campaign_id`),
  KEY `date_hour` (`date_hour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_hour_counts_archive`
--

/*!40000 ALTER TABLE `vicidial_campaign_hour_counts_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_hour_counts_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_server_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_server_stats` (
  `campaign_id` varchar(20) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `local_trunk_shortage` smallint(5) unsigned DEFAULT 0,
  KEY `campaign_id` (`campaign_id`),
  KEY `server_ip` (`server_ip`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_server_stats`
--

/*!40000 ALTER TABLE `vicidial_campaign_server_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_server_stats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_stats` (
  `campaign_id` varchar(20) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `dialable_leads` int(9) unsigned DEFAULT 0,
  `calls_today` int(9) unsigned DEFAULT 0,
  `answers_today` int(9) unsigned DEFAULT 0,
  `drops_today` decimal(12,3) DEFAULT 0.000,
  `drops_today_pct` varchar(6) DEFAULT '0',
  `drops_answers_today_pct` varchar(6) DEFAULT '0',
  `calls_hour` int(9) unsigned DEFAULT 0,
  `answers_hour` int(9) unsigned DEFAULT 0,
  `drops_hour` int(9) unsigned DEFAULT 0,
  `drops_hour_pct` varchar(6) DEFAULT '0',
  `calls_halfhour` int(9) unsigned DEFAULT 0,
  `answers_halfhour` int(9) unsigned DEFAULT 0,
  `drops_halfhour` int(9) unsigned DEFAULT 0,
  `drops_halfhour_pct` varchar(6) DEFAULT '0',
  `calls_fivemin` int(9) unsigned DEFAULT 0,
  `answers_fivemin` int(9) unsigned DEFAULT 0,
  `drops_fivemin` int(9) unsigned DEFAULT 0,
  `drops_fivemin_pct` varchar(6) DEFAULT '0',
  `calls_onemin` int(9) unsigned DEFAULT 0,
  `answers_onemin` int(9) unsigned DEFAULT 0,
  `drops_onemin` int(9) unsigned DEFAULT 0,
  `drops_onemin_pct` varchar(6) DEFAULT '0',
  `differential_onemin` varchar(20) DEFAULT '0',
  `agents_average_onemin` varchar(20) DEFAULT '0',
  `balance_trunk_fill` smallint(5) unsigned DEFAULT 0,
  `status_category_1` varchar(20) DEFAULT NULL,
  `status_category_count_1` int(9) unsigned DEFAULT 0,
  `status_category_2` varchar(20) DEFAULT NULL,
  `status_category_count_2` int(9) unsigned DEFAULT 0,
  `status_category_3` varchar(20) DEFAULT NULL,
  `status_category_count_3` int(9) unsigned DEFAULT 0,
  `status_category_4` varchar(20) DEFAULT NULL,
  `status_category_count_4` int(9) unsigned DEFAULT 0,
  `hold_sec_stat_one` mediumint(8) unsigned DEFAULT 0,
  `hold_sec_stat_two` mediumint(8) unsigned DEFAULT 0,
  `agent_non_pause_sec` mediumint(8) unsigned DEFAULT 0,
  `hold_sec_answer_calls` mediumint(8) unsigned DEFAULT 0,
  `hold_sec_drop_calls` mediumint(8) unsigned DEFAULT 0,
  `hold_sec_queue_calls` mediumint(8) unsigned DEFAULT 0,
  `agent_calls_today` int(9) unsigned DEFAULT 0,
  `agent_wait_today` bigint(14) unsigned DEFAULT 0,
  `agent_custtalk_today` bigint(14) unsigned DEFAULT 0,
  `agent_acw_today` bigint(14) unsigned DEFAULT 0,
  `agent_pause_today` bigint(14) unsigned DEFAULT 0,
  `answering_machines_today` int(9) unsigned DEFAULT 0,
  `agenthandled_today` int(9) unsigned DEFAULT 0,
  `park_calls_today` mediumint(8) unsigned DEFAULT 0,
  `park_sec_today` bigint(14) unsigned DEFAULT 0,
  PRIMARY KEY (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_stats`
--

/*!40000 ALTER TABLE `vicidial_campaign_stats` DISABLE KEYS */;
INSERT INTO `vicidial_campaign_stats` 
(campaign_id, update_time, dialable_leads, calls_today, answers_today, drops_today, 
drops_today_pct, drops_answers_today_pct, calls_hour, answers_hour, drops_hour, 
drops_hour_pct, calls_halfhour, answers_halfhour, drops_halfhour, drops_halfhour_pct, 
calls_fivemin, answers_fivemin, drops_fivemin, drops_fivemin_pct, calls_onemin, 
answers_onemin, drops_onemin, drops_onemin_pct, differential_onemin, agents_average_onemin, 
balance_trunk_fill, status_category_1, status_category_count_1, status_category_2, 
status_category_count_2, status_category_3, status_category_count_3, status_category_4, 
status_category_count_4, hold_sec_stat_one, hold_sec_stat_two, agent_non_pause_sec, 
hold_sec_answer_calls, hold_sec_drop_calls, hold_sec_queue_calls, agent_calls_today, 
agent_wait_today, agent_custtalk_today, agent_acw_today, agent_pause_today, 
answering_machines_today, agenthandled_today, park_calls_today, park_sec_today)
SELECT campaign_id, update_time, dialable_leads, calls_today, answers_today, drops_today, 
drops_today_pct, drops_answers_today_pct, calls_hour, answers_hour, drops_hour, 
drops_hour_pct, calls_halfhour, answers_halfhour, drops_halfhour, drops_halfhour_pct, 
calls_fivemin, answers_fivemin, drops_fivemin, drops_fivemin_pct, calls_onemin, 
answers_onemin, drops_onemin, drops_onemin_pct, differential_onemin, agents_average_onemin, 
balance_trunk_fill, status_category_1, status_category_count_1, status_category_2, 
status_category_count_2, status_category_3, status_category_count_3, status_category_4, 
status_category_count_4, hold_sec_stat_one, hold_sec_stat_two, agent_non_pause_sec, 
hold_sec_answer_calls, hold_sec_drop_calls, hold_sec_queue_calls, agent_calls_today, 
agent_wait_today, agent_custtalk_today, agent_acw_today, agent_pause_today, 
answering_machines_today, agenthandled_today, park_calls_today, park_sec_today
FROM (
    SELECT 'AGENTDIRECT' AS campaign_id, '2025-06-23 16:45:05' AS update_time, 0 AS dialable_leads, 0 AS calls_today, 0 AS answers_today, 0 AS drops_today, 0.000 AS drops_today_pct, '0' AS drops_answers_today_pct, 0 AS calls_hour, 0 AS answers_hour, 0 AS drops_hour, '0' AS drops_hour_pct, 0 AS calls_halfhour, 0 AS answers_halfhour, 0 AS drops_halfhour, '0' AS drops_halfhour_pct, 0 AS calls_fivemin, 0 AS answers_fivemin, 0 AS drops_fivemin, '0' AS drops_fivemin_pct, 0 AS calls_onemin, 0 AS answers_onemin, 0 AS drops_onemin, '0' AS drops_onemin_pct, '0' AS differential_onemin, '0' AS agents_average_onemin, 0 AS balance_trunk_fill, NULL AS status_category_1, 0 AS status_category_count_1, NULL AS status_category_2, 0 AS status_category_count_2, NULL AS status_category_3, 0 AS status_category_count_3, NULL AS status_category_4, 0 AS status_category_count_4, 0 AS hold_sec_stat_one, 0 AS hold_sec_stat_two, 0 AS agent_non_pause_sec, 0 AS hold_sec_answer_calls, 0 AS hold_sec_drop_calls, 0 AS hold_sec_queue_calls, 0 AS agent_calls_today, 0 AS agent_wait_today, 0 AS agent_custtalk_today, 0 AS agent_acw_today, 0 AS agent_pause_today, 0 AS answering_machines_today, 0 AS agenthandled_today, 0 AS park_calls_today, 0 AS park_sec_today
    UNION ALL
    SELECT 'AGENTDIRECT_CHAT', '2025-06-23 16:45:05', 0, 0, 0, 0, 0.000, '0', 0, 0, 0, '0', 0, 0, 0, '0', 0, 0, 0, '0', 0, 0, 0, '0', '0', '0', 0, NULL, 0, NULL, 0, NULL, 0, NULL, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_campaign_stats);
/*!40000 ALTER TABLE `vicidial_campaign_stats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_stats_debug`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_stats_debug` (
  `campaign_id` varchar(20) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `entry_time` datetime DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `debug_output` text DEFAULT NULL,
  `adapt_output` text DEFAULT NULL,
  UNIQUE KEY `campserver` (`campaign_id`,`server_ip`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_stats_debug`
--

/*!40000 ALTER TABLE `vicidial_campaign_stats_debug` DISABLE KEYS */;
INSERT INTO `vicidial_campaign_stats_debug` (campaign_id, server_ip, entry_time, update_time, debug_output, adapt_output)
SELECT campaign_id, server_ip, entry_time, update_time, debug_output, adapt_output FROM (
  SELECT '--ALL--' AS campaign_id, 'SHARED' AS server_ip, NULL AS entry_time, '2025-06-23 16:45:05' AS update_time, NULL AS debug_output, NULL AS adapt_output
  UNION ALL
  SELECT '--CALLBACK-QUEUE--', 'ADAPT', '2025-06-23 12:51:06', '2025-06-23 16:51:06', NULL, '\nActive Inbound Callback Queue Entries: |0|\n\nOrphan SENDING Inbound Callback Queue Entries: |0|\n'
  UNION ALL
  SELECT '--ABANDON-QUEUE--', 'ADAPT', NULL, '2025-06-23 16:45:05', NULL, NULL
  UNION ALL
  SELECT 'AGENTDIRECT', 'INBOUND', '2025-06-23 12:50:56', '2025-06-23 16:50:56', '     ANSWERED STATUSES: AGENTDIRECT|DROP,XDROP,CALLBK,CBHOLD,DEC,DNC,SALE,NI,NP,XFER,RQXFER,TIMEOT,AFTHRS,NANQUE,IQNANQ,PDROP,IVRXFR,SVYCLM,MLINAT,MAXCAL,LRERR,QCFAIL|\n     DAILY STATS|0|0|0|0         IN-GROUP: AGENTDIRECT   CALLS: 0   ANSWER: 0   DROPS: 0\n               Stat1: 0   Stat2: 0   Hold: 0|0|0\n', NULL
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT', 'INBOUND', '2025-06-23 12:50:56', '2025-06-23 16:50:56', '     ANSWERED STATUSES: AGENTDIRECT_CHAT|DROP,XDROP,CALLBK,CBHOLD,DEC,DNC,SALE,NI,NP,XFER,RQXFER,TIMEOT,AFTHRS,NANQUE,IQNANQ,PDROP,IVRXFR,SVYCLM,MLINAT,MAXCAL,LRERR,QCFAIL|\n     DAILY STATS|0|0|0|1         IN-GROUP: AGENTDIRECT_CHAT   CALLS: 0   ANSWER: 0   DROPS: 0\n               Stat1: 0   Stat2: 0   Hold: 0|0|0\n', NULL
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_campaign_stats_debug);
/*!40000 ALTER TABLE `vicidial_campaign_stats_debug` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaign_statuses`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaign_statuses` (
  `status` varchar(6) NOT NULL,
  `status_name` varchar(30) DEFAULT NULL,
  `selectable` enum('Y','N') DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `human_answered` enum('Y','N') DEFAULT 'N',
  `category` varchar(20) DEFAULT 'UNDEFINED',
  `sale` enum('Y','N') DEFAULT 'N',
  `dnc` enum('Y','N') DEFAULT 'N',
  `customer_contact` enum('Y','N') DEFAULT 'N',
  `not_interested` enum('Y','N') DEFAULT 'N',
  `unworkable` enum('Y','N') DEFAULT 'N',
  `scheduled_callback` enum('Y','N') DEFAULT 'N',
  `completed` enum('Y','N') DEFAULT 'N',
  `min_sec` int(5) unsigned DEFAULT 0,
  `max_sec` int(5) unsigned DEFAULT 0,
  `answering_machine` enum('Y','N') DEFAULT 'N',
  UNIQUE KEY `vicidial_campaign_statuses_key` (`status`,`campaign_id`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaign_statuses`
--

/*!40000 ALTER TABLE `vicidial_campaign_statuses` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaign_statuses` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaigns`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaigns` (
  `campaign_id` varchar(8) NOT NULL,
  `campaign_name` varchar(40) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `dial_status_a` varchar(6) DEFAULT NULL,
  `dial_status_b` varchar(6) DEFAULT NULL,
  `dial_status_c` varchar(6) DEFAULT NULL,
  `dial_status_d` varchar(6) DEFAULT NULL,
  `dial_status_e` varchar(6) DEFAULT NULL,
  `lead_order` varchar(30) DEFAULT NULL,
  `park_ext` varchar(10) DEFAULT NULL,
  `park_file_name` varchar(100) DEFAULT 'default',
  `web_form_address` text DEFAULT NULL,
  `allow_closers` enum('Y','N') DEFAULT NULL,
  `hopper_level` int(8) unsigned DEFAULT 1,
  `auto_dial_level` varchar(6) DEFAULT '0',
  `next_agent_call` varchar(40) DEFAULT 'longest_wait_time',
  `local_call_time` varchar(10) DEFAULT '9am-9pm',
  `voicemail_ext` varchar(10) DEFAULT NULL,
  `dial_timeout` tinyint(3) unsigned DEFAULT 60,
  `dial_prefix` varchar(20) DEFAULT '9',
  `campaign_cid` varchar(20) DEFAULT '0000000000',
  `campaign_vdad_exten` varchar(20) DEFAULT '8368',
  `campaign_rec_exten` varchar(20) DEFAULT '8309',
  `campaign_recording` enum('NEVER','ONDEMAND','ALLCALLS','ALLFORCE') DEFAULT 'ONDEMAND',
  `campaign_rec_filename` varchar(50) DEFAULT 'FULLDATE_CUSTPHONE',
  `campaign_script` varchar(20) DEFAULT NULL,
  `get_call_launch` enum('NONE','SCRIPT','SCRIPTTWO','WEBFORM','WEBFORMTWO','WEBFORMTHREE','FORM','PREVIEW_WEBFORM','PREVIEW_WEBFORMTWO','PREVIEW_WEBFORMTHREE','PREVIEW_SCRIPT','PREVIEW_SCRIPTTWO','PREVIEW_FORM') DEFAULT 'NONE',
  `am_message_exten` varchar(100) DEFAULT 'vm-goodbye',
  `amd_send_to_vmx` enum('Y','N') DEFAULT 'N',
  `xferconf_a_dtmf` varchar(50) DEFAULT NULL,
  `xferconf_a_number` varchar(50) DEFAULT NULL,
  `xferconf_b_dtmf` varchar(50) DEFAULT NULL,
  `xferconf_b_number` varchar(50) DEFAULT NULL,
  `alt_number_dialing` enum('N','Y','SELECTED','SELECTED_TIMER_ALT','SELECTED_TIMER_ADDR3','UNSELECTED','UNSELECTED_TIMER_ALT','UNSELECTED_TIMER_ADDR3') DEFAULT 'N',
  `scheduled_callbacks` enum('Y','N') DEFAULT 'N',
  `lead_filter_id` varchar(20) DEFAULT 'NONE',
  `drop_call_seconds` tinyint(3) DEFAULT 5,
  `drop_action` enum('HANGUP','MESSAGE','VOICEMAIL','IN_GROUP','AUDIO','CALLMENU','VMAIL_NO_INST') DEFAULT 'AUDIO',
  `safe_harbor_exten` varchar(20) DEFAULT '8307',
  `display_dialable_count` enum('Y','N') DEFAULT 'Y',
  `wrapup_seconds` smallint(3) unsigned DEFAULT 0,
  `wrapup_message` varchar(255) DEFAULT 'Wrapup Call',
  `closer_campaigns` text DEFAULT NULL,
  `use_internal_dnc` enum('Y','N','AREACODE') DEFAULT 'N',
  `allcalls_delay` smallint(3) unsigned DEFAULT 0,
  `omit_phone_code` enum('Y','N') DEFAULT 'N',
  `dial_method` enum('MANUAL','RATIO','ADAPT_HARD_LIMIT','ADAPT_TAPERED','ADAPT_AVERAGE','INBOUND_MAN','SHARED_RATIO','SHARED_ADAPT_HARD_LIMIT','SHARED_ADAPT_TAPERED','SHARED_ADAPT_AVERAGE') DEFAULT 'MANUAL',
  `available_only_ratio_tally` enum('Y','N') DEFAULT 'N',
  `adaptive_dropped_percentage` varchar(4) DEFAULT '3',
  `adaptive_maximum_level` varchar(6) DEFAULT '3.0',
  `adaptive_latest_server_time` varchar(4) DEFAULT '2100',
  `adaptive_intensity` varchar(6) DEFAULT '0',
  `adaptive_dl_diff_target` smallint(3) DEFAULT 0,
  `concurrent_transfers` enum('AUTO','1','2','3','4','5','6','7','8','9','10','15','20','25','30','40','50','60','80','100','1000','10000') DEFAULT 'AUTO',
  `auto_alt_dial` enum('NONE','ALT_ONLY','ADDR3_ONLY','ALT_AND_ADDR3','ALT_AND_EXTENDED','ALT_AND_ADDR3_AND_EXTENDED','EXTENDED_ONLY','MULTI_LEAD') DEFAULT 'NONE',
  `auto_alt_dial_statuses` varchar(255) DEFAULT ' B N NA DC -',
  `agent_pause_codes_active` enum('Y','N','FORCE') DEFAULT 'N',
  `campaign_description` varchar(255) DEFAULT NULL,
  `campaign_changedate` datetime DEFAULT NULL,
  `campaign_stats_refresh` enum('Y','N') DEFAULT 'N',
  `campaign_logindate` datetime DEFAULT NULL,
  `dial_statuses` varchar(255) DEFAULT ' NEW -',
  `disable_alter_custdata` enum('Y','N') DEFAULT 'N',
  `no_hopper_leads_logins` enum('Y','N') DEFAULT 'N',
  `list_order_mix` varchar(20) DEFAULT 'DISABLED',
  `campaign_allow_inbound` enum('Y','N') DEFAULT 'N',
  `manual_dial_list_id` bigint(14) unsigned DEFAULT 998,
  `default_xfer_group` varchar(20) DEFAULT '---NONE---',
  `xfer_groups` text DEFAULT NULL,
  `queue_priority` tinyint(2) DEFAULT 50,
  `drop_inbound_group` varchar(20) DEFAULT '---NONE---',
  `qc_enabled` enum('Y','N') DEFAULT 'N',
  `qc_statuses` text DEFAULT NULL,
  `qc_lists` text DEFAULT NULL,
  `qc_shift_id` varchar(20) DEFAULT '24HRMIDNIGHT',
  `qc_get_record_launch` enum('NONE','SCRIPT','WEBFORM','QCSCRIPT','QCWEBFORM') DEFAULT 'NONE',
  `qc_show_recording` enum('Y','N') DEFAULT 'Y',
  `qc_web_form_address` varchar(255) DEFAULT NULL,
  `qc_script` varchar(20) DEFAULT NULL,
  `survey_first_audio_file` text DEFAULT NULL,
  `survey_dtmf_digits` varchar(16) DEFAULT '1238',
  `survey_ni_digit` varchar(1) DEFAULT '8',
  `survey_opt_in_audio_file` text DEFAULT NULL,
  `survey_ni_audio_file` text DEFAULT NULL,
  `survey_method` enum('AGENT_XFER','VOICEMAIL','EXTENSION','HANGUP','CAMPREC_60_WAV','CALLMENU','VMAIL_NO_INST') DEFAULT 'AGENT_XFER',
  `survey_no_response_action` enum('OPTIN','OPTOUT','DROP') DEFAULT 'OPTIN',
  `survey_ni_status` varchar(6) DEFAULT 'NI',
  `survey_response_digit_map` varchar(255) DEFAULT '1-DEMOCRAT|2-REPUBLICAN|3-INDEPENDANT|8-OPTOUT|X-NO RESPONSE|',
  `survey_xfer_exten` varchar(20) DEFAULT '8300',
  `survey_camp_record_dir` varchar(255) DEFAULT '/home/survey',
  `disable_alter_custphone` enum('Y','N','HIDE') DEFAULT 'Y',
  `display_queue_count` enum('Y','N') DEFAULT 'Y',
  `manual_dial_filter` varchar(50) DEFAULT 'NONE',
  `agent_clipboard_copy` varchar(50) DEFAULT 'NONE',
  `agent_extended_alt_dial` enum('Y','N') DEFAULT 'N',
  `use_campaign_dnc` enum('Y','N','AREACODE') DEFAULT 'N',
  `three_way_call_cid` enum('CAMPAIGN','CUSTOMER','AGENT_PHONE','AGENT_CHOOSE','CUSTOM_CID') DEFAULT 'CAMPAIGN',
  `three_way_dial_prefix` varchar(20) DEFAULT '',
  `web_form_target` varchar(100) NOT NULL DEFAULT 'vdcwebform',
  `vtiger_search_category` varchar(100) DEFAULT 'LEAD',
  `vtiger_create_call_record` enum('Y','N','DISPO') DEFAULT 'Y',
  `vtiger_create_lead_record` enum('Y','N') DEFAULT 'Y',
  `vtiger_screen_login` enum('Y','N','NEW_WINDOW') DEFAULT 'Y',
  `cpd_amd_action` enum('DISABLED','DISPO','MESSAGE','CALLMENU','INGROUP') DEFAULT 'DISABLED',
  `agent_allow_group_alias` enum('Y','N') DEFAULT 'N',
  `default_group_alias` varchar(30) DEFAULT '',
  `vtiger_search_dead` enum('DISABLED','ASK','RESURRECT') DEFAULT 'ASK',
  `vtiger_status_call` enum('Y','N') DEFAULT 'N',
  `survey_third_digit` varchar(1) DEFAULT '',
  `survey_third_audio_file` text DEFAULT NULL,
  `survey_third_status` varchar(6) DEFAULT 'NI',
  `survey_third_exten` varchar(20) DEFAULT '8300',
  `survey_fourth_digit` varchar(1) DEFAULT '',
  `survey_fourth_audio_file` text DEFAULT NULL,
  `survey_fourth_status` varchar(6) DEFAULT 'NI',
  `survey_fourth_exten` varchar(20) DEFAULT '8300',
  `drop_lockout_time` varchar(6) DEFAULT '0',
  `quick_transfer_button` varchar(20) DEFAULT 'N',
  `prepopulate_transfer_preset` enum('N','PRESET_1','PRESET_2','PRESET_3','PRESET_4','PRESET_5') DEFAULT 'N',
  `drop_rate_group` varchar(20) DEFAULT 'DISABLED',
  `view_calls_in_queue` enum('NONE','ALL','1','2','3','4','5') DEFAULT 'NONE',
  `view_calls_in_queue_launch` enum('AUTO','MANUAL') DEFAULT 'MANUAL',
  `grab_calls_in_queue` enum('Y','N') DEFAULT 'N',
  `call_requeue_button` enum('Y','N') DEFAULT 'N',
  `pause_after_each_call` enum('Y','N') DEFAULT 'N',
  `no_hopper_dialing` enum('Y','N') DEFAULT 'N',
  `agent_dial_owner_only` enum('NONE','USER','TERRITORY','USER_GROUP','USER_BLANK','TERRITORY_BLANK','USER_GROUP_BLANK') DEFAULT 'NONE',
  `agent_display_dialable_leads` enum('Y','N') DEFAULT 'N',
  `web_form_address_two` text DEFAULT NULL,
  `waitforsilence_options` varchar(25) DEFAULT '',
  `agent_select_territories` enum('Y','N') DEFAULT 'N',
  `campaign_calldate` datetime DEFAULT NULL,
  `crm_popup_login` enum('Y','N') DEFAULT 'N',
  `crm_login_address` text DEFAULT NULL,
  `timer_action` varchar(20) DEFAULT 'NONE',
  `timer_action_message` varchar(255) DEFAULT '',
  `timer_action_seconds` mediumint(7) DEFAULT -1,
  `start_call_url` text DEFAULT NULL,
  `dispo_call_url` text DEFAULT NULL,
  `xferconf_c_number` varchar(50) DEFAULT '',
  `xferconf_d_number` varchar(50) DEFAULT '',
  `xferconf_e_number` varchar(50) DEFAULT '',
  `use_custom_cid` enum('Y','N','AREACODE','USER_CUSTOM_1','USER_CUSTOM_2','USER_CUSTOM_3','USER_CUSTOM_4','USER_CUSTOM_5') DEFAULT 'N',
  `scheduled_callbacks_alert` enum('NONE','BLINK','RED','BLINK_RED','BLINK_DEFER','RED_DEFER','BLINK_RED_DEFER') DEFAULT 'NONE',
  `queuemetrics_callstatus_override` enum('DISABLED','NO','YES') DEFAULT 'DISABLED',
  `extension_appended_cidname` enum('Y','N','Y_USER','Y_WITH_CAMPAIGN','Y_USER_WITH_CAMPAIGN') DEFAULT 'N',
  `scheduled_callbacks_count` enum('LIVE','ALL_ACTIVE') DEFAULT 'ALL_ACTIVE',
  `manual_dial_override` enum('NONE','ALLOW_ALL','DISABLE_ALL') DEFAULT 'NONE',
  `blind_monitor_warning` enum('DISABLED','ALERT','NOTICE','AUDIO','ALERT_NOTICE','ALERT_AUDIO','NOTICE_AUDIO','ALL') DEFAULT 'DISABLED',
  `blind_monitor_message` varchar(255) DEFAULT 'Someone is blind monitoring your session',
  `blind_monitor_filename` varchar(100) DEFAULT '',
  `inbound_queue_no_dial` enum('DISABLED','ENABLED','ALL_SERVERS','ENABLED_WITH_CHAT','ALL_SERVERS_WITH_CHAT') DEFAULT 'DISABLED',
  `timer_action_destination` varchar(30) DEFAULT '',
  `enable_xfer_presets` enum('DISABLED','ENABLED','STAGING','CONTACTS') DEFAULT 'DISABLED',
  `hide_xfer_number_to_dial` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `manual_dial_prefix` varchar(20) DEFAULT '',
  `customer_3way_hangup_logging` enum('DISABLED','ENABLED') DEFAULT 'ENABLED',
  `customer_3way_hangup_seconds` smallint(5) unsigned DEFAULT 5,
  `customer_3way_hangup_action` enum('NONE','DISPO') DEFAULT 'NONE',
  `ivr_park_call` enum('DISABLED','ENABLED','ENABLED_PARK_ONLY','ENABLED_BUTTON_HIDDEN') DEFAULT 'DISABLED',
  `ivr_park_call_agi` text DEFAULT NULL,
  `manual_preview_dial` enum('DISABLED','PREVIEW_AND_SKIP','PREVIEW_ONLY') DEFAULT 'PREVIEW_AND_SKIP',
  `realtime_agent_time_stats` enum('DISABLED','WAIT_CUST_ACW','WAIT_CUST_ACW_PAUSE','CALLS_WAIT_CUST_ACW_PAUSE') DEFAULT 'CALLS_WAIT_CUST_ACW_PAUSE',
  `use_auto_hopper` enum('Y','N') DEFAULT 'Y',
  `auto_hopper_multi` varchar(6) DEFAULT '1',
  `auto_hopper_level` mediumint(8) unsigned DEFAULT 0,
  `auto_trim_hopper` enum('Y','N') DEFAULT 'Y',
  `api_manual_dial` enum('STANDARD','QUEUE','QUEUE_AND_AUTOCALL') DEFAULT 'STANDARD',
  `manual_dial_call_time_check` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `display_leads_count` enum('Y','N') DEFAULT 'N',
  `lead_order_randomize` enum('Y','N') DEFAULT 'N',
  `lead_order_secondary` enum('LEAD_ASCEND','LEAD_DESCEND','CALLTIME_ASCEND','CALLTIME_DESCEND','VENDOR_ASCEND','VENDOR_DESCEND') DEFAULT 'LEAD_ASCEND',
  `per_call_notes` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `my_callback_option` enum('CHECKED','UNCHECKED') DEFAULT 'UNCHECKED',
  `agent_lead_search` enum('ENABLED','LIVE_CALL_INBOUND','LIVE_CALL_INBOUND_AND_MANUAL','DISABLED') DEFAULT 'DISABLED',
  `agent_lead_search_method` varchar(30) DEFAULT 'CAMPLISTS_ALL',
  `queuemetrics_phone_environment` varchar(20) DEFAULT '',
  `auto_pause_precall` enum('Y','N') DEFAULT 'N',
  `auto_pause_precall_code` varchar(6) DEFAULT 'PRECAL',
  `auto_resume_precall` enum('Y','N') DEFAULT 'N',
  `manual_dial_cid` enum('CAMPAIGN','AGENT_PHONE','AGENT_PHONE_OVERRIDE') DEFAULT 'CAMPAIGN',
  `post_phone_time_diff_alert` varchar(30) DEFAULT 'DISABLED',
  `custom_3way_button_transfer` varchar(30) DEFAULT 'DISABLED',
  `available_only_tally_threshold` enum('DISABLED','LOGGED-IN_AGENTS','NON-PAUSED_AGENTS','WAITING_AGENTS') DEFAULT 'DISABLED',
  `available_only_tally_threshold_agents` smallint(5) unsigned DEFAULT 0,
  `dial_level_threshold` enum('DISABLED','LOGGED-IN_AGENTS','NON-PAUSED_AGENTS','WAITING_AGENTS') DEFAULT 'DISABLED',
  `dial_level_threshold_agents` smallint(5) unsigned DEFAULT 0,
  `safe_harbor_audio` varchar(100) DEFAULT 'buzz',
  `safe_harbor_menu_id` varchar(50) DEFAULT '',
  `survey_menu_id` varchar(50) DEFAULT '',
  `callback_days_limit` smallint(3) DEFAULT 0,
  `dl_diff_target_method` enum('ADAPT_CALC_ONLY','CALLS_PLACED') DEFAULT 'ADAPT_CALC_ONLY',
  `disable_dispo_screen` enum('DISPO_ENABLED','DISPO_DISABLED','DISPO_SELECT_DISABLED') DEFAULT 'DISPO_ENABLED',
  `disable_dispo_status` varchar(6) DEFAULT '',
  `screen_labels` varchar(20) DEFAULT '--SYSTEM-SETTINGS--',
  `status_display_fields` varchar(30) DEFAULT 'CALLID',
  `na_call_url` text DEFAULT NULL,
  `survey_recording` enum('Y','N','Y_WITH_AMD') DEFAULT 'N',
  `pllb_grouping` enum('DISABLED','ONE_SERVER_ONLY','CASCADING') DEFAULT 'DISABLED',
  `pllb_grouping_limit` smallint(5) DEFAULT 50,
  `call_count_limit` smallint(5) unsigned DEFAULT 0,
  `call_count_target` smallint(5) unsigned DEFAULT 3,
  `callback_hours_block` tinyint(2) DEFAULT 0,
  `callback_list_calltime` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `hopper_vlc_dup_check` enum('Y','N') DEFAULT 'N',
  `in_group_dial` enum('DISABLED','MANUAL_DIAL','NO_DIAL','BOTH') DEFAULT 'DISABLED',
  `in_group_dial_select` enum('AGENT_SELECTED','CAMPAIGN_SELECTED','ALL_USER_GROUP') DEFAULT 'CAMPAIGN_SELECTED',
  `safe_harbor_audio_field` varchar(30) DEFAULT 'DISABLED',
  `pause_after_next_call` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `owner_populate` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `use_other_campaign_dnc` varchar(8) DEFAULT '',
  `allow_emails` enum('Y','N') DEFAULT 'N',
  `amd_inbound_group` varchar(20) DEFAULT '',
  `amd_callmenu` varchar(50) DEFAULT '',
  `survey_wait_sec` tinyint(3) DEFAULT 10,
  `manual_dial_lead_id` enum('Y','N') DEFAULT 'N',
  `dead_max` smallint(5) unsigned DEFAULT 0,
  `dead_max_dispo` varchar(6) DEFAULT 'DCMX',
  `dispo_max` smallint(5) unsigned DEFAULT 0,
  `dispo_max_dispo` varchar(6) DEFAULT 'DISMX',
  `pause_max` smallint(5) unsigned DEFAULT 0,
  `max_inbound_calls` smallint(5) unsigned DEFAULT 0,
  `manual_dial_search_checkbox` enum('SELECTED','SELECTED_RESET','UNSELECTED','UNSELECTED_RESET','SELECTED_LOCK','UNSELECTED_LOCK') DEFAULT 'SELECTED',
  `hide_call_log_info` enum('Y','N','SHOW_1','SHOW_2','SHOW_3','SHOW_4','SHOW_5','SHOW_6','SHOW_7','SHOW_8','SHOW_9','SHOW_10') DEFAULT 'N',
  `timer_alt_seconds` smallint(5) DEFAULT 0,
  `wrapup_bypass` enum('DISABLED','ENABLED') DEFAULT 'ENABLED',
  `wrapup_after_hotkey` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `callback_active_limit` smallint(5) unsigned DEFAULT 0,
  `callback_active_limit_override` enum('N','Y') DEFAULT 'N',
  `allow_chats` enum('Y','N') DEFAULT 'N',
  `comments_all_tabs` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `comments_dispo_screen` enum('DISABLED','ENABLED','REPLACE_CALL_NOTES') DEFAULT 'DISABLED',
  `comments_callback_screen` enum('DISABLED','ENABLED','REPLACE_CB_NOTES') DEFAULT 'DISABLED',
  `qc_comment_history` enum('CLICK','AUTO_OPEN','CLICK_ALLOW_MINIMIZE','AUTO_OPEN_ALLOW_MINIMIZE') DEFAULT 'CLICK',
  `show_previous_callback` enum('DISABLED','ENABLED') DEFAULT 'ENABLED',
  `clear_script` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `cpd_unknown_action` enum('DISABLED','DISPO','MESSAGE','CALLMENU','INGROUP') DEFAULT 'DISABLED',
  `manual_dial_search_filter` varchar(50) DEFAULT 'NONE',
  `web_form_address_three` text DEFAULT NULL,
  `manual_dial_override_field` enum('ENABLED','DISABLED') DEFAULT 'ENABLED',
  `status_display_ingroup` enum('ENABLED','DISABLED') DEFAULT 'ENABLED',
  `customer_gone_seconds` smallint(5) unsigned DEFAULT 30,
  `agent_display_fields` varchar(100) DEFAULT '',
  `am_message_wildcards` enum('Y','N') DEFAULT 'N',
  `manual_dial_timeout` varchar(3) DEFAULT '',
  `routing_initiated_recordings` enum('Y','N') DEFAULT 'Y',
  `manual_dial_hopper_check` enum('Y','N') DEFAULT 'N',
  `callback_useronly_move_minutes` mediumint(5) unsigned DEFAULT 0,
  `ofcom_uk_drop_calc` enum('Y','N') DEFAULT 'N',
  `manual_auto_next` smallint(5) unsigned DEFAULT 0,
  `manual_auto_show` enum('Y','N') DEFAULT 'N',
  `allow_required_fields` enum('Y','N') DEFAULT 'N',
  `dead_to_dispo` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `agent_xfer_validation` enum('N','Y') DEFAULT 'N',
  `ready_max_logout` mediumint(7) DEFAULT 0,
  `callback_display_days` smallint(3) DEFAULT 0,
  `three_way_record_stop` enum('Y','N') DEFAULT 'N',
  `hangup_xfer_record_start` enum('Y','N') DEFAULT 'N',
  `scheduled_callbacks_email_alert` enum('Y','N') DEFAULT 'N',
  `max_inbound_calls_outcome` enum('DEFAULT','ALLOW_AGENTDIRECT','ALLOW_MI_PAUSE','ALLOW_AGENTDIRECT_AND_MI_PAUSE') DEFAULT 'DEFAULT',
  `manual_auto_next_options` enum('DEFAULT','PAUSE_NO_COUNT') DEFAULT 'DEFAULT',
  `agent_screen_time_display` varchar(40) DEFAULT 'DISABLED',
  `next_dial_my_callbacks` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `inbound_no_agents_no_dial_container` varchar(40) DEFAULT '---DISABLED---',
  `inbound_no_agents_no_dial_threshold` smallint(5) DEFAULT 0,
  `cid_group_id` varchar(20) DEFAULT '---DISABLED---',
  `pause_max_dispo` varchar(6) DEFAULT 'PAUSMX',
  `script_top_dispo` enum('Y','N') DEFAULT 'N',
  `dead_trigger_seconds` smallint(5) DEFAULT 0,
  `dead_trigger_action` enum('DISABLED','AUDIO','URL','AUDIO_AND_URL') DEFAULT 'DISABLED',
  `dead_trigger_repeat` enum('NO','REPEAT_ALL','REPEAT_AUDIO','REPEAT_URL') DEFAULT 'NO',
  `dead_trigger_filename` text DEFAULT NULL,
  `dead_trigger_url` text DEFAULT NULL,
  `scheduled_callbacks_force_dial` enum('N','Y') DEFAULT 'N',
  `scheduled_callbacks_auto_reschedule` varchar(10) DEFAULT 'DISABLED',
  `scheduled_callbacks_timezones_container` varchar(40) DEFAULT 'DISABLED',
  `three_way_volume_buttons` varchar(20) DEFAULT 'ENABLED',
  `callback_dnc` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `manual_dial_validation` enum('Y','N') DEFAULT 'N',
  `mute_recordings` enum('Y','N') DEFAULT 'N',
  `auto_active_list_new` varchar(20) DEFAULT 'DISABLED',
  `call_quota_lead_ranking` varchar(40) DEFAULT 'DISABLED',
  `call_quota_process_running` tinyint(3) DEFAULT 0,
  `call_quota_last_run_date` datetime DEFAULT NULL,
  `sip_event_logging` varchar(40) DEFAULT 'DISABLED',
  `campaign_script_two` varchar(20) DEFAULT '',
  `leave_vm_no_dispo` enum('ENABLED','DISABLED') DEFAULT 'DISABLED',
  `leave_vm_message_group_id` varchar(40) DEFAULT '---NONE---',
  `dial_timeout_lead_container` varchar(40) DEFAULT 'DISABLED',
  `amd_type` enum('AMD','CPD','KHOMP') DEFAULT 'AMD',
  `vmm_daily_limit` tinyint(3) unsigned DEFAULT 0,
  `opensips_cid_name` varchar(15) DEFAULT '',
  `amd_agent_route_options` enum('ENABLED','DISABLED','PENDING') DEFAULT 'DISABLED',
  `browser_alert_sound` varchar(20) DEFAULT '---NONE---',
  `browser_alert_volume` tinyint(3) unsigned DEFAULT 50,
  `three_way_record_stop_exception` varchar(40) DEFAULT 'DISABLED',
  `pause_max_exceptions` varchar(40) DEFAULT '',
  `hopper_drop_run_trigger` varchar(1) DEFAULT 'N',
  `daily_call_count_limit` tinyint(3) unsigned DEFAULT 0,
  `daily_limit_manual` varchar(20) DEFAULT 'DISABLED',
  `transfer_button_launch` varchar(12) DEFAULT 'NONE',
  `shared_dial_rank` tinyint(3) DEFAULT 99,
  `agent_search_method` varchar(2) DEFAULT '',
  `qc_scorecard_id` varchar(20) DEFAULT '',
  `qc_statuses_id` varchar(20) DEFAULT '',
  `clear_form` enum('DISABLED','ENABLED','ACKNOWLEDGE') DEFAULT 'ACKNOWLEDGE',
  `leave_3way_start_recording` enum('DISABLED','ALL_CALLS','ALL_BUT_EXCEPTIONS','ONLY_EXCEPTIONS') DEFAULT 'DISABLED',
  `leave_3way_start_recording_exception` varchar(40) DEFAULT 'DISABLED',
  `calls_waiting_vl_one` varchar(25) DEFAULT 'DISABLED',
  `calls_waiting_vl_two` varchar(25) DEFAULT 'DISABLED',
  `calls_inqueue_count_one` varchar(40) DEFAULT 'DISABLED',
  `calls_inqueue_count_two` varchar(40) DEFAULT 'DISABLED',
  `in_man_dial_next_ready_seconds` smallint(5) unsigned DEFAULT 0,
  `in_man_dial_next_ready_seconds_override` varchar(40) DEFAULT 'DISABLED',
  `transfer_no_dispo` enum('DISABLED','EXTERNAL_ONLY','LOCAL_ONLY','LEAVE3WAY_ONLY','LOCAL_AND_EXTERNAL','LOCAL_AND_LEAVE3WAY','LEAVE3WAY_AND_EXTERNAL','LOCAL_AND_EXTERNAL_AND_LEAVE3WAY') DEFAULT 'DISABLED',
  `call_limit_24hour_method` enum('DISABLED','PHONE_NUMBER','LEAD') DEFAULT 'DISABLED',
  `call_limit_24hour_scope` enum('SYSTEM_WIDE','CAMPAIGN_LISTS') DEFAULT 'SYSTEM_WIDE',
  `call_limit_24hour` tinyint(3) unsigned DEFAULT 0,
  `call_limit_24hour_override` varchar(40) DEFAULT 'DISABLED',
  `cid_group_id_two` varchar(20) DEFAULT '---DISABLED---',
  `incall_tally_threshold_seconds` smallint(5) unsigned DEFAULT 0,
  `auto_alt_threshold` tinyint(3) unsigned DEFAULT 0,
  `pause_max_url` text DEFAULT NULL,
  `agent_hide_hangup` enum('Y','N') DEFAULT 'N',
  `ig_xfer_list_sort` enum('GROUP_ID_UP','GROUP_ID_DOWN','GROUP_NAME_UP','GROUP_NAME_DOWN','PRIORITY_UP','PRIORITY_DOWN') DEFAULT 'GROUP_ID_UP',
  `script_tab_frame_size` varchar(10) DEFAULT 'DEFAULT',
  `max_logged_in_agents` smallint(5) unsigned DEFAULT 0,
  `user_group_script` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `agent_hangup_route` enum('HANGUP','MESSAGE','EXTENSION','IN_GROUP','CALLMENU') DEFAULT 'HANGUP',
  `agent_hangup_value` text DEFAULT NULL,
  `agent_hangup_ig_override` enum('Y','N') DEFAULT 'N',
  `show_confetti` enum('DISABLED','SALES','CALLBACKS','SALES_AND_CALLBACKS') DEFAULT 'DISABLED',
  `demographic_quotas` enum('DISABLED','ENABLED','INVALID','COMPLETE') DEFAULT 'DISABLED',
  `demographic_quotas_container` varchar(40) DEFAULT 'DISABLED',
  `demographic_quotas_rerank` enum('NO','NOW','HOUR','MINUTE','NOW_HOUR') DEFAULT 'NO',
  `demographic_quotas_last_rerank` datetime DEFAULT '2000-01-01 00:00:00',
  `demographic_quotas_list_resets` enum('AUTO','MANUAL') DEFAULT 'MANUAL',
  `custom_one` text DEFAULT NULL,
  `custom_two` text DEFAULT NULL,
  `custom_three` text DEFAULT NULL,
  `custom_four` text DEFAULT NULL,
  `custom_five` text DEFAULT NULL,
  `dead_stop_recording` enum('DISABLED','ALL_CALLS','OUTBOUND_ONLY','INBOUND_ONLY','AUTODIAL_ONLY','MANUAL_ONLY') DEFAULT 'DISABLED',
  `manual_vm_status_updates` enum('ENABLED','DISABLED') DEFAULT 'ENABLED',
  `force_per_call_notes` enum('DISABLED','ENABLED','5_CHARACTERS','15_CHARACTERS','30_CHARACTERS','100_CHARACTERS') DEFAULT 'DISABLED',
  `agent_search_ingroup_list` enum('DISABLED','ENABLED','ENABLED_OVERRIDE') DEFAULT 'DISABLED',
  `hopper_hold_inserts` enum('ENABLED','DISABLED','AUTONEXT') DEFAULT 'DISABLED',
  `daily_phone_number_call_limit` tinyint(3) unsigned DEFAULT 0,
  `state_descriptions` varchar(40) DEFAULT '---DISABLED---',
  `script_tab_height` smallint(5) DEFAULT 0,
  `call_log_days` smallint(5) DEFAULT 0,
  `leave_3way_stop_recording` enum('DISABLED','ALL_CALLS') DEFAULT 'DISABLED',
  `manual_minimum_ring_seconds` smallint(5) DEFAULT 0,
  `manual_minimum_attempt_seconds` smallint(5) DEFAULT 0,
  `manual_minimum_answer_seconds` smallint(5) DEFAULT 0,
  `stereo_recording` enum('DISABLED','CUSTOMER','CUSTOMER_MUTE') DEFAULT 'DISABLED',
  `khomp_settings_container` varchar(40) DEFAULT 'KHOMPSETTINGS',
  PRIMARY KEY (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaigns`
--

/*!40000 ALTER TABLE `vicidial_campaigns` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaigns` ENABLE KEYS */;

--
-- Table structure for table `vicidial_campaigns_list_mix`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_campaigns_list_mix` (
  `vcl_id` varchar(20) NOT NULL,
  `vcl_name` varchar(50) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `list_mix_container` text DEFAULT NULL,
  `mix_method` enum('EVEN_MIX','IN_ORDER','RANDOM') DEFAULT 'IN_ORDER',
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'INACTIVE',
  PRIMARY KEY (`vcl_id`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_campaigns_list_mix`
--

/*!40000 ALTER TABLE `vicidial_campaigns_list_mix` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_campaigns_list_mix` ENABLE KEYS */;

--
-- Table structure for table `vicidial_carrier_hour_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_carrier_hour_counts` (
  `date_hour` datetime DEFAULT NULL,
  `next_hour` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `type` varchar(20) DEFAULT 'ANSWERED',
  `calls` mediumint(6) unsigned DEFAULT 0,
  `hr` tinyint(2) DEFAULT 0,
  UNIQUE KEY `vclhc_hour` (`date_hour`,`type`),
  KEY `date_hour` (`date_hour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_carrier_hour_counts`
--

/*!40000 ALTER TABLE `vicidial_carrier_hour_counts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_carrier_hour_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_carrier_hour_counts_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_carrier_hour_counts_archive` (
  `date_hour` datetime DEFAULT NULL,
  `next_hour` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `type` varchar(20) DEFAULT 'ANSWERED',
  `calls` mediumint(6) unsigned DEFAULT 0,
  `hr` tinyint(2) DEFAULT 0,
  UNIQUE KEY `vclhc_hour` (`date_hour`,`type`),
  KEY `date_hour` (`date_hour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_carrier_hour_counts_archive`
--

/*!40000 ALTER TABLE `vicidial_carrier_hour_counts_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_carrier_hour_counts_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_carrier_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_carrier_log` (
  `uniqueid` varchar(20) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `hangup_cause` tinyint(1) unsigned DEFAULT 0,
  `dialstatus` varchar(16) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `dial_time` smallint(3) unsigned DEFAULT 0,
  `answered_time` smallint(4) unsigned DEFAULT 0,
  `sip_hangup_cause` smallint(4) unsigned DEFAULT 0,
  `sip_hangup_reason` varchar(50) DEFAULT '',
  `caller_code` varchar(30) DEFAULT '',
  PRIMARY KEY (`uniqueid`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_carrier_log`
--

/*!40000 ALTER TABLE `vicidial_carrier_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_carrier_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_carrier_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_carrier_log_archive` (
  `uniqueid` varchar(20) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `hangup_cause` tinyint(1) unsigned DEFAULT 0,
  `dialstatus` varchar(16) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `dial_time` smallint(3) unsigned DEFAULT 0,
  `answered_time` smallint(4) unsigned DEFAULT 0,
  `sip_hangup_cause` smallint(4) unsigned DEFAULT 0,
  `sip_hangup_reason` varchar(50) DEFAULT '',
  `caller_code` varchar(30) DEFAULT '',
  PRIMARY KEY (`uniqueid`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_carrier_log_archive`
--

/*!40000 ALTER TABLE `vicidial_carrier_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_carrier_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ccc_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ccc_log` (
  `call_date` datetime DEFAULT NULL,
  `remote_call_id` varchar(30) DEFAULT '',
  `local_call_id` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT '',
  `channel` varchar(100) DEFAULT '',
  `server_ip` varchar(60) NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `container_id` varchar(40) DEFAULT '',
  `remote_lead_id` int(9) unsigned DEFAULT NULL,
  KEY `call_date` (`call_date`),
  KEY `local_call_id` (`local_call_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ccc_log`
--

/*!40000 ALTER TABLE `vicidial_ccc_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ccc_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ccc_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ccc_log_archive` (
  `call_date` datetime DEFAULT NULL,
  `remote_call_id` varchar(30) DEFAULT '',
  `local_call_id` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT '',
  `channel` varchar(100) DEFAULT '',
  `server_ip` varchar(60) NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `container_id` varchar(40) DEFAULT '',
  `remote_lead_id` int(9) unsigned DEFAULT NULL,
  UNIQUE KEY `ccc_unq_key` (`uniqueid`,`call_date`,`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `local_call_id` (`local_call_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ccc_log_archive`
--

/*!40000 ALTER TABLE `vicidial_ccc_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ccc_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_chat_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_chat_archive` (
  `chat_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `chat_start_time` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `chat_creator` varchar(20) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `transferring_agent` varchar(20) DEFAULT NULL,
  `user_direct` varchar(20) DEFAULT NULL,
  `user_direct_group_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`chat_id`),
  KEY `vicidial_chat_archive_lead_id_key` (`lead_id`),
  KEY `vicidial_chat_archive_start_time_key` (`chat_start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_chat_archive`
--

/*!40000 ALTER TABLE `vicidial_chat_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_chat_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_chat_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_chat_log` (
  `message_row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` varchar(20) DEFAULT NULL,
  `message` mediumtext DEFAULT NULL,
  `message_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `poster` varchar(100) DEFAULT NULL,
  `chat_member_name` varchar(100) DEFAULT NULL,
  `chat_level` enum('0','1') DEFAULT '0',
  PRIMARY KEY (`message_row_id`),
  KEY `vicidial_chat_log_user_key` (`poster`),
  KEY `vicidial_chat_log_chat_id` (`chat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_chat_log`
--

/*!40000 ALTER TABLE `vicidial_chat_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_chat_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_chat_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_chat_log_archive` (
  `message_row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` varchar(20) DEFAULT NULL,
  `message` mediumtext DEFAULT NULL,
  `message_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `poster` varchar(100) DEFAULT NULL,
  `chat_member_name` varchar(100) DEFAULT NULL,
  `chat_level` enum('0','1') DEFAULT '0',
  PRIMARY KEY (`message_row_id`),
  KEY `vicidial_chat_log_archive_user_key` (`poster`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_chat_log_archive`
--

/*!40000 ALTER TABLE `vicidial_chat_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_chat_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_chat_participants`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_chat_participants` (
  `chat_participant_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` int(9) unsigned DEFAULT NULL,
  `chat_member` varchar(20) DEFAULT NULL,
  `chat_member_name` varchar(100) DEFAULT NULL,
  `ping_date` datetime DEFAULT NULL,
  `vd_agent` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`chat_participant_id`),
  UNIQUE KEY `vicidial_chat_participants_key` (`chat_id`,`chat_member`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_chat_participants`
--

/*!40000 ALTER TABLE `vicidial_chat_participants` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_chat_participants` ENABLE KEYS */;

--
-- Table structure for table `vicidial_cid_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_cid_groups` (
  `cid_group_id` varchar(20) NOT NULL,
  `cid_group_notes` varchar(255) DEFAULT '',
  `cid_group_type` enum('AREACODE','STATE','NONE') DEFAULT 'AREACODE',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `cid_auto_rotate_minutes` mediumint(7) unsigned DEFAULT 0,
  `cid_auto_rotate_minimum` mediumint(7) unsigned DEFAULT 0,
  `cid_auto_rotate_calls` mediumint(7) unsigned DEFAULT 0,
  `cid_last_auto_rotate` datetime DEFAULT NULL,
  `cid_auto_rotate_cid` varchar(20) DEFAULT '',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`cid_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_cid_groups`
--

/*!40000 ALTER TABLE `vicidial_cid_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_cid_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_closer_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_closer_log` (
  `closecallid` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `queue_seconds` decimal(7,2) DEFAULT 0.00,
  `user_group` varchar(20) DEFAULT NULL,
  `xfercallid` int(9) unsigned DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','HOLDRECALLXFER','HOLDTIME','NOAGENT','NONE','MAXCALLS','ACFILTER','CLOSETIME') DEFAULT 'NONE',
  `uniqueid` varchar(20) NOT NULL DEFAULT '',
  `agent_only` varchar(20) DEFAULT '',
  `queue_position` smallint(4) unsigned DEFAULT 1,
  `called_count` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`closecallid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `campaign_id` (`campaign_id`),
  KEY `uniqueid` (`uniqueid`),
  KEY `phone_number` (`phone_number`),
  KEY `date_user` (`call_date`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_closer_log`
--

/*!40000 ALTER TABLE `vicidial_closer_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_closer_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_closer_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_closer_log_archive` (
  `closecallid` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `queue_seconds` decimal(7,2) DEFAULT 0.00,
  `user_group` varchar(20) DEFAULT NULL,
  `xfercallid` int(9) unsigned DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','HOLDRECALLXFER','HOLDTIME','NOAGENT','NONE','MAXCALLS','ACFILTER','CLOSETIME') DEFAULT 'NONE',
  `uniqueid` varchar(20) NOT NULL DEFAULT '',
  `agent_only` varchar(20) DEFAULT '',
  `queue_position` smallint(4) unsigned DEFAULT 1,
  `called_count` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`closecallid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `campaign_id` (`campaign_id`),
  KEY `uniqueid` (`uniqueid`),
  KEY `phone_number` (`phone_number`),
  KEY `date_user` (`call_date`,`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_closer_log_archive`
--

/*!40000 ALTER TABLE `vicidial_closer_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_closer_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_comments`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_comments` (
  `comment_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(11) NOT NULL,
  `user_id` varchar(20) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `list_id` bigint(14) unsigned NOT NULL,
  `campaign_id` varchar(8) NOT NULL,
  `comment` varchar(255) NOT NULL,
  `hidden` tinyint(1) DEFAULT NULL,
  `hidden_user_id` int(11) DEFAULT NULL,
  `hidden_timestamp` datetime DEFAULT NULL,
  `unhidden_user_id` int(11) DEFAULT NULL,
  `unhidden_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_comments`
--

/*!40000 ALTER TABLE `vicidial_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_comments` ENABLE KEYS */;

--
-- Table structure for table `vicidial_conf_templates`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_conf_templates` (
  `template_id` varchar(15) NOT NULL,
  `template_name` varchar(50) NOT NULL,
  `template_contents` text DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  UNIQUE KEY `template_id` (`template_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_conf_templates`
--

/*!40000 ALTER TABLE `vicidial_conf_templates` DISABLE KEYS */;
INSERT INTO `vicidial_conf_templates` (template_id, template_name, template_contents, user_group)
SELECT * FROM (
  SELECT 'SIP_generic' AS template_id, 'SIP phone generic' AS template_name, 'type=friend\nhost=dynamic\ncanreinvite=no\ncontext=default' AS template_contents, '---ALL---' AS user_group
  UNION ALL
  SELECT 'IAX_generic', 'IAX phone generic', 'type=friend\nhost=dynamic\nmaxauthreq=10\nauth=md5,plaintext,rsa\ncontext=default', '---ALL---'
  UNION ALL
  SELECT 'VICIphoneSIP', 'VICIphoneSIP WebRTC', 'type=friend\r\nhost=dynamic\r\nencryption=yes\r\navpf=yes\r\nicesupport=yes\r\ndirectmedia=no\r\ntransport=wss\r\nforce_avp=yes\r\ndtlsenable=yes\r\ndtlsverify=no\r\ndtlscertfile=/etc/apache2/ssl.crt/vicibox.crt\r\ndtlsprivatekey=/etc/apache2/ssl.key/vicibox.key\r\ndtlssetup=actpass\r\nrtcp_mux=yes\r\n', '---ALL---'
  UNION ALL
  SELECT 'VICIphonePJSIP', 'VICIphonePJSIP WebRTC', 'inbound_auth/nonce_lifetime = 32\r\naor/max_contacts = 1\r\naor/maximum_expiration = 3600\r\naor/minimum_expiration = 60\r\naor/default_expiration = 120\r\n\r\nendpoint/context = default\r\nendpoint/dtmf_mode = rfc4733\r\nendpoint/rtp_symmetric = yes\r\nendpoint/rewrite_contact = yes\r\nendpoint/rtp_timeout = 60\r\nendpoint/use_ptime = yes\r\nendpoint/moh_suggest = default\r\nendpoint/direct_media = no\r\nendpoint/trust_id_inbound = no\r\nendpoint/send_rpid = yes\r\nendpoint/inband_progress = no\r\nendpoint/tos_audio = ef\r\nendpoint/language = en\r\n\r\nendpoint/ice_support = yes\r\nendpoint/media_encryption = dtls\r\nendpoint/media_use_received_transport=yes\r\nendpoint/dtls_verify = no\r\nendpoint/dtls_cert_file = /etc/apache2/ssl.crt/vicibox.crt\r\nendpoint/dtls_private_key = /etc/apache2/ssl.key/vicibox.key\r\nendpoint/dtls_setup = actpass\r\nendpoint/transport=transport-wss\r\nendpoint/rtcp_mux=yes', '---ALL---'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_conf_templates);
/*!40000 ALTER TABLE `vicidial_conf_templates` ENABLE KEYS */;

--
-- Table structure for table `vicidial_confbridges`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_confbridges` (
  `conf_exten` int(7) unsigned NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `leave_3way` enum('0','1') DEFAULT '0',
  `leave_3way_datetime` datetime DEFAULT NULL,
  UNIQUE KEY `serverconf` (`server_ip`,`conf_exten`),
  UNIQUE KEY `conf_exten` (`conf_exten`,`server_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_confbridges`
--

/*!40000 ALTER TABLE `vicidial_confbridges` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_confbridges` ENABLE KEYS */;

--
-- Table structure for table `vicidial_conferences`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_conferences` (
  `conf_exten` int(7) unsigned NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `leave_3way` enum('0','1') DEFAULT '0',
  `leave_3way_datetime` datetime DEFAULT NULL,
  UNIQUE KEY `vextenserver` (`conf_exten`,`server_ip`),
  UNIQUE KEY `serverconf` (`server_ip`,`conf_exten`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_conferences`
--

/*!40000 ALTER TABLE `vicidial_conferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_conferences` ENABLE KEYS */;

--
-- Table structure for table `vicidial_configuration`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(36) NOT NULL,
  `value` varchar(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_configuration`
--

/*!40000 ALTER TABLE `vicidial_configuration` DISABLE KEYS */;
INSERT INTO `vicidial_configuration` select 1,'qc_database_version','1766' as data where not exists (select 1 from vicidial_configuration);
/*!40000 ALTER TABLE `vicidial_configuration` ENABLE KEYS */;

--
-- Table structure for table `vicidial_country_dnc_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_country_dnc_queue` (
  `dnc_file_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(250) DEFAULT NULL,
  `country_code` varchar(3) DEFAULT NULL,
  `file_layout` varchar(30) DEFAULT NULL,
  `file_status` enum('UPLOADING','READY','PENDING','INVALID LAYOUT','PROCESSING','FINISHED','CANCELLED') DEFAULT NULL,
  `file_action` enum('PURGE','APPEND') DEFAULT NULL,
  `date_uploaded` datetime DEFAULT NULL,
  `total_records` int(10) unsigned DEFAULT NULL,
  `records_processed` int(10) unsigned DEFAULT NULL,
  `records_inserted` int(10) unsigned DEFAULT NULL,
  `date_processed` datetime DEFAULT NULL,
  PRIMARY KEY (`dnc_file_id`),
  KEY `vicidial_country_dnc_queue_filename_key` (`filename`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_country_dnc_queue`
--

/*!40000 ALTER TABLE `vicidial_country_dnc_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_country_dnc_queue` ENABLE KEYS */;

--
-- Table structure for table `vicidial_country_iso_tld`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_country_iso_tld` (
  `country_name` varchar(200) DEFAULT '',
  `iso2` varchar(2) DEFAULT '',
  `iso3` varchar(3) DEFAULT '',
  `num3` varchar(4) DEFAULT '',
  `tld` varchar(20) DEFAULT '',
  KEY `iso3` (`iso3`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_country_iso_tld`
--

/*!40000 ALTER TABLE `vicidial_country_iso_tld` DISABLE KEYS */;

/*!40000 ALTER TABLE `vicidial_country_iso_tld` ENABLE KEYS */;

--
-- Table structure for table `vicidial_cpd_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_cpd_log` (
  `cpd_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel` varchar(100) NOT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `result` varchar(20) DEFAULT NULL,
  `status` enum('NEW','PROCESSED') DEFAULT 'NEW',
  `cpd_seconds` decimal(7,2) DEFAULT 0.00,
  PRIMARY KEY (`cpd_id`),
  KEY `uniqueid` (`uniqueid`),
  KEY `callerid` (`callerid`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_cpd_log`
--

/*!40000 ALTER TABLE `vicidial_cpd_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_cpd_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_custom_cid`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_custom_cid` (
  `cid` varchar(18) NOT NULL,
  `state` varchar(20) DEFAULT NULL,
  `areacode` varchar(6) DEFAULT NULL,
  `country_code` smallint(5) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT '--ALL--',
  KEY `state` (`state`),
  KEY `areacode` (`areacode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_custom_cid`
--

/*!40000 ALTER TABLE `vicidial_custom_cid` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_custom_cid` ENABLE KEYS */;

--
-- Table structure for table `vicidial_custom_leadloader_templates`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_custom_leadloader_templates` (
  `template_id` varchar(20) NOT NULL,
  `template_name` varchar(30) DEFAULT NULL,
  `template_description` varchar(255) DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `standard_variables` text DEFAULT NULL,
  `custom_table` varchar(20) DEFAULT NULL,
  `custom_variables` text DEFAULT NULL,
  `template_statuses` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`template_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_custom_leadloader_templates`
--

/*!40000 ALTER TABLE `vicidial_custom_leadloader_templates` DISABLE KEYS */;
INSERT INTO `vicidial_custom_leadloader_templates` select 'SAMPLE_TEMPLATE','Sample template','',999,'phone_number,9|first_name,0|last_name,1|address1,3|address2,4|address3,5|city,6|state,7|postal_code,8|','custom_999','appointment_date,2|appointment_notes,9|nearest_city,2|','' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_custom_leadloader_templates);
/*!40000 ALTER TABLE `vicidial_custom_leadloader_templates` ENABLE KEYS */;

--
-- Table structure for table `vicidial_custom_reports`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_custom_reports` (
  `custom_report_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report_name` varchar(100) DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `domain` varchar(70) DEFAULT NULL,
  `path_name` text DEFAULT NULL,
  `custom_variables` text DEFAULT NULL,
  `date_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_modify` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`custom_report_id`),
  UNIQUE KEY `custom_report_name_key` (`report_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_custom_reports`
--

/*!40000 ALTER TABLE `vicidial_custom_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_custom_reports` ENABLE KEYS */;

--
-- Table structure for table `vicidial_daily_max_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_daily_max_stats` (
  `stats_date` date NOT NULL,
  `stats_flag` enum('OPEN','CLOSED','CLOSING') DEFAULT 'CLOSED',
  `stats_type` enum('TOTAL','INGROUP','CAMPAIGN','') DEFAULT '',
  `campaign_id` varchar(20) DEFAULT '',
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `closed_time` datetime DEFAULT NULL,
  `max_channels` mediumint(8) unsigned DEFAULT 0,
  `max_calls` mediumint(8) unsigned DEFAULT 0,
  `max_inbound` mediumint(8) unsigned DEFAULT 0,
  `max_outbound` mediumint(8) unsigned DEFAULT 0,
  `max_agents` mediumint(8) unsigned DEFAULT 0,
  `max_remote_agents` mediumint(8) unsigned DEFAULT 0,
  `total_calls` int(9) unsigned DEFAULT 0,
  KEY `stats_date` (`stats_date`),
  KEY `stats_flag` (`stats_flag`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_daily_max_stats`
--

/*!40000 ALTER TABLE `vicidial_daily_max_stats` DISABLE KEYS */;
INSERT INTO `vicidial_daily_max_stats` 
(stats_date, stats_flag, stats_type, campaign_id, update_time, closed_time, max_channels, max_calls, max_inbound, max_outbound, max_agents, max_remote_agents, total_calls)
SELECT stats_date, stats_flag, stats_type, campaign_id, update_time, closed_time, max_channels, max_calls, max_inbound, max_outbound, max_agents, max_remote_agents, total_calls FROM (
    SELECT '2025-06-23' AS stats_date, 'OPEN' AS stats_flag, 'INGROUP' AS stats_type, 'AGENTDIRECT' AS campaign_id, '2025-06-23 16:45:05' AS update_time, NULL AS closed_time, 0 AS max_channels, 0 AS max_calls, 0 AS max_inbound, 0 AS max_outbound, 0 AS max_agents, 0 AS max_remote_agents, 0 AS total_calls
    UNION ALL
    SELECT '2025-06-23', 'OPEN', 'INGROUP', 'AGENTDIRECT_CHAT', '2025-06-23 16:45:05', NULL, 0, 0, 0, 0, 0, 0, 0
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_daily_max_stats);
/*!40000 ALTER TABLE `vicidial_daily_max_stats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_daily_ra_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_daily_ra_stats` (
  `stats_date` date NOT NULL,
  `stats_flag` enum('OPEN','CLOSED','CLOSING') DEFAULT 'CLOSED',
  `user` varchar(20) DEFAULT '',
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `closed_time` datetime DEFAULT NULL,
  `max_calls` mediumint(8) unsigned DEFAULT 0,
  `total_calls` int(9) unsigned DEFAULT 0,
  KEY `stats_date` (`stats_date`),
  KEY `stats_flag` (`stats_flag`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_daily_ra_stats`
--

/*!40000 ALTER TABLE `vicidial_daily_ra_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_daily_ra_stats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_daily_rt_monitoring_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_daily_rt_monitoring_log` (
  `manager_user` varchar(20) NOT NULL,
  `manager_server_ip` varchar(15) NOT NULL,
  `manager_phone` varchar(20) NOT NULL,
  `manager_ip` varchar(15) DEFAULT NULL,
  `agent_user` varchar(20) DEFAULT NULL,
  `agent_server_ip` varchar(15) DEFAULT NULL,
  `agent_status` varchar(10) DEFAULT NULL,
  `agent_session` varchar(10) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `monitor_start_time` datetime DEFAULT NULL,
  `monitor_end_time` datetime DEFAULT NULL,
  `monitor_sec` int(9) unsigned DEFAULT 0,
  `monitor_type` enum('LISTEN','BARGE','HIJACK','WHISPER') DEFAULT 'LISTEN',
  UNIQUE KEY `caller_code` (`caller_code`),
  KEY `manager_user` (`manager_user`),
  KEY `agent_user` (`agent_user`),
  KEY `monitor_start_time` (`monitor_start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_daily_rt_monitoring_log`
--

/*!40000 ALTER TABLE `vicidial_daily_rt_monitoring_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_daily_rt_monitoring_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_demographic_quotas_goals`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_demographic_quotas_goals` (
  `vdqg_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` varchar(8) DEFAULT '',
  `demographic_quotas_container` varchar(40) DEFAULT '',
  `quota_field` varchar(20) DEFAULT '',
  `quota_field_order` tinyint(3) DEFAULT 0,
  `quota_value` varchar(100) DEFAULT '',
  `quota_value_order` tinyint(3) DEFAULT 0,
  `quota_goal` mediumint(7) DEFAULT 0,
  `quota_count` mediumint(7) DEFAULT 0,
  `quota_leads_total` mediumint(7) DEFAULT 0,
  `quota_leads_active` mediumint(7) DEFAULT 0,
  `quota_status` varchar(10) DEFAULT 'ACTIVE',
  `quota_modify_date` datetime DEFAULT NULL,
  `last_lead_id` int(9) unsigned DEFAULT 0,
  `last_list_id` bigint(14) unsigned DEFAULT 0,
  `last_call_date` datetime DEFAULT NULL,
  `last_status` varchar(6) DEFAULT '',
  PRIMARY KEY (`vdqg_id`),
  UNIQUE KEY `vdqgi` (`campaign_id`,`quota_field`,`quota_field_order`,`quota_value`,`quota_value_order`),
  KEY `campaign_id` (`campaign_id`),
  KEY `quota_field` (`quota_field`),
  KEY `quota_value` (`quota_value`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_demographic_quotas_goals`
--

/*!40000 ALTER TABLE `vicidial_demographic_quotas_goals` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_demographic_quotas_goals` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dial_cid_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dial_cid_log` (
  `caller_code` varchar(30) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `call_type` enum('OUT','OUTBALANCE','MANUAL','OVERRIDE','3WAY') DEFAULT 'OUT',
  `call_alt` varchar(20) DEFAULT '',
  `outbound_cid` varchar(20) DEFAULT '',
  `outbound_cid_type` varchar(20) DEFAULT '',
  KEY `caller_code` (`caller_code`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dial_cid_log`
--

/*!40000 ALTER TABLE `vicidial_dial_cid_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dial_cid_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dial_cid_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dial_cid_log_archive` (
  `caller_code` varchar(30) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `call_type` enum('OUT','OUTBALANCE','MANUAL','OVERRIDE','3WAY') DEFAULT 'OUT',
  `call_alt` varchar(20) DEFAULT '',
  `outbound_cid` varchar(20) DEFAULT '',
  `outbound_cid_type` varchar(20) DEFAULT '',
  UNIQUE KEY `caller_code_date` (`caller_code`,`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dial_cid_log_archive`
--

/*!40000 ALTER TABLE `vicidial_dial_cid_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dial_cid_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dial_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dial_log` (
  `caller_code` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT 0,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `extension` varchar(100) DEFAULT '',
  `channel` varchar(100) DEFAULT '',
  `context` varchar(100) DEFAULT '',
  `timeout` mediumint(7) unsigned DEFAULT 0,
  `outbound_cid` varchar(100) DEFAULT '',
  `sip_hangup_cause` smallint(4) unsigned DEFAULT 0,
  `sip_hangup_reason` varchar(50) DEFAULT '',
  `uniqueid` varchar(20) DEFAULT '',
  KEY `caller_code` (`caller_code`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dial_log`
--

/*!40000 ALTER TABLE `vicidial_dial_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dial_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dial_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dial_log_archive` (
  `caller_code` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT 0,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `extension` varchar(100) DEFAULT '',
  `channel` varchar(100) DEFAULT '',
  `context` varchar(100) DEFAULT '',
  `timeout` mediumint(7) unsigned DEFAULT 0,
  `outbound_cid` varchar(100) DEFAULT '',
  `sip_hangup_cause` smallint(4) unsigned DEFAULT 0,
  `sip_hangup_reason` varchar(50) DEFAULT '',
  `uniqueid` varchar(20) DEFAULT '',
  UNIQUE KEY `vddla` (`caller_code`,`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dial_log_archive`
--

/*!40000 ALTER TABLE `vicidial_dial_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dial_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_did_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_did_agent_log` (
  `uniqueid` varchar(20) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id_number` varchar(18) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `did_id` varchar(9) DEFAULT '',
  `did_description` varchar(50) DEFAULT '',
  `did_route` varchar(20) DEFAULT '',
  `group_id` varchar(20) DEFAULT '',
  `user` varchar(20) DEFAULT 'VDCL',
  KEY `uniqueid` (`uniqueid`),
  KEY `caller_id_number` (`caller_id_number`),
  KEY `extension` (`extension`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_did_agent_log`
--

/*!40000 ALTER TABLE `vicidial_did_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_did_agent_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_did_agent_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_did_agent_log_archive` (
  `uniqueid` varchar(20) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id_number` varchar(18) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `did_id` varchar(9) DEFAULT '',
  `did_description` varchar(50) DEFAULT '',
  `did_route` varchar(20) DEFAULT '',
  `group_id` varchar(20) DEFAULT '',
  `user` varchar(20) DEFAULT 'VDCL',
  UNIQUE KEY `vdala` (`uniqueid`,`call_date`,`did_route`),
  KEY `uniqueid` (`uniqueid`),
  KEY `caller_id_number` (`caller_id_number`),
  KEY `extension` (`extension`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_did_agent_log_archive`
--

/*!40000 ALTER TABLE `vicidial_did_agent_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_did_agent_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_did_gateway_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_did_gateway_log` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id_number` varchar(18) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `VICIrecGatewayID` varchar(30) DEFAULT '',
  KEY `uniqueid` (`uniqueid`),
  KEY `VICIrecGatewayID` (`VICIrecGatewayID`),
  KEY `extension` (`extension`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_did_gateway_log`
--

/*!40000 ALTER TABLE `vicidial_did_gateway_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_did_gateway_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_did_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_did_log` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id_number` varchar(18) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `did_id` varchar(9) DEFAULT '',
  `did_route` varchar(20) DEFAULT '',
  KEY `uniqueid` (`uniqueid`),
  KEY `caller_id_number` (`caller_id_number`),
  KEY `extension` (`extension`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_did_log`
--

/*!40000 ALTER TABLE `vicidial_did_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_did_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_did_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_did_log_archive` (
  `uniqueid` varchar(20) NOT NULL,
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `caller_id_number` varchar(18) DEFAULT NULL,
  `caller_id_name` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `did_id` varchar(9) DEFAULT '',
  `did_route` varchar(20) DEFAULT '',
  UNIQUE KEY `vdidla_key` (`uniqueid`,`call_date`,`server_ip`),
  KEY `uniqueid` (`uniqueid`),
  KEY `caller_id_number` (`caller_id_number`),
  KEY `extension` (`extension`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_did_log_archive`
--

/*!40000 ALTER TABLE `vicidial_did_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_did_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_did_ra_extensions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_did_ra_extensions` (
  `did_id` int(9) unsigned NOT NULL,
  `user_start` varchar(20) DEFAULT NULL,
  `extension` varchar(50) DEFAULT '',
  `description` varchar(50) DEFAULT NULL,
  `active` enum('Y','N','') DEFAULT '',
  `call_count_today` mediumint(7) DEFAULT 0,
  UNIQUE KEY `didraexten` (`did_id`,`user_start`,`extension`),
  KEY `did_id` (`did_id`),
  KEY `user_start` (`user_start`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_did_ra_extensions`
--

/*!40000 ALTER TABLE `vicidial_did_ra_extensions` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_did_ra_extensions` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dnc`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dnc` (
  `phone_number` varchar(18) NOT NULL,
  PRIMARY KEY (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dnc`
--

/*!40000 ALTER TABLE `vicidial_dnc` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dnc` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dnc_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dnc_log` (
  `phone_number` varchar(18) NOT NULL,
  `campaign_id` varchar(8) NOT NULL,
  `action` enum('add','delete') DEFAULT 'add',
  `action_date` datetime NOT NULL,
  `user` varchar(20) DEFAULT '',
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dnc_log`
--

/*!40000 ALTER TABLE `vicidial_dnc_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dnc_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dnccom_filter_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dnccom_filter_log` (
  `filter_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `filter_date` datetime DEFAULT NULL,
  `new_status` varchar(6) DEFAULT NULL,
  `old_status` varchar(6) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `dnccom_data` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`filter_log_id`),
  KEY `lead_id` (`lead_id`),
  KEY `filter_date` (`filter_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dnccom_filter_log`
--

/*!40000 ALTER TABLE `vicidial_dnccom_filter_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dnccom_filter_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dnccom_scrub_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dnccom_scrub_log` (
  `phone_number` varchar(18) DEFAULT NULL,
  `scrub_date` datetime NOT NULL,
  `flag_invalid` enum('','0','1') DEFAULT '',
  `flag_dnc` enum('','0','1') DEFAULT '',
  `flag_projdnc` enum('','0','1') DEFAULT '',
  `flag_litigator` enum('','0','1') DEFAULT '',
  `full_response` varchar(255) DEFAULT '',
  KEY `phone_number` (`phone_number`),
  KEY `scrub_date` (`scrub_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dnccom_scrub_log`
--

/*!40000 ALTER TABLE `vicidial_dnccom_scrub_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dnccom_scrub_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_drop_lists`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_drop_lists` (
  `dl_id` varchar(30) NOT NULL,
  `dl_name` varchar(100) DEFAULT NULL,
  `last_run` datetime DEFAULT NULL,
  `dl_server` varchar(30) DEFAULT 'active_voicemail_server',
  `dl_times` varchar(120) DEFAULT '',
  `dl_weekdays` varchar(7) DEFAULT '',
  `dl_monthdays` varchar(100) DEFAULT '',
  `drop_statuses` varchar(255) DEFAULT ' DROP -',
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `duplicate_check` varchar(50) DEFAULT 'NONE',
  `run_now_trigger` enum('N','Y') DEFAULT 'N',
  `active` enum('N','Y') DEFAULT 'N',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `closer_campaigns` text DEFAULT NULL,
  `dl_minutes` mediumint(6) unsigned DEFAULT 0,
  UNIQUE KEY `dl_id` (`dl_id`),
  KEY `dl_times` (`dl_times`),
  KEY `run_now_trigger` (`run_now_trigger`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_drop_lists`
--

/*!40000 ALTER TABLE `vicidial_drop_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_drop_lists` ENABLE KEYS */;

--
-- Table structure for table `vicidial_drop_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_drop_log` (
  `uniqueid` varchar(50) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `drop_date` datetime NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `campaign_id` varchar(20) NOT NULL,
  `status` varchar(6) NOT NULL,
  `drop_processed` enum('N','Y','U') DEFAULT 'N',
  KEY `drop_date` (`drop_date`),
  KEY `drop_processed` (`drop_processed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_drop_log`
--

/*!40000 ALTER TABLE `vicidial_drop_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_drop_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_drop_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_drop_log_archive` (
  `uniqueid` varchar(50) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `drop_date` datetime NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `campaign_id` varchar(20) NOT NULL,
  `status` varchar(6) NOT NULL,
  `drop_processed` enum('N','Y','U') DEFAULT 'N',
  UNIQUE KEY `vicidial_drop_log_archive_key` (`drop_date`,`uniqueid`),
  KEY `drop_processed` (`drop_processed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_drop_log_archive`
--

/*!40000 ALTER TABLE `vicidial_drop_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_drop_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_drop_rate_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_drop_rate_groups` (
  `group_id` varchar(20) NOT NULL,
  `update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `calls_today` int(9) unsigned DEFAULT 0,
  `answers_today` int(9) unsigned DEFAULT 0,
  `drops_today` double(12,3) DEFAULT 0.000,
  `drops_today_pct` varchar(6) DEFAULT '0',
  `drops_answers_today_pct` varchar(6) DEFAULT '0',
  `answering_machines_today` int(9) unsigned DEFAULT 0,
  `agenthandled_today` int(9) unsigned DEFAULT 0,
  PRIMARY KEY (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_drop_rate_groups`
--

/*!40000 ALTER TABLE `vicidial_drop_rate_groups` DISABLE KEYS */;
INSERT INTO `vicidial_drop_rate_groups` 
SELECT '101' as col1,'2025-06-23 16:43:09' as col2,0 as col3,0 as col4,0.000 as col5,'0' as col6,'0' as col7,0 as col8,0 as col9
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '101')
UNION ALL
SELECT '102','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '102')
UNION ALL
SELECT '103','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '103')
UNION ALL
SELECT '104','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '104')
UNION ALL
SELECT '105','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '105')
UNION ALL
SELECT '106','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '106')
UNION ALL
SELECT '107','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '107')
UNION ALL
SELECT '108','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '108')
UNION ALL
SELECT '109','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '109')
UNION ALL
SELECT '110','2025-06-23 16:43:09',0,0,0.000,'0','0',0,0
WHERE NOT EXISTS (SELECT 1 FROM vicidial_drop_rate_groups WHERE group_id = '110');
/*!40000 ALTER TABLE `vicidial_drop_rate_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_dtmf_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_dtmf_log` (
  `dtmf_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dtmf_time` datetime DEFAULT NULL,
  `channel` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `uniqueid` varchar(20) DEFAULT '',
  `digit` varchar(1) DEFAULT '',
  `direction` enum('Received','Sent') DEFAULT 'Received',
  `state` enum('BEGIN','END') DEFAULT 'BEGIN',
  PRIMARY KEY (`dtmf_id`),
  KEY `vicidial_dtmf_uniqueid_key` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_dtmf_log`
--

/*!40000 ALTER TABLE `vicidial_dtmf_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_dtmf_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_email_accounts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_email_accounts` (
  `email_account_id` varchar(20) NOT NULL,
  `email_account_name` varchar(100) DEFAULT NULL,
  `email_account_description` varchar(255) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  `protocol` enum('POP3','IMAP','SMTP') DEFAULT 'IMAP',
  `email_replyto_address` varchar(255) DEFAULT NULL,
  `email_account_server` varchar(255) DEFAULT NULL,
  `email_account_user` varchar(255) DEFAULT NULL,
  `email_account_pass` varchar(100) DEFAULT NULL,
  `pop3_auth_mode` enum('BEST','PASS','APOP','CRAM-MD5') DEFAULT 'BEST',
  `active` enum('Y','N') DEFAULT 'N',
  `email_frequency_check_mins` tinyint(3) unsigned DEFAULT 5,
  `group_id` varchar(20) DEFAULT NULL,
  `default_list_id` bigint(14) unsigned DEFAULT NULL,
  `call_handle_method` varchar(20) DEFAULT 'CID',
  `agent_search_method` enum('LO','LB','SO') DEFAULT 'LB',
  `campaign_id` varchar(8) DEFAULT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `email_account_type` enum('INBOUND','OUTBOUND') DEFAULT 'INBOUND',
  PRIMARY KEY (`email_account_id`),
  KEY `email_accounts_group_key` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_email_accounts`
--

/*!40000 ALTER TABLE `vicidial_email_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_email_accounts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_email_list`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_email_list` (
  `email_row_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `email_date` datetime DEFAULT NULL,
  `protocol` enum('POP3','IMAP','NONE') DEFAULT 'IMAP',
  `email_to` varchar(255) DEFAULT NULL,
  `email_from` varchar(255) DEFAULT NULL,
  `email_from_name` varchar(255) DEFAULT NULL,
  `subject` text DEFAULT NULL,
  `mime_type` text DEFAULT NULL,
  `content_type` text DEFAULT NULL,
  `content_transfer_encoding` text DEFAULT NULL,
  `x_mailer` text DEFAULT NULL,
  `sender_ip` varchar(25) DEFAULT NULL,
  `message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `email_account_id` varchar(20) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL,
  `direction` enum('INBOUND','OUTBOUND') DEFAULT 'INBOUND',
  `uniqueid` varchar(20) DEFAULT NULL,
  `xfercallid` int(9) unsigned DEFAULT NULL,
  PRIMARY KEY (`email_row_id`),
  KEY `email_list_account_key` (`email_account_id`),
  KEY `email_list_user_key` (`user`),
  KEY `vicidial_email_lead_id_key` (`lead_id`),
  KEY `vicidial_email_group_key` (`group_id`),
  KEY `vicidial_email_xfer_key` (`xfercallid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_email_list`
--

/*!40000 ALTER TABLE `vicidial_email_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_email_list` ENABLE KEYS */;

--
-- Table structure for table `vicidial_email_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_email_log` (
  `email_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_row_id` int(10) unsigned DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `email_date` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `email_to` varchar(255) DEFAULT NULL,
  `message` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `campaign_id` varchar(10) DEFAULT NULL,
  `attachments` text DEFAULT NULL,
  PRIMARY KEY (`email_log_id`),
  KEY `vicidial_email_log_lead_id_key` (`lead_id`),
  KEY `vicidial_email_log_email_row_id_key` (`email_row_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_email_log`
--

/*!40000 ALTER TABLE `vicidial_email_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_email_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_extension_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_extension_groups` (
  `extension_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `extension_group_id` varchar(20) NOT NULL,
  `extension` varchar(100) DEFAULT '8300',
  `rank` mediumint(7) DEFAULT 0,
  `campaign_groups` text DEFAULT NULL,
  `call_count_today` mediumint(7) DEFAULT 0,
  `last_call_time` datetime DEFAULT NULL,
  `last_callerid` varchar(20) DEFAULT '',
  PRIMARY KEY (`extension_id`),
  KEY `extension_group_id` (`extension_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_extension_groups`
--

/*!40000 ALTER TABLE `vicidial_extension_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_extension_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_filter_phone_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_filter_phone_groups` (
  `filter_phone_group_id` varchar(20) NOT NULL,
  `filter_phone_group_name` varchar(40) NOT NULL,
  `filter_phone_group_description` varchar(100) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  KEY `filter_phone_group_id` (`filter_phone_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_filter_phone_groups`
--

/*!40000 ALTER TABLE `vicidial_filter_phone_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_filter_phone_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_filter_phone_numbers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_filter_phone_numbers` (
  `phone_number` varchar(18) NOT NULL,
  `filter_phone_group_id` varchar(20) NOT NULL,
  UNIQUE KEY `phonefilter` (`phone_number`,`filter_phone_group_id`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_filter_phone_numbers`
--

/*!40000 ALTER TABLE `vicidial_filter_phone_numbers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_filter_phone_numbers` ENABLE KEYS */;

--
-- Table structure for table `vicidial_grab_call_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_grab_call_log` (
  `auto_call_id` int(9) unsigned NOT NULL,
  `user` varchar(20) DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `call_time` datetime DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `queue_priority` tinyint(2) DEFAULT 0,
  `call_type` enum('IN','OUT','OUTBALANCE') DEFAULT 'OUT',
  KEY `auto_call_id` (`auto_call_id`),
  KEY `event_date` (`event_date`),
  KEY `user` (`user`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_grab_call_log`
--

/*!40000 ALTER TABLE `vicidial_grab_call_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_grab_call_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_hci_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_hci_agent_log` (
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `user_ip` varchar(45) DEFAULT '',
  `login_time` datetime DEFAULT NULL,
  `last_call_time` datetime DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  KEY `user` (`user`),
  KEY `login_time` (`login_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_hci_agent_log`
--

/*!40000 ALTER TABLE `vicidial_hci_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_hci_agent_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_hci_live_agents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_hci_live_agents` (
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `user_ip` varchar(45) DEFAULT '',
  `login_time` datetime DEFAULT NULL,
  `last_call_time` datetime DEFAULT NULL,
  `last_update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(40) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT 0,
  `phone_number` varchar(18) DEFAULT NULL,
  `random_id` int(8) unsigned DEFAULT NULL,
  KEY `user` (`user`),
  KEY `campaign_id` (`campaign_id`),
  KEY `last_update_time` (`last_update_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_hci_live_agents`
--

/*!40000 ALTER TABLE `vicidial_hci_live_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_hci_live_agents` ENABLE KEYS */;

--
-- Table structure for table `vicidial_hci_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_hci_log` (
  `user` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  `user_ip` varchar(45) DEFAULT '',
  KEY `user` (`user`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_hci_log`
--

/*!40000 ALTER TABLE `vicidial_hci_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_hci_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_hci_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_hci_log_archive` (
  `user` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  `user_ip` varchar(45) DEFAULT '',
  UNIQUE KEY `vhlclu` (`call_date`,`lead_id`,`user`),
  KEY `user` (`user`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_hci_log_archive`
--

/*!40000 ALTER TABLE `vicidial_hci_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_hci_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_hci_reserve`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_hci_reserve` (
  `user` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `reserve_date` datetime DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` varchar(40) DEFAULT NULL,
  UNIQUE KEY `vhcir` (`lead_id`,`user`,`campaign_id`),
  KEY `user` (`user`),
  KEY `reserve_date` (`reserve_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_hci_reserve`
--

/*!40000 ALTER TABLE `vicidial_hci_reserve` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_hci_reserve` ENABLE KEYS */;

--
-- Table structure for table `vicidial_hopper`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_hopper` (
  `hopper_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` enum('READY','QUEUE','INCALL','DONE','HOLD','DNC','RHOLD','RQUEUE') DEFAULT 'READY',
  `user` varchar(20) DEFAULT NULL,
  `list_id` bigint(14) unsigned NOT NULL,
  `gmt_offset_now` decimal(4,2) DEFAULT 0.00,
  `state` varchar(2) DEFAULT '',
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `priority` tinyint(2) DEFAULT 0,
  `source` varchar(1) DEFAULT '',
  `vendor_lead_code` varchar(20) DEFAULT '',
  PRIMARY KEY (`hopper_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_hopper`
--

/*!40000 ALTER TABLE `vicidial_hopper` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_hopper` ENABLE KEYS */;

--
-- Table structure for table `vicidial_html_cache_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_html_cache_stats` (
  `stats_type` varchar(20) NOT NULL,
  `stats_id` varchar(20) NOT NULL,
  `stats_date` datetime NOT NULL,
  `stats_count` int(9) unsigned DEFAULT 0,
  `stats_html` mediumtext DEFAULT NULL,
  UNIQUE KEY `vicidial_html_cache_stats_key` (`stats_type`,`stats_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_html_cache_stats`
--

/*!40000 ALTER TABLE `vicidial_html_cache_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_html_cache_stats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_callback_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_callback_queue` (
  `icbq_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `icbq_date` datetime DEFAULT NULL,
  `icbq_status` varchar(10) DEFAULT NULL,
  `icbq_phone_number` varchar(20) DEFAULT NULL,
  `icbq_phone_code` varchar(10) DEFAULT NULL,
  `icbq_nextday_choice` enum('Y','N','U') DEFAULT 'U',
  `lead_id` int(9) unsigned NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `queue_priority` tinyint(2) DEFAULT 0,
  `call_date` datetime DEFAULT NULL,
  `gmt_offset_now` decimal(4,2) DEFAULT 0.00,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`icbq_id`),
  KEY `icbq_status` (`icbq_status`),
  KEY `group_id` (`group_id`),
  KEY `icbq_date` (`icbq_date`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_callback_queue`
--

/*!40000 ALTER TABLE `vicidial_inbound_callback_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_callback_queue` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_callback_queue_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_callback_queue_archive` (
  `icbq_id` int(9) unsigned NOT NULL,
  `icbq_date` datetime DEFAULT NULL,
  `icbq_status` varchar(10) DEFAULT NULL,
  `icbq_phone_number` varchar(20) DEFAULT NULL,
  `icbq_phone_code` varchar(10) DEFAULT NULL,
  `icbq_nextday_choice` enum('Y','N','U') DEFAULT 'U',
  `lead_id` int(9) unsigned NOT NULL,
  `group_id` varchar(20) NOT NULL,
  `queue_priority` tinyint(2) DEFAULT 0,
  `call_date` datetime DEFAULT NULL,
  `gmt_offset_now` decimal(4,2) DEFAULT 0.00,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`icbq_id`),
  KEY `icbq_status` (`icbq_status`),
  KEY `group_id` (`group_id`),
  KEY `icbq_date` (`icbq_date`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_callback_queue_archive`
--

/*!40000 ALTER TABLE `vicidial_inbound_callback_queue_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_callback_queue_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_caller_codes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_caller_codes` (
  `uniqueid` varchar(50) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `group_id` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `prev_caller_code` varchar(40) NOT NULL,
  UNIQUE KEY `cicc_cd` (`caller_code`,`uniqueid`),
  KEY `uniqueid` (`uniqueid`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_caller_codes`
--

/*!40000 ALTER TABLE `vicidial_inbound_caller_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_caller_codes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_caller_codes_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_caller_codes_archive` (
  `uniqueid` varchar(50) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `group_id` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `prev_caller_code` varchar(40) NOT NULL,
  UNIQUE KEY `cicc_cd` (`caller_code`,`uniqueid`),
  KEY `uniqueid` (`uniqueid`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_caller_codes_archive`
--

/*!40000 ALTER TABLE `vicidial_inbound_caller_codes_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_caller_codes_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_dids`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_dids` (
  `did_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `did_pattern` varchar(50) NOT NULL,
  `did_description` varchar(50) DEFAULT NULL,
  `did_active` enum('Y','N') DEFAULT 'Y',
  `did_route` enum('EXTEN','VOICEMAIL','AGENT','PHONE','IN_GROUP','CALLMENU','VMAIL_NO_INST') DEFAULT 'EXTEN',
  `extension` varchar(50) DEFAULT '9998811112',
  `exten_context` varchar(50) DEFAULT 'default',
  `voicemail_ext` varchar(10) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `user_unavailable_action` enum('IN_GROUP','EXTEN','VOICEMAIL','PHONE','VMAIL_NO_INST') DEFAULT 'VOICEMAIL',
  `user_route_settings_ingroup` varchar(20) DEFAULT 'AGENTDIRECT',
  `group_id` varchar(20) DEFAULT NULL,
  `call_handle_method` varchar(40) DEFAULT 'CID',
  `agent_search_method` enum('LO','LB','SO') DEFAULT 'LB',
  `list_id` bigint(14) unsigned DEFAULT 999,
  `campaign_id` varchar(8) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT '1',
  `menu_id` varchar(50) DEFAULT '',
  `record_call` enum('Y','N','Y_QUEUESTOP') DEFAULT 'N',
  `filter_inbound_number` enum('DISABLED','GROUP','URL','DNC_INTERNAL','DNC_CAMPAIGN','GROUP_AREACODE') DEFAULT 'DISABLED',
  `filter_phone_group_id` text DEFAULT NULL,
  `filter_url` varchar(1000) DEFAULT '',
  `filter_action` enum('EXTEN','VOICEMAIL','AGENT','PHONE','IN_GROUP','CALLMENU','VMAIL_NO_INST') DEFAULT 'EXTEN',
  `filter_extension` varchar(50) DEFAULT '9998811112',
  `filter_exten_context` varchar(50) DEFAULT 'default',
  `filter_voicemail_ext` varchar(10) DEFAULT NULL,
  `filter_phone` varchar(100) DEFAULT NULL,
  `filter_server_ip` varchar(15) DEFAULT NULL,
  `filter_user` varchar(20) DEFAULT NULL,
  `filter_user_unavailable_action` enum('IN_GROUP','EXTEN','VOICEMAIL','PHONE','VMAIL_NO_INST') DEFAULT 'VOICEMAIL',
  `filter_user_route_settings_ingroup` varchar(20) DEFAULT 'AGENTDIRECT',
  `filter_group_id` varchar(20) DEFAULT NULL,
  `filter_call_handle_method` varchar(40) DEFAULT 'CID',
  `filter_agent_search_method` enum('LO','LB','SO') DEFAULT 'LB',
  `filter_list_id` bigint(14) unsigned DEFAULT 999,
  `filter_campaign_id` varchar(8) DEFAULT NULL,
  `filter_phone_code` varchar(10) DEFAULT '1',
  `filter_menu_id` varchar(50) DEFAULT '',
  `filter_clean_cid_number` varchar(20) DEFAULT '',
  `custom_one` varchar(100) DEFAULT '',
  `custom_two` varchar(100) DEFAULT '',
  `custom_three` varchar(100) DEFAULT '',
  `custom_four` varchar(100) DEFAULT '',
  `custom_five` varchar(100) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `filter_dnc_campaign` varchar(8) DEFAULT '',
  `filter_url_did_redirect` enum('Y','N') DEFAULT 'N',
  `no_agent_ingroup_redirect` enum('DISABLED','Y','NO_PAUSED','READY_ONLY') DEFAULT 'DISABLED',
  `no_agent_ingroup_id` varchar(20) DEFAULT '',
  `no_agent_ingroup_extension` varchar(50) DEFAULT '9998811112',
  `pre_filter_phone_group_id` text DEFAULT NULL,
  `pre_filter_extension` varchar(50) DEFAULT '',
  `entry_list_id` bigint(14) unsigned DEFAULT 0,
  `filter_entry_list_id` bigint(14) unsigned DEFAULT 0,
  `max_queue_ingroup_calls` smallint(5) DEFAULT 0,
  `max_queue_ingroup_id` varchar(20) DEFAULT '',
  `max_queue_ingroup_extension` varchar(50) DEFAULT '9998811112',
  `did_carrier_description` varchar(255) DEFAULT '',
  `inbound_route_answer` enum('Y','N') DEFAULT 'Y',
  `pre_filter_recent_call` varchar(20) DEFAULT '',
  `pre_filter_recent_extension` varchar(50) DEFAULT '',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`did_id`),
  UNIQUE KEY `did_pattern` (`did_pattern`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_dids`
--

/*!40000 ALTER TABLE `vicidial_inbound_dids` DISABLE KEYS */;
INSERT INTO `vicidial_inbound_dids` select 1,'default','Default DID','Y','EXTEN','9998811112','default',NULL,NULL,NULL,NULL,'VOICEMAIL','AGENTDIRECT',NULL,'CID','LB',999,NULL,'1','','N','DISABLED',NULL,'','EXTEN','9998811112','default',NULL,NULL,NULL,NULL,'VOICEMAIL','AGENTDIRECT',NULL,'CID','LB',999,NULL,'1','','','','','','','','---ALL---','','N','DISABLED','','9998811112',NULL,'',0,0,0,'','9998811112','','Y','','','2025-06-23 16:43:09' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_inbound_dids);
/*!40000 ALTER TABLE `vicidial_inbound_dids` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_group_agents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_group_agents` (
  `user` varchar(20) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `group_rank` tinyint(1) DEFAULT 0,
  `group_weight` tinyint(1) DEFAULT 0,
  `calls_today` smallint(5) unsigned DEFAULT 0,
  `group_web_vars` varchar(255) DEFAULT '',
  `group_grade` tinyint(2) unsigned DEFAULT 1,
  `group_type` varchar(1) DEFAULT 'C',
  `calls_today_filtered` smallint(5) unsigned DEFAULT 0,
  `daily_limit` smallint(5) DEFAULT -1,
  UNIQUE KEY `viga_user_group_id` (`user`,`group_id`),
  KEY `group_id` (`group_id`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_group_agents`
--

/*!40000 ALTER TABLE `vicidial_inbound_group_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_group_agents` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_groups` (
  `group_id` varchar(20) NOT NULL,
  `group_name` varchar(30) DEFAULT NULL,
  `group_color` varchar(20) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `web_form_address` text DEFAULT NULL,
  `voicemail_ext` varchar(10) DEFAULT NULL,
  `next_agent_call` varchar(40) DEFAULT 'longest_wait_time',
  `fronter_display` enum('Y','N') DEFAULT 'Y',
  `ingroup_script` varchar(20) DEFAULT NULL,
  `get_call_launch` enum('NONE','SCRIPT','SCRIPTTWO','WEBFORM','WEBFORMTWO','WEBFORMTHREE','FORM','EMAIL') DEFAULT 'NONE',
  `xferconf_a_dtmf` varchar(50) DEFAULT NULL,
  `xferconf_a_number` varchar(50) DEFAULT NULL,
  `xferconf_b_dtmf` varchar(50) DEFAULT NULL,
  `xferconf_b_number` varchar(50) DEFAULT NULL,
  `drop_call_seconds` smallint(4) unsigned DEFAULT 360,
  `drop_action` enum('HANGUP','MESSAGE','VOICEMAIL','IN_GROUP','CALLMENU','VMAIL_NO_INST') DEFAULT 'MESSAGE',
  `drop_exten` varchar(20) DEFAULT '8307',
  `call_time_id` varchar(20) DEFAULT '24hours',
  `after_hours_action` enum('HANGUP','MESSAGE','EXTENSION','VOICEMAIL','IN_GROUP','CALLMENU','VMAIL_NO_INST') DEFAULT 'MESSAGE',
  `after_hours_message_filename` varchar(255) DEFAULT 'vm-goodbye',
  `after_hours_exten` varchar(20) DEFAULT '8300',
  `after_hours_voicemail` varchar(20) DEFAULT NULL,
  `welcome_message_filename` varchar(255) DEFAULT '---NONE---',
  `moh_context` varchar(50) DEFAULT 'default',
  `onhold_prompt_filename` varchar(255) DEFAULT 'generic_hold',
  `prompt_interval` smallint(5) unsigned DEFAULT 60,
  `agent_alert_exten` varchar(100) DEFAULT 'ding',
  `agent_alert_delay` int(6) DEFAULT 1000,
  `default_xfer_group` varchar(20) DEFAULT '---NONE---',
  `queue_priority` tinyint(2) DEFAULT 0,
  `drop_inbound_group` varchar(20) DEFAULT '---NONE---',
  `ingroup_recording_override` enum('DISABLED','NEVER','ONDEMAND','ALLCALLS','ALLFORCE') DEFAULT 'DISABLED',
  `ingroup_rec_filename` varchar(50) DEFAULT 'NONE',
  `afterhours_xfer_group` varchar(20) DEFAULT '---NONE---',
  `qc_enabled` enum('Y','N') DEFAULT 'N',
  `qc_statuses` text DEFAULT NULL,
  `qc_shift_id` varchar(20) DEFAULT '24HRMIDNIGHT',
  `qc_get_record_launch` enum('NONE','SCRIPT','WEBFORM','QCSCRIPT','QCWEBFORM') DEFAULT 'NONE',
  `qc_show_recording` enum('Y','N') DEFAULT 'Y',
  `qc_web_form_address` varchar(255) DEFAULT NULL,
  `qc_script` varchar(20) DEFAULT NULL,
  `play_place_in_line` enum('Y','N') DEFAULT 'N',
  `play_estimate_hold_time` enum('Y','N') DEFAULT 'N',
  `hold_time_option` varchar(30) DEFAULT 'NONE',
  `hold_time_option_seconds` smallint(5) DEFAULT 360,
  `hold_time_option_exten` varchar(20) DEFAULT '8300',
  `hold_time_option_voicemail` varchar(20) DEFAULT '',
  `hold_time_option_xfer_group` varchar(20) DEFAULT '---NONE---',
  `hold_time_option_callback_filename` varchar(255) DEFAULT 'vm-hangup',
  `hold_time_option_callback_list_id` bigint(14) unsigned DEFAULT 999,
  `hold_recall_xfer_group` varchar(20) DEFAULT '---NONE---',
  `no_delay_call_route` enum('Y','N') DEFAULT 'N',
  `play_welcome_message` enum('ALWAYS','NEVER','IF_WAIT_ONLY','YES_UNLESS_NODELAY') DEFAULT 'ALWAYS',
  `answer_sec_pct_rt_stat_one` smallint(5) unsigned DEFAULT 20,
  `answer_sec_pct_rt_stat_two` smallint(5) unsigned DEFAULT 30,
  `default_group_alias` varchar(30) DEFAULT '',
  `no_agent_no_queue` enum('N','Y','NO_PAUSED','NO_READY') DEFAULT 'N',
  `no_agent_action` enum('CALLMENU','INGROUP','DID','MESSAGE','EXTENSION','VOICEMAIL','VMAIL_NO_INST') DEFAULT 'MESSAGE',
  `no_agent_action_value` varchar(255) DEFAULT 'nbdy-avail-to-take-call|vm-goodbye',
  `web_form_address_two` text DEFAULT NULL,
  `timer_action` varchar(20) DEFAULT 'NONE',
  `timer_action_message` varchar(255) DEFAULT '',
  `timer_action_seconds` mediumint(7) DEFAULT -1,
  `start_call_url` text DEFAULT NULL,
  `dispo_call_url` text DEFAULT NULL,
  `xferconf_c_number` varchar(50) DEFAULT '',
  `xferconf_d_number` varchar(50) DEFAULT '',
  `xferconf_e_number` varchar(50) DEFAULT '',
  `ignore_list_script_override` enum('Y','N') DEFAULT 'N',
  `extension_appended_cidname` enum('Y','N','Y_USER','Y_WITH_CAMPAIGN','Y_USER_WITH_CAMPAIGN') DEFAULT 'N',
  `uniqueid_status_display` enum('DISABLED','ENABLED','ENABLED_PREFIX','ENABLED_PRESERVE') DEFAULT 'DISABLED',
  `uniqueid_status_prefix` varchar(50) DEFAULT '',
  `hold_time_option_minimum` smallint(5) DEFAULT 0,
  `hold_time_option_press_filename` varchar(255) DEFAULT 'to-be-called-back|digits/1',
  `hold_time_option_callmenu` varchar(50) DEFAULT '',
  `hold_time_option_no_block` enum('N','Y') DEFAULT 'N',
  `hold_time_option_prompt_seconds` smallint(5) DEFAULT 10,
  `onhold_prompt_no_block` enum('N','Y') DEFAULT 'N',
  `onhold_prompt_seconds` smallint(5) DEFAULT 9,
  `hold_time_second_option` varchar(30) DEFAULT 'NONE',
  `hold_time_third_option` varchar(30) DEFAULT 'NONE',
  `wait_hold_option_priority` enum('WAIT','HOLD','BOTH') DEFAULT 'WAIT',
  `wait_time_option` varchar(30) DEFAULT 'NONE',
  `wait_time_second_option` varchar(30) DEFAULT 'NONE',
  `wait_time_third_option` varchar(30) DEFAULT 'NONE',
  `wait_time_option_seconds` smallint(5) DEFAULT 120,
  `wait_time_option_exten` varchar(20) DEFAULT '8300',
  `wait_time_option_voicemail` varchar(20) DEFAULT '',
  `wait_time_option_xfer_group` varchar(20) DEFAULT '---NONE---',
  `wait_time_option_callmenu` varchar(50) DEFAULT '',
  `wait_time_option_callback_filename` varchar(255) DEFAULT 'vm-hangup',
  `wait_time_option_callback_list_id` bigint(14) unsigned DEFAULT 999,
  `wait_time_option_press_filename` varchar(255) DEFAULT 'to-be-called-back|digits/1',
  `wait_time_option_no_block` enum('N','Y') DEFAULT 'N',
  `wait_time_option_prompt_seconds` smallint(5) DEFAULT 10,
  `timer_action_destination` varchar(30) DEFAULT '',
  `calculate_estimated_hold_seconds` smallint(5) unsigned DEFAULT 0,
  `add_lead_url` text DEFAULT NULL,
  `eht_minimum_prompt_filename` varchar(255) DEFAULT '',
  `eht_minimum_prompt_no_block` enum('N','Y') DEFAULT 'N',
  `eht_minimum_prompt_seconds` smallint(5) DEFAULT 10,
  `on_hook_ring_time` smallint(5) DEFAULT 15,
  `na_call_url` text DEFAULT NULL,
  `on_hook_cid` varchar(30) DEFAULT 'CUSTOMER_PHONE_RINGAGENT',
  `group_calldate` datetime DEFAULT NULL,
  `action_xfer_cid` varchar(18) DEFAULT 'CUSTOMER',
  `drop_callmenu` varchar(50) DEFAULT '',
  `after_hours_callmenu` varchar(50) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `max_calls_method` enum('TOTAL','IN_QUEUE','DISABLED') DEFAULT 'DISABLED',
  `max_calls_count` smallint(5) DEFAULT 0,
  `max_calls_action` enum('DROP','AFTERHOURS','NO_AGENT_NO_QUEUE','AREACODE_FILTER') DEFAULT 'NO_AGENT_NO_QUEUE',
  `dial_ingroup_cid` varchar(20) DEFAULT '',
  `group_handling` enum('PHONE','EMAIL','CHAT') DEFAULT 'PHONE',
  `web_form_address_three` text DEFAULT NULL,
  `populate_lead_ingroup` enum('ENABLED','DISABLED') DEFAULT 'ENABLED',
  `drop_lead_reset` enum('Y','N') DEFAULT 'N',
  `after_hours_lead_reset` enum('Y','N') DEFAULT 'N',
  `nanq_lead_reset` enum('Y','N') DEFAULT 'N',
  `wait_time_lead_reset` enum('Y','N') DEFAULT 'N',
  `hold_time_lead_reset` enum('Y','N') DEFAULT 'N',
  `status_group_id` varchar(20) DEFAULT '',
  `routing_initiated_recordings` enum('Y','N') DEFAULT 'Y',
  `on_hook_cid_number` varchar(18) DEFAULT '',
  `customer_chat_screen_colors` varchar(20) DEFAULT 'default',
  `customer_chat_survey_link` text DEFAULT NULL,
  `customer_chat_survey_text` text DEFAULT NULL,
  `populate_lead_province` varchar(20) DEFAULT 'DISABLED',
  `areacode_filter` enum('DISABLED','ALLOW_ONLY','DROP_ONLY') DEFAULT 'DISABLED',
  `areacode_filter_seconds` smallint(5) DEFAULT 10,
  `areacode_filter_action` enum('CALLMENU','INGROUP','DID','MESSAGE','EXTENSION','VOICEMAIL','VMAIL_NO_INST') DEFAULT 'MESSAGE',
  `areacode_filter_action_value` varchar(255) DEFAULT 'nbdy-avail-to-take-call|vm-goodbye',
  `populate_state_areacode` enum('DISABLED','NEW_LEAD_ONLY','OVERWRITE_ALWAYS') DEFAULT 'DISABLED',
  `inbound_survey` enum('DISABLED','ENABLED') DEFAULT 'DISABLED',
  `inbound_survey_filename` text DEFAULT NULL,
  `inbound_survey_accept_digit` varchar(1) DEFAULT '',
  `inbound_survey_question_filename` text DEFAULT NULL,
  `inbound_survey_callmenu` text DEFAULT NULL,
  `icbq_expiration_hours` smallint(5) DEFAULT 96,
  `closing_time_action` varchar(30) DEFAULT 'DISABLED',
  `closing_time_now_trigger` enum('Y','N') DEFAULT 'N',
  `closing_time_filename` text DEFAULT NULL,
  `closing_time_end_filename` text DEFAULT NULL,
  `closing_time_lead_reset` enum('Y','N') DEFAULT 'N',
  `closing_time_option_exten` varchar(20) DEFAULT '8300',
  `closing_time_option_callmenu` varchar(50) DEFAULT '',
  `closing_time_option_voicemail` varchar(20) DEFAULT '',
  `closing_time_option_xfer_group` varchar(20) DEFAULT '---NONE---',
  `closing_time_option_callback_list_id` bigint(14) unsigned DEFAULT 999,
  `add_lead_timezone` enum('SERVER','PHONE_CODE_AREACODE') DEFAULT 'SERVER',
  `icbq_call_time_id` varchar(20) DEFAULT '24hours',
  `icbq_dial_filter` varchar(50) DEFAULT 'NONE',
  `populate_lead_source` varchar(20) DEFAULT 'DISABLED',
  `populate_lead_vendor` varchar(20) DEFAULT 'INBOUND_NUMBER',
  `park_file_name` varchar(100) DEFAULT '',
  `waiting_call_url_on` text DEFAULT NULL,
  `waiting_call_url_off` text DEFAULT NULL,
  `waiting_call_count` smallint(5) unsigned DEFAULT 0,
  `enter_ingroup_url` text DEFAULT NULL,
  `cid_cb_confirm_number` varchar(20) DEFAULT 'NO',
  `cid_cb_invalid_filter_phone_group` varchar(20) DEFAULT '',
  `cid_cb_valid_length` varchar(30) DEFAULT '10',
  `cid_cb_valid_filename` text DEFAULT NULL,
  `cid_cb_confirmed_filename` text DEFAULT NULL,
  `cid_cb_enter_filename` text DEFAULT NULL,
  `cid_cb_you_entered_filename` text DEFAULT NULL,
  `cid_cb_press_to_confirm_filename` text DEFAULT NULL,
  `cid_cb_invalid_filename` text DEFAULT NULL,
  `cid_cb_reenter_filename` text DEFAULT NULL,
  `cid_cb_error_filename` text DEFAULT NULL,
  `place_in_line_caller_number_filename` text DEFAULT NULL,
  `place_in_line_you_next_filename` text DEFAULT NULL,
  `ingroup_script_two` varchar(20) DEFAULT '',
  `browser_alert_sound` varchar(20) DEFAULT '---NONE---',
  `browser_alert_volume` tinyint(3) unsigned DEFAULT 50,
  `answer_signal` enum('START','ROUTE','NONE') DEFAULT 'START',
  `no_agent_delay` smallint(5) DEFAULT 0,
  `agent_search_method` varchar(2) DEFAULT '',
  `qc_scorecard_id` varchar(20) DEFAULT '',
  `qc_statuses_id` varchar(20) DEFAULT '',
  `populate_lead_comments` varchar(40) DEFAULT 'CALLERID_NAME',
  `drop_call_seconds_override` varchar(40) DEFAULT 'DISABLED',
  `populate_lead_owner` varchar(20) DEFAULT 'DISABLED',
  `in_queue_nanque` enum('N','Y','NO_PAUSED','NO_PAUSED_EXCEPTIONS','NO_READY') DEFAULT 'N',
  `in_queue_nanque_exceptions` varchar(40) DEFAULT '',
  `custom_one` text DEFAULT NULL,
  `custom_two` text DEFAULT NULL,
  `custom_three` text DEFAULT NULL,
  `custom_four` text DEFAULT NULL,
  `custom_five` text DEFAULT NULL,
  `second_alert_trigger` varchar(20) DEFAULT 'DISABLED',
  `second_alert_trigger_seconds` int(6) DEFAULT 600,
  `second_alert_filename` varchar(100) DEFAULT '',
  `second_alert_delay` int(6) DEFAULT 1000,
  `second_alert_container` varchar(40) DEFAULT 'DISABLED',
  `second_alert_only` varchar(40) DEFAULT 'DISABLED',
  `third_alert_trigger` varchar(20) DEFAULT 'DISABLED',
  `third_alert_trigger_seconds` int(6) DEFAULT 600,
  `third_alert_filename` varchar(100) DEFAULT '',
  `third_alert_delay` int(6) DEFAULT 1000,
  `third_alert_container` varchar(40) DEFAULT 'DISABLED',
  `third_alert_only` varchar(40) DEFAULT 'DISABLED',
  `agent_search_list` varchar(20) DEFAULT '',
  `state_descriptions` varchar(40) DEFAULT '---DISABLED---',
  `stereo_recording` enum('DISABLED','CUSTOMER','CUSTOMER_MUTE') DEFAULT 'DISABLED',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_groups`
--

/*!40000 ALTER TABLE `vicidial_inbound_groups` DISABLE KEYS */;

/*!40000 ALTER TABLE `vicidial_inbound_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_survey_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_survey_log` (
  `uniqueid` varchar(50) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `campaign_id` varchar(20) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `participate` enum('N','Y') DEFAULT 'N',
  `played` enum('N','R','Y') DEFAULT 'N',
  `dtmf_response` varchar(1) DEFAULT '',
  `next_call_menu` text DEFAULT NULL,
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`),
  KEY `uniqueid` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_survey_log`
--

/*!40000 ALTER TABLE `vicidial_inbound_survey_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_survey_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_inbound_survey_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_inbound_survey_log_archive` (
  `uniqueid` varchar(50) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `campaign_id` varchar(20) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `participate` enum('N','Y') DEFAULT 'N',
  `played` enum('N','R','Y') DEFAULT 'N',
  `dtmf_response` varchar(1) DEFAULT '',
  `next_call_menu` text DEFAULT NULL,
  UNIQUE KEY `visla_key` (`uniqueid`,`call_date`,`campaign_id`,`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`),
  KEY `uniqueid` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_inbound_survey_log_archive`
--

/*!40000 ALTER TABLE `vicidial_inbound_survey_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_inbound_survey_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ingroup_hour_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ingroup_hour_counts` (
  `group_id` varchar(20) DEFAULT NULL,
  `date_hour` datetime DEFAULT NULL,
  `next_hour` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `type` varchar(22) DEFAULT 'CALLS',
  `calls` int(9) unsigned DEFAULT 0,
  `hr` tinyint(2) DEFAULT 0,
  UNIQUE KEY `vihc_ingr_hour` (`group_id`,`date_hour`,`type`),
  KEY `group_id` (`group_id`),
  KEY `date_hour` (`date_hour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ingroup_hour_counts`
--

/*!40000 ALTER TABLE `vicidial_ingroup_hour_counts` DISABLE KEYS */;
INSERT INTO `vicidial_ingroup_hour_counts` 
(group_id, date_hour, next_hour, last_update, type, calls, hr)
SELECT group_id, date_hour, next_hour, last_update, type, calls, hr FROM (
  SELECT 'AGENTDIRECT' AS group_id, '2025-06-23 12:00:00' AS date_hour, '2025-06-23 13:00:00' AS next_hour, '2025-06-23 12:50:56' AS last_update, 'CALLS' AS type, 0 AS calls, 12 AS hr
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 00:00:00','2025-06-23 01:00:00','2025-06-23 12:45:05','CALLS',0,0
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 01:00:00','2025-06-23 02:00:00','2025-06-23 12:45:05','CALLS',0,1
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 02:00:00','2025-06-23 03:00:00','2025-06-23 12:45:05','CALLS',0,2
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 03:00:00','2025-06-23 04:00:00','2025-06-23 12:45:05','CALLS',0,3
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 04:00:00','2025-06-23 05:00:00','2025-06-23 12:45:05','CALLS',0,4
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 05:00:00','2025-06-23 06:00:00','2025-06-23 12:45:05','CALLS',0,5
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 06:00:00','2025-06-23 07:00:00','2025-06-23 12:45:05','CALLS',0,6
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 07:00:00','2025-06-23 08:00:00','2025-06-23 12:45:05','CALLS',0,7
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 08:00:00','2025-06-23 09:00:00','2025-06-23 12:45:05','CALLS',0,8
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 09:00:00','2025-06-23 10:00:00','2025-06-23 12:45:05','CALLS',0,9
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 10:00:00','2025-06-23 11:00:00','2025-06-23 12:45:05','CALLS',0,10
  UNION ALL
  SELECT 'AGENTDIRECT','2025-06-23 11:00:00','2025-06-23 12:00:00','2025-06-23 12:45:05','CALLS',0,11
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 12:00:00','2025-06-23 13:00:00','2025-06-23 12:50:56','CALLS',0,12
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 00:00:00','2025-06-23 01:00:00','2025-06-23 12:45:05','CALLS',0,0
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 01:00:00','2025-06-23 02:00:00','2025-06-23 12:45:05','CALLS',0,1
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 02:00:00','2025-06-23 03:00:00','2025-06-23 12:45:05','CALLS',0,2
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 03:00:00','2025-06-23 04:00:00','2025-06-23 12:45:05','CALLS',0,3
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 04:00:00','2025-06-23 05:00:00','2025-06-23 12:45:05','CALLS',0,4
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 05:00:00','2025-06-23 06:00:00','2025-06-23 12:45:05','CALLS',0,5
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 06:00:00','2025-06-23 07:00:00','2025-06-23 12:45:05','CALLS',0,6
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 07:00:00','2025-06-23 08:00:00','2025-06-23 12:45:05','CALLS',0,7
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 08:00:00','2025-06-23 09:00:00','2025-06-23 12:45:05','CALLS',0,8
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 09:00:00','2025-06-23 10:00:00','2025-06-23 12:45:05','CALLS',0,9
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 10:00:00','2025-06-23 11:00:00','2025-06-23 12:45:05','CALLS',0,10
  UNION ALL
  SELECT 'AGENTDIRECT_CHAT','2025-06-23 11:00:00','2025-06-23 12:00:00','2025-06-23 12:45:05','CALLS',0,11
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_ingroup_hour_counts);


/*!40000 ALTER TABLE `vicidial_ingroup_hour_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ingroup_hour_counts_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ingroup_hour_counts_archive` (
  `group_id` varchar(20) DEFAULT NULL,
  `date_hour` datetime DEFAULT NULL,
  `next_hour` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `type` varchar(22) DEFAULT 'CALLS',
  `calls` int(9) unsigned DEFAULT 0,
  `hr` tinyint(2) DEFAULT 0,
  UNIQUE KEY `vihc_ingr_hour` (`group_id`,`date_hour`,`type`),
  KEY `group_id` (`group_id`),
  KEY `date_hour` (`date_hour`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ingroup_hour_counts_archive`
--

/*!40000 ALTER TABLE `vicidial_ingroup_hour_counts_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ingroup_hour_counts_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ip_list_entries`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ip_list_entries` (
  `ip_list_id` varchar(30) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  KEY `ip_list_id` (`ip_list_id`),
  KEY `ip_address` (`ip_address`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ip_list_entries`
--

/*!40000 ALTER TABLE `vicidial_ip_list_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ip_list_entries` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ip_lists`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ip_lists` (
  `ip_list_id` varchar(30) NOT NULL,
  `ip_list_name` varchar(100) DEFAULT NULL,
  `active` enum('N','Y') DEFAULT 'N',
  `user_group` varchar(20) DEFAULT '---ALL---',
  UNIQUE KEY `ip_list_id` (`ip_list_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ip_lists`
--

/*!40000 ALTER TABLE `vicidial_ip_lists` DISABLE KEYS */;
INSERT INTO `vicidial_ip_lists` 
(ip_list_id, ip_list_name, active, user_group)
SELECT * FROM (
    SELECT 'ViciWhite','White List for ViciBox firewall ACL','N','---ALL---'
    UNION ALL
    SELECT 'ViciBlack','Black List for ViciBox firewall ACL','N','---ALL---'
) as data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_ip_lists);
/*!40000 ALTER TABLE `vicidial_ip_lists` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ivr`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ivr` (
  `ivr_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `entry_time` datetime DEFAULT NULL,
  `length_in_sec` smallint(5) unsigned DEFAULT 0,
  `inbound_number` varchar(12) DEFAULT NULL,
  `recording_id` int(9) unsigned DEFAULT NULL,
  `recording_filename` varchar(50) DEFAULT NULL,
  `company_id` varchar(12) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `prompt_audio_1` varchar(20) DEFAULT NULL,
  `prompt_response_1` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_2` varchar(20) DEFAULT NULL,
  `prompt_response_2` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_3` varchar(20) DEFAULT NULL,
  `prompt_response_3` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_4` varchar(20) DEFAULT NULL,
  `prompt_response_4` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_5` varchar(20) DEFAULT NULL,
  `prompt_response_5` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_6` varchar(20) DEFAULT NULL,
  `prompt_response_6` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_7` varchar(20) DEFAULT NULL,
  `prompt_response_7` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_8` varchar(20) DEFAULT NULL,
  `prompt_response_8` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_9` varchar(20) DEFAULT NULL,
  `prompt_response_9` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_10` varchar(20) DEFAULT NULL,
  `prompt_response_10` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_11` varchar(20) DEFAULT NULL,
  `prompt_response_11` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_12` varchar(20) DEFAULT NULL,
  `prompt_response_12` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_13` varchar(20) DEFAULT NULL,
  `prompt_response_13` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_14` varchar(20) DEFAULT NULL,
  `prompt_response_14` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_15` varchar(20) DEFAULT NULL,
  `prompt_response_15` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_16` varchar(20) DEFAULT NULL,
  `prompt_response_16` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_17` varchar(20) DEFAULT NULL,
  `prompt_response_17` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_18` varchar(20) DEFAULT NULL,
  `prompt_response_18` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_19` varchar(20) DEFAULT NULL,
  `prompt_response_19` tinyint(1) unsigned DEFAULT 0,
  `prompt_audio_20` varchar(20) DEFAULT NULL,
  `prompt_response_20` tinyint(1) unsigned DEFAULT 0,
  PRIMARY KEY (`ivr_id`),
  KEY `phone_number` (`phone_number`),
  KEY `entry_time` (`entry_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1000000 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ivr`
--

/*!40000 ALTER TABLE `vicidial_ivr` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ivr` ENABLE KEYS */;

--
-- Table structure for table `vicidial_ivr_response`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_ivr_response` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `btn` varchar(10) DEFAULT NULL,
  `lead_id` int(10) unsigned DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `question` int(11) DEFAULT NULL,
  `response` varchar(10) DEFAULT NULL,
  `uniqueid` varchar(50) DEFAULT NULL,
  `campaign` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `question_created` (`question`,`uniqueid`,`campaign`,`created`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1599 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_ivr_response`
--

/*!40000 ALTER TABLE `vicidial_ivr_response` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_ivr_response` ENABLE KEYS */;

--
-- Table structure for table `vicidial_khomp_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_khomp_log` (
  `khomp_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `caller_code` varchar(30) NOT NULL,
  `lead_id` int(10) unsigned DEFAULT 0,
  `server_ip` varchar(15) NOT NULL,
  `khomp_header` varchar(100) DEFAULT NULL,
  `khomp_id` varchar(256) DEFAULT NULL,
  `khomp_id_format` enum('CALLERCODE','CALLERCODE_EXTERNIP','CALLERCODE_CAMP_EXTERNIP') DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `start_date` datetime(6) DEFAULT NULL,
  `audio_date` datetime(6) DEFAULT NULL,
  `answer_date` datetime(6) DEFAULT NULL,
  `end_date` datetime(6) DEFAULT NULL,
  `analyzer_date` datetime(6) DEFAULT NULL,
  `conclusion` varchar(100) DEFAULT NULL,
  `pattern` varchar(256) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `hangup_origin` varchar(20) DEFAULT NULL,
  `hangup_cause_recv` varchar(20) DEFAULT NULL,
  `hangup_cause_sent` varchar(20) DEFAULT NULL,
  `hangup_auth_time` varchar(20) DEFAULT '0',
  `hangup_query_time` varchar(20) DEFAULT '0',
  `route_auth_time` varchar(20) DEFAULT '0',
  `route_query_time` varchar(20) DEFAULT '0',
  `vici_action` varchar(10) DEFAULT NULL,
  `vici_status` varchar(6) DEFAULT NULL,
  `khomp_settings_container` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`khomp_log_id`),
  KEY `caller_code` (`caller_code`),
  KEY `start_date` (`start_date`),
  KEY `khomp_id` (`khomp_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_khomp_log`
--

/*!40000 ALTER TABLE `vicidial_khomp_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_khomp_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_language_phrases`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_language_phrases` (
  `phrase_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language_id` varchar(100) NOT NULL,
  `english_text` varchar(10000) DEFAULT '',
  `translated_text` text DEFAULT NULL,
  `source` varchar(20) DEFAULT '',
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`phrase_id`),
  KEY `language_id` (`language_id`),
  KEY `english_text` (`english_text`(333))
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_language_phrases`
--

/*!40000 ALTER TABLE `vicidial_language_phrases` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_language_phrases` ENABLE KEYS */;

--
-- Table structure for table `vicidial_languages`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_languages` (
  `language_id` varchar(100) NOT NULL,
  `language_code` varchar(20) DEFAULT '',
  `language_description` varchar(255) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `active` enum('Y','N') DEFAULT 'N',
  UNIQUE KEY `language_id` (`language_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_languages`
--

/*!40000 ALTER TABLE `vicidial_languages` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_languages` ENABLE KEYS */;

--
-- Table structure for table `vicidial_latency_gaps`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_latency_gaps` (
  `user` varchar(20) DEFAULT '',
  `user_ip` varchar(45) DEFAULT '',
  `gap_date` datetime DEFAULT NULL,
  `gap_length` mediumint(5) unsigned DEFAULT 0,
  `last_login_date` datetime DEFAULT NULL,
  `check_date` datetime DEFAULT NULL,
  UNIQUE KEY `vlgi` (`user`,`gap_date`),
  KEY `user` (`user`),
  KEY `gap_date` (`gap_date`),
  KEY `check_date` (`check_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_latency_gaps`
--

/*!40000 ALTER TABLE `vicidial_latency_gaps` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_latency_gaps` ENABLE KEYS */;

--
-- Table structure for table `vicidial_latency_gaps_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_latency_gaps_archive` (
  `user` varchar(20) DEFAULT '',
  `user_ip` varchar(45) DEFAULT '',
  `gap_date` datetime DEFAULT NULL,
  `gap_length` mediumint(5) unsigned DEFAULT 0,
  `last_login_date` datetime DEFAULT NULL,
  `check_date` datetime DEFAULT NULL,
  UNIQUE KEY `vlgi` (`user`,`gap_date`),
  UNIQUE KEY `vdlga` (`user`,`gap_date`),
  KEY `user` (`user`),
  KEY `gap_date` (`gap_date`),
  KEY `check_date` (`check_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_latency_gaps_archive`
--

/*!40000 ALTER TABLE `vicidial_latency_gaps_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_latency_gaps_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_24hour_calls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_24hour_calls` (
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT 0,
  `call_date` datetime DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `call_type` enum('MANUAL','AUTO','') DEFAULT '',
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_24hour_calls`
--

/*!40000 ALTER TABLE `vicidial_lead_24hour_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_24hour_calls` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_call_daily_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_call_daily_counts` (
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT 0,
  `called_count_total` tinyint(3) unsigned DEFAULT 0,
  `called_count_auto` tinyint(3) unsigned DEFAULT 0,
  `called_count_manual` tinyint(3) unsigned DEFAULT 0,
  `modify_date` datetime DEFAULT NULL,
  UNIQUE KEY `vlcdc_lead` (`lead_id`),
  KEY `list_id` (`list_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_call_daily_counts`
--

/*!40000 ALTER TABLE `vicidial_lead_call_daily_counts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_call_daily_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_call_quota_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_call_quota_counts` (
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT 0,
  `first_call_date` datetime DEFAULT NULL,
  `last_call_date` datetime DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `called_count` smallint(5) unsigned DEFAULT 0,
  `session_one_calls` tinyint(3) DEFAULT 0,
  `session_two_calls` tinyint(3) DEFAULT 0,
  `session_three_calls` tinyint(3) DEFAULT 0,
  `session_four_calls` tinyint(3) DEFAULT 0,
  `session_five_calls` tinyint(3) DEFAULT 0,
  `session_six_calls` tinyint(3) DEFAULT 0,
  `day_one_calls` tinyint(3) DEFAULT 0,
  `day_two_calls` tinyint(3) DEFAULT 0,
  `day_three_calls` tinyint(3) DEFAULT 0,
  `day_four_calls` tinyint(3) DEFAULT 0,
  `day_five_calls` tinyint(3) DEFAULT 0,
  `day_six_calls` tinyint(3) DEFAULT 0,
  `day_seven_calls` tinyint(3) DEFAULT 0,
  `session_one_today_calls` tinyint(3) DEFAULT 0,
  `session_two_today_calls` tinyint(3) DEFAULT 0,
  `session_three_today_calls` tinyint(3) DEFAULT 0,
  `session_four_today_calls` tinyint(3) DEFAULT 0,
  `session_five_today_calls` tinyint(3) DEFAULT 0,
  `session_six_today_calls` tinyint(3) DEFAULT 0,
  `rank` smallint(5) NOT NULL DEFAULT 0,
  `modify_date` datetime DEFAULT NULL,
  UNIQUE KEY `vlcqc_lead_list` (`lead_id`,`list_id`),
  KEY `last_call_date` (`last_call_date`),
  KEY `list_id` (`list_id`),
  KEY `modify_date` (`modify_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_call_quota_counts`
--

/*!40000 ALTER TABLE `vicidial_lead_call_quota_counts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_call_quota_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_call_quota_counts_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_call_quota_counts_archive` (
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT 0,
  `first_call_date` datetime DEFAULT NULL,
  `last_call_date` datetime DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `called_count` smallint(5) unsigned DEFAULT 0,
  `session_one_calls` tinyint(3) DEFAULT 0,
  `session_two_calls` tinyint(3) DEFAULT 0,
  `session_three_calls` tinyint(3) DEFAULT 0,
  `session_four_calls` tinyint(3) DEFAULT 0,
  `session_five_calls` tinyint(3) DEFAULT 0,
  `session_six_calls` tinyint(3) DEFAULT 0,
  `day_one_calls` tinyint(3) DEFAULT 0,
  `day_two_calls` tinyint(3) DEFAULT 0,
  `day_three_calls` tinyint(3) DEFAULT 0,
  `day_four_calls` tinyint(3) DEFAULT 0,
  `day_five_calls` tinyint(3) DEFAULT 0,
  `day_six_calls` tinyint(3) DEFAULT 0,
  `day_seven_calls` tinyint(3) DEFAULT 0,
  `session_one_today_calls` tinyint(3) DEFAULT 0,
  `session_two_today_calls` tinyint(3) DEFAULT 0,
  `session_three_today_calls` tinyint(3) DEFAULT 0,
  `session_four_today_calls` tinyint(3) DEFAULT 0,
  `session_five_today_calls` tinyint(3) DEFAULT 0,
  `session_six_today_calls` tinyint(3) DEFAULT 0,
  `rank` smallint(5) NOT NULL DEFAULT 0,
  `modify_date` datetime DEFAULT NULL,
  UNIQUE KEY `vlcqc_lead_date` (`lead_id`,`first_call_date`),
  KEY `first_call_date` (`first_call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_call_quota_counts_archive`
--

/*!40000 ALTER TABLE `vicidial_lead_call_quota_counts_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_call_quota_counts_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_filters`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_filters` (
  `lead_filter_id` varchar(20) NOT NULL,
  `lead_filter_name` varchar(30) NOT NULL,
  `lead_filter_comments` varchar(255) DEFAULT NULL,
  `lead_filter_sql` text DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`lead_filter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_filters`
--

/*!40000 ALTER TABLE `vicidial_lead_filters` DISABLE KEYS */;
INSERT INTO `vicidial_lead_filters` select 'DROP72HOUR','UK 72 hour Drop No Call','Prevents dropped calls from being called within 72 hours of the last attempt','( ( (status=\'DROP\') and (last_local_call_time < CONCAT(DATE_ADD(CURDATE(), INTERVAL -3 DAY),\' \',CURTIME()) ) ) or (status != \'DROP\') )','---ALL---','2025-06-23 16:43:09' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_lead_filters);
/*!40000 ALTER TABLE `vicidial_lead_filters` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_messages`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_messages` (
  `lead_id` int(9) unsigned NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `played` tinyint(3) DEFAULT 0,
  `message_entry` mediumtext DEFAULT NULL,
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_messages`
--

/*!40000 ALTER TABLE `vicidial_lead_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_messages` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_recycle`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_recycle` (
  `recycle_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` varchar(8) DEFAULT NULL,
  `status` varchar(6) NOT NULL,
  `attempt_delay` smallint(5) unsigned DEFAULT 1800,
  `attempt_maximum` tinyint(3) unsigned DEFAULT 2,
  `active` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`recycle_id`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_recycle`
--

/*!40000 ALTER TABLE `vicidial_lead_recycle` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_recycle` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_search_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_search_log` (
  `search_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) NOT NULL,
  `event_date` datetime NOT NULL,
  `source` varchar(10) DEFAULT '',
  `search_query` text DEFAULT NULL,
  `results` int(9) unsigned DEFAULT 0,
  `seconds` mediumint(7) unsigned DEFAULT 0,
  PRIMARY KEY (`search_log_id`),
  KEY `user` (`user`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_search_log`
--

/*!40000 ALTER TABLE `vicidial_lead_search_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_search_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lead_search_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lead_search_log_archive` (
  `search_log_id` int(9) unsigned NOT NULL,
  `user` varchar(20) NOT NULL,
  `event_date` datetime NOT NULL,
  `source` varchar(10) DEFAULT '',
  `search_query` text DEFAULT NULL,
  `results` int(9) unsigned DEFAULT 0,
  `seconds` mediumint(7) unsigned DEFAULT 0,
  PRIMARY KEY (`search_log_id`),
  KEY `user` (`user`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lead_search_log_archive`
--

/*!40000 ALTER TABLE `vicidial_lead_search_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lead_search_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_list`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_list` (
  `lead_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `entry_date` datetime DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(6) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `vendor_lead_code` varchar(20) DEFAULT NULL,
  `source_id` varchar(50) DEFAULT NULL,
  `list_id` bigint(14) unsigned NOT NULL DEFAULT 0,
  `gmt_offset_now` decimal(4,2) DEFAULT 0.00,
  `called_since_last_reset` enum('Y','N','Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','D') DEFAULT 'N',
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) NOT NULL,
  `title` varchar(4) DEFAULT NULL,
  `first_name` varchar(30) DEFAULT NULL,
  `middle_initial` varchar(1) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `address3` varchar(100) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(2) DEFAULT NULL,
  `province` varchar(50) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `country_code` varchar(3) DEFAULT NULL,
  `gender` enum('M','F','U') DEFAULT 'U',
  `date_of_birth` date DEFAULT NULL,
  `alt_phone` varchar(12) DEFAULT NULL,
  `email` varchar(70) DEFAULT NULL,
  `security_phrase` varchar(100) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `called_count` smallint(5) unsigned DEFAULT 0,
  `last_local_call_time` datetime DEFAULT NULL,
  `rank` smallint(5) NOT NULL DEFAULT 0,
  `owner` varchar(20) DEFAULT '',
  `entry_list_id` bigint(14) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`lead_id`),
  KEY `phone_number` (`phone_number`),
  KEY `list_id` (`list_id`),
  KEY `called_since_last_reset` (`called_since_last_reset`),
  KEY `status` (`status`),
  KEY `gmt_offset_now` (`gmt_offset_now`),
  KEY `postal_code` (`postal_code`),
  KEY `last_local_call_time` (`last_local_call_time`),
  KEY `rank` (`rank`),
  KEY `owner` (`owner`),
  KEY `phone_list` (`phone_number`,`list_id`),
  KEY `list_phone` (`list_id`,`phone_number`),
  KEY `list_status` (`list_id`,`status`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_list`
--

/*!40000 ALTER TABLE `vicidial_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_list` ENABLE KEYS */;

--
-- Table structure for table `vicidial_list_alt_phones`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_list_alt_phones` (
  `alt_phone_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `alt_phone_note` varchar(30) DEFAULT NULL,
  `alt_phone_count` smallint(5) unsigned DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'Y',
  PRIMARY KEY (`alt_phone_id`),
  KEY `lead_id` (`lead_id`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_list_alt_phones`
--

/*!40000 ALTER TABLE `vicidial_list_alt_phones` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_list_alt_phones` ENABLE KEYS */;

--
-- Table structure for table `vicidial_list_pins`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_list_pins` (
  `pins_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `entry_time` datetime DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `product_code` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `digits` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`pins_id`),
  KEY `lead_id` (`lead_id`),
  KEY `phone_number` (`phone_number`),
  KEY `entry_time` (`entry_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_list_pins`
--

/*!40000 ALTER TABLE `vicidial_list_pins` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_list_pins` ENABLE KEYS */;

--
-- Table structure for table `vicidial_list_update_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_list_update_log` (
  `event_date` datetime DEFAULT NULL,
  `lead_id` varchar(255) DEFAULT NULL,
  `vendor_id` varchar(255) DEFAULT NULL,
  `phone_number` varchar(255) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `old_status` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT '',
  `result` varchar(20) DEFAULT NULL,
  `result_rows` smallint(3) unsigned DEFAULT 0,
  `list_id` varchar(255) DEFAULT NULL,
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_list_update_log`
--

/*!40000 ALTER TABLE `vicidial_list_update_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_list_update_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lists`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lists` (
  `list_id` bigint(14) unsigned NOT NULL,
  `list_name` varchar(30) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `list_description` varchar(255) DEFAULT NULL,
  `list_changedate` datetime DEFAULT NULL,
  `list_lastcalldate` datetime DEFAULT NULL,
  `reset_time` varchar(100) DEFAULT '',
  `agent_script_override` varchar(20) DEFAULT '',
  `campaign_cid_override` varchar(20) DEFAULT '',
  `am_message_exten_override` varchar(100) DEFAULT '',
  `drop_inbound_group_override` varchar(20) DEFAULT '',
  `xferconf_a_number` varchar(50) DEFAULT '',
  `xferconf_b_number` varchar(50) DEFAULT '',
  `xferconf_c_number` varchar(50) DEFAULT '',
  `xferconf_d_number` varchar(50) DEFAULT '',
  `xferconf_e_number` varchar(50) DEFAULT '',
  `web_form_address` text DEFAULT NULL,
  `web_form_address_two` text DEFAULT NULL,
  `time_zone_setting` enum('COUNTRY_AND_AREA_CODE','POSTAL_CODE','NANPA_PREFIX','OWNER_TIME_ZONE_CODE') DEFAULT 'COUNTRY_AND_AREA_CODE',
  `inventory_report` enum('Y','N') DEFAULT 'Y',
  `expiration_date` date DEFAULT '2099-12-31',
  `na_call_url` text DEFAULT NULL,
  `local_call_time` varchar(10) NOT NULL DEFAULT 'campaign',
  `web_form_address_three` text DEFAULT NULL,
  `status_group_id` varchar(20) DEFAULT '',
  `user_new_lead_limit` smallint(5) DEFAULT -1,
  `inbound_list_script_override` varchar(20) DEFAULT NULL,
  `default_xfer_group` varchar(20) DEFAULT '---NONE---',
  `daily_reset_limit` smallint(5) DEFAULT -1,
  `resets_today` smallint(5) unsigned DEFAULT 0,
  `auto_active_list_rank` smallint(5) DEFAULT 0,
  `cache_count` int(9) unsigned DEFAULT 0,
  `cache_count_new` int(9) unsigned DEFAULT 0,
  `cache_count_dialable_new` int(9) unsigned DEFAULT 0,
  `cache_date` datetime DEFAULT NULL,
  `inbound_drop_voicemail` varchar(20) DEFAULT NULL,
  `inbound_after_hours_voicemail` varchar(20) DEFAULT NULL,
  `qc_scorecard_id` varchar(20) DEFAULT '',
  `qc_statuses_id` varchar(20) DEFAULT '',
  `qc_web_form_address` varchar(255) DEFAULT '',
  `auto_alt_threshold` tinyint(3) DEFAULT -1,
  `cid_group_id` varchar(20) DEFAULT '---DISABLED---',
  `dial_prefix` varchar(20) DEFAULT '',
  `weekday_resets_container` varchar(40) DEFAULT 'DISABLED',
  PRIMARY KEY (`list_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lists`
--

/*!40000 ALTER TABLE `vicidial_lists` DISABLE KEYS */;
INSERT INTO `vicidial_lists` 
(list_id, list_name, campaign_id, active, list_description, list_changedate, list_lastcalldate, reset_time, agent_script_override, campaign_cid_override, am_message_exten_override, drop_inbound_group_override, xferconf_a_number, xferconf_b_number, xferconf_c_number, xferconf_d_number, xferconf_e_number, web_form_address, web_form_address_two, time_zone_setting, inventory_report, expiration_date, na_call_url, local_call_time, web_form_address_three, status_group_id, user_new_lead_limit, inbound_list_script_override, default_xfer_group, daily_reset_limit, resets_today, auto_active_list_rank, cache_count, cache_count_new, cache_count_dialable_new, cache_date, inbound_drop_voicemail, inbound_after_hours_voicemail, qc_scorecard_id, qc_statuses_id, qc_web_form_address, auto_alt_threshold, cid_group_id, dial_prefix, weekday_resets_container)
SELECT list_id, list_name, campaign_id, active, list_description, list_changedate, list_lastcalldate, reset_time, agent_script_override, campaign_cid_override, am_message_exten_override, drop_inbound_group_override, xferconf_a_number, xferconf_b_number, xferconf_c_number, xferconf_d_number, xferconf_e_number, web_form_address, web_form_address_two, time_zone_setting, inventory_report, expiration_date, na_call_url, local_call_time, web_form_address_three, status_group_id, user_new_lead_limit, inbound_list_script_override, default_xfer_group, daily_reset_limit, resets_today, auto_active_list_rank, cache_count, cache_count_new, cache_count_dialable_new, cache_date, inbound_drop_voicemail, inbound_after_hours_voicemail, qc_scorecard_id, qc_statuses_id, qc_web_form_address, auto_alt_threshold, cid_group_id, dial_prefix, weekday_resets_container FROM (
    SELECT 999 AS list_id,'Default inbound list' AS list_name,'TESTCAMP' AS campaign_id,'N' AS active,NULL AS list_description,NULL AS list_changedate,NULL AS list_lastcalldate,'' AS reset_time,'' AS agent_script_override,'' AS campaign_cid_override,'' AS am_message_exten_override,'' AS drop_inbound_group_override,'' AS xferconf_a_number,'' AS xferconf_b_number,'' AS xferconf_c_number,'' AS xferconf_d_number,'' AS xferconf_e_number,NULL AS web_form_address,NULL AS web_form_address_two,'COUNTRY_AND_AREA_CODE' AS time_zone_setting,'Y' AS inventory_report,'2099-12-31' AS expiration_date,NULL AS na_call_url,'campaign' AS local_call_time,NULL AS web_form_address_three,'' AS status_group_id,-1 AS user_new_lead_limit,NULL AS inbound_list_script_override,'---NONE---' AS default_xfer_group,-1 AS daily_reset_limit,0 AS resets_today,0 AS auto_active_list_rank,0 AS cache_count,0 AS cache_count_new,0 AS cache_count_dialable_new,NULL AS cache_date,NULL AS inbound_drop_voicemail,NULL AS inbound_after_hours_voicemail,'' AS qc_scorecard_id,'' AS qc_statuses_id,'' AS qc_web_form_address,-1 AS auto_alt_threshold,'---DISABLED---' AS cid_group_id,'' AS dial_prefix,'DISABLED' AS weekday_resets_container
    UNION ALL
    SELECT 998,'Default Manual list','TESTCAMP','N',NULL,NULL,NULL,'','','','','','','','','','',NULL,NULL,'COUNTRY_AND_AREA_CODE','Y','2099-12-31',NULL,'campaign',NULL,'',-1,NULL,'---NONE---',-1,0,0,0,0,0,NULL,NULL,NULL,'','','',-1,'---DISABLED---','','DISABLED'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_lists WHERE list_id IN (999, 998));
/*!40000 ALTER TABLE `vicidial_lists` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lists_custom`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lists_custom` (
  `list_id` bigint(14) unsigned NOT NULL,
  `audit_comments` tinyint(1) DEFAULT NULL COMMENT 'visible',
  `audit_comments_enabled` tinyint(1) DEFAULT NULL COMMENT 'invisible',
  PRIMARY KEY (`list_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lists_custom`
--

/*!40000 ALTER TABLE `vicidial_lists_custom` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lists_custom` ENABLE KEYS */;

--
-- Table structure for table `vicidial_lists_fields`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_lists_fields` (
  `field_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `list_id` bigint(14) unsigned NOT NULL DEFAULT 0,
  `field_label` varchar(50) DEFAULT NULL,
  `field_name` varchar(5000) DEFAULT NULL,
  `field_description` varchar(100) DEFAULT NULL,
  `field_rank` smallint(5) DEFAULT NULL,
  `field_help` varchar(1000) DEFAULT NULL,
  `field_type` enum('TEXT','AREA','SELECT','MULTI','RADIO','CHECKBOX','DATE','TIME','DISPLAY','SCRIPT','HIDDEN','READONLY','HIDEBLOB','SWITCH','SOURCESELECT','BUTTON') DEFAULT 'TEXT',
  `field_options` varchar(5000) DEFAULT NULL,
  `field_size` smallint(5) DEFAULT NULL,
  `field_max` smallint(5) DEFAULT NULL,
  `field_default` varchar(255) DEFAULT NULL,
  `field_cost` smallint(5) DEFAULT NULL,
  `field_required` enum('Y','N','INBOUND_ONLY') DEFAULT 'N',
  `name_position` enum('LEFT','TOP') DEFAULT 'LEFT',
  `multi_position` enum('HORIZONTAL','VERTICAL') DEFAULT 'HORIZONTAL',
  `field_order` smallint(5) DEFAULT 1,
  `field_encrypt` enum('Y','N') DEFAULT 'N',
  `field_show_hide` enum('DISABLED','X_OUT_ALL','LAST_1','LAST_2','LAST_3','LAST_4','FIRST_1_LAST_4') DEFAULT 'DISABLED',
  `field_duplicate` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`field_id`),
  UNIQUE KEY `listfield` (`list_id`,`field_label`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_lists_fields`
--

/*!40000 ALTER TABLE `vicidial_lists_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_lists_fields` ENABLE KEYS */;

--
-- Table structure for table `vicidial_live_agents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_live_agents` (
  `live_agent_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `conf_exten` varchar(20) DEFAULT NULL,
  `extension` varchar(100) DEFAULT NULL,
  `status` enum('READY','QUEUE','INCALL','PAUSED','CLOSER','MQUEUE') DEFAULT 'PAUSED',
  `lead_id` int(9) unsigned NOT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `random_id` int(8) unsigned DEFAULT NULL,
  `last_call_time` datetime DEFAULT NULL,
  `last_update_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_call_finish` datetime DEFAULT NULL,
  `closer_campaigns` text DEFAULT NULL,
  `call_server_ip` varchar(15) DEFAULT NULL,
  `user_level` tinyint(3) unsigned DEFAULT 0,
  `comments` varchar(20) DEFAULT NULL,
  `campaign_weight` tinyint(1) DEFAULT 0,
  `calls_today` smallint(5) unsigned DEFAULT 0,
  `external_hangup` varchar(1) DEFAULT '',
  `external_status` varchar(255) DEFAULT '',
  `external_pause` varchar(20) DEFAULT '',
  `external_dial` varchar(100) DEFAULT '',
  `external_ingroups` text DEFAULT NULL,
  `external_blended` enum('0','1') DEFAULT '0',
  `external_igb_set_user` varchar(20) DEFAULT '',
  `external_update_fields` enum('0','1') DEFAULT '0',
  `external_update_fields_data` varchar(255) DEFAULT '',
  `external_timer_action` varchar(20) DEFAULT '',
  `external_timer_action_message` varchar(255) DEFAULT '',
  `external_timer_action_seconds` mediumint(7) DEFAULT -1,
  `agent_log_id` int(9) unsigned DEFAULT 0,
  `last_state_change` datetime DEFAULT NULL,
  `agent_territories` text DEFAULT NULL,
  `outbound_autodial` enum('Y','N') DEFAULT 'N',
  `manager_ingroup_set` enum('Y','N','SET') DEFAULT 'N',
  `ra_user` varchar(20) DEFAULT '',
  `ra_extension` varchar(100) DEFAULT '',
  `external_dtmf` varchar(100) DEFAULT '',
  `external_transferconf` varchar(120) DEFAULT '',
  `external_park` varchar(40) DEFAULT '',
  `external_timer_action_destination` varchar(100) DEFAULT '',
  `on_hook_agent` enum('Y','N') DEFAULT 'N',
  `on_hook_ring_time` smallint(5) DEFAULT 15,
  `ring_callerid` varchar(20) DEFAULT '',
  `last_inbound_call_time` datetime DEFAULT NULL,
  `last_inbound_call_finish` datetime DEFAULT NULL,
  `campaign_grade` tinyint(2) unsigned DEFAULT 1,
  `external_recording` varchar(20) DEFAULT '',
  `external_pause_code` varchar(6) DEFAULT '',
  `pause_code` varchar(6) DEFAULT '',
  `preview_lead_id` int(9) unsigned DEFAULT 0,
  `external_lead_id` int(9) unsigned DEFAULT 0,
  `last_inbound_call_time_filtered` datetime DEFAULT NULL,
  `last_inbound_call_finish_filtered` datetime DEFAULT NULL,
  `dial_campaign_id` varchar(8) DEFAULT '',
  PRIMARY KEY (`live_agent_id`),
  KEY `random_id` (`random_id`),
  KEY `last_call_time` (`last_call_time`),
  KEY `last_update_time` (`last_update_time`),
  KEY `last_call_finish` (`last_call_finish`),
  KEY `vlali` (`lead_id`),
  KEY `vlaus` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_live_agents`
--

/*!40000 ALTER TABLE `vicidial_live_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_live_agents` ENABLE KEYS */;

--
-- Table structure for table `vicidial_live_agents_details`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_live_agents_details` (
  `user` varchar(20) NOT NULL,
  `update_date` datetime DEFAULT NULL,
  `web_ip` varchar(45) DEFAULT '',
  `latency` mediumint(7) DEFAULT 0,
  `latency_min_avg` mediumint(7) DEFAULT 0,
  `latency_min_peak` mediumint(7) DEFAULT 0,
  `latency_hour_avg` mediumint(7) DEFAULT 0,
  `latency_hour_peak` mediumint(7) DEFAULT 0,
  `latency_today_avg` mediumint(7) DEFAULT 0,
  `latency_today_peak` mediumint(7) DEFAULT 0,
  PRIMARY KEY (`user`),
  KEY `user` (`user`),
  KEY `update_date` (`update_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_live_agents_details`
--

/*!40000 ALTER TABLE `vicidial_live_agents_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_live_agents_details` ENABLE KEYS */;

--
-- Table structure for table `vicidial_live_chats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_live_chats` (
  `chat_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `chat_start_time` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `chat_creator` varchar(20) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `transferring_agent` varchar(20) DEFAULT NULL,
  `user_direct` varchar(20) DEFAULT NULL,
  `user_direct_group_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`chat_id`),
  KEY `vicidial_live_chats_lead_id_key` (`lead_id`),
  KEY `vicidial_live_chats_start_time_key` (`chat_start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_live_chats`
--

/*!40000 ALTER TABLE `vicidial_live_chats` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_live_chats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_live_inbound_agents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_live_inbound_agents` (
  `user` varchar(20) DEFAULT NULL,
  `group_id` varchar(20) DEFAULT NULL,
  `group_weight` tinyint(1) DEFAULT 0,
  `calls_today` smallint(5) unsigned DEFAULT 0,
  `last_call_time` datetime DEFAULT NULL,
  `last_call_finish` datetime DEFAULT NULL,
  `group_grade` tinyint(2) unsigned DEFAULT 1,
  `calls_today_filtered` smallint(5) unsigned DEFAULT 0,
  `last_call_time_filtered` datetime DEFAULT NULL,
  `last_call_finish_filtered` datetime DEFAULT NULL,
  `daily_limit` smallint(5) DEFAULT -1,
  UNIQUE KEY `vlia_user_group_id` (`user`,`group_id`),
  KEY `group_id` (`group_id`),
  KEY `group_weight` (`group_weight`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_live_inbound_agents`
--

/*!40000 ALTER TABLE `vicidial_live_inbound_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_live_inbound_agents` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log` (
  `uniqueid` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','NONE','SYSTEM') DEFAULT 'NONE',
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `called_count` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`uniqueid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log`
--

/*!40000 ALTER TABLE `vicidial_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_archive` (
  `uniqueid` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','NONE','SYSTEM') DEFAULT 'NONE',
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `called_count` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`uniqueid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_archive`
--

/*!40000 ALTER TABLE `vicidial_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_extended`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_extended` (
  `uniqueid` varchar(50) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `custom_call_id` varchar(100) DEFAULT NULL,
  `start_url_processed` enum('N','Y','U') DEFAULT 'N',
  `dispo_url_processed` enum('N','Y','U','XY','XU') DEFAULT 'N',
  `multi_alt_processed` enum('N','Y','U') DEFAULT 'N',
  `noanswer_processed` enum('N','Y','U') DEFAULT 'N',
  PRIMARY KEY (`uniqueid`),
  KEY `call_date` (`call_date`),
  KEY `vle_lead_id` (`lead_id`),
  KEY `vlecc` (`caller_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_extended`
--

/*!40000 ALTER TABLE `vicidial_log_extended` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_extended` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_extended_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_extended_archive` (
  `uniqueid` varchar(50) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `custom_call_id` varchar(100) DEFAULT NULL,
  `start_url_processed` enum('N','Y','U') DEFAULT 'N',
  `dispo_url_processed` enum('N','Y','U','XY','XU') DEFAULT 'N',
  `multi_alt_processed` enum('N','Y','U') DEFAULT 'N',
  `noanswer_processed` enum('N','Y','U') DEFAULT 'N',
  PRIMARY KEY (`uniqueid`),
  UNIQUE KEY `vlea` (`uniqueid`,`call_date`,`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `vle_lead_id` (`lead_id`),
  KEY `vlecc` (`caller_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_extended_archive`
--

/*!40000 ALTER TABLE `vicidial_log_extended_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_extended_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_extended_sip`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_extended_sip` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `invite_to_ring` decimal(10,6) DEFAULT 0.000000,
  `ring_to_final` decimal(10,6) DEFAULT 0.000000,
  `invite_to_final` decimal(10,6) DEFAULT 0.000000,
  `last_event_code` smallint(3) DEFAULT 0,
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_extended_sip`
--

/*!40000 ALTER TABLE `vicidial_log_extended_sip` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_extended_sip` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_extended_sip_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_extended_sip_archive` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `invite_to_ring` decimal(10,6) DEFAULT 0.000000,
  `ring_to_final` decimal(10,6) DEFAULT 0.000000,
  `invite_to_final` decimal(10,6) DEFAULT 0.000000,
  `last_event_code` smallint(3) DEFAULT 0,
  UNIQUE KEY `vlesa` (`caller_code`,`call_date`),
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_extended_sip_archive`
--

/*!40000 ALTER TABLE `vicidial_log_extended_sip_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_extended_sip_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_noanswer`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_noanswer` (
  `uniqueid` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','NONE','SYSTEM') DEFAULT 'NONE',
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `caller_code` varchar(30) NOT NULL,
  PRIMARY KEY (`uniqueid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_noanswer`
--

/*!40000 ALTER TABLE `vicidial_log_noanswer` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_noanswer` ENABLE KEYS */;

--
-- Table structure for table `vicidial_log_noanswer_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_log_noanswer_archive` (
  `uniqueid` varchar(20) NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `start_epoch` int(10) unsigned DEFAULT NULL,
  `end_epoch` int(10) unsigned DEFAULT NULL,
  `length_in_sec` int(10) DEFAULT NULL,
  `status` varchar(6) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  `processed` enum('Y','N') DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `term_reason` enum('CALLER','AGENT','QUEUETIMEOUT','ABANDON','AFTERHOURS','NONE','SYSTEM') DEFAULT 'NONE',
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `caller_code` varchar(30) NOT NULL,
  PRIMARY KEY (`uniqueid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_log_noanswer_archive`
--

/*!40000 ALTER TABLE `vicidial_log_noanswer_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_log_noanswer_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_long_extensions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_long_extensions` (
  `le_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `extension` varchar(1000) DEFAULT NULL,
  `call_date` datetime DEFAULT '2001-01-01 00:00:01',
  `source` varchar(20) DEFAULT '',
  PRIMARY KEY (`le_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_long_extensions`
--

/*!40000 ALTER TABLE `vicidial_long_extensions` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_long_extensions` ENABLE KEYS */;

--
-- Table structure for table `vicidial_manager`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_manager` (
  `man_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `uniqueid` varchar(20) DEFAULT NULL,
  `entry_date` datetime DEFAULT NULL,
  `status` enum('NEW','QUEUE','SENT','UPDATED','DEAD') DEFAULT NULL,
  `response` enum('Y','N') DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `action` varchar(20) DEFAULT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `cmd_line_b` varchar(100) DEFAULT NULL,
  `cmd_line_c` varchar(100) DEFAULT NULL,
  `cmd_line_d` varchar(200) DEFAULT NULL,
  `cmd_line_e` varchar(100) DEFAULT NULL,
  `cmd_line_f` varchar(100) DEFAULT NULL,
  `cmd_line_g` varchar(100) DEFAULT NULL,
  `cmd_line_h` varchar(100) DEFAULT NULL,
  `cmd_line_i` varchar(50) DEFAULT NULL,
  `cmd_line_j` varchar(50) DEFAULT NULL,
  `cmd_line_k` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`man_id`),
  KEY `callerid` (`callerid`),
  KEY `uniqueid` (`uniqueid`),
  KEY `serverstat` (`server_ip`,`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_manager`
--

/*!40000 ALTER TABLE `vicidial_manager` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_manager` ENABLE KEYS */;

--
-- Table structure for table `vicidial_manager_chat_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_manager_chat_log` (
  `manager_chat_message_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manager_chat_id` int(10) unsigned DEFAULT NULL,
  `manager_chat_subid` tinyint(3) unsigned DEFAULT NULL,
  `manager` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `message` mediumtext DEFAULT NULL,
  `message_id` varchar(20) DEFAULT NULL,
  `message_date` datetime DEFAULT NULL,
  `message_viewed_date` datetime DEFAULT NULL,
  `message_posted_by` varchar(20) DEFAULT NULL,
  `audio_alerted` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`manager_chat_message_id`),
  KEY `manager_chat_id_key` (`manager_chat_id`),
  KEY `manager_chat_subid_key` (`manager_chat_subid`),
  KEY `manager_chat_manager_key` (`manager`),
  KEY `manager_chat_user_key` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_manager_chat_log`
--

/*!40000 ALTER TABLE `vicidial_manager_chat_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_manager_chat_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_manager_chat_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_manager_chat_log_archive` (
  `manager_chat_message_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `manager_chat_id` int(10) unsigned DEFAULT NULL,
  `manager_chat_subid` tinyint(3) unsigned DEFAULT NULL,
  `manager` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `message` mediumtext DEFAULT NULL,
  `message_id` varchar(20) DEFAULT NULL,
  `message_date` datetime DEFAULT NULL,
  `message_viewed_date` datetime DEFAULT NULL,
  `message_posted_by` varchar(20) DEFAULT NULL,
  `audio_alerted` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`manager_chat_message_id`),
  KEY `manager_chat_id_archive_key` (`manager_chat_id`),
  KEY `manager_chat_subid_archive_key` (`manager_chat_subid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_manager_chat_log_archive`
--

/*!40000 ALTER TABLE `vicidial_manager_chat_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_manager_chat_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_manager_chats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_manager_chats` (
  `manager_chat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `internal_chat_type` enum('AGENT','MANAGER') DEFAULT 'MANAGER',
  `chat_start_date` datetime DEFAULT NULL,
  `manager` varchar(20) DEFAULT NULL,
  `selected_agents` mediumtext DEFAULT NULL,
  `selected_user_groups` mediumtext DEFAULT NULL,
  `selected_campaigns` mediumtext DEFAULT NULL,
  `allow_replies` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`manager_chat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_manager_chats`
--

/*!40000 ALTER TABLE `vicidial_manager_chats` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_manager_chats` ENABLE KEYS */;

--
-- Table structure for table `vicidial_manager_chats_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_manager_chats_archive` (
  `manager_chat_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `internal_chat_type` enum('AGENT','MANAGER') DEFAULT 'MANAGER',
  `chat_start_date` datetime DEFAULT NULL,
  `manager` varchar(20) DEFAULT NULL,
  `selected_agents` mediumtext DEFAULT NULL,
  `selected_user_groups` mediumtext DEFAULT NULL,
  `selected_campaigns` mediumtext DEFAULT NULL,
  `allow_replies` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`manager_chat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_manager_chats_archive`
--

/*!40000 ALTER TABLE `vicidial_manager_chats_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_manager_chats_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_manual_dial_queue`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_manual_dial_queue` (
  `mdq_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `phone_number` varchar(100) DEFAULT '',
  `entry_time` datetime DEFAULT NULL,
  `status` enum('READY','QUEUE') DEFAULT 'READY',
  `external_dial` varchar(100) DEFAULT '',
  PRIMARY KEY (`mdq_id`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_manual_dial_queue`
--

/*!40000 ALTER TABLE `vicidial_manual_dial_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_manual_dial_queue` ENABLE KEYS */;

--
-- Table structure for table `vicidial_monitor_calls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_monitor_calls` (
  `monitor_call_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `server_ip` varchar(15) NOT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `context` varchar(100) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `monitor_time` datetime DEFAULT NULL,
  `user_phone` varchar(10) DEFAULT 'USER',
  `api_log` enum('Y','N') DEFAULT 'N',
  `barge_listen` enum('LISTEN','BARGE') DEFAULT 'LISTEN',
  `prepop_id` varchar(100) DEFAULT '',
  `campaigns_limit` varchar(1000) DEFAULT '',
  `users_list` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`monitor_call_id`),
  KEY `callerid` (`callerid`),
  KEY `monitor_time` (`monitor_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_monitor_calls`
--

/*!40000 ALTER TABLE `vicidial_monitor_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_monitor_calls` ENABLE KEYS */;

--
-- Table structure for table `vicidial_monitor_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_monitor_log` (
  `server_ip` varchar(15) NOT NULL,
  `callerid` varchar(20) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `context` varchar(100) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `monitor_time` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  KEY `user` (`user`),
  KEY `campaign_id` (`campaign_id`),
  KEY `monitor_time` (`monitor_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_monitor_log`
--

/*!40000 ALTER TABLE `vicidial_monitor_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_monitor_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_music_on_hold`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_music_on_hold` (
  `moh_id` varchar(100) NOT NULL,
  `moh_name` varchar(255) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'N',
  `random` enum('Y','N') DEFAULT 'N',
  `remove` enum('Y','N') DEFAULT 'N',
  `user_group` varchar(20) DEFAULT '---ALL---',
  PRIMARY KEY (`moh_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_music_on_hold`
--

/*!40000 ALTER TABLE `vicidial_music_on_hold` DISABLE KEYS */;
INSERT INTO `vicidial_music_on_hold` VALUES ('default','Default Music On Hold','Y','N','N','---ALL---');
/*!40000 ALTER TABLE `vicidial_music_on_hold` ENABLE KEYS */;

--
-- Table structure for table `vicidial_music_on_hold_files`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_music_on_hold_files` (
  `filename` varchar(100) NOT NULL,
  `moh_id` varchar(100) NOT NULL,
  `rank` smallint(5) DEFAULT NULL,
  UNIQUE KEY `mohfile` (`filename`,`moh_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_music_on_hold_files`
--

/*!40000 ALTER TABLE `vicidial_music_on_hold_files` DISABLE KEYS */;
INSERT INTO `vicidial_music_on_hold_files` VALUES ('conf','default',1);
/*!40000 ALTER TABLE `vicidial_music_on_hold_files` ENABLE KEYS */;

--
-- Table structure for table `vicidial_nanpa_filter_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_nanpa_filter_log` (
  `output_code` varchar(30) NOT NULL,
  `status` varchar(20) DEFAULT 'BEGIN',
  `server_ip` varchar(15) DEFAULT '',
  `list_id` text DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT '',
  `leads_count` bigint(14) DEFAULT 0,
  `filter_count` bigint(14) DEFAULT 0,
  `status_line` varchar(255) DEFAULT '',
  `script_output` text DEFAULT NULL,
  PRIMARY KEY (`output_code`),
  KEY `start_time` (`start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_nanpa_filter_log`
--

/*!40000 ALTER TABLE `vicidial_nanpa_filter_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_nanpa_filter_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_nanpa_prefix_codes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_nanpa_prefix_codes` (
  `areacode` char(3) DEFAULT NULL,
  `prefix` char(3) DEFAULT NULL,
  `GMT_offset` varchar(6) DEFAULT NULL,
  `DST` enum('Y','N') DEFAULT NULL,
  `latitude` varchar(17) DEFAULT NULL,
  `longitude` varchar(17) DEFAULT NULL,
  `city` varchar(50) DEFAULT '',
  `state` varchar(2) DEFAULT '',
  `postal_code` varchar(10) DEFAULT '',
  `country` varchar(2) DEFAULT '',
  `lata_type` varchar(1) DEFAULT '',
  UNIQUE KEY `areaprefix` (`areacode`,`prefix`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_nanpa_prefix_codes`
--

/*!40000 ALTER TABLE `vicidial_nanpa_prefix_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_nanpa_prefix_codes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_outbound_ivr_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_outbound_ivr_log` (
  `uniqueid` varchar(50) NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `event_date` datetime DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `menu_id` varchar(50) DEFAULT '',
  `menu_action` varchar(50) DEFAULT '',
  UNIQUE KEY `campserver` (`event_date`,`lead_id`,`menu_id`),
  KEY `event_date` (`event_date`),
  KEY `lead_id` (`lead_id`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_outbound_ivr_log`
--

/*!40000 ALTER TABLE `vicidial_outbound_ivr_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_outbound_ivr_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_outbound_ivr_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_outbound_ivr_log_archive` (
  `uniqueid` varchar(50) NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `event_date` datetime DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `menu_id` varchar(50) DEFAULT '',
  `menu_action` varchar(50) DEFAULT '',
  UNIQUE KEY `campserver` (`event_date`,`lead_id`,`menu_id`),
  KEY `event_date` (`event_date`),
  KEY `lead_id` (`lead_id`),
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_outbound_ivr_log_archive`
--

/*!40000 ALTER TABLE `vicidial_outbound_ivr_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_outbound_ivr_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_override_ids`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_override_ids` (
  `id_table` varchar(50) NOT NULL,
  `active` enum('0','1') DEFAULT '1',
  `value` int(9) DEFAULT 0,
  PRIMARY KEY (`id_table`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_override_ids`
--

/*!40000 ALTER TABLE `vicidial_override_ids` DISABLE KEYS */;
INSERT INTO `vicidial_override_ids`(id_table, active, value) 
SELECT * FROM (
    SELECT 'vicidial_users','0',1000
    UNION ALL SELECT 'vicidial_campaigns','0',20000
    UNION ALL SELECT 'vicidial_inbound_groups','0',30000
    UNION ALL SELECT 'vicidial_lists','0',40000
    UNION ALL SELECT 'vicidial_call_menu','0',50000
    UNION ALL SELECT 'vicidial_user_groups','0',60000
    UNION ALL SELECT 'vicidial_lead_filters','0',70000
    UNION ALL SELECT 'vicidial_scripts','0',80000
    UNION ALL SELECT 'phones','0',100
) as data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_override_ids);
/*!40000 ALTER TABLE `vicidial_override_ids` ENABLE KEYS */;

--
-- Table structure for table `vicidial_pause_codes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_pause_codes` (
  `pause_code` varchar(6) NOT NULL,
  `pause_code_name` varchar(30) DEFAULT NULL,
  `billable` enum('NO','YES','HALF') DEFAULT 'NO',
  `campaign_id` varchar(8) DEFAULT NULL,
  `time_limit` smallint(5) unsigned DEFAULT 65000,
  `require_mgr_approval` enum('NO','YES') DEFAULT 'NO',
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_pause_codes`
--

/*!40000 ALTER TABLE `vicidial_pause_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_pause_codes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_peer_event_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_peer_event_log` (
  `peer_event_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `event_type` enum('UNKNOWN','REGISTERED','UNREGISTERED','REACHABLE','LAGGED','UNREACHABLE','RTPDISCONNECT','CRITICALTIMEOUT') DEFAULT 'UNKNOWN',
  `event_date` datetime(6) NOT NULL,
  `channel` varchar(100) DEFAULT '',
  `server_ip` varchar(15) NOT NULL,
  `host_ip` varchar(15) DEFAULT '',
  `port` smallint(6) DEFAULT NULL,
  `channel_type` enum('IAX2','SIP','PJSIP') DEFAULT NULL,
  `peer` varchar(100) DEFAULT '',
  `data` varchar(255) DEFAULT '',
  PRIMARY KEY (`peer_event_id`),
  KEY `event_date` (`event_date`),
  KEY `peer` (`peer`),
  KEY `channel` (`channel`)
) ENGINE=MyISAM AUTO_INCREMENT=630320 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_peer_event_log`
--

/*!40000 ALTER TABLE `vicidial_peer_event_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_peer_event_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_peer_event_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_peer_event_log_archive` (
  `peer_event_id` int(9) unsigned NOT NULL,
  `event_type` enum('UNKNOWN','REGISTERED','UNREGISTERED','REACHABLE','LAGGED','UNREACHABLE','RTPDISCONNECT','CRITICALTIMEOUT') DEFAULT 'UNKNOWN',
  `event_date` datetime(6) NOT NULL,
  `channel` varchar(100) DEFAULT '',
  `server_ip` varchar(15) NOT NULL,
  `host_ip` varchar(15) DEFAULT '',
  `port` smallint(6) DEFAULT NULL,
  `channel_type` enum('IAX2','SIP','PJSIP') DEFAULT NULL,
  `peer` varchar(100) DEFAULT '',
  `data` varchar(255) DEFAULT '',
  PRIMARY KEY (`peer_event_id`),
  KEY `event_date` (`event_date`),
  KEY `peer` (`peer`),
  KEY `channel` (`channel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_peer_event_log_archive`
--

/*!40000 ALTER TABLE `vicidial_peer_event_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_peer_event_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_pending_ar`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_pending_ar` (
  `ar_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `report_id` varchar(30) DEFAULT '',
  `start_datetime` datetime DEFAULT NULL,
  `php_script` varchar(50) DEFAULT '',
  `user` varchar(20) DEFAULT NULL,
  `status` enum('TRIGGERED','AUTHORIZED','COMPLETED','ERROR') DEFAULT 'TRIGGERED',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`ar_id`),
  KEY `pending_ar_key` (`user`,`start_datetime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_pending_ar`
--

/*!40000 ALTER TABLE `vicidial_pending_ar` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_pending_ar` ENABLE KEYS */;

--
-- Table structure for table `vicidial_phone_codes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_phone_codes` (
  `country_code` smallint(5) unsigned DEFAULT NULL,
  `country` char(3) DEFAULT NULL,
  `areacode` char(3) DEFAULT NULL,
  `state` varchar(4) DEFAULT NULL,
  `GMT_offset` varchar(6) DEFAULT NULL,
  `DST` enum('Y','N') DEFAULT NULL,
  `DST_range` varchar(8) DEFAULT NULL,
  `geographic_description` varchar(100) DEFAULT NULL,
  `tz_code` varchar(4) DEFAULT '',
  `php_tz` varchar(100) DEFAULT '',
  KEY `country_area_code` (`country_code`,`areacode`),
  KEY `country_state` (`country_code`,`state`),
  KEY `country_code` (`country_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_phone_codes`
--

/*!40000 ALTER TABLE `vicidial_phone_codes` DISABLE KEYS */;

/*!40000 ALTER TABLE `vicidial_phone_codes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_phone_number_call_daily_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_phone_number_call_daily_counts` (
  `phone_number` varchar(18) NOT NULL,
  `called_count` tinyint(3) unsigned DEFAULT 0,
  `modify_date` datetime DEFAULT NULL,
  UNIQUE KEY `vpncdc_phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_phone_number_call_daily_counts`
--

/*!40000 ALTER TABLE `vicidial_phone_number_call_daily_counts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_phone_number_call_daily_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_postal_codes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_postal_codes` (
  `postal_code` varchar(10) NOT NULL,
  `state` varchar(4) DEFAULT NULL,
  `GMT_offset` varchar(6) DEFAULT NULL,
  `DST` enum('Y','N') DEFAULT NULL,
  `DST_range` varchar(8) DEFAULT NULL,
  `country` char(3) DEFAULT NULL,
  `country_code` smallint(5) unsigned DEFAULT NULL,
  KEY `country_postal_code` (`country_code`,`postal_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_postal_codes`
--

/*!40000 ALTER TABLE `vicidial_postal_codes` DISABLE KEYS */;

/*!40000 ALTER TABLE `vicidial_postal_codes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_postal_codes_cities`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_postal_codes_cities` (
  `postal_code` varchar(10) NOT NULL,
  `state` varchar(4) DEFAULT NULL,
  `city` varchar(60) DEFAULT NULL,
  `county` varchar(60) DEFAULT NULL,
  `latitude` varchar(17) DEFAULT NULL,
  `longitude` varchar(17) DEFAULT NULL,
  `areacode` char(3) DEFAULT NULL,
  `country_code` smallint(5) unsigned DEFAULT NULL,
  `country` char(3) DEFAULT NULL,
  KEY `postal_code` (`postal_code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_postal_codes_cities`
--

/*!40000 ALTER TABLE `vicidial_postal_codes_cities` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_postal_codes_cities` ENABLE KEYS */;

--
-- Table structure for table `vicidial_process_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_process_log` (
  `serial_id` varchar(20) NOT NULL,
  `run_time` datetime DEFAULT NULL,
  `run_sec` int(11) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `script` varchar(100) DEFAULT NULL,
  `process` varchar(100) DEFAULT NULL,
  `output_lines` mediumtext DEFAULT NULL,
  KEY `serial_id` (`serial_id`),
  KEY `run_time` (`run_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_process_log`
--

/*!40000 ALTER TABLE `vicidial_process_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_process_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_process_trigger_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_process_trigger_log` (
  `trigger_id` varchar(20) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `trigger_time` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `trigger_lines` text DEFAULT NULL,
  `trigger_results` mediumtext DEFAULT NULL,
  KEY `trigger_id` (`trigger_id`),
  KEY `trigger_time` (`trigger_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_process_trigger_log`
--

/*!40000 ALTER TABLE `vicidial_process_trigger_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_process_trigger_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_process_triggers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_process_triggers` (
  `trigger_id` varchar(20) NOT NULL,
  `trigger_name` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `trigger_time` datetime DEFAULT NULL,
  `trigger_run` enum('0','1') DEFAULT '0',
  `user` varchar(20) DEFAULT NULL,
  `trigger_lines` text DEFAULT NULL,
  PRIMARY KEY (`trigger_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_process_triggers`
--

/*!40000 ALTER TABLE `vicidial_process_triggers` DISABLE KEYS */;
INSERT INTO `vicidial_process_triggers` select 'LOAD_LEADS','Load Leads','10.10.10.15','2009-01-01 00:00:00','0',NULL,'/usr/share/astguiclient/VICIDIAL_IN_new_leads_file.pl' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_process_triggers);
/*!40000 ALTER TABLE `vicidial_process_triggers` ENABLE KEYS */;

--
-- Table structure for table `vicidial_qc_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_qc_agent_log` (
  `qc_agent_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `qc_user` varchar(20) NOT NULL,
  `qc_user_group` varchar(20) NOT NULL,
  `qc_user_ip` varchar(15) NOT NULL,
  `lead_user` varchar(20) NOT NULL,
  `web_server_ip` varchar(15) NOT NULL,
  `view_datetime` datetime NOT NULL,
  `save_datetime` datetime DEFAULT NULL,
  `view_epoch` int(10) unsigned NOT NULL,
  `save_epoch` int(10) unsigned DEFAULT NULL,
  `elapsed_seconds` smallint(5) unsigned DEFAULT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned NOT NULL,
  `campaign_id` varchar(8) NOT NULL,
  `old_status` varchar(6) DEFAULT NULL,
  `new_status` varchar(6) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `processed` enum('Y','N') NOT NULL,
  `qc_log_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`qc_agent_log_id`),
  KEY `view_epoch` (`view_epoch`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_qc_agent_log`
--

/*!40000 ALTER TABLE `vicidial_qc_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_qc_agent_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_qc_codes`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_qc_codes` (
  `code` varchar(8) NOT NULL,
  `code_name` varchar(30) DEFAULT NULL,
  `qc_result_type` enum('PASS','FAIL','CANCEL','COMMIT') NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_qc_codes`
--

/*!40000 ALTER TABLE `vicidial_qc_codes` DISABLE KEYS */;
INSERT INTO `vicidial_qc_codes` 
(code, code_name, qc_result_type)
SELECT code, code_name, qc_result_type FROM (
    SELECT 'QCPASS' AS code, 'PASS' AS code_name, 'PASS' AS qc_result_type
    UNION ALL
    SELECT 'QCFAIL', 'FAIL', 'FAIL'
    UNION ALL
    SELECT 'QCCANCEL', 'CANCEL', 'CANCEL'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_qc_codes);

/*!40000 ALTER TABLE `vicidial_qc_codes` ENABLE KEYS */;

--
-- Table structure for table `vicidial_queue_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_queue_groups` (
  `queue_group` varchar(20) NOT NULL,
  `queue_group_name` varchar(40) NOT NULL,
  `included_campaigns` text DEFAULT NULL,
  `included_inbound_groups` text DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  `active` enum('Y','N') DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_queue_groups`
--

/*!40000 ALTER TABLE `vicidial_queue_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_queue_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_recent_ascb_calls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_recent_ascb_calls` (
  `call_date` datetime DEFAULT NULL,
  `callback_date` datetime DEFAULT NULL,
  `callback_id` int(9) unsigned DEFAULT 0,
  `caller_code` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `server_ip` varchar(60) NOT NULL,
  `orig_status` varchar(6) DEFAULT 'CALLBK',
  `reschedule` varchar(10) DEFAULT '',
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `rescheduled` enum('U','P','Y','N') DEFAULT 'U',
  UNIQUE KEY `caller_code` (`caller_code`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_recent_ascb_calls`
--

/*!40000 ALTER TABLE `vicidial_recent_ascb_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_recent_ascb_calls` ENABLE KEYS */;

--
-- Table structure for table `vicidial_recent_ascb_calls_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_recent_ascb_calls_archive` (
  `call_date` datetime DEFAULT NULL,
  `callback_date` datetime DEFAULT NULL,
  `callback_id` int(9) unsigned DEFAULT 0,
  `caller_code` varchar(30) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT NULL,
  `server_ip` varchar(60) NOT NULL,
  `orig_status` varchar(6) DEFAULT 'CALLBK',
  `reschedule` varchar(10) DEFAULT '',
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `rescheduled` enum('U','P','Y','N') DEFAULT 'U',
  UNIQUE KEY `caller_code` (`caller_code`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_recent_ascb_calls_archive`
--

/*!40000 ALTER TABLE `vicidial_recent_ascb_calls_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_recent_ascb_calls_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_recording_access_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_recording_access_log` (
  `recording_access_log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recording_id` int(10) unsigned DEFAULT NULL,
  `lead_id` int(10) unsigned DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `access_datetime` datetime DEFAULT NULL,
  `access_result` enum('ACCESSED','INVALID USER','INVALID PERMISSIONS','NO RECORDING','RECORDING UNAVAILABLE') DEFAULT NULL,
  `ip` varchar(15) DEFAULT '',
  PRIMARY KEY (`recording_access_log_id`),
  KEY `recording_id` (`recording_id`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1599 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_recording_access_log`
--

/*!40000 ALTER TABLE `vicidial_recording_access_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_recording_access_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_remote_agent_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_remote_agent_log` (
  `uniqueid` varchar(20) DEFAULT '',
  `callerid` varchar(20) DEFAULT '',
  `ra_user` varchar(20) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `call_time` datetime DEFAULT NULL,
  `extension` varchar(100) DEFAULT '',
  `lead_id` int(9) unsigned DEFAULT 0,
  `phone_number` varchar(18) DEFAULT '',
  `campaign_id` varchar(20) DEFAULT '',
  `processed` enum('Y','N') DEFAULT 'N',
  `comment` varchar(255) DEFAULT '',
  KEY `call_time` (`call_time`),
  KEY `ra_user` (`ra_user`),
  KEY `extension` (`extension`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_remote_agent_log`
--

/*!40000 ALTER TABLE `vicidial_remote_agent_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_remote_agent_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_remote_agents`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_remote_agents` (
  `remote_agent_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user_start` varchar(20) DEFAULT NULL,
  `number_of_lines` tinyint(3) unsigned DEFAULT 1,
  `server_ip` varchar(15) NOT NULL,
  `conf_exten` varchar(20) DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'INACTIVE',
  `campaign_id` varchar(8) DEFAULT NULL,
  `closer_campaigns` text DEFAULT NULL,
  `extension_group` varchar(20) DEFAULT 'NONE',
  `extension_group_order` varchar(20) DEFAULT 'NONE',
  `on_hook_agent` enum('Y','N') DEFAULT 'N',
  `on_hook_ring_time` smallint(5) DEFAULT 15,
  PRIMARY KEY (`remote_agent_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_remote_agents`
--

/*!40000 ALTER TABLE `vicidial_remote_agents` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_remote_agents` ENABLE KEYS */;

--
-- Table structure for table `vicidial_report_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_report_log` (
  `report_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `event_date` datetime NOT NULL,
  `user` varchar(20) NOT NULL,
  `ip_address` varchar(15) NOT NULL,
  `report_name` varchar(50) NOT NULL,
  `browser` text DEFAULT NULL,
  `referer` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `url` text DEFAULT NULL,
  `run_time` varchar(20) DEFAULT '0',
  `webserver` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`report_log_id`),
  KEY `user` (`user`),
  KEY `report_name` (`report_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_report_log`
--

/*!40000 ALTER TABLE `vicidial_report_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_report_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_rt_monitor_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_rt_monitor_log` (
  `manager_user` varchar(20) NOT NULL,
  `manager_server_ip` varchar(15) NOT NULL,
  `manager_phone` varchar(20) NOT NULL,
  `manager_ip` varchar(15) DEFAULT NULL,
  `agent_user` varchar(20) DEFAULT NULL,
  `agent_server_ip` varchar(15) DEFAULT NULL,
  `agent_status` varchar(10) DEFAULT NULL,
  `agent_session` varchar(10) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `monitor_start_time` datetime DEFAULT NULL,
  `monitor_end_time` datetime DEFAULT NULL,
  `monitor_sec` int(9) unsigned DEFAULT 0,
  `monitor_type` enum('LISTEN','BARGE','HIJACK','WHISPER') DEFAULT 'LISTEN',
  UNIQUE KEY `caller_code` (`caller_code`),
  KEY `manager_user` (`manager_user`),
  KEY `agent_user` (`agent_user`),
  KEY `monitor_start_time` (`monitor_start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_rt_monitor_log`
--

/*!40000 ALTER TABLE `vicidial_rt_monitor_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_rt_monitor_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_rt_monitor_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_rt_monitor_log_archive` (
  `manager_user` varchar(20) NOT NULL,
  `manager_server_ip` varchar(15) NOT NULL,
  `manager_phone` varchar(20) NOT NULL,
  `manager_ip` varchar(15) DEFAULT NULL,
  `agent_user` varchar(20) DEFAULT NULL,
  `agent_server_ip` varchar(15) DEFAULT NULL,
  `agent_status` varchar(10) DEFAULT NULL,
  `agent_session` varchar(10) DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `monitor_start_time` datetime DEFAULT NULL,
  `monitor_end_time` datetime DEFAULT NULL,
  `monitor_sec` int(9) unsigned DEFAULT 0,
  `monitor_type` enum('LISTEN','BARGE','HIJACK','WHISPER') DEFAULT 'LISTEN',
  UNIQUE KEY `caller_code` (`caller_code`),
  KEY `manager_user` (`manager_user`),
  KEY `agent_user` (`agent_user`),
  KEY `monitor_start_time` (`monitor_start_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_rt_monitor_log_archive`
--

/*!40000 ALTER TABLE `vicidial_rt_monitor_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_rt_monitor_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_screen_colors`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_screen_colors` (
  `colors_id` varchar(20) NOT NULL,
  `colors_name` varchar(100) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'N',
  `menu_background` varchar(6) DEFAULT '015B91',
  `frame_background` varchar(6) DEFAULT 'D9E6FE',
  `std_row1_background` varchar(6) DEFAULT '9BB9FB',
  `std_row2_background` varchar(6) DEFAULT 'B9CBFD',
  `std_row3_background` varchar(6) DEFAULT '8EBCFD',
  `std_row4_background` varchar(6) DEFAULT 'B6D3FC',
  `std_row5_background` varchar(6) DEFAULT 'A3C3D6',
  `alt_row1_background` varchar(6) DEFAULT 'BDFFBD',
  `alt_row2_background` varchar(6) DEFAULT '99FF99',
  `alt_row3_background` varchar(6) DEFAULT 'CCFFCC',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `web_logo` varchar(100) DEFAULT 'default_new',
  `button_color` varchar(6) DEFAULT 'EFEFEF',
  PRIMARY KEY (`colors_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_screen_colors`
--

/*!40000 ALTER TABLE `vicidial_screen_colors` DISABLE KEYS */;
INSERT INTO `vicidial_screen_colors` 
(colors_id, colors_name, active, menu_background, frame_background, std_row1_background, std_row2_background, std_row3_background, std_row4_background, std_row5_background, alt_row1_background, alt_row2_background, alt_row3_background, user_group, web_logo, button_color)
SELECT colors_id, colors_name, active, menu_background, frame_background, std_row1_background, std_row2_background, std_row3_background, std_row4_background, std_row5_background, alt_row1_background, alt_row2_background, alt_row3_background, user_group, web_logo, button_color FROM (
  SELECT 'red_rust' AS colors_id, 'dark red rust' AS colors_name, 'Y' AS active, '804435' AS menu_background, 'E7D0C2' AS frame_background, 'C68C71' AS std_row1_background, 'D9B39F' AS std_row2_background, 'D9B49F' AS std_row3_background, 'C68C72' AS std_row4_background, 'C68C73' AS std_row5_background, 'BDFFBD' AS alt_row1_background, '99FF99' AS alt_row2_background, 'CCFFCC' AS alt_row3_background, '---ALL---' AS user_group, 'default_new' AS web_logo, 'EFEFEF' AS button_color
  UNION ALL
  SELECT 'pale_green', 'pale green', 'Y', '738035', 'E0E7C2', 'B6C572', 'C4CF8B', 'B6C572', 'C4CF8B', 'C4CF8B', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'default_new', 'EFEFEF'
  UNION ALL
  SELECT 'alt_green', 'alternate green', 'Y', '333333', 'D6E3B2', 'AEC866', 'BCD180', 'BCD180', 'AEC866', 'AEC866', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'default_new', 'EFEFEF'
  UNION ALL
  SELECT 'default_blue_test', 'default blue test', 'Y', '015B91', 'D9E6FE', '9BB9FB', 'B9CBFD', '8EBCFD', 'B6D3FC', 'A3C3D6', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'default_new', 'EFEFEF'
  UNION ALL
  SELECT 'basic_orange', 'basic orange', 'Y', '804d00', 'ffebcc', 'ffcc80', 'ffd699', 'ffcc80', 'ffd699', 'ffcc80', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'default_new', 'EFEFEF'
  UNION ALL
  SELECT 'basic_purple', 'basic purple', 'Y', '660066', 'ffccff', 'ff99ff', 'ffb3ff', 'ff99ff', 'ffb3ff', 'ff99ff', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'SAMPLE.png', 'EFEFEF'
  UNION ALL
  SELECT 'basic_yellow', 'basic yellow', 'Y', '666600', 'ffffcc', 'ffff66', 'ffff99', 'ffff66', 'ffff99', 'ffff66', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'default_new', 'EFEFEF'
  UNION ALL
  SELECT 'basic_red', 'basic red', 'Y', '800000', 'ffe6e6', 'ff9999', 'ffb3b3', 'ff9999', 'ffb3b3', 'ff9999', 'BDFFBD', '99FF99', 'CCFFCC', '---ALL---', 'default_new', 'EFEFEF'
  UNION ALL
  SELECT 'default_grey_agent', 'default grey agent', 'Y', 'FFFFFF', 'cccccc', 'E6E6E6', 'E6E6E6', 'E6E6E6', 'E6E6E6', 'E6E6E6', 'E6E6E6', 'E6E6E6', 'E6E6E6', '---ALL---', 'DEFAULTAGENT.png', 'EFEFEF'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_screen_colors);

/*!40000 ALTER TABLE `vicidial_screen_colors` ENABLE KEYS */;

--
-- Table structure for table `vicidial_screen_labels`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_screen_labels` (
  `label_id` varchar(20) NOT NULL,
  `label_name` varchar(100) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT 'N',
  `label_hide_field_logs` varchar(6) DEFAULT 'Y',
  `label_title` varchar(60) DEFAULT '',
  `label_first_name` varchar(60) DEFAULT '',
  `label_middle_initial` varchar(60) DEFAULT '',
  `label_last_name` varchar(60) DEFAULT '',
  `label_address1` varchar(60) DEFAULT '',
  `label_address2` varchar(60) DEFAULT '',
  `label_address3` varchar(60) DEFAULT '',
  `label_city` varchar(60) DEFAULT '',
  `label_state` varchar(60) DEFAULT '',
  `label_province` varchar(60) DEFAULT '',
  `label_postal_code` varchar(60) DEFAULT '',
  `label_vendor_lead_code` varchar(60) DEFAULT '',
  `label_gender` varchar(60) DEFAULT '',
  `label_phone_number` varchar(60) DEFAULT '',
  `label_phone_code` varchar(60) DEFAULT '',
  `label_alt_phone` varchar(60) DEFAULT '',
  `label_security_phrase` varchar(60) DEFAULT '',
  `label_email` varchar(60) DEFAULT '',
  `label_comments` varchar(60) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `label_lead_id` varchar(60) DEFAULT '',
  `label_list_id` varchar(60) DEFAULT '',
  `label_entry_date` varchar(60) DEFAULT '',
  `label_gmt_offset_now` varchar(60) DEFAULT '',
  `label_source_id` varchar(60) DEFAULT '',
  `label_called_since_last_reset` varchar(60) DEFAULT '',
  `label_status` varchar(60) DEFAULT '',
  `label_user` varchar(60) DEFAULT '',
  `label_date_of_birth` varchar(60) DEFAULT '',
  `label_country_code` varchar(60) DEFAULT '',
  `label_last_local_call_time` varchar(60) DEFAULT '',
  `label_called_count` varchar(60) DEFAULT '',
  `label_rank` varchar(60) DEFAULT '',
  `label_owner` varchar(60) DEFAULT '',
  `label_entry_list_id` varchar(60) DEFAULT '',
  PRIMARY KEY (`label_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_screen_labels`
--

/*!40000 ALTER TABLE `vicidial_screen_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_screen_labels` ENABLE KEYS */;

--
-- Table structure for table `vicidial_scripts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_scripts` (
  `script_id` varchar(20) NOT NULL,
  `script_name` varchar(50) DEFAULT NULL,
  `script_comments` varchar(255) DEFAULT NULL,
  `script_text` text DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  `script_color` varchar(20) DEFAULT 'white',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`script_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_scripts`
--

/*!40000 ALTER TABLE `vicidial_scripts` DISABLE KEYS */;
INSERT INTO `vicidial_scripts` select 'CALLNOTES','Call Notes and Appointment Setting','','<iframe src=\"../agc/vdc_script_notes.php?lead_id=--A--lead_id--B--&vendor_id=--A--vendor_lead_code--B--&list_id=--A--list_id--B--&gmt_offset_now=--A--gmt_offset_now--B--&phone_code=--A--phone_code--B--&phone_number=--A--phone_number--B--&title=--A--title--B--&first_name=--A--first_name--B--&middle_initial=--A--middle_initial--B--&last_name=--A--last_name--B--&address1=--A--address1--B--&address2=--A--address2--B--&address3=--A--address3--B--&city=--A--city--B--&state=--A--state--B--&province=--A--province--B--&postal_code=--A--postal_code--B--&country_code=--A--country_code--B--&gender=--A--gender--B--&date_of_birth=--A--date_of_birth--B--&alt_phone=--A--alt_phone--B--&email=--A--email--B--&security_phrase=--A--security_phrase--B--&comments=--A--comments--B--&user=--A--user--B--&pass=--A--pass--B--&campaign=--A--campaign--B--&phone_login=--A--phone_login--B--&fronter=--A--fronter--B--&closer=--A--user--B--&group=--A--group--B--&channel_group=--A--group--B--&SQLdate=--A--SQLdate--B--&epoch=--A--epoch--B--&uniqueid=--A--uniqueid--B--&rank=--A--rank--B--&owner=--A--owner--B--&customer_zap_channel=--A--customer_zap_channel--B--&server_ip=--A--server_ip--B--&SIPexten=--A--SIPexten--B--&session_id=--A--session_id--B--\" style=\"background-color:transparent;\" scrolling=\"auto\" frameborder=\"0\" allowtransparency=\"true\" id=\"popupFrame\" name=\"popupFrame\"  width=\"--A--script_width--B--\" height=\"--A--script_height--B--\" STYLE=\"z-index:17\"> </iframe>','Y','---ALL---','white','2025-06-23 16:43:09' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_scripts);
/*!40000 ALTER TABLE `vicidial_scripts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_security_event_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_security_event_log` (
  `event_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `server_ip` varchar(15) DEFAULT NULL,
  `event` varchar(25) NOT NULL,
  `event_time` datetime(3) NOT NULL,
  `severity` enum('Informational','Error') NOT NULL,
  `service` varchar(25) NOT NULL,
  `event_version` varchar(25) NOT NULL,
  `account_id` varchar(25) NOT NULL,
  `session_id` varchar(25) NOT NULL,
  `local_address` varchar(15) NOT NULL,
  `local_port` smallint(6) NOT NULL,
  `remote_address` varchar(15) NOT NULL,
  `remote_port` smallint(6) NOT NULL,
  `module` varchar(25) DEFAULT NULL,
  `session_time` datetime(3) DEFAULT NULL,
  `optional_one` varchar(100) DEFAULT NULL,
  `optional_two` varchar(100) DEFAULT NULL,
  `optional_three` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `server_ip` (`server_ip`),
  KEY `event` (`event`),
  KEY `event_time` (`event_time`),
  KEY `remote_address` (`remote_address`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_security_event_log`
--

/*!40000 ALTER TABLE `vicidial_security_event_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_security_event_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_server_carriers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_server_carriers` (
  `carrier_id` varchar(15) NOT NULL,
  `carrier_name` varchar(50) NOT NULL,
  `registration_string` varchar(255) DEFAULT NULL,
  `template_id` varchar(15) NOT NULL,
  `account_entry` text DEFAULT NULL,
  `protocol` enum('SIP','PJSIP','PJSIP_WIZ','Zap','IAX2','EXTERNAL') DEFAULT 'SIP',
  `globals_string` varchar(255) DEFAULT NULL,
  `dialplan_entry` text DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `active` enum('Y','N') DEFAULT 'Y',
  `carrier_description` varchar(255) DEFAULT NULL,
  `user_group` varchar(20) DEFAULT '---ALL---',
  UNIQUE KEY `carrier_id` (`carrier_id`),
  KEY `server_ip` (`server_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_server_carriers`
--

/*!40000 ALTER TABLE `vicidial_server_carriers` DISABLE KEYS */;
INSERT INTO `vicidial_server_carriers` 
(carrier_id, carrier_name, registration_string, template_id, account_entry, protocol, globals_string, dialplan_entry, server_ip, active, carrier_description, user_group)
SELECT carrier_id, carrier_name, registration_string, template_id, account_entry, protocol, globals_string, dialplan_entry, server_ip, active, carrier_description, user_group FROM (
  SELECT 'OLD_SIPEXAMPLE' AS carrier_id, 'OLD TEST SIP carrier example' AS carrier_name, 'register => testcarrier:test@10.10.10.15:5060' AS registration_string, '--NONE--' AS template_id,
         '[testcarrier]\ndisallow=all\nallow=ulaw\ntype=friend\nusername=testcarrier\nsecret=test\nhost=dynamic\ndtmfmode=rfc2833\ncontext=trunkinbound\n' AS account_entry, 'SIP' AS protocol,
         'TESTSIPTRUNK = SIP/testcarrier' AS globals_string,
         'exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,2,Dial(${TESTSIPTRUNK}/${EXTEN:2},${CAMPDTO},To)\nexten => _91999NXXXXXX,3,Hangup\n' AS dialplan_entry,
         '10.10.10.15' AS server_ip, 'N' AS active, NULL AS carrier_description, '---ALL---' AS user_group
  UNION ALL
  SELECT 'OLD_IAXEXAMPLE', 'OLD TEST IAX carrier example', 'register => testcarrier:test@10.10.10.15:4569', '--NONE--',
         '[testcarrier]\ndisallow=all\nallow=ulaw\ntype=friend\naccountcode=testcarrier\nsecret=test\nhost=dynamic\ncontext=trunkinbound\n', 'IAX2',
         'TESTIAXTRUNK = IAX2/testcarrier',
         'exten => _71999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _71999NXXXXXX,2,Dial(${TESTIAXTRUNK}/${EXTEN:2},${CAMPDTO},To)\nexten => _71999NXXXXXX,3,Hangup\n',
         '10.10.10.15', 'N', NULL, '---ALL---'
  UNION ALL
  SELECT 'SIPExample', 'SIP Example', '', '--NONE--',
         '[ExampleSIP]\ntype = peer\ncontext = trunkinbound\nusecallerid = yes\ntrustrpid = no\nsendrpid = yes\nhost = 10.10.10.15\nqualify = yes\ninsecure = port,invite\ndisallow = all\nallow = ulaw\ndtmfmode = auto', 'SIP',
         'SIPTRUNK = SIP/ExampleSIP',
         'exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,2,Dial(${SIPTRUNK}/${EXTEN:1},${CAMPDTO},To)\nexten => _91999NXXXXXX,3,Hangup',
         '0.0.0.0', 'N', 'A SIP example carrier using IP Authentication', '---ALL---'
  UNION ALL
  SELECT 'PJSIPExample', 'PJSIP Example', '', '--NONE--',
         '[ExamplePJSIP]\ntype = aor\ncontact = sip:10.10.10.15\nqualify_frequency = 15\nmaximum_expiration = 3600\nminimum_expiration = 60\ndefault_expiration = 120\n\n[ExamplePJSIP]\ntype = identify\nendpoint = ExamplePJSIP\nmatch = 10.10.10.15\n\n[ExamplePJSIP]\ntype = endpoint\ncontext = trunkinbound\ndtmf_mode = rfc4733\ndisallow = all\nallow = ulaw\nrtp_symmetric = yes\nrewrite_contact = yes\nrtp_timeout = 60\nuse_ptime = yes\nmoh_suggest = default\ndirect_media = no\ntrust_id_inbound = yes\nsend_rpid = yes\ninband_progress = no\ntos_audio = ef\nlanguage = en\naors = ExamplePJSIP\ndtmf_mode=auto', 'PJSIP',
         'PJTRUNK=ExamplePJSIP',
         'exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,n,Dial(PJSIP/${EXTEN:1}@${PJTRUNK},${CAMPDTO},To)\nexten => _91999NXXXXXX,n,Hangup()',
         '0.0.0.0', 'N', 'A PJSIP example carrier using IP authentication', '---ALL---'
  UNION ALL
  SELECT 'PJSIPWIZExample', 'PJSIP_WIZ Example', '', '--NONE--',
         '[ExamplePJSIPWIZ]\ntype = wizard\nremote_hosts = 10.10.10.15:5060\nsends_registrations = no\naccepts_registrations = no\nsends_auth = no\naccepts_auth = no\naor/qualify_frequency = 15\naor/maximum_expiration = 3600\naor/minimum_expiration = 60\naor/default_expiration = 120\nendpoint/allow_subscribe = no\nendpoint/context = trunkinbound\nendpoint/dtmf_mode = auto\nendpoint/disallow = all\nendpoint/allow = ulaw\nendpoint/rtp_symmetric = yes\nendpoint/rewrite_contact = yes\nendpoint/rtp_timeout = 60\nendpoint/use_ptime = yes\nendpoint/moh_suggest = default\nendpoint/direct_media = no\nendpoint/trust_id_inbound = yes\nendpoint/send_rpid = yes\nendpoint/inband_progress = no\nendpoint/tos_audio = ef\nendpoint/language = en', 'PJSIP_WIZ',
         'WIZTRK=ExamplePJSIPWIZ',
         'exten => _91999NXXXXXX,1,AGI(agi://127.0.0.1:4577/call_log)\nexten => _91999NXXXXXX,n,Dial(PJSIP/${EXTEN:1}@${WIZTRK},${CAMPDTO},To)\nexten => _91999NXXXXXX,n,Hangup()',
         '0.0.0.0', 'N', 'A PJSIP_WIZ example carrier using IP authentication', '---ALL---'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_server_carriers);

/*!40000 ALTER TABLE `vicidial_server_carriers` ENABLE KEYS */;

--
-- Table structure for table `vicidial_server_trunks`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_server_trunks` (
  `server_ip` varchar(15) NOT NULL,
  `campaign_id` varchar(20) NOT NULL,
  `dedicated_trunks` smallint(5) unsigned DEFAULT 0,
  `trunk_restriction` enum('MAXIMUM_LIMIT','OVERFLOW_ALLOWED') DEFAULT 'OVERFLOW_ALLOWED',
  KEY `campaign_id` (`campaign_id`),
  KEY `server_ip` (`server_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_server_trunks`
--

/*!40000 ALTER TABLE `vicidial_server_trunks` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_server_trunks` ENABLE KEYS */;

--
-- Table structure for table `vicidial_session_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_session_data` (
  `session_name` varchar(40) NOT NULL,
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `conf_exten` varchar(20) DEFAULT NULL,
  `extension` varchar(100) NOT NULL,
  `login_time` datetime NOT NULL,
  `webphone_url` text DEFAULT NULL,
  `agent_login_call` text DEFAULT NULL,
  UNIQUE KEY `session_name` (`session_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_session_data`
--

/*!40000 ALTER TABLE `vicidial_session_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_session_data` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sessions_recent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sessions_recent` (
  `lead_id` int(9) unsigned DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `conf_exten` varchar(20) DEFAULT NULL,
  `call_type` varchar(1) DEFAULT '',
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sessions_recent`
--

/*!40000 ALTER TABLE `vicidial_sessions_recent` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sessions_recent` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sessions_recent_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sessions_recent_archive` (
  `lead_id` int(9) unsigned DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `call_date` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `conf_exten` varchar(20) DEFAULT NULL,
  `call_type` varchar(1) DEFAULT '',
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sessions_recent_archive`
--

/*!40000 ALTER TABLE `vicidial_sessions_recent_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sessions_recent_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_settings_containers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_settings_containers` (
  `container_id` varchar(40) NOT NULL,
  `container_notes` varchar(255) DEFAULT '',
  `container_type` varchar(40) DEFAULT 'OTHER',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `container_entry` mediumtext DEFAULT NULL,
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`container_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_settings_containers`
--

/*!40000 ALTER TABLE `vicidial_settings_containers` DISABLE KEYS */;

/*!40000 ALTER TABLE `vicidial_settings_containers` ENABLE KEYS */;

--
-- Table structure for table `vicidial_shared_drops`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_shared_drops` (
  `callerid` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) NOT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `status` enum('SENT','RINGING','LIVE','XFER','PAUSED','CLOSER','BUSY','DISCONNECT','IVR') DEFAULT 'PAUSED',
  `lead_id` int(9) unsigned NOT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `call_time` datetime DEFAULT NULL,
  `call_type` enum('IN','OUT','OUTBALANCE') DEFAULT 'OUT',
  `stage` varchar(20) DEFAULT 'START',
  `last_update_time` datetime DEFAULT NULL,
  `alt_dial` varchar(6) DEFAULT 'NONE',
  `drop_time` datetime DEFAULT NULL,
  KEY `callerid` (`callerid`),
  KEY `call_time` (`call_time`),
  KEY `drop_time` (`drop_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_shared_drops`
--

/*!40000 ALTER TABLE `vicidial_shared_drops` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_shared_drops` ENABLE KEYS */;

--
-- Table structure for table `vicidial_shared_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_shared_log` (
  `campaign_id` varchar(20) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `log_time` datetime DEFAULT NULL,
  `total_agents` smallint(5) DEFAULT 0,
  `total_calls` smallint(5) DEFAULT 0,
  `debug_output` text DEFAULT NULL,
  `adapt_output` text DEFAULT NULL,
  KEY `campaign_id` (`campaign_id`),
  KEY `log_time` (`log_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_shared_log`
--

/*!40000 ALTER TABLE `vicidial_shared_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_shared_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_shifts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_shifts` (
  `shift_id` varchar(20) NOT NULL,
  `shift_name` varchar(50) DEFAULT NULL,
  `shift_start_time` varchar(4) DEFAULT '0900',
  `shift_length` varchar(5) DEFAULT '16:00',
  `shift_weekdays` varchar(7) DEFAULT '0123456',
  `report_option` enum('Y','N') DEFAULT 'N',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `report_rank` smallint(5) DEFAULT 1,
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  KEY `shift_id` (`shift_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_shifts`
--

/*!40000 ALTER TABLE `vicidial_shifts` DISABLE KEYS */;
INSERT INTO `vicidial_shifts` select '24HRMIDNIGHT','24 hours 7 days a week','0000','24:00','0123456','N','---ALL---',1,'2025-06-23 16:43:09' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_shifts);
/*!40000 ALTER TABLE `vicidial_shifts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_action_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_action_log` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `result` varchar(40) DEFAULT NULL,
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `result` (`result`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_action_log`
--

/*!40000 ALTER TABLE `vicidial_sip_action_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_action_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_action_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_action_log_archive` (
  `call_date` datetime(6) DEFAULT NULL,
  `caller_code` varchar(30) NOT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `result` varchar(40) DEFAULT NULL,
  UNIQUE KEY `vlesa` (`caller_code`,`call_date`),
  KEY `call_date` (`call_date`),
  KEY `caller_code` (`caller_code`),
  KEY `result` (`result`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_action_log_archive`
--

/*!40000 ALTER TABLE `vicidial_sip_action_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_action_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_archive_details`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_archive_details` (
  `wday` tinyint(1) unsigned NOT NULL,
  `start_event_date` datetime(6) DEFAULT NULL,
  `end_event_date` datetime(6) DEFAULT NULL,
  `record_count` int(9) unsigned DEFAULT 0,
  PRIMARY KEY (`wday`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_archive_details`
--

/*!40000 ALTER TABLE `vicidial_sip_event_archive_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_archive_details` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log` (
  `sip_event_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_0`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_0` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_0`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_0` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_0` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_1`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_1` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_1`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_1` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_1` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_2`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_2` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_2`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_2` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_2` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_3`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_3` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_3`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_3` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_3` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_4`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_4` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_4`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_4` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_4` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_5`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_5` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_5`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_5` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_5` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_log_6`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_log_6` (
  `sip_event_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(30) NOT NULL,
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `sip_call_id` varchar(256) DEFAULT NULL,
  `event_date` datetime(6) DEFAULT NULL,
  `sip_event` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`sip_event_id`),
  KEY `caller_code` (`caller_code`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_log_6`
--

/*!40000 ALTER TABLE `vicidial_sip_event_log_6` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_log_6` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sip_event_recent`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sip_event_recent` (
  `caller_code` varchar(20) DEFAULT '',
  `channel` varchar(100) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `uniqueid` varchar(20) DEFAULT NULL,
  `invite_date` datetime(6) DEFAULT NULL,
  `first_100_date` datetime(6) DEFAULT NULL,
  `first_180_date` datetime(6) DEFAULT NULL,
  `first_183_date` datetime(6) DEFAULT NULL,
  `last_100_date` datetime(6) DEFAULT NULL,
  `last_180_date` datetime(6) DEFAULT NULL,
  `last_183_date` datetime(6) DEFAULT NULL,
  `200_date` datetime(6) DEFAULT NULL,
  `error_date` datetime(6) DEFAULT NULL,
  `processed` enum('N','Y','U') DEFAULT 'N',
  KEY `caller_code` (`caller_code`),
  KEY `invite_date` (`invite_date`),
  KEY `processed` (`processed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sip_event_recent`
--

/*!40000 ALTER TABLE `vicidial_sip_event_recent` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sip_event_recent` ENABLE KEYS */;

--
-- Table structure for table `vicidial_state_call_times`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_state_call_times` (
  `state_call_time_id` varchar(10) NOT NULL,
  `state_call_time_state` varchar(2) NOT NULL,
  `state_call_time_name` varchar(30) NOT NULL,
  `state_call_time_comments` varchar(255) DEFAULT '',
  `sct_default_start` smallint(4) unsigned NOT NULL DEFAULT 900,
  `sct_default_stop` smallint(4) unsigned NOT NULL DEFAULT 2100,
  `sct_sunday_start` smallint(4) unsigned DEFAULT 0,
  `sct_sunday_stop` smallint(4) unsigned DEFAULT 0,
  `sct_monday_start` smallint(4) unsigned DEFAULT 0,
  `sct_monday_stop` smallint(4) unsigned DEFAULT 0,
  `sct_tuesday_start` smallint(4) unsigned DEFAULT 0,
  `sct_tuesday_stop` smallint(4) unsigned DEFAULT 0,
  `sct_wednesday_start` smallint(4) unsigned DEFAULT 0,
  `sct_wednesday_stop` smallint(4) unsigned DEFAULT 0,
  `sct_thursday_start` smallint(4) unsigned DEFAULT 0,
  `sct_thursday_stop` smallint(4) unsigned DEFAULT 0,
  `sct_friday_start` smallint(4) unsigned DEFAULT 0,
  `sct_friday_stop` smallint(4) unsigned DEFAULT 0,
  `sct_saturday_start` smallint(4) unsigned DEFAULT 0,
  `sct_saturday_stop` smallint(4) unsigned DEFAULT 0,
  `user_group` varchar(20) DEFAULT '---ALL---',
  `ct_holidays` text DEFAULT NULL,
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`state_call_time_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_state_call_times`
--

/*!40000 ALTER TABLE `vicidial_state_call_times` DISABLE KEYS */;
INSERT INTO `vicidial_state_call_times` 
(state_call_time_id, state_call_time_state, state_call_time_name, state_call_time_comments, sct_default_start, sct_default_stop, sct_sunday_start, sct_sunday_stop, sct_monday_start, sct_monday_stop, sct_tuesday_start, sct_tuesday_stop, sct_wednesday_start, sct_wednesday_stop, sct_thursday_start, sct_thursday_stop, sct_friday_start, sct_friday_stop, sct_saturday_start, sct_saturday_stop, user_group, ct_holidays, modify_stamp)
SELECT state_call_time_id, state_call_time_state, state_call_time_name, state_call_time_comments, sct_default_start, sct_default_stop, sct_sunday_start, sct_sunday_stop, sct_monday_start, sct_monday_stop, sct_tuesday_start, sct_tuesday_stop, sct_wednesday_start, sct_wednesday_stop, sct_thursday_start, sct_thursday_stop, sct_friday_start, sct_friday_stop, sct_saturday_start, sct_saturday_stop, user_group, ct_holidays, modify_stamp FROM (
  SELECT 'alabama' AS state_call_time_id, 'AL' AS state_call_time_state, 'Alabama 8am-8pm and Sunday' AS state_call_time_name, '' AS state_call_time_comments,
         800 AS sct_default_start, 2000 AS sct_default_stop, 2400 AS sct_sunday_start, 2400 AS sct_sunday_stop, 0 AS sct_monday_start, 0 AS sct_monday_stop,
         0 AS sct_tuesday_start, 0 AS sct_tuesday_stop, 0 AS sct_wednesday_start, 0 AS sct_wednesday_stop, 0 AS sct_thursday_start, 0 AS sct_thursday_stop,
         0 AS sct_friday_start, 0 AS sct_friday_stop, 0 AS sct_saturday_start, 0 AS sct_saturday_stop, '---ALL---' AS user_group, NULL AS ct_holidays, '2025-06-23 16:43:09' AS modify_stamp
  UNION ALL
  SELECT 'florida','FL','Florida 8am 8pm','',800,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'illinois','IL','Illinois 8am','',800,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'indiana','IN','Indiana 8pm restriction','',900,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'kentucky','KY','Kentucky 10am restriction','',1000,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'louisiana','LA','Louisiana 8am-8pm and Sunday','',800,2000,2400,2400,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'maine','ME','Maine 9am-5pm','',900,1700,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'maryland','MD','Maryland 8am 8pm','',800,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'massachuse','MA','Massachusetts 8am-8pm','',800,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'mississipp','MS','Mississippi 8am-8pm and Sunday','',800,2000,2400,2400,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'nebraska','NE','Nebraska 8am','',800,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'nevada','NV','Nevada 8pm restriction','',900,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'oklahoma','OK','Oklahoma 8am 8pm','',800,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'pennsylvan','PA','Pennsylvania sunday restrictn','',900,2100,1330,2100,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'rhodeislan','RI','Rhode Island restrictions','',900,1800,2400,2400,0,0,0,0,0,0,0,0,0,0,1000,1700,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'sdakota','SD','South Dakota sunday restrict','',900,2100,2400,2400,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'tennessee','TN','Tennessee 8am','',800,2100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'texas','TX','Texas sunday restriction','',900,2100,1200,2100,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'utah','UT','Utah 8pm restriction','',900,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'washington','WA','Washington 8am-8pm','',800,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
  UNION ALL
  SELECT 'wyoming','WY','Wyoming 8am-8pm','',800,2000,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'---ALL---',NULL,'2025-06-23 16:43:09'
) AS data
WHERE NOT EXISTS (SELECT 1 FROM vicidial_state_call_times);

/*!40000 ALTER TABLE `vicidial_state_call_times` ENABLE KEYS */;

--
-- Table structure for table `vicidial_stations`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_stations` (
  `agent_station` varchar(10) NOT NULL,
  `phone_channel` varchar(100) DEFAULT NULL,
  `computer_ip` varchar(15) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `DB_server_ip` varchar(15) NOT NULL,
  `DB_user` varchar(15) DEFAULT NULL,
  `DB_pass` varchar(15) DEFAULT NULL,
  `DB_port` varchar(6) DEFAULT NULL,
  PRIMARY KEY (`agent_station`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_stations`
--

/*!40000 ALTER TABLE `vicidial_stations` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_stations` ENABLE KEYS */;

--
-- Table structure for table `vicidial_status_categories`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_status_categories` (
  `vsc_id` varchar(20) NOT NULL,
  `vsc_name` varchar(50) DEFAULT NULL,
  `vsc_description` varchar(255) DEFAULT NULL,
  `tovdad_display` enum('Y','N') DEFAULT 'N',
  `sale_category` enum('Y','N') DEFAULT 'N',
  `dead_lead_category` enum('Y','N') DEFAULT 'N',
  PRIMARY KEY (`vsc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_status_categories`
--

/*!40000 ALTER TABLE `vicidial_status_categories` DISABLE KEYS */;
INSERT INTO `vicidial_status_categories` select 'UNDEFINED','Default Category',NULL,'N','N','N' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_status_categories);
/*!40000 ALTER TABLE `vicidial_status_categories` ENABLE KEYS */;

--
-- Table structure for table `vicidial_status_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_status_groups` (
  `status_group_id` varchar(20) NOT NULL,
  `status_group_notes` varchar(255) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`status_group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_status_groups`
--

/*!40000 ALTER TABLE `vicidial_status_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_status_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_statuses`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_statuses` (
  `status` varchar(6) NOT NULL,
  `status_name` varchar(30) DEFAULT NULL,
  `selectable` enum('Y','N') DEFAULT 'N',
  `human_answered` enum('Y','N') DEFAULT 'N',
  `category` varchar(20) DEFAULT 'UNDEFINED',
  `sale` enum('Y','N') DEFAULT 'N',
  `dnc` enum('Y','N') DEFAULT 'N',
  `customer_contact` enum('Y','N') DEFAULT 'N',
  `not_interested` enum('Y','N') DEFAULT 'N',
  `unworkable` enum('Y','N') DEFAULT 'N',
  `scheduled_callback` enum('Y','N') DEFAULT 'N',
  `completed` enum('Y','N') DEFAULT 'N',
  `min_sec` int(5) unsigned DEFAULT 0,
  `max_sec` int(5) unsigned DEFAULT 0,
  `answering_machine` enum('Y','N') DEFAULT 'N',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`status`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_statuses`
--

/*!40000 ALTER TABLE `vicidial_statuses` DISABLE KEYS */;

/*!40000 ALTER TABLE `vicidial_statuses` ENABLE KEYS */;

--
-- Table structure for table `vicidial_sync_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_sync_log` (
  `user` varchar(20) DEFAULT '',
  `start_time` datetime NOT NULL,
  `db_time` datetime NOT NULL,
  `run_time` varchar(20) DEFAULT '0',
  `php_script` varchar(40) NOT NULL,
  `action` varchar(100) DEFAULT '',
  `lead_id` int(10) unsigned DEFAULT 0,
  `stage` varchar(200) DEFAULT '',
  `session_name` varchar(40) DEFAULT '',
  `last_sql` text DEFAULT NULL,
  KEY `ajax_dbtime_key` (`db_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_sync_log`
--

/*!40000 ALTER TABLE `vicidial_sync_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_sync_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_territories`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_territories` (
  `territory_id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `territory` varchar(100) DEFAULT '',
  `territory_description` varchar(255) DEFAULT '',
  PRIMARY KEY (`territory_id`),
  UNIQUE KEY `uniqueterritory` (`territory`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_territories`
--

/*!40000 ALTER TABLE `vicidial_territories` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_territories` ENABLE KEYS */;

--
-- Table structure for table `vicidial_tiltx_shaken_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_tiltx_shaken_log` (
  `db_time` datetime NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `url_log_id` int(9) unsigned NOT NULL,
  `caller_code` varchar(20) DEFAULT NULL,
  `phone_number` varchar(19) DEFAULT '',
  `CIDnumber` varchar(19) DEFAULT '',
  `CallerIDToUse` varchar(19) DEFAULT '',
  `IsDNC` tinyint(1) DEFAULT 0,
  `IsDisconnected` tinyint(1) DEFAULT 0,
  `TILTXID` varchar(50) DEFAULT NULL,
  `Identity` text DEFAULT NULL,
  `CAID` varchar(50) DEFAULT NULL,
  KEY `db_time` (`db_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_tiltx_shaken_log`
--

/*!40000 ALTER TABLE `vicidial_tiltx_shaken_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_tiltx_shaken_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_timeclock_audit_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_timeclock_audit_log` (
  `timeclock_id` int(9) unsigned NOT NULL,
  `event_epoch` int(10) unsigned NOT NULL,
  `event_date` datetime NOT NULL,
  `login_sec` int(10) unsigned DEFAULT NULL,
  `event` varchar(50) NOT NULL,
  `user` varchar(20) NOT NULL,
  `user_group` varchar(20) NOT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  `shift_id` varchar(20) DEFAULT NULL,
  `event_datestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tcid_link` int(9) unsigned DEFAULT NULL,
  KEY `timeclock_id` (`timeclock_id`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_timeclock_audit_log`
--

/*!40000 ALTER TABLE `vicidial_timeclock_audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_timeclock_audit_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_timeclock_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_timeclock_log` (
  `timeclock_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `event_epoch` int(10) unsigned NOT NULL,
  `event_date` datetime NOT NULL,
  `login_sec` int(10) unsigned DEFAULT NULL,
  `event` varchar(50) NOT NULL,
  `user` varchar(20) NOT NULL,
  `user_group` varchar(20) NOT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  `shift_id` varchar(20) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `manager_user` varchar(20) DEFAULT NULL,
  `manager_ip` varchar(15) DEFAULT NULL,
  `event_datestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `tcid_link` int(9) unsigned DEFAULT NULL,
  PRIMARY KEY (`timeclock_id`),
  KEY `user` (`user`),
  KEY `event_epoch` (`event_epoch`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_timeclock_log`
--

/*!40000 ALTER TABLE `vicidial_timeclock_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_timeclock_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_timeclock_status`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_timeclock_status` (
  `user` varchar(20) NOT NULL,
  `user_group` varchar(20) NOT NULL,
  `event_epoch` int(10) unsigned DEFAULT NULL,
  `event_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(50) DEFAULT NULL,
  `ip_address` varchar(15) DEFAULT NULL,
  `shift_id` varchar(20) DEFAULT NULL,
  UNIQUE KEY `user` (`user`),
  KEY `user_2` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_timeclock_status`
--

/*!40000 ALTER TABLE `vicidial_timeclock_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_timeclock_status` ENABLE KEYS */;

--
-- Table structure for table `vicidial_timeoff_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_timeoff_log` (
  `vtl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `timeoff_month` char(7) DEFAULT NULL,
  `timeoff_type` varchar(10) DEFAULT NULL,
  `hours` decimal(5,2) unsigned DEFAULT NULL,
  `entry_date` datetime DEFAULT NULL,
  `modify_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `entered_by` varchar(20) DEFAULT NULL,
  `last_modified_by` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`vtl_id`),
  UNIQUE KEY `vicidial_timeoff_log_agent_month_key` (`user`,`timeoff_month`,`timeoff_type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_timeoff_log`
--

/*!40000 ALTER TABLE `vicidial_timeoff_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_timeoff_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_tts_prompts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_tts_prompts` (
  `tts_id` varchar(50) NOT NULL,
  `tts_name` varchar(100) DEFAULT NULL,
  `active` enum('Y','N') DEFAULT NULL,
  `tts_text` text DEFAULT NULL,
  `tts_voice` varchar(100) DEFAULT 'Allison-8kHz',
  `user_group` varchar(20) DEFAULT '---ALL---',
  PRIMARY KEY (`tts_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_tts_prompts`
--

/*!40000 ALTER TABLE `vicidial_tts_prompts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_tts_prompts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_two_factor_auth`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_two_factor_auth` (
  `auth_date` datetime DEFAULT NULL,
  `auth_exp_date` datetime DEFAULT NULL,
  `user` varchar(20) DEFAULT '',
  `auth_stage` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `auth_code` varchar(20) DEFAULT '',
  `auth_code_exp_date` datetime DEFAULT NULL,
  `auth_method` varchar(20) DEFAULT 'EMAIL',
  `auth_attempts` smallint(5) DEFAULT 0,
  KEY `user` (`user`),
  KEY `auth_date` (`auth_date`),
  KEY `auth_exp_date` (`auth_exp_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_two_factor_auth`
--

/*!40000 ALTER TABLE `vicidial_two_factor_auth` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_two_factor_auth` ENABLE KEYS */;

--
-- Table structure for table `vicidial_url_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_url_log` (
  `url_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `uniqueid` varchar(50) NOT NULL,
  `url_date` datetime DEFAULT NULL,
  `url_type` varchar(10) DEFAULT '',
  `response_sec` smallint(5) unsigned DEFAULT 0,
  `url` text DEFAULT NULL,
  `url_response` text DEFAULT NULL,
  PRIMARY KEY (`url_log_id`),
  KEY `uniqueid` (`uniqueid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_url_log`
--

/*!40000 ALTER TABLE `vicidial_url_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_url_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_url_multi`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_url_multi` (
  `url_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` varchar(20) NOT NULL,
  `entry_type` enum('campaign','ingroup','list','system','') DEFAULT '',
  `active` enum('Y','N') DEFAULT 'N',
  `url_type` enum('dispo','start','addlead','noagent','apinewlead','') DEFAULT '',
  `url_rank` smallint(5) DEFAULT 1,
  `url_statuses` varchar(1000) DEFAULT '',
  `url_description` varchar(255) DEFAULT '',
  `url_address` text DEFAULT NULL,
  `url_lists` varchar(1000) DEFAULT '',
  `url_call_length` smallint(5) DEFAULT 0,
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`url_id`),
  KEY `vicidial_url_multi_campaign_id_key` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_url_multi`
--

/*!40000 ALTER TABLE `vicidial_url_multi` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_url_multi` ENABLE KEYS */;

--
-- Table structure for table `vicidial_urls`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_urls` (
  `url_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(250) DEFAULT '',
  PRIMARY KEY (`url_id`),
  UNIQUE KEY `url` (`url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_urls`
--

/*!40000 ALTER TABLE `vicidial_urls` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_urls` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_closer_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_closer_log` (
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `blended` enum('1','0') DEFAULT '0',
  `closer_campaigns` text DEFAULT NULL,
  `manager_change` varchar(20) DEFAULT '',
  KEY `user` (`user`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_closer_log`
--

/*!40000 ALTER TABLE `vicidial_user_closer_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_closer_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_dial_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_dial_log` (
  `caller_code` varchar(30) NOT NULL,
  `user` varchar(20) DEFAULT '',
  `call_date` datetime DEFAULT NULL,
  `call_type` varchar(10) DEFAULT '',
  `notes` varchar(100) DEFAULT '',
  KEY `caller_code` (`caller_code`),
  KEY `user` (`user`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_dial_log`
--

/*!40000 ALTER TABLE `vicidial_user_dial_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_dial_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_dial_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_dial_log_archive` (
  `caller_code` varchar(30) NOT NULL,
  `user` varchar(20) DEFAULT '',
  `call_date` datetime DEFAULT NULL,
  `call_type` varchar(10) DEFAULT '',
  `notes` varchar(100) DEFAULT '',
  UNIQUE KEY `vdudl` (`caller_code`,`call_date`,`user`),
  KEY `caller_code` (`caller_code`),
  KEY `user` (`user`),
  KEY `call_date` (`call_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_dial_log_archive`
--

/*!40000 ALTER TABLE `vicidial_user_dial_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_dial_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_groups`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_groups` (
  `user_group` varchar(20) NOT NULL,
  `group_name` varchar(40) NOT NULL,
  `allowed_campaigns` text DEFAULT NULL,
  `qc_allowed_campaigns` text DEFAULT NULL,
  `qc_allowed_inbound_groups` text DEFAULT NULL,
  `group_shifts` text DEFAULT NULL,
  `forced_timeclock_login` enum('Y','N','ADMIN_EXEMPT') DEFAULT 'N',
  `shift_enforcement` enum('OFF','START','ALL','ADMIN_EXEMPT') DEFAULT 'OFF',
  `agent_status_viewable_groups` text DEFAULT NULL,
  `agent_status_view_time` enum('Y','N') DEFAULT 'N',
  `agent_call_log_view` enum('Y','N') DEFAULT 'N',
  `agent_xfer_consultative` enum('Y','N') DEFAULT 'Y',
  `agent_xfer_dial_override` enum('Y','N') DEFAULT 'Y',
  `agent_xfer_vm_transfer` enum('Y','N') DEFAULT 'Y',
  `agent_xfer_blind_transfer` enum('Y','N') DEFAULT 'Y',
  `agent_xfer_dial_with_customer` enum('Y','N') DEFAULT 'Y',
  `agent_xfer_park_customer_dial` enum('Y','N') DEFAULT 'Y',
  `agent_fullscreen` enum('Y','N') DEFAULT 'N',
  `allowed_reports` varchar(4000) DEFAULT 'ALL REPORTS',
  `webphone_url_override` varchar(255) DEFAULT '',
  `webphone_systemkey_override` varchar(100) DEFAULT '',
  `webphone_dialpad_override` enum('DISABLED','Y','N','TOGGLE','TOGGLE_OFF') DEFAULT 'DISABLED',
  `admin_viewable_groups` text DEFAULT NULL,
  `admin_viewable_call_times` text DEFAULT NULL,
  `allowed_custom_reports` varchar(2000) DEFAULT '',
  `agent_allowed_chat_groups` text DEFAULT NULL,
  `agent_xfer_park_3way` enum('Y','N') DEFAULT 'Y',
  `admin_ip_list` varchar(30) DEFAULT '',
  `agent_ip_list` varchar(30) DEFAULT '',
  `api_ip_list` varchar(30) DEFAULT '',
  `webphone_layout` varchar(255) DEFAULT '',
  `allowed_queue_groups` text DEFAULT NULL,
  `reports_header_override` enum('DISABLED','LOGO_ONLY_SMALL','LOGO_ONLY_LARGE','ALT_1','ALT_2','ALT_3','ALT_4') DEFAULT 'DISABLED',
  `admin_home_url` varchar(255) DEFAULT '',
  `script_id` varchar(20) DEFAULT '',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_groups`
--

/*!40000 ALTER TABLE `vicidial_user_groups` DISABLE KEYS */;
INSERT INTO `vicidial_user_groups` select 'ADMIN','VICIDIAL ADMINISTRATORS',' -ALL-CAMPAIGNS- - -',NULL,NULL,NULL,'N','OFF',' --ALL-GROUPS-- ','N','N','Y','Y','Y','Y','Y','Y','N','ALL REPORTS','','','DISABLED',' ---ALL--- ',' ---ALL--- ','',' --ALL-GROUPS-- ','Y','','','','',NULL,'DISABLED','','','2025-06-23 16:43:09' as data WHERE NOT EXISTS (SELECT 1 FROM vicidial_user_groups);
/*!40000 ALTER TABLE `vicidial_user_groups` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_list_new_lead`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_list_new_lead` (
  `user` varchar(20) NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT 999,
  `user_override` smallint(5) DEFAULT -1,
  `new_count` mediumint(8) unsigned DEFAULT 0,
  UNIQUE KEY `userlistnew` (`user`,`list_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_list_new_lead`
--

/*!40000 ALTER TABLE `vicidial_user_list_new_lead` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_list_new_lead` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_log` (
  `user_log_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) DEFAULT NULL,
  `event` varchar(50) DEFAULT NULL,
  `campaign_id` varchar(8) DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `event_epoch` int(10) unsigned DEFAULT NULL,
  `user_group` varchar(20) DEFAULT NULL,
  `session_id` varchar(20) DEFAULT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `extension` varchar(50) DEFAULT NULL,
  `computer_ip` varchar(15) DEFAULT NULL,
  `browser` varchar(255) DEFAULT NULL,
  `data` varchar(255) DEFAULT NULL,
  `phone_login` varchar(15) DEFAULT '',
  `server_phone` varchar(15) DEFAULT '',
  `phone_ip` varchar(15) DEFAULT '',
  `webserver` smallint(5) unsigned DEFAULT 0,
  `login_url` int(9) unsigned DEFAULT 0,
  `browser_width` smallint(5) unsigned DEFAULT 0,
  `browser_height` smallint(5) unsigned DEFAULT 0,
  PRIMARY KEY (`user_log_id`),
  KEY `user` (`user`),
  KEY `event_date` (`event_date`),
  KEY `phone_ip` (`phone_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_log`
--

/*!40000 ALTER TABLE `vicidial_user_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_logins_daily`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_logins_daily` (
  `user` varchar(20) DEFAULT NULL,
  `login_day` date DEFAULT NULL,
  `last_login_date` datetime DEFAULT '2001-01-01 00:00:01',
  `last_ip` varchar(50) DEFAULT '',
  `failed_login_attempts_today` mediumint(8) unsigned DEFAULT 0,
  `failed_login_count_today` smallint(6) unsigned DEFAULT 0,
  `failed_last_ip_today` varchar(50) DEFAULT '',
  `failed_last_type_today` varchar(20) DEFAULT '',
  UNIQUE KEY `vicidial_user_logins_daily_user` (`login_day`,`user`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_logins_daily`
--

/*!40000 ALTER TABLE `vicidial_user_logins_daily` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_logins_daily` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_territories`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_territories` (
  `user` varchar(20) NOT NULL,
  `territory` varchar(100) DEFAULT '',
  `level` enum('TOP_AGENT','STANDARD_AGENT','BOTTOM_AGENT') DEFAULT 'STANDARD_AGENT',
  UNIQUE KEY `userterritory` (`user`,`territory`),
  KEY `user` (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_territories`
--

/*!40000 ALTER TABLE `vicidial_user_territories` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_territories` ENABLE KEYS */;

--
-- Table structure for table `vicidial_user_territory_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_user_territory_log` (
  `user` varchar(20) DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `event_date` datetime DEFAULT NULL,
  `agent_territories` text DEFAULT NULL,
  KEY `user` (`user`),
  KEY `event_date` (`event_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_user_territory_log`
--

/*!40000 ALTER TABLE `vicidial_user_territory_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_user_territory_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_users`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_users` (
  `user_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(20) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `full_name` varchar(50) DEFAULT NULL,
  `user_level` tinyint(3) unsigned DEFAULT 1,
  `user_group` varchar(20) DEFAULT NULL,
  `phone_login` varchar(20) DEFAULT NULL,
  `phone_pass` varchar(100) DEFAULT NULL,
  `delete_users` enum('0','1') DEFAULT '0',
  `delete_user_groups` enum('0','1') DEFAULT '0',
  `delete_lists` enum('0','1') DEFAULT '0',
  `delete_campaigns` enum('0','1') DEFAULT '0',
  `delete_ingroups` enum('0','1') DEFAULT '0',
  `delete_remote_agents` enum('0','1') DEFAULT '0',
  `load_leads` enum('0','1') DEFAULT '0',
  `campaign_detail` enum('0','1') DEFAULT '0',
  `ast_admin_access` enum('0','1') DEFAULT '0',
  `ast_delete_phones` enum('0','1') DEFAULT '0',
  `delete_scripts` enum('0','1') DEFAULT '0',
  `modify_leads` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `hotkeys_active` enum('0','1') DEFAULT '0',
  `change_agent_campaign` enum('0','1') DEFAULT '0',
  `agent_choose_ingroups` enum('0','1') DEFAULT '1',
  `closer_campaigns` text DEFAULT NULL,
  `scheduled_callbacks` enum('0','1') DEFAULT '1',
  `agentonly_callbacks` enum('0','1') DEFAULT '0',
  `agentcall_manual` enum('0','1','2','3','4','5') DEFAULT '0',
  `vicidial_recording` enum('0','1') DEFAULT '1',
  `vicidial_transfers` enum('0','1') DEFAULT '1',
  `delete_filters` enum('0','1') DEFAULT '0',
  `alter_agent_interface_options` enum('0','1') DEFAULT '0',
  `closer_default_blended` enum('0','1') DEFAULT '0',
  `delete_call_times` enum('0','1') DEFAULT '0',
  `modify_call_times` enum('0','1') DEFAULT '0',
  `modify_users` enum('0','1') DEFAULT '0',
  `modify_campaigns` enum('0','1') DEFAULT '0',
  `modify_lists` enum('0','1') DEFAULT '0',
  `modify_scripts` enum('0','1') DEFAULT '0',
  `modify_filters` enum('0','1') DEFAULT '0',
  `modify_ingroups` enum('0','1') DEFAULT '0',
  `modify_usergroups` enum('0','1') DEFAULT '0',
  `modify_remoteagents` enum('0','1') DEFAULT '0',
  `modify_servers` enum('0','1') DEFAULT '0',
  `view_reports` enum('0','1') DEFAULT '0',
  `vicidial_recording_override` enum('DISABLED','NEVER','ONDEMAND','ALLCALLS','ALLFORCE') DEFAULT 'DISABLED',
  `alter_custdata_override` enum('NOT_ACTIVE','ALLOW_ALTER') DEFAULT 'NOT_ACTIVE',
  `qc_enabled` enum('0','1') DEFAULT '0',
  `qc_user_level` int(2) DEFAULT 1,
  `qc_pass` enum('0','1') DEFAULT '0',
  `qc_finish` enum('0','1') DEFAULT '0',
  `qc_commit` enum('0','1') DEFAULT '0',
  `add_timeclock_log` enum('0','1') DEFAULT '0',
  `modify_timeclock_log` enum('0','1') DEFAULT '0',
  `delete_timeclock_log` enum('0','1') DEFAULT '0',
  `alter_custphone_override` enum('NOT_ACTIVE','ALLOW_ALTER') DEFAULT 'NOT_ACTIVE',
  `vdc_agent_api_access` enum('0','1') DEFAULT '0',
  `modify_inbound_dids` enum('0','1') DEFAULT '0',
  `delete_inbound_dids` enum('0','1') DEFAULT '0',
  `active` enum('Y','N') DEFAULT 'Y',
  `alert_enabled` enum('0','1') DEFAULT '0',
  `download_lists` enum('0','1') DEFAULT '0',
  `agent_shift_enforcement_override` enum('DISABLED','OFF','START','ALL') DEFAULT 'DISABLED',
  `manager_shift_enforcement_override` enum('0','1') DEFAULT '0',
  `shift_override_flag` enum('0','1') DEFAULT '0',
  `export_reports` enum('0','1') DEFAULT '0',
  `delete_from_dnc` enum('0','1') DEFAULT '0',
  `email` varchar(100) DEFAULT '',
  `user_code` varchar(100) DEFAULT '',
  `territory` varchar(100) DEFAULT '',
  `allow_alerts` enum('0','1') DEFAULT '0',
  `agent_choose_territories` enum('0','1') DEFAULT '1',
  `custom_one` varchar(100) DEFAULT '',
  `custom_two` varchar(100) DEFAULT '',
  `custom_three` varchar(100) DEFAULT '',
  `custom_four` varchar(100) DEFAULT '',
  `custom_five` varchar(100) DEFAULT '',
  `voicemail_id` varchar(10) DEFAULT NULL,
  `agent_call_log_view_override` enum('DISABLED','Y','N') DEFAULT 'DISABLED',
  `callcard_admin` enum('1','0') DEFAULT '0',
  `agent_choose_blended` enum('0','1') DEFAULT '1',
  `realtime_block_user_info` enum('0','1') DEFAULT '0',
  `custom_fields_modify` enum('0','1') DEFAULT '0',
  `force_change_password` enum('Y','N') DEFAULT 'N',
  `agent_lead_search_override` enum('NOT_ACTIVE','ENABLED','LIVE_CALL_INBOUND','LIVE_CALL_INBOUND_AND_MANUAL','DISABLED') DEFAULT 'NOT_ACTIVE',
  `modify_shifts` enum('1','0') DEFAULT '0',
  `modify_phones` enum('1','0') DEFAULT '0',
  `modify_carriers` enum('1','0') DEFAULT '0',
  `modify_labels` enum('1','0') DEFAULT '0',
  `modify_statuses` enum('1','0') DEFAULT '0',
  `modify_voicemail` enum('1','0') DEFAULT '0',
  `modify_audiostore` enum('1','0') DEFAULT '0',
  `modify_moh` enum('1','0') DEFAULT '0',
  `modify_tts` enum('1','0') DEFAULT '0',
  `preset_contact_search` enum('NOT_ACTIVE','ENABLED','DISABLED') DEFAULT 'NOT_ACTIVE',
  `modify_contacts` enum('1','0') DEFAULT '0',
  `modify_same_user_level` enum('0','1') DEFAULT '1',
  `admin_hide_lead_data` enum('0','1') DEFAULT '0',
  `admin_hide_phone_data` enum('0','1','2_DIGITS','3_DIGITS','4_DIGITS') DEFAULT '0',
  `agentcall_email` enum('0','1') DEFAULT '0',
  `modify_email_accounts` enum('0','1') DEFAULT '0',
  `failed_login_count` tinyint(3) unsigned DEFAULT 0,
  `last_login_date` datetime DEFAULT '2001-01-01 00:00:01',
  `last_ip` varchar(15) DEFAULT '',
  `pass_hash` varchar(500) DEFAULT '',
  `alter_admin_interface_options` enum('0','1') DEFAULT '1',
  `max_inbound_calls` smallint(5) unsigned DEFAULT 0,
  `modify_custom_dialplans` enum('1','0') DEFAULT '0',
  `wrapup_seconds_override` smallint(4) DEFAULT -1,
  `modify_languages` enum('1','0') DEFAULT '0',
  `selected_language` varchar(100) DEFAULT 'default English',
  `user_choose_language` enum('1','0') DEFAULT '0',
  `ignore_group_on_search` enum('1','0') DEFAULT '0',
  `api_list_restrict` enum('1','0') DEFAULT '0',
  `api_allowed_functions` varchar(1000) DEFAULT ' ALL_FUNCTIONS ',
  `lead_filter_id` varchar(20) DEFAULT 'NONE',
  `admin_cf_show_hidden` enum('1','0') DEFAULT '0',
  `agentcall_chat` enum('1','0') DEFAULT '0',
  `user_hide_realtime` enum('1','0') DEFAULT '0',
  `access_recordings` enum('0','1') DEFAULT '0',
  `modify_colors` enum('1','0') DEFAULT '0',
  `user_nickname` varchar(50) DEFAULT '',
  `user_new_lead_limit` smallint(5) DEFAULT -1,
  `api_only_user` enum('0','1') DEFAULT '0',
  `modify_auto_reports` enum('1','0') DEFAULT '0',
  `modify_ip_lists` enum('1','0') DEFAULT '0',
  `ignore_ip_list` enum('1','0') DEFAULT '0',
  `ready_max_logout` mediumint(7) DEFAULT -1,
  `export_gdpr_leads` enum('0','1','2') DEFAULT '0',
  `pause_code_approval` enum('1','0') DEFAULT '0',
  `max_hopper_calls` smallint(5) unsigned DEFAULT 0,
  `max_hopper_calls_hour` smallint(5) unsigned DEFAULT 0,
  `mute_recordings` enum('DISABLED','Y','N') DEFAULT 'DISABLED',
  `hide_call_log_info` enum('DISABLED','Y','N','SHOW_1','SHOW_2','SHOW_3','SHOW_4','SHOW_5','SHOW_6','SHOW_7','SHOW_8','SHOW_9','SHOW_10') DEFAULT 'DISABLED',
  `next_dial_my_callbacks` enum('NOT_ACTIVE','DISABLED','ENABLED') DEFAULT 'NOT_ACTIVE',
  `user_admin_redirect_url` text DEFAULT NULL,
  `max_inbound_filter_enabled` enum('0','1') DEFAULT '0',
  `max_inbound_filter_statuses` text DEFAULT NULL,
  `max_inbound_filter_ingroups` text DEFAULT NULL,
  `max_inbound_filter_min_sec` smallint(5) DEFAULT -1,
  `status_group_id` varchar(20) DEFAULT '',
  `mobile_number` varchar(20) DEFAULT '',
  `two_factor_override` enum('NOT_ACTIVE','ENABLED','DISABLED') DEFAULT 'NOT_ACTIVE',
  `manual_dial_filter` varchar(50) DEFAULT 'DISABLED',
  `user_location` varchar(100) DEFAULT '',
  `download_invalid_files` enum('0','1') DEFAULT '0',
  `user_group_two` varchar(20) DEFAULT '',
  `failed_login_attempts_today` mediumint(8) unsigned DEFAULT 0,
  `failed_login_count_today` smallint(6) unsigned DEFAULT 0,
  `failed_last_ip_today` varchar(50) DEFAULT '',
  `failed_last_type_today` varchar(20) DEFAULT '',
  `modify_dial_prefix` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `inbound_credits` mediumint(7) DEFAULT -1,
  `hci_enabled` enum('0','1','2','3','4','5','6') DEFAULT '0',
  `modify_stamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_users`
--

/*!40000 ALTER TABLE `vicidial_users` DISABLE KEYS */;
INSERT IGNORE INTO `vicidial_users` 
(user, pass, full_name, user_level, user_group, phone_login, phone_pass, delete_users, delete_user_groups, delete_lists, delete_campaigns, delete_ingroups, delete_remote_agents, load_leads, campaign_detail, ast_admin_access, ast_delete_phones, delete_scripts, modify_leads, hotkeys_active, change_agent_campaign, agent_choose_ingroups, closer_campaigns, scheduled_callbacks, agentonly_callbacks, agentcall_manual, vicidial_recording, vicidial_transfers, delete_filters, alter_agent_interface_options, closer_default_blended, delete_call_times, modify_call_times, modify_users, modify_campaigns, modify_lists, modify_scripts, modify_filters, modify_ingroups, modify_usergroups, modify_remoteagents, modify_servers, view_reports, vicidial_recording_override, alter_custdata_override, qc_enabled, qc_user_level, qc_pass, qc_finish, qc_commit, add_timeclock_log, modify_timeclock_log, delete_timeclock_log, alter_custphone_override, vdc_agent_api_access, modify_inbound_dids, delete_inbound_dids, active, alert_enabled, download_lists, agent_shift_enforcement_override, manager_shift_enforcement_override, shift_override_flag, export_reports, delete_from_dnc, email, user_code, territory, allow_alerts, agent_choose_territories, custom_one, custom_two, custom_three, custom_four, custom_five, voicemail_id, agent_call_log_view_override, callcard_admin, agent_choose_blended, realtime_block_user_info, custom_fields_modify, force_change_password, agent_lead_search_override, modify_shifts, modify_phones, modify_carriers, modify_labels, modify_statuses, modify_voicemail, modify_audiostore, modify_moh, modify_tts, preset_contact_search, modify_contacts, modify_same_user_level, admin_hide_lead_data, admin_hide_phone_data, agentcall_email, modify_email_accounts, failed_login_count, last_login_date, last_ip, pass_hash, alter_admin_interface_options, max_inbound_calls, modify_custom_dialplans, wrapup_seconds_override, modify_languages, selected_language, user_choose_language, ignore_group_on_search, api_list_restrict, api_allowed_functions, lead_filter_id, admin_cf_show_hidden, agentcall_chat, user_hide_realtime, access_recordings, modify_colors, user_nickname, user_new_lead_limit, api_only_user, modify_auto_reports, modify_ip_lists, ignore_ip_list, ready_max_logout, export_gdpr_leads, pause_code_approval, max_hopper_calls, max_hopper_calls_hour, mute_recordings, hide_call_log_info, next_dial_my_callbacks, user_admin_redirect_url, max_inbound_filter_enabled, max_inbound_filter_statuses, max_inbound_filter_ingroups, max_inbound_filter_min_sec, status_group_id, mobile_number, two_factor_override, manual_dial_filter, user_location, download_invalid_files, user_group_two, failed_login_attempts_today, failed_login_count_today, failed_last_ip_today, failed_last_type_today, modify_dial_prefix, inbound_credits, hci_enabled, modify_stamp)
VALUES 
('6666','1234','Admin',9,'ADMIN',NULL,NULL,'0','0','0','0','0','0','1','1','1','0','0','0','0','0','1',NULL,'1','0','0','1','1','0','1','0','0','0','1','0','0','0','0','0','0','0','0','0','DISABLED','NOT_ACTIVE','0',1,'0','0','0','0','0','0','NOT_ACTIVE','0','0','0','Y','0','0','DISABLED','0','0','0','0','','','','0','1','','','','','',NULL,'DISABLED','0','1','0','0','N','NOT_ACTIVE','0','0','0','0','0','0','0','0','0','NOT_ACTIVE','0','1','0','0','0','0',0,'2001-01-01 00:00:01','','','1',0,'0',-1,'0','default English','0','0','0',' ALL_FUNCTIONS ','NONE','0','0','0','0','0','',-1,'0','0','0','0',-1,'0','0',0,0,'DISABLED','DISABLED','NOT_ACTIVE',NULL,'0',NULL,NULL,-1,'','','NOT_ACTIVE','DISABLED','','0','',0,0,'','','0',-1,'0','2025-06-23 16:43:10'),
('VDAD','donotedit','Outbound Auto Dial',1,'ADMIN',NULL,NULL,'0','0','0','0','0','0','0','0','0','0','0','0','0','0','1',NULL,'1','0','0','1','1','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','DISABLED','NOT_ACTIVE','0',1,'0','0','0','0','0','0','NOT_ACTIVE','0','0','0','N','0','0','DISABLED','0','0','0','0','','','','0','1','','','','','',NULL,'DISABLED','0','1','0','0','N','NOT_ACTIVE','0','0','0','0','0','0','0','0','0','NOT_ACTIVE','0','1','0','0','0','0',0,'2001-01-01 00:00:01','','','1',0,'0',-1,'0','default English','0','0','0',' ALL_FUNCTIONS ','NONE','0','0','0','0','0','',-1,'0','0','0','0',-1,'0','0',0,0,'DISABLED','DISABLED','NOT_ACTIVE',NULL,'0',NULL,NULL,-1,'','','NOT_ACTIVE','DISABLED','','0','',0,0,'','','0',-1,'0','2025-06-23 16:43:10'),
('VDCL','donotedit','Inbound No Agent',1,'ADMIN',NULL,NULL,'0','0','0','0','0','0','0','0','0','0','0','0','0','0','1',NULL,'1','0','0','1','1','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','DISABLED','NOT_ACTIVE','0',1,'0','0','0','0','0','0','NOT_ACTIVE','0','0','0','N','0','0','DISABLED','0','0','0','0','','','','0','1','','','','','',NULL,'DISABLED','0','1','0','0','N','NOT_ACTIVE','0','0','0','0','0','0','0','0','0','NOT_ACTIVE','0','1','0','0','0','0',0,'2001-01-01 00:00:01','','','1',0,'0',-1,'0','default English','0','0','0',' ALL_FUNCTIONS ','NONE','0','0','0','0','0','',-1,'0','0','0','0',-1,'0','0',0,0,'DISABLED','DISABLED','NOT_ACTIVE',NULL,'0',NULL,NULL,-1,'','','NOT_ACTIVE','DISABLED','','0','',0,0,'','','0',-1,'0','2025-06-23 16:43:10');
/*!40000 ALTER TABLE `vicidial_users` ENABLE KEYS */;

--
-- Table structure for table `vicidial_vdad_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_vdad_log` (
  `caller_code` varchar(30) NOT NULL,
  `server_ip` varchar(15) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `epoch_micro` varchar(20) DEFAULT '',
  `db_time` datetime NOT NULL,
  `run_time` varchar(20) DEFAULT '0',
  `vdad_script` varchar(40) NOT NULL,
  `lead_id` int(10) unsigned DEFAULT 0,
  `stage` varchar(100) DEFAULT '',
  `step` smallint(5) unsigned DEFAULT 0,
  KEY `caller_code` (`caller_code`),
  KEY `vdad_dbtime_key` (`db_time`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_vdad_log`
--

/*!40000 ALTER TABLE `vicidial_vdad_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_vdad_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_vmm_counts`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_vmm_counts` (
  `call_date` date DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `vmm_count` smallint(5) unsigned DEFAULT 0,
  `vmm_played` smallint(5) unsigned DEFAULT 0,
  UNIQUE KEY `vvmmcount` (`lead_id`,`call_date`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_vmm_counts`
--

/*!40000 ALTER TABLE `vicidial_vmm_counts` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_vmm_counts` ENABLE KEYS */;

--
-- Table structure for table `vicidial_vmm_counts_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_vmm_counts_archive` (
  `call_date` date DEFAULT NULL,
  `lead_id` int(9) unsigned DEFAULT NULL,
  `vmm_count` smallint(5) unsigned DEFAULT 0,
  `vmm_played` smallint(5) unsigned DEFAULT 0,
  UNIQUE KEY `vvmmcount` (`lead_id`,`call_date`),
  KEY `call_date` (`call_date`),
  KEY `lead_id` (`lead_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_vmm_counts_archive`
--

/*!40000 ALTER TABLE `vicidial_vmm_counts_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_vmm_counts_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_voicemail`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_voicemail` (
  `voicemail_id` varchar(10) NOT NULL,
  `active` enum('Y','N') DEFAULT 'Y',
  `pass` varchar(10) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `messages` int(4) DEFAULT 0,
  `old_messages` int(4) DEFAULT 0,
  `email` varchar(100) DEFAULT NULL,
  `delete_vm_after_email` enum('N','Y') DEFAULT 'N',
  `voicemail_timezone` varchar(30) DEFAULT 'eastern',
  `voicemail_options` varchar(255) DEFAULT '',
  `user_group` varchar(20) DEFAULT '---ALL---',
  `voicemail_greeting` varchar(100) DEFAULT '',
  `on_login_report` enum('Y','N') NOT NULL DEFAULT 'N',
  PRIMARY KEY (`voicemail_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_voicemail`
--

/*!40000 ALTER TABLE `vicidial_voicemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_voicemail` ENABLE KEYS */;

--
-- Table structure for table `vicidial_webservers`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_webservers` (
  `webserver_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `webserver` varchar(125) DEFAULT '',
  `hostname` varchar(125) DEFAULT '',
  PRIMARY KEY (`webserver_id`),
  UNIQUE KEY `vdweb` (`webserver`,`hostname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_webservers`
--

/*!40000 ALTER TABLE `vicidial_webservers` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_webservers` ENABLE KEYS */;

--
-- Table structure for table `vicidial_xfer_log`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_xfer_log` (
  `xfercallid` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `closer` varchar(20) DEFAULT NULL,
  `front_uniqueid` varchar(50) DEFAULT '',
  `close_uniqueid` varchar(50) DEFAULT '',
  PRIMARY KEY (`xfercallid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `date_user` (`call_date`,`user`),
  KEY `date_closer` (`call_date`,`closer`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_xfer_log`
--

/*!40000 ALTER TABLE `vicidial_xfer_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_xfer_log` ENABLE KEYS */;

--
-- Table structure for table `vicidial_xfer_log_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_xfer_log_archive` (
  `xfercallid` int(9) unsigned NOT NULL,
  `lead_id` int(9) unsigned NOT NULL,
  `list_id` bigint(14) unsigned DEFAULT NULL,
  `campaign_id` varchar(20) DEFAULT NULL,
  `call_date` datetime DEFAULT NULL,
  `phone_code` varchar(10) DEFAULT NULL,
  `phone_number` varchar(18) DEFAULT NULL,
  `user` varchar(20) DEFAULT NULL,
  `closer` varchar(20) DEFAULT NULL,
  `front_uniqueid` varchar(50) DEFAULT '',
  `close_uniqueid` varchar(50) DEFAULT '',
  PRIMARY KEY (`xfercallid`),
  KEY `lead_id` (`lead_id`),
  KEY `call_date` (`call_date`),
  KEY `date_user` (`call_date`,`user`),
  KEY `date_closer` (`call_date`,`closer`),
  KEY `phone_number` (`phone_number`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_xfer_log_archive`
--

/*!40000 ALTER TABLE `vicidial_xfer_log_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_xfer_log_archive` ENABLE KEYS */;

--
-- Table structure for table `vicidial_xfer_presets`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_xfer_presets` (
  `campaign_id` varchar(20) NOT NULL,
  `preset_name` varchar(40) NOT NULL,
  `preset_number` varchar(50) NOT NULL,
  `preset_dtmf` varchar(50) DEFAULT '',
  `preset_hide_number` enum('Y','N') DEFAULT 'N',
  KEY `preset_name` (`preset_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_xfer_presets`
--

/*!40000 ALTER TABLE `vicidial_xfer_presets` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_xfer_presets` ENABLE KEYS */;

--
-- Table structure for table `vicidial_xfer_stats`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vicidial_xfer_stats` (
  `campaign_id` varchar(20) NOT NULL,
  `preset_name` varchar(40) NOT NULL,
  `xfer_count` smallint(5) unsigned DEFAULT 0,
  KEY `campaign_id` (`campaign_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vicidial_xfer_stats`
--

/*!40000 ALTER TABLE `vicidial_xfer_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `vicidial_xfer_stats` ENABLE KEYS */;

--
-- Table structure for table `vtiger_rank_data`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vtiger_rank_data` (
  `account` varchar(20) NOT NULL,
  `seqacct` varchar(20) NOT NULL,
  `last_attempt_days` smallint(5) unsigned NOT NULL,
  `orders` smallint(5) NOT NULL,
  `net_sales` smallint(5) NOT NULL,
  `net_sales_ly` smallint(5) NOT NULL,
  `percent_variance` varchar(10) NOT NULL,
  `imu` varchar(10) NOT NULL,
  `aov` smallint(5) NOT NULL,
  `returns` smallint(5) NOT NULL,
  `rank` smallint(5) NOT NULL,
  PRIMARY KEY (`account`),
  UNIQUE KEY `seqacct` (`seqacct`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vtiger_rank_data`
--

/*!40000 ALTER TABLE `vtiger_rank_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `vtiger_rank_data` ENABLE KEYS */;

--
-- Table structure for table `vtiger_rank_parameters`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vtiger_rank_parameters` (
  `parameter_id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `parameter` varchar(20) NOT NULL,
  `lower_range` varchar(20) NOT NULL,
  `upper_range` varchar(20) NOT NULL,
  `points` smallint(5) NOT NULL,
  PRIMARY KEY (`parameter_id`),
  KEY `parameter` (`parameter`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vtiger_rank_parameters`
--

/*!40000 ALTER TABLE `vtiger_rank_parameters` DISABLE KEYS */;
/*!40000 ALTER TABLE `vtiger_rank_parameters` ENABLE KEYS */;

--
-- Table structure for table `vtiger_vicidial_roles`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `vtiger_vicidial_roles` (
  `user_level` tinyint(2) DEFAULT NULL,
  `vtiger_role` varchar(5) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vtiger_vicidial_roles`
--

/*!40000 ALTER TABLE `vtiger_vicidial_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `vtiger_vicidial_roles` ENABLE KEYS */;

--
-- Table structure for table `wallboard_reports`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `wallboard_reports` (
  `wallboard_report_id` varchar(20) NOT NULL,
  `wallboard_name` varchar(100) DEFAULT NULL,
  `wallboard_views` tinyint(3) unsigned DEFAULT NULL,
  `date_created` datetime DEFAULT NULL,
  `last_modified` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `data_refresh_rate` smallint(5) unsigned DEFAULT 10,
  `view_refresh_rate` smallint(5) unsigned DEFAULT 30,
  PRIMARY KEY (`wallboard_report_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallboard_reports`
--

/*!40000 ALTER TABLE `wallboard_reports` DISABLE KEYS */;
INSERT INTO `wallboard_reports` select 'AGENTS_AND_QUEUES','Agents and Queues',2,'2022-01-18 09:00:23','2022-01-18 20:00:23',10,30 as data WHERE NOT EXISTS (SELECT 1 FROM wallboard_reports);
/*!40000 ALTER TABLE `wallboard_reports` ENABLE KEYS */;

--
-- Table structure for table `wallboard_widgets`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `wallboard_widgets` (
  `widget_id` varchar(100) NOT NULL,
  `wallboard_report_id` varchar(100) DEFAULT NULL,
  `view_id` varchar(100) DEFAULT NULL,
  `widget_title` varchar(100) DEFAULT NULL,
  `widget_type` varchar(30) DEFAULT NULL,
  `widget_width` tinyint(3) unsigned DEFAULT NULL,
  `widget_is_row` enum('Y','N') DEFAULT 'N',
  `widget_rowspan` tinyint(3) unsigned DEFAULT 1,
  `widget_text` text DEFAULT NULL,
  `widget_queue` varchar(20) DEFAULT NULL,
  `widget_sla_level` varchar(5) DEFAULT NULL,
  `widget_agent` varchar(20) DEFAULT NULL,
  `widget_color` varchar(20) DEFAULT NULL,
  `widget_color2` varchar(20) DEFAULT NULL,
  `widget_alarms` text DEFAULT NULL,
  `widget_order` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`widget_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallboard_widgets`
--

/*!40000 ALTER TABLE `wallboard_widgets` DISABLE KEYS */;
INSERT INTO `wallboard_widgets` 
(widget_id, wallboard_report_id, view_id, widget_title, widget_type, widget_width, widget_is_row, widget_rowspan, widget_text, widget_queue, widget_sla_level, widget_agent, widget_color, widget_color2, widget_alarms, widget_order)
SELECT widget_id, wallboard_report_id, view_id, widget_title, widget_type, widget_width, widget_is_row, widget_rowspan, widget_text, widget_queue, widget_sla_level, widget_agent, widget_color, widget_color2, widget_alarms, widget_order FROM (
  SELECT 'queues_widget_1' AS widget_id, 'AGENTS_AND_QUEUES' AS wallboard_report_id, 'queues' AS view_id, '' AS widget_title, 'TEXT' AS widget_type, 5 AS widget_width, 'N' AS widget_is_row, 1 AS widget_rowspan, 'Queue Information' AS widget_text, '' AS widget_queue, '' AS widget_sla_level, NULL AS widget_agent, '' AS widget_color, '' AS widget_color2, NULL AS widget_alarms, 2 AS widget_order
  UNION ALL
  SELECT 'queues_widget_0','AGENTS_AND_QUEUES','queues','','LOGO',2,'N',1,NULL,'','',NULL,'','',NULL,1
  UNION ALL
  SELECT 'queues_widget_2','AGENTS_AND_QUEUES','queues','SLA Level %','SLA_LEVEL_PCT',1,'N',1,NULL,'','>60',NULL,'','',NULL,3
  UNION ALL
  SELECT 'queues_widget_3','AGENTS_AND_QUEUES','queues','Outbound calls','LIVE_QUEUE_INFO',1,'N',1,'','201201','','','','','yellow_alarm,|red_alarm,',4
  UNION ALL
  SELECT 'queues_widget_4','AGENTS_AND_QUEUES','queues','USA Ded Inbound','LIVE_QUEUE_INFO',1,'N',1,'','ALL_IN','','','','','yellow_alarm,|red_alarm,',5
  UNION ALL
  SELECT 'queues_widget_5','AGENTS_AND_QUEUES','queues','MLA Ded Inbound','LIVE_QUEUE_INFO',1,'N',1,'','514911','','','','','yellow_alarm,|red_alarm,',6
  UNION ALL
  SELECT 'queues_widget_6','AGENTS_AND_QUEUES','queues','N Waiting Calls','N_WAITING_CALLS',1,'N',1,NULL,'','',NULL,'','',NULL,7
  UNION ALL
  SELECT 'queues_widget_7','AGENTS_AND_QUEUES','queues','Offered Calls','OFFERED_CALLS',1,'N',1,NULL,'','',NULL,'','',NULL,8
  UNION ALL
  SELECT 'queues_widget_8','AGENTS_AND_QUEUES','queues','Answered Calls','ANSWERED_CALLS',1,'N',1,NULL,'','',NULL,'','',NULL,9
  UNION ALL
  SELECT 'queues_widget_9','AGENTS_AND_QUEUES','queues','Lost Calls','LOST_CALLS',1,'N',1,NULL,'','',NULL,'','',NULL,10
  UNION ALL
  SELECT 'queues_widget_10','AGENTS_AND_QUEUES','queues','Longest Wait','LONGEST_WAIT',1,'N',1,NULL,'','',NULL,'','',NULL,11
  UNION ALL
  SELECT 'queues_widget_11','AGENTS_AND_QUEUES','queues','Live Queues','LIVE_QUEUES',1,'Y',1,NULL,'','',NULL,'','',NULL,12
  UNION ALL
  SELECT 'queues_widget_12','AGENTS_AND_QUEUES','queues','Live Calls','LIVE_CALLS',1,'Y',2,NULL,'','',NULL,'','',NULL,13
  UNION ALL
  SELECT 'agent_widget_0','AGENTS_AND_QUEUES','agents','','LOGO',2,'N',1,NULL,'','',NULL,'','',NULL,1
  UNION ALL
  SELECT 'agent_widget_1','AGENTS_AND_QUEUES','agents','N Waiting Calls','N_WAITING_CALLS',1,'N',1,NULL,'','',NULL,'','',NULL,2
  UNION ALL
  SELECT 'agent_widget_2','AGENTS_AND_QUEUES','agents','Agents Ready','AGENTS_READY',1,'N',1,NULL,'','',NULL,'','',NULL,3
  UNION ALL
  SELECT 'agent_widget_3','AGENTS_AND_QUEUES','agents','Agents On Call','N_AGENTS_ON_CALL',1,'N',1,NULL,'','',NULL,'','',NULL,4
  UNION ALL
  SELECT 'agent_widget_4','AGENTS_AND_QUEUES','agents','N Answered Calls','N_ANSWERED_CALLS',1,'N',1,NULL,'','',NULL,'','',NULL,5
  UNION ALL
  SELECT 'agent_widget_5','AGENTS_AND_QUEUES','agents','Clock','CLOCK',1,'N',1,NULL,'','',NULL,'','',NULL,6
  UNION ALL
  SELECT 'agent_widget_6','AGENTS_AND_QUEUES','agents','Live Agents','LIVE_AGENTS',1,'Y',3,NULL,'','',NULL,'','',NULL,7
) AS data
WHERE NOT EXISTS (SELECT 1 FROM wallboard_widgets);

/*!40000 ALTER TABLE `wallboard_widgets` ENABLE KEYS */;

--
-- Table structure for table `web_client_sessions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `web_client_sessions` (
  `extension` varchar(100) NOT NULL,
  `server_ip` varchar(15) NOT NULL,
  `program` enum('agc','vicidial','monitor','other') DEFAULT 'agc',
  `start_time` datetime NOT NULL,
  `session_name` varchar(40) NOT NULL,
  UNIQUE KEY `session_name` (`session_name`)
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `web_client_sessions`
--

/*!40000 ALTER TABLE `web_client_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `web_client_sessions` ENABLE KEYS */;

--
-- Table structure for table `www_phrases`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE IF NOT EXISTS `www_phrases` (
  `phrase_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `phrase_text` varchar(10000) DEFAULT '',
  `php_filename` varchar(255) NOT NULL,
  `php_directory` varchar(255) DEFAULT '',
  `source` varchar(20) DEFAULT '',
  `insert_date` datetime DEFAULT NULL,
  PRIMARY KEY (`phrase_id`),
  KEY `phrase_text` (`phrase_text`(333))
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `www_phrases`
--

/*!40000 ALTER TABLE `www_phrases` DISABLE KEYS */;
/*!40000 ALTER TABLE `www_phrases` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-23 12:51:21

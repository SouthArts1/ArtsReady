-- MySQL dump 10.13  Distrib 5.5.14, for osx10.6 (i386)
--
-- Host: localhost    Database: artsready_development
-- ------------------------------------------------------
-- Server version	5.5.14

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `action_items`
--

DROP TABLE IF EXISTS `action_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `action_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `import_id` int(11) DEFAULT NULL,
  `recurrence` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_action_items_on_import_id` (`import_id`),
  KEY `index_action_items_on_question_id` (`question_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action_items`
--

LOCK TABLES `action_items` WRITE;
/*!40000 ALTER TABLE `action_items` DISABLE KEYS */;
INSERT INTO `action_items` VALUES (1,' Update your organizational chart and upload to your Critical Stuff on ArtsReady',1,1,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(2,' Update the stakeholder contact list and upload to your Critical Stuff on ArtsReady',2,2,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(3,' Update staff, board, and regular volunteer emergency contact lists and upload to your Critical Stuff on ArtsReady',3,3,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(4,' Gather contracts and contact information for guest artists',4,4,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(5,' Develop a phone and email tree (with external email addresses and phone numbers) for staff and other personnel',5,5,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(6,' Document key responsibilities and functions for each staff member and place into a comprehensive \'Organization Guide\' to be used in the event of a sudden absence',6,6,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(7,' Cross train staff in each other\'s key functions and tasks so a substitute can easily fill in case of sudden absence',6,6,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(8,' Develop a clear interim and succession plan for the executive or organizational leader in the case of sudden absence',7,7,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(9,' Research and list a few local counselors that specialize in workplace trauma',8,8,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(10,' Designate a media spokesperson and back up person for crisis communications',9,9,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(11,' Time to conduct workplace safety training! Work on response for one crisis or hazard pertinent to your facility (tornado, earthquake,OSHA safety procedures, etc)',10,10,'Annually','2011-07-19 15:34:32','2011-07-19 15:34:32'),(12,' Time practice evacuating your facility! Be sure to also discuss and develop procedures for evacuating the public with your staff',10,10,'Annually','2011-07-19 15:34:32','2011-07-19 15:34:32'),(13,' Time to check and refresh first aid kits in your facility! Make sure staff and volunteers know where they are',10,10,'Annually','2011-07-19 15:34:32','2011-07-19 15:34:32'),(14,' Time to do basic first aid and CPR training with staff and volunteers!',10,10,'Biannually','2011-07-19 15:34:32','2011-07-19 15:34:32'),(15,'Designate and officiate back up signatories so funds can be accessed if the regular person becomes unavailable.',11,11,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(16,'Develop a safe way to store your daily cash intake at the close of business.',12,12,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(17,'Distill and digitize up-to-date financial records (including bank account numbers and quarterly balances). Upload the files to your Critical Stuff on ArtsReady',13,13,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(18,'Train at least one back up person so they know how to access and read financial files in the case of a sudden absence.',13,13,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(19,'Set up on-line access with your bank(s) so you can conduct remote banking.',14,14,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(20,'Develop and document a plan for back-up compensation for staff.',15,15,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(21,'Create an inventory of valuable equipment, include serial numbers and value. Digitize and upload the list to your critical stuff on ArtsReady.',16,16,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(22,'Photograph or make a video of your facility and key equipment. Organize and clearly label the digital images in a folder. Save the file to your Critical Stuff on ArtsReady.',16,16,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(23,'Time to contact your insurance agent! Make sure your coverage is up-to-date and includes any changes you\'ve made recently.',17,17,'Annually','2011-07-19 15:34:32','2011-07-19 15:34:32'),(24,'Upload your insurance company or agent\'s contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.',17,17,'Annually','2011-07-19 15:34:32','2011-07-19 15:34:32'),(25,'Obtain an event insurance policy. Upload the providing company\'s contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.',18,18,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(26,'Get insurance coverage for your new asset (or add it to your current policy). Upload the insurance company or agent\'s contact information, a copy of the policy, and the policy number to your Critical Stuff on ArtsReady.',19,19,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(27,'Develop or update your GuideStar account.',20,20,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(28,'Organize your finances so restricted funds are in one or more separate accounts from general-use funds.',21,21,NULL,'2011-07-19 15:34:32','2011-07-19 15:34:32');
/*!40000 ALTER TABLE `action_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answers`
--

DROP TABLE IF EXISTS `answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `assessment_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `preparedness` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `was_skipped` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_answers_on_assessment_id` (`assessment_id`),
  KEY `index_answers_on_question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answers`
--

LOCK TABLES `answers` WRITE;
/*!40000 ALTER TABLE `answers` DISABLE KEYS */;
/*!40000 ALTER TABLE `answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `document` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `published_on` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `visibility` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'private',
  `critical_function` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `on_critical_list` tinyint(1) DEFAULT '0',
  `todo_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_articles_on_organization_id` (`organization_id`),
  KEY `index_articles_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articles`
--

LOCK TABLES `articles` WRITE;
/*!40000 ALTER TABLE `articles` DISABLE KEYS */;
/*!40000 ALTER TABLE `articles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments`
--

DROP TABLE IF EXISTS `assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `has_performances` tinyint(1) DEFAULT NULL,
  `has_tickets` tinyint(1) DEFAULT NULL,
  `has_facilities` tinyint(1) DEFAULT NULL,
  `has_programs` tinyint(1) DEFAULT NULL,
  `has_grants` tinyint(1) DEFAULT NULL,
  `has_exhibits` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_assessments_on_organization_id` (`organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments`
--

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crises`
--

DROP TABLE IF EXISTS `crises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `crises` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `declared_on` tinyint(1) DEFAULT NULL,
  `resolved_on` date DEFAULT NULL,
  `resolution` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_crises_on_organization_id` (`organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crises`
--

LOCK TABLES `crises` WRITE;
/*!40000 ALTER TABLE `crises` DISABLE KEYS */;
/*!40000 ALTER TABLE `crises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `needs`
--

DROP TABLE IF EXISTS `needs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `needs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `crisis_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `resource` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `provided` tinyint(1) DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_updated_on` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_needs_on_crisis_id` (`crisis_id`),
  KEY `index_needs_on_organization_id` (`organization_id`),
  KEY `index_needs_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `needs`
--

LOCK TABLES `needs` WRITE;
/*!40000 ALTER TABLE `needs` DISABLE KEYS */;
/*!40000 ALTER TABLE `needs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organizations`
--

DROP TABLE IF EXISTS `organizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT '0',
  `battle_buddy_enabled` tinyint(1) DEFAULT '0',
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `gmaps` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations`
--

LOCK TABLES `organizations` WRITE;
/*!40000 ALTER TABLE `organizations` DISABLE KEYS */;
INSERT INTO `organizations` VALUES (1,'South Arts','1800 Peachtree St., NW','Atlanta','GA','30309','2011-07-19 15:34:28','2011-07-19 15:34:28',1,0,33.8039,-84.3933,1),(2,'Fractured Atlas','248 W. 35th Street','New York','NY','10001','2011-07-19 15:34:29','2011-07-19 15:34:29',1,0,40.7524,-73.9919,1),(3,'Lincoln Center','10 Lincoln Center Plaza','New York','NY','10023','2011-07-19 15:34:30','2011-07-19 15:34:30',1,1,40.7723,-73.983,1),(4,'Whitney Museum of American Art','945 Madison Avenue','New York','NY','10021','2011-07-19 15:34:30','2011-07-19 15:34:30',1,1,40.7733,-73.9636,1),(5,'The Museum of Modern Art','11 West 53rd Street','New York','NY','10019','2011-07-19 15:34:31','2011-07-19 15:34:31',1,1,40.7614,-73.9776,1),(6,'Fractured Atlas','248 West 35th Street','New York','NY','10001','2011-07-19 15:34:31','2011-07-19 15:34:31',1,0,40.7524,-73.9919,1),(7,'Unapproved Org','1505 Broadway','New York','NY','10001','2011-07-19 15:34:31','2011-07-19 15:34:31',0,0,40.7573,-73.9859,1);
/*!40000 ALTER TABLE `organizations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text COLLATE utf8_unicode_ci,
  `critical_function` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `import_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_questions_on_import_id` (`import_id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'Ready means you keep your organizational chart in such a way that it can be accessed, no matter what happens.','People Resources',1,'2011-07-19 15:34:31','2011-07-19 15:34:31'),(2,'Ready means your stakeholder contact lists are recently updated and easily obtained from offsite.','People Resources',2,'2011-07-19 15:34:31','2011-07-19 15:34:31'),(3,'Ready means you have current, accessible, in-case-of-emergency contact information for all staff, board and regular volunteers.','People Resources',3,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(4,'Ready means you collect contact information for all contract/guest artists and store it so it\'s accessible from offsite.','People Resources',4,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(5,'Ready means you have an established phone/email tree, including alternate web-based email accounts, to contact key individuals in case of emergency.','People Resources',5,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(6,'Ready means you have documented key responsibilities and provided cross training on critical functions where a staff member\'s sudden absence would cause serious difficulties.','People Resources',6,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(7,'Ready means you have an emergency succession plan in place for your executive/leadership position.','People Resources',7,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(8,'Ready means you know how to obtain counseling for your staff if needed.','People Resources',8,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(9,'Ready means you have a designated media spokesperson, backup person and a crisis communications plan for handling media and stakeholder relations during a crisis.','People Resources',9,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(10,'Ready means you regularly conduct workplace safety training including evacuation and first aid procedures.','People Resources',10,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(11,'Ready means you have an adequate number of signatories authorized to spend funds (in case one or more is suddenly not available).','Finances & Insurance',11,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(12,'Ready means if you collect significant amounts of cash, you have a safe location in which to secure them at the end of your event/workday.','Finances & Insurance',12,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(13,'Ready means your financial records are accessible (and understandable) to more than one person (including bank statements, accounts receivable, accounts payable and payroll).','Finances & Insurance',13,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(14,'Ready means you are able to conduct remote banking.','Finances & Insurance',14,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(15,'Ready means you have a plan for how employees would be compensated during times of emergency.','Finances & Insurance',15,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(16,'Ready means you have recently taken and stored (offsite/online) photos/videos of your building, inventory and equipment for potential insurance claims.','Finances & Insurance',16,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(17,'Ready means you consult annually with your insurance agent about coverage and other advice.','Finances & Insurance',17,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(18,'Ready means you have an event insurance policy in place to offset costs/losses in the case of a disruption to your normal event schedule.','Finances & Insurance',18,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(19,'Ready means you regularly update your insurance coverage to reflect new items (e.g. equipment, supplies, acquisitions, de-accessioned artwork and borrowed artwork).','Finances & Insurance',19,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(20,'Ready means your GuideStar profile is up to date so that potential donors can vet your organization.','Finances & Insurance',20,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(21,'Ready means restricted-use funds (e.g. grant monies, endowment) are kept in separate bank accounts from general use funds.','Finances & Insurance',21,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(22,'Ready means your organization\'s computer systems (administrative privileges, passwords and processes) are known to enough people, and this data is kept where people can access them, in times of disruption.','Technology',22,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(23,'Ready means you have considered how power failure will impact your systems, and have tested to verify you can restart systems.','Technology',23,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(24,'Ready means if you use outside vendors to host your website(s) and/or valuable digital data, you know what their policies are for backing up your data and keeping it safe.','Technology',24,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(25,'Ready means you have multiple people at your organization who know how to get in touch with I.T. vendors (and are authorized through your contract with the vendor) in case of an emergency at your organization','Technology',25,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(26,'Ready means your key people are able to work remotely.','Technology',26,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(27,'Ready means you have important onsite electronic documents/ recordings stored in multiple safe offsite places.','Technology',27,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(28,'Ready means you have taken steps to keep your email server and website secure from cyber-attacks and hacking.','Technology',28,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(29,'Ready means you have designated a place on the organization\'s website where crisis communications would be posted, and assigned responsibility for authoring/posting information.','Technology',29,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(30,'Ready means your productions are documented sufficiently that, if one or more of your key people were suddenly absent, the show could still go on.','Productions',30,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(31,'Ready means you keep your current production schedule in such a way that it can be accessed, no matter what happens.','Productions',31,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(32,'Ready means your current contracts with artists and vendors are stored in a way that they can be accessed, no matter what happens.','Productions',32,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(33,'Ready means you have documented policies in place so that if one of your productions had to be suddenly delayed or cancelled, your staff can successfully negotiate the change.','Productions',33,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(34,'Ready means if you tour or perform offsite, you have plans in case something occurs offsite (transportation problems, medical issues, etc.)','Productions',34,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(35,'Ready means your phones have call-forwarding so that you can receive calls at another location.','Ticketing & Messaging',35,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(36,'Ready means you keep your current events calendar in such a way that it can be altered for the public and internally, no matter what happens.','Ticketing & Messaging',36,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(37,'Ready means you have a plan for how to sell tickets in the event that your current box office system fails.','Ticketing & Messaging',37,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(38,'Ready means your ticket refund policy is documented in such a way that audience members, employees and volunteers can easily understand it if an event changes/is cancelled.','Ticketing & Messaging',38,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(39,'Ready means you have a current evacuation plan documented and posted.','Facilities',39,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(40,'Ready means volunteers and employees are trained/refreshed in evacuation procedures regularly.','Facilities',40,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(41,'Ready means you have a facility preparation plan, and staff training, to protect and mitigate damage to your facility and assets in the event you have warning time before an event occurs.','Facilities',41,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(42,'Ready means your most valuable assets (artwork, equipment, costumes/inventory) are stored in such a way as to minimize theft and damage.','Facilities',42,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(43,'Ready means your facilities have up-to-date emergency/safety equipment.','Facilities',43,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(44,'Ready means you have tested and and updated your building alarms (security, fire, smoke, etc.) in the last six months.','Facilities',44,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(45,'Ready means your local police and fire departments have toured your facilities recently and advised on security and fire protection.','Facilities',45,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(46,'Ready means a trusted employee or volunteer living close to your facility has copies of keys and alarm codes and is authorized to respond to emergency services.','Facilities',46,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(47,'Ready means if you rent or receive donated space, your landlord has current information on who in your organization to contact in case of emergency.','Facilities',47,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(48,'Ready means you have a \'crisis kit\' or cache of emergency supplies in your facility.','Facilities',48,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(49,'Ready means your facility has a functional emergency generator.','Facilities',49,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(50,'Ready means you have up to date agreements in place with a few Battle Buddies who can provide alternate facilities if yours becomes unavailable','Facilities',50,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(51,'Ready means your programming is documented sufficiently so that, if one or more of your key people were suddenly absent, programming could still take place.','Programs',51,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(52,'Ready means you have a list of alternate suppliers/vendors to work with if your usual ones are not available.','Programs',52,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(53,'Ready means you have a planned process for making decisions about program budget cuts and alterations should they occur.','Programs',53,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(54,'Ready means you know how you would quickly communicate with the participants in your program(s) if you needed to.','Programs',54,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(55,'Ready means your documents and records pertaining to grants are adequately backed-up on a frequent basis.','Grantmaking',55,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(56,'Ready means more than one person on your staff knows how to facilitate your grant application process, use your grantmaking database, or access your grantmaking files.','Grantmaking',56,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(57,'Ready means you have an adequate number of signatories authorized to award funds (in case one or more is suddenly not available).','Grantmaking',57,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(58,'Ready means you have a process to ensure grants can be paid if your organization experiences an emergency.','Grantmaking',58,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(59,'Ready means you have a process to determine how you will support constituent organizations/individuals in the event your community is impacted by a crisis.','Grantmaking',59,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(60,'Ready means if your grants are awarded with pass-through funds and require your organization to provide reports to another funder, more than one person on staff knows your deadlines and the process for reporting your grantmaking activities.','Grantmaking',60,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(61,'Ready means you have a plan for handling any changes to grant awards and communicating to grantees, if your budget were to decrease significantly and your grantmaking activities were jeopardized.','Grantmaking',61,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(62,'Ready means your preparation for exhibits and the exhibit schedule (for either in-house or touring exhibits) is documented sufficiently that, if one or more of your key people were suddenly absent, the preparation could continue and the documents can be accessed off site','Exhibits',62,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(63,'Ready means you have a plan for accessing installation/de-installation materials should your organization\'s own tools become suddenly unavailable','Exhibits',63,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(64,'Ready means your current contracts/loan agreements with artists, organizations, contractors and vendors and their contact information are kept in such a way that they can be accessed, no matter what happens.','Exhibits',64,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(65,'Ready means you have documented policies in place so that if one of your exhibits had to be suddenly delayed or cancelled, your staff can successfully negotiate the delay/cancellation.','Exhibits',65,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(66,'Ready means if you loan or rent your exhibits, you have plans in case something occurs offsite (transportation problems, damage documentation, ensuring adequate insurance coverage, etc.)','Exhibits',66,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(67,'Ready means you have the objects in your exhibit adequately documented/photographed upon installation in case they incur damage or get lost while in your care','Exhibits',67,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(68,'Ready means the value of the objects in the current exhibit has been accessed, documented, and could be easily obtained offsite','Exhibits',68,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(69,'Ready means insurance is immediately updated upon the installation of a new exhibit or when a new object is acquired and multiple people can access records offsite','Exhibits',69,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(70,'Ready means back up personnel understand the sensitivity and can handle the objects on display should the regular art handler become unavailable','Exhibits',70,'2011-07-19 15:34:32','2011-07-19 15:34:32'),(71,'Ready means you have an adequate (environmentally sensitive) back up site for emergency storage and clear instructions for their transport should your facility need to be evacuated of objects','Exhibits',71,'2011-07-19 15:34:32','2011-07-19 15:34:32');
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `details` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_resources_on_organization_id` (`organization_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20110601161713'),('20110606094827'),('20110606194300'),('20110608014445'),('20110609101453'),('20110609153644'),('20110610154153'),('20110612132725'),('20110612152620'),('20110616151008'),('20110616154820'),('20110621142922'),('20110621174432'),('20110621185010'),('20110622185904'),('20110622205025'),('20110623145241'),('20110702134555'),('20110705140732'),('20110707181213'),('20110712101452'),('20110713132204'),('20110713133616'),('20110714154712'),('20110714181246'),('20110715155651'),('20110715203657');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `todo_notes`
--

DROP TABLE IF EXISTS `todo_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todo_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `todo_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_todo_notes_on_todo_id` (`todo_id`),
  KEY `index_todo_notes_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `todo_notes`
--

LOCK TABLES `todo_notes` WRITE;
/*!40000 ALTER TABLE `todo_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `todo_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `todos`
--

DROP TABLE IF EXISTS `todos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `todos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_item_id` int(11) DEFAULT NULL,
  `answer_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `due_on` date DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `details` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `review_on` date DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `critical_function` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `complete` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_todos_on_action_item_id` (`action_item_id`),
  KEY `index_todos_on_answer_id` (`answer_id`),
  KEY `index_todos_on_organization_id` (`organization_id`),
  KEY `index_todos_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `todos`
--

LOCK TABLES `todos` WRITE;
/*!40000 ALTER TABLE `todos` DISABLE KEYS */;
/*!40000 ALTER TABLE `todos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `updates`
--

DROP TABLE IF EXISTS `updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `crisis_id` int(11) DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_updates_on_crisis_id` (`crisis_id`),
  KEY `index_updates_on_organization_id` (`organization_id`),
  KEY `index_updates_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updates`
--

LOCK TABLES `updates` WRITE;
/*!40000 ALTER TABLE `updates` DISABLE KEYS */;
/*!40000 ALTER TABLE `updates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  `active` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_users_on_organization_id` (`organization_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','User','admin@test.host','$2a$10$0UPWnfQgitqqYAvbj.wUO.aeacilX8dI3W4WVTgiJ7EVT6xdwLJTy','2011-07-19 15:34:29','2011-07-19 15:34:29',1,1,0),(2,'Test','User','test@test.host','$2a$10$y3GZki.ygzvUSdfyiWPbDu13ueBGxIFt7MGCFHp41bSfubdgK0r72','2011-07-19 15:34:29','2011-07-19 15:34:29',2,0,0),(3,'Kirsten','Nordine','kirsten.nordine@fracturedatlas.org','$2a$10$3sRtiNE3fErT1ozhaKFgyejG8TM7mY.fXi93oMZfmRuPd862KES5u','2011-07-19 15:34:29','2011-07-19 15:34:29',2,0,0),(4,'Justin','Karr','justin.karr@fracturedatlas.org','$2a$10$j7Pjcip3pa4dZ.AU0iTEc.1odEHzVyPQ/l0m62LuTgEsbibqalGwG','2011-07-19 15:34:29','2011-07-19 15:34:29',2,0,0),(5,'Lincoln','Center','lc@test.host','$2a$10$fRnQQkwVYO4BcAegpuWuFuG8iip9M./XJm04kxHMfKYCL05ejoEyC','2011-07-19 15:34:30','2011-07-19 15:34:30',3,0,0),(6,'Whitney','Museum','wmaa@test.host','$2a$10$6jwt8STZ964MjDDbhopcsOlq073Gn4DnoW/GLviL8psAUK87cHW2G','2011-07-19 15:34:30','2011-07-19 15:34:30',4,0,0),(7,'Moma','Museum','moma@test.host','$2a$10$M1Jj84YjnEzscxdbYAh.u.w4kwEjs0/ObAnESuQJlW1iu7/48YVuy','2011-07-19 15:34:31','2011-07-19 15:34:31',5,0,0),(8,'Fractured','Atlas','fa@test.host','$2a$10$Hktz1mDZ0hx.Qz77ywPiVulpW1f4QZeqtIn6TrQZNm65L6LxE33uK','2011-07-19 15:34:31','2011-07-19 15:34:31',6,0,0),(9,'Unapproved','Org','unapproved@test.host','$2a$10$czYGtyHg5i4m0H0CAeXC2.aoyrPDxx64GVlYi4mZONlY3J/anE4jC','2011-07-19 15:34:31','2011-07-19 15:34:31',7,0,0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-07-19 11:34:42

CREATE DATABASE  IF NOT EXISTS `twitterDB` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `twitterDB`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: 127.0.0.1    Database: twitterDB
-- ------------------------------------------------------
-- Server version	5.6.35

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
-- Table structure for table `followers`
--

DROP TABLE IF EXISTS `followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `followers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `follower_id` int(11) NOT NULL,
  `leader_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`follower_id`,`leader_id`),
  KEY `fk_users_has_users_users2_idx` (`leader_id`),
  KEY `fk_users_has_users_users1_idx` (`follower_id`),
  CONSTRAINT `fk_users_has_users_users1` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_users_users2` FOREIGN KEY (`leader_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `followers`
--

LOCK TABLES `followers` WRITE;
/*!40000 ALTER TABLE `followers` DISABLE KEYS */;
INSERT INTO `followers` VALUES (2,5,1),(6,3,1),(1,1,3),(3,5,3),(4,5,4),(7,3,4),(5,1,5),(8,3,5);
/*!40000 ALTER TABLE `followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `likes`
--

DROP TABLE IF EXISTS `likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tweet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`tweet_id`,`user_id`),
  KEY `fk_tweets_has_users_users1_idx` (`user_id`),
  KEY `fk_tweets_has_users_tweets_idx` (`tweet_id`),
  CONSTRAINT `fk_tweets_has_users_tweets` FOREIGN KEY (`tweet_id`) REFERENCES `tweets` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_tweets_has_users_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `likes`
--

LOCK TABLES `likes` WRITE;
/*!40000 ALTER TABLE `likes` DISABLE KEYS */;
INSERT INTO `likes` VALUES (1,11,5),(2,11,5),(3,10,5),(4,9,5),(5,6,5),(6,4,5);
/*!40000 ALTER TABLE `likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tweets`
--

DROP TABLE IF EXISTS `tweets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tweet` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`,`user_id`),
  KEY `fk_tweets_users1_idx` (`user_id`),
  CONSTRAINT `fk_tweets_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tweets`
--

LOCK TABLES `tweets` WRITE;
/*!40000 ALTER TABLE `tweets` DISABLE KEYS */;
INSERT INTO `tweets` VALUES (2,'Another tweet!!!','2018-07-14 15:57:52','2018-07-14 15:57:52',5),(3,'Have a nice day!','2018-07-14 16:03:38','2018-07-14 16:03:38',5),(4,'Yes, indeed!!!','2018-07-14 16:50:30','2018-07-14 16:50:30',5),(5,'Happy Sunday everyone','2018-07-15 17:34:14','2018-07-15 17:34:14',1),(6,'Yes, It\'s Sunday again!!! ','2018-07-15 17:55:25','2018-07-15 17:55:25',5),(7,'My name is Mitchell, and I am following you people.','2018-07-15 17:58:04','2018-07-15 17:58:04',3),(8,'I am excited for this week!','2018-07-15 17:59:44','2018-07-15 17:59:44',3),(9,'What about you guys?','2018-07-15 18:07:05','2018-07-15 18:07:05',3),(10,'Happy New Week!','2018-07-16 13:37:04','2018-07-16 13:37:04',1),(11,'Bon début de la semaine à tous!','2018-07-16 13:49:52','2018-07-16 13:49:52',5);
/*!40000 ALTER TABLE `tweets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Joseph','$2b$12$v8D8TfbQrAxDQ9jcr8c.Qu.tmG6l8cLSSJj0wscFJI.Vw.Nk1BBhq','2018-07-14 14:09:17','2018-07-14 14:09:17'),(3,'Michell','$2b$12$gTqplwZF.kMjGi8GK/aHquwvFUadyY6rzCT8IkrrX7Px6w8DX3qxe','2018-07-14 14:51:41','2018-07-14 14:51:41'),(4,'Michell','$2b$12$VcW3LFa/LpsqurCUDhUvLezdrp/CcHnz7agmIAQ2qF0txDu2mw9b.','2018-07-14 14:53:19','2018-07-14 14:53:19'),(5,'Viny','$2b$12$8wP5HhZJaOi5rGf9ch9CmuIXCAGm4/6eyaua.I2Q87sCKTmMPegC2','2018-07-14 15:08:57','2018-07-14 15:08:57');
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

-- Dump completed on 2018-07-16 20:25:36

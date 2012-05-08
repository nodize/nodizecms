-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: pageone
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.7

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
-- Table structure for table `article`
--

DROP TABLE IF EXISTS `article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article` (
  `id_article` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `publish_on` datetime DEFAULT NULL,
  `publish_off` datetime DEFAULT NULL,
  `logical_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id_article`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article`
--

LOCK TABLES `article` WRITE;
/*!40000 ALTER TABLE `article` DISABLE KEYS */;
INSERT INTO `article` VALUES (1,'welcome','2012-04-11 22:41:00','2012-04-11 22:42:10','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(2,'creative-ideas','2012-04-11 22:42:00','2012-04-11 22:43:11','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(3,'innovation','2012-04-11 22:52:00','2012-04-11 22:52:43','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(4,'design-and-development','2012-04-11 22:52:00','2012-04-11 22:53:07','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(5,'web-design','2012-04-11 22:58:00','2012-04-11 22:59:19','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(6,'slider','2012-04-11 23:01:00','2012-04-11 23:01:59','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(7,'web-development','2012-04-11 23:24:00','2012-04-11 23:24:35','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(8,'seo-services','2012-04-11 23:38:00','2012-04-11 23:39:02','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(9,'print-design','2012-04-11 23:39:00','2012-04-11 23:39:28','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(10,'logo-design---branding','2012-04-11 23:40:00','2012-04-11 23:40:38','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(11,'newsletter','2012-04-11 23:40:00','2012-04-11 23:40:56','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(12,'milk-splashes','2012-04-12 08:16:00','2012-04-12 08:16:18','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(13,'hexagon-bokeh','2012-04-12 08:16:00','2012-04-12 08:16:28','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(14,'aftermath-sample-video','2012-04-12 08:16:00','2012-04-12 08:16:39','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(15,'dandelion','2012-04-12 08:18:00','2012-04-12 08:18:06','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(16,'eiffel-tower','2012-04-12 08:18:00','2012-04-12 08:18:12','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(17,'clouds---rainbow','2012-04-12 08:18:00','2012-04-12 08:18:19','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(18,'rural-landscape','2012-04-12 08:18:00','2012-04-12 08:18:27','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(19,'cosmic-sneakers','2012-04-12 08:18:00','2012-04-12 08:18:39','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(20,'abstract-vector','2012-04-12 08:18:00','2012-04-12 08:18:49','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(21,'intro','2012-04-12 09:52:00','2012-04-12 09:53:09','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(22,'template-license','2012-04-12 09:53:00','2012-04-12 09:54:07','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(23,'','2012-04-12 10:18:00','2012-04-12 10:19:02','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(24,'our-approach','2012-04-12 10:19:00','2012-04-12 10:19:53','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(25,'erwin-aligam','2012-04-12 11:23:00','2012-04-12 11:23:36','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(26,'uzumaki-naruto','2012-04-12 11:23:00','2012-04-12 11:23:55','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(27,'haruno-sakura','2012-04-12 11:28:00','2012-04-12 11:28:30','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(28,'uchiha-sasuke','2012-04-12 11:32:00','2012-04-12 11:32:10','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(29,'nodejs','2012-04-12 14:00:00','2012-04-12 14:02:10','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(30,'coffeescript','2012-04-12 14:11:00','2012-04-12 14:12:17','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(31,'more-about-us','2012-04-12 14:24:00','2012-04-12 14:25:12','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(32,'john-doe-xyz-company','2012-04-12 17:00:00','2012-04-12 17:01:16','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00'),(33,'jane-roe-abc-corps','2012-04-12 17:02:00','2012-04-12 17:02:21','0000-00-00 00:00:00','0000-00-00 00:00:00','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_lang`
--

DROP TABLE IF EXISTS `article_lang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_lang` (
  `id_article` int(11) DEFAULT NULL,
  `lang` varchar(255) DEFAULT NULL,
  `url` text,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `meta_title` varchar(255) DEFAULT NULL,
  `summary` text,
  `content` text,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `meta_description` text,
  `online` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_lang`
--

LOCK TABLES `article_lang` WRITE;
/*!40000 ALTER TABLE `article_lang` DISABLE KEYS */;
INSERT INTO `article_lang` VALUES (1,'en','welcome','Welcome','',NULL,NULL,'<p class=\"intro\">Hello there. We are PageOne. We are a small design studio based in somewhere. We create awesome websites, user interfaces, logos and other digital stuff. We\'re here to make you and your business stand out from the crowds.</p>\n<p class=\"intro\">Learn more&nbsp;<a href=\"/about-us\">about us</a>&nbsp;or&nbsp;<a href=\"/contact\">get in touch</a>&nbsp;if you want to hire us on your next projects.</p>',NULL,NULL,'1',1),(2,'en','creative-ideas','Creative Ideas','',NULL,NULL,'<p><span>Nascetur augue hac platea enim, egestas pulvinar vut. Pulvinar cum, ac eu, tristie acus duis in dictumst non integer! Elit, sed scelerisque odio tortor, sed platea dis? Quis cursus parturient ac amet odio in? Nunc Amet urna scelerisque eu lectus placerat.</span></p>',NULL,NULL,'1',2),(3,'en','innovation','Innovation','',NULL,NULL,'<p><span>Pellentesque magna mi, iaculis pharetra eu, fermentum ullamcorper nisi. Integer fringilla magna ut quam vulputate erat. Pulvinar cum, ac eu augue ut sit amet gravida lacinia, eros massa condimentum sem, a fermentum ligula lorem non. Phasellus vulputate.</span></p>',NULL,NULL,'1',3),(4,'en','design-and-development','Design and Development','',NULL,NULL,'<p><span>In hac habitasse platea risus dictumst. Suspendisse sit amet enim arcu. Aliquam erat volutpat. Phasellus a dui nisi. Nunc nec quam vitae nisl vehicula euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo ligula blandit risus.</span></p>',NULL,NULL,'1',4),(5,'en','web-design','Web Design','',NULL,NULL,'<p><span>Pellentesque magna mi, iaculis pharetra eu, fermentum ullamcorper nisi. Integer fringilla magna ut quam vulputate erat. Pulvinar cum, ac eu augue ut sit amet gravida lacinia, eros massa condimentum sem, a fermentum ligula lorem non. Phasellus vulputate.</span></p>',NULL,NULL,'1',5),(6,'en','slider','Slider','',NULL,NULL,'',NULL,NULL,'1',6),(7,'en','web-development','Web Development','',NULL,NULL,'<p><span>In hac habitasse platea risus dictumst. Suspendisse sit amet enim arcu. Aliquam erat volutpat. Phasellus a dui nisi. Nunc nec quam vitae nisl vehicula euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo ligula blandit risus</span></p>',NULL,NULL,'1',7),(8,'en','seo-services','SEO Services','',NULL,NULL,'<p><span>Nascetur augue hac platea enim, egestas pulvinar vut. Pulvinar cum, ac eu, tristie acus duis in dictumst non integer! Elit, sed scelerisque odio tortor, sed platea dis? Quis cursus parturient ac amet odio in? Nunc Amet urna scelerisque eu lectus placerat.</span></p>',NULL,NULL,'1',8),(9,'en','print-design','Print Design','',NULL,NULL,'<p><span>In hac habitasse platea risus dictumst. Suspendisse sit amet enim arcu. Aliquam erat volutpat. Phasellus a dui nisi. Nunc nec quam vitae nisl vehicula euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed commodo ligula blandit risus</span></p>',NULL,NULL,'1',9),(10,'en','logo-design---branding','Logo Design & Branding','',NULL,NULL,'<p><span>Nascetur augue hac platea enim, egestas pulvinar vut. Pulvinar cum, ac eu, tristie acus duis in dictumst non integer! Elit, sed scelerisque odio tortor, sed platea dis? Quis cursus parturient ac amet odio in? Nunc Amet urna scelerisque eu lectus placerat.</span></p>',NULL,NULL,'1',10),(11,'en','newsletter','Newsletter','',NULL,NULL,'<p><span>Pellentesque magna mi, iaculis pharetra eu, fermentum ullamcorper nisi. Integer fringilla magna ut quam vulputate erat. Pulvinar cum, ac eu augue ut sit amet gravida lacinia, eros massa condimentum sem, a fermentum ligula lorem non. Phasellus vulputate.</span></p>',NULL,NULL,'1',11),(12,'en','milk-splashes','Milk Splashes','',NULL,NULL,'',NULL,NULL,'1',12),(13,'en','hexagon-bokeh','Hexagon Bokeh','',NULL,NULL,'',NULL,NULL,'1',13),(14,'en','aftermath-sample-video','Aftermath','',NULL,NULL,'',NULL,NULL,'1',14),(15,'en','dandelion','Dandelion','',NULL,NULL,'',NULL,NULL,'1',15),(16,'en','eiffel-tower','Eiffel Tower','',NULL,NULL,'',NULL,NULL,'1',16),(17,'en','clouds---rainbow','Clouds & Rainbow','',NULL,NULL,'',NULL,NULL,'1',17),(18,'en','rural-landscape','Rural Landscape','',NULL,NULL,'',NULL,NULL,'1',18),(19,'en','cosmic-sneakers','Cosmic Sneakers','',NULL,NULL,'',NULL,NULL,'1',19),(20,'en','abstract-vector','Abstract Vector','',NULL,NULL,'',NULL,NULL,'1',20),(21,'en','intro','','',NULL,NULL,'<p><br class=\"Apple-interchange-newline\" /><span>Maecenas eu neque erat, auctor feugiat enim. Sed libero risus, pretium vel elementum id, lacinia vel purus. Mauris semper, orci vitae aliquam vestibul, lorem nulla auctor nulla, gravida fermentum urna libero eget sapien. Quisque cursus, urna quis vestibulum egestas, nibh sem semper erat, a feugiat justo dolor eget libero. Quisque cursus, urna quis vestibulum egestas, nibh sem semper erat, a feugiat justo dolor eget libero</span></p>',NULL,NULL,'1',21),(22,'en','template-license','Template License','',NULL,NULL,'<p><span>This work is released and licensed under the&nbsp;</span><a href=\"http://creativecommons.org/licenses/by/2.5/\" rel=\"license\">Creative Commons Attribution 3.0 License</a><span>, which means that you are free to use and modify it for any personal or commercial purpose. All I ask is that you give me credit by including a link back to my&nbsp;</span><a href=\"http://www.styleshout.com/\">website</a></p>',NULL,NULL,'1',22),(23,'en','','Our Process','',NULL,NULL,'<p><span>Nascetur augue hac platea enim, egestas pulvinar vut. Pulvinar cum, ac eu, tristie acus duis in dictumst non integer! Elit, sed scelerisque odio tortor, sed platea dis? Quis cursus parturient ac amet odio in? Nunc Amet urna scelerisque eu lectus placerat.</span></p>',NULL,NULL,'1',23),(24,'en','our-approach','Our Approach','',NULL,NULL,'<p><span>Pellentesque magna mi, iaculis pharetra eu, fermentum ullamcorper nisi. Integer fringilla magna ut quam vulputate erat. Pulvinar cum, ac eu augue ut sit amet gravida lacinia, eros massa condimentum sem, a fermentum ligula lorem non. Phasellus vulputate.</span></p>',NULL,NULL,'1',24),(25,'en','erwin-aligam','Erwin Aligam','',NULL,NULL,'<p><span>Co-founder &amp; Creative Director</span></p>',NULL,NULL,'1',25),(26,'en','uzumaki-naruto','Uzumaki Naruto','',NULL,NULL,'<p><span>Senior Webdesigner</span></p>',NULL,NULL,'1',26),(27,'en','haruno-sakura','Haruno Sakura','',NULL,NULL,'<p><span>Graphic Designer</span></p>',NULL,NULL,'1',27),(28,'en','uchiha-sasuke','Uchiha Sasuke','',NULL,NULL,'<p><span>Web Developer</span></p>',NULL,NULL,'1',28),(29,'en','nodejs','Node.js','',NULL,NULL,'<p><a href=\"http://nodejs.org\" target=\"_blank\">Node.js</a></p>',NULL,NULL,'1',29),(30,'en','coffeescript','CoffeeScript','',NULL,NULL,'<p><a href=\"http://www.coffeescript.org/\" target=\"_blank\">Coffeescript</a></p>',NULL,NULL,'1',30),(31,'en','more-about-us','More about us','',NULL,NULL,'<p><span>Nascetur augue hac platea enim, egestas pulvinar vut. Pulvinar cum, ac eu, tristie acus duis in dictumst non integer! Elit, sed scelerisque odio.</span></p>',NULL,NULL,'1',31),(32,'en','john-doe-xyz-company','JOHN DOE, XYZ COMPANY','',NULL,NULL,'<p><span>Donec sed odio dui. Nulla vitae elit libero, a pharetra augue. Nullam id dolor id nibh ultricies vehicula ut id elit.</span></p>',NULL,NULL,'1',32),(33,'en','jane-roe-abc-corps','JANE ROE, ABC CORPS','',NULL,NULL,'<p><span>Aenean lacinia bibendum nulla sed consectetur. Cras mattis consectetur purus sit amet fermentum.</span></p>',NULL,NULL,'1',33);
/*!40000 ALTER TABLE `article_lang` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_media`
--

DROP TABLE IF EXISTS `article_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_media` (
  `id_article` int(11) DEFAULT NULL,
  `id_media` int(11) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_media`
--

LOCK TABLES `article_media` WRITE;
/*!40000 ALTER TABLE `article_media` DISABLE KEYS */;
INSERT INTO `article_media` VALUES (6,1,NULL,NULL,1),(6,3,NULL,NULL,3),(6,4,NULL,NULL,4),(5,5,NULL,NULL,5),(7,6,NULL,NULL,6),(8,7,NULL,NULL,7),(9,8,NULL,NULL,8),(10,9,NULL,NULL,9),(11,10,NULL,NULL,10),(12,11,NULL,NULL,11),(13,12,NULL,NULL,12),(14,13,NULL,NULL,13),(15,14,NULL,NULL,14),(16,15,NULL,NULL,15),(17,16,NULL,NULL,16),(18,17,NULL,NULL,17),(19,18,NULL,NULL,18),(20,19,NULL,NULL,19),(12,22,NULL,NULL,22),(13,23,NULL,NULL,23),(15,24,NULL,NULL,24),(16,25,NULL,NULL,25),(17,26,NULL,NULL,26),(18,27,NULL,NULL,27),(19,28,NULL,NULL,28),(20,29,NULL,NULL,29),(25,30,NULL,NULL,30),(26,31,NULL,NULL,31),(27,32,NULL,NULL,32),(28,33,NULL,NULL,33);
/*!40000 ALTER TABLE `article_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `article_type`
--

DROP TABLE IF EXISTS `article_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `article_type` (
  `id_type` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `type_flag` int(11) DEFAULT NULL,
  `description` text,
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_type`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `article_type`
--

LOCK TABLES `article_type` WRITE;
/*!40000 ALTER TABLE `article_type` DISABLE KEYS */;
INSERT INTO `article_type` VALUES (1,'welcome_top',5,'Home page, top',1),(2,'welcome_slider',1,'',2),(3,'right_column',4,'',3),(4,'testimonials',2,'',4);
/*!40000 ALTER TABLE `article_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id_media` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `path` varchar(255) DEFAULT NULL,
  `base_path` varchar(255) DEFAULT NULL,
  `copyright` varchar(255) DEFAULT NULL,
  `container` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_media`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,'picture','slide1.png','files/slide1.png','files/',NULL,'','2012-04-11 23:06:22',NULL),(3,'picture','slide3.png','files/slide3.png','files/',NULL,'','2012-04-11 23:06:35',NULL),(4,'picture','slide2.png','files/slide2.png','files/',NULL,'','2012-04-11 23:12:39',NULL),(5,'picture','webdesign.png','files/webdesign.png','files/',NULL,'','2012-04-11 23:25:30',NULL),(6,'picture','webdevelopment.png','files/webdevelopment.png','files/',NULL,'','2012-04-11 23:25:35',NULL),(7,'picture','seo-services.png','files/seo-services.png','files/',NULL,'','2012-04-11 23:41:23',NULL),(8,'picture','print-design.png','files/print-design.png','files/',NULL,'','2012-04-11 23:41:29',NULL),(9,'picture','logo-design-and-branding.png','files/logo-design-and-branding.png','files/',NULL,'','2012-04-11 23:41:33',NULL),(10,'picture','newsletter.png','files/newsletter.png','files/',NULL,'','2012-04-11 23:41:38',NULL),(11,'picture','milk.jpg','files/milk.jpg','files/',NULL,'','2012-04-12 08:19:39',NULL),(12,'picture','hexagon.jpg','files/hexagon.jpg','files/',NULL,'','2012-04-12 08:19:43',NULL),(13,'picture','hillsong-united-aftermath.jpg','files/hillsong-united-aftermath.jpg','files/',NULL,'','2012-04-12 08:19:52',NULL),(14,'picture','dandelion.jpg','files/dandelion.jpg','files/',NULL,'','2012-04-12 08:19:56',NULL),(15,'picture','eiffel.jpg','files/eiffel.jpg','files/',NULL,'','2012-04-12 08:20:00',NULL),(16,'picture','clouds-and-rainbow.jpg','files/clouds-and-rainbow.jpg','files/',NULL,'','2012-04-12 08:20:05',NULL),(17,'picture','landscape.jpg','files/landscape.jpg','files/',NULL,'','2012-04-12 08:20:10',NULL),(18,'picture','sneakers.jpg','files/sneakers.jpg','files/',NULL,'','2012-04-12 08:20:20',NULL),(19,'picture','vector-flower-fullscreen.jpg','files/vector-flower-fullscreen.jpg','files/',NULL,'','2012-04-12 08:20:24',NULL),(22,'picture','milk_big.jpg','files/milk_big.jpg','files/',NULL,'','2012-04-12 08:49:20',NULL),(23,'picture','hexagon_big.jpg','files/hexagon_big.jpg','files/',NULL,'','2012-04-12 08:51:00',NULL),(24,'picture','dandelion_big.jpg','files/dandelion_big.jpg','files/',NULL,'','2012-04-12 08:51:17',NULL),(25,'picture','eiffel_big.jpg','files/eiffel_big.jpg','files/',NULL,'','2012-04-12 08:51:21',NULL),(26,'picture','clouds-and-rainbow_big.jpg','files/clouds-and-rainbow_big.jpg','files/',NULL,'','2012-04-12 08:51:26',NULL),(27,'picture','landscape_big.jpg','files/landscape_big.jpg','files/',NULL,'','2012-04-12 08:51:30',NULL),(28,'picture','sneakers_big.jpg','files/sneakers_big.jpg','files/',NULL,'','2012-04-12 08:51:39',NULL),(29,'picture','vector-flower-fullscreen_big.jpg','files/vector-flower-fullscreen_big.jpg','files/',NULL,'','2012-04-12 08:51:44',NULL),(30,'picture','thumb-pic.png','files/thumb-pic.png','files/',NULL,'','2012-04-12 11:37:31',NULL),(31,'picture','thumb-pic.png','files/thumb-pic.png','files/',NULL,'','2012-04-12 11:37:36',NULL),(32,'picture','thumb-pic.png','files/thumb-pic.png','files/',NULL,'','2012-04-12 11:37:39',NULL),(33,'picture','thumb-pic.png','files/thumb-pic.png','files/',NULL,'','2012-04-12 11:37:43',NULL);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu` (
  `id_menu` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu`
--

LOCK TABLES `menu` WRITE;
/*!40000 ALTER TABLE `menu` DISABLE KEYS */;
INSERT INTO `menu` VALUES (1,'main','Main Menu',1,1);
/*!40000 ALTER TABLE `menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page`
--

DROP TABLE IF EXISTS `page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page` (
  `id_page` int(11) NOT NULL AUTO_INCREMENT,
  `id_parent` int(11) DEFAULT NULL,
  `id_menu` int(11) DEFAULT NULL,
  `id_subnav` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `online` int(11) DEFAULT NULL,
  `home` int(11) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `view` varchar(255) DEFAULT NULL,
  `view_single` varchar(255) DEFAULT NULL,
  `article_list_view` varchar(255) DEFAULT NULL,
  `article_view` varchar(255) DEFAULT NULL,
  `article_order` varchar(255) DEFAULT NULL,
  `article_order_direction` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `link_type` varchar(255) DEFAULT NULL,
  `link_id` varchar(255) DEFAULT NULL,
  `pagination` int(11) DEFAULT NULL,
  `pagination_nb` int(11) DEFAULT NULL,
  `id_group` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_page`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page`
--

LOCK TABLES `page` WRITE;
/*!40000 ALTER TABLE `page` DISABLE KEYS */;
INSERT INTO `page` VALUES (1,0,1,0,'home-page',0,0,1,1,NULL,'page_default.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(2,0,1,0,'services',1,0,1,0,NULL,'page_services.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(3,0,1,0,'our-work',2,0,1,0,NULL,'page_portfolio.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(5,0,1,0,'about-us',3,0,1,0,NULL,'page_about.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(6,5,1,0,'more-about-us',2,1,1,0,NULL,'page_about.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(7,5,1,0,'our-team',0,1,1,0,NULL,'page_about.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(8,5,1,0,'links',1,1,1,0,NULL,'page_about.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5),(9,5,1,0,'testimonials',3,1,1,0,NULL,'page_about.eco',NULL,NULL,NULL,'0','0',NULL,NULL,'0',0,0,0,5);
/*!40000 ALTER TABLE `page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_article`
--

DROP TABLE IF EXISTS `page_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_article` (
  `id_page` int(11) DEFAULT NULL,
  `id_article` int(11) DEFAULT NULL,
  `online` int(11) DEFAULT NULL,
  `view` varchar(255) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  `id_type` int(11) DEFAULT NULL,
  `link_type` varchar(255) DEFAULT NULL,
  `link_id` int(11) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `main_parent` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_article`
--

LOCK TABLES `page_article` WRITE;
/*!40000 ALTER TABLE `page_article` DISABLE KEYS */;
INSERT INTO `page_article` VALUES (1,1,1,NULL,1,1,'',0,'',1,1),(1,2,1,NULL,3,NULL,'',0,'',1,2),(1,3,1,NULL,4,NULL,'',0,'',1,3),(1,4,1,NULL,5,NULL,'',0,'',1,4),(2,5,1,NULL,1,NULL,'',0,'',2,5),(1,6,1,NULL,2,2,'',0,'',1,6),(2,7,1,NULL,2,NULL,'',0,'',2,7),(2,8,1,NULL,3,NULL,'',0,'',2,8),(2,9,1,NULL,4,NULL,'',0,'',2,9),(2,10,1,NULL,5,NULL,'',0,'',2,10),(2,11,1,NULL,6,NULL,'',0,'',2,11),(3,12,1,NULL,1,NULL,'',0,'',3,12),(3,13,1,NULL,2,NULL,'',0,'',3,13),(3,14,1,NULL,3,NULL,'',0,'',3,14),(3,15,1,NULL,4,NULL,'',0,'',3,15),(3,16,1,NULL,5,NULL,'',0,'',3,16),(3,17,1,NULL,6,NULL,'',0,'',3,17),(3,18,1,NULL,7,NULL,'',0,'',3,18),(3,19,1,NULL,8,NULL,'',0,'',3,19),(3,20,1,NULL,9,NULL,'',0,'',3,20),(5,21,1,NULL,1,NULL,'',0,'',5,21),(5,22,1,NULL,2,NULL,'',0,'',5,22),(6,23,1,NULL,NULL,NULL,'',0,'',6,23),(6,24,1,NULL,NULL,NULL,'',0,'',6,24),(7,25,1,NULL,1,NULL,'',0,'',7,25),(7,26,1,NULL,2,NULL,'',0,'',7,26),(7,27,1,NULL,3,NULL,'',0,'',7,27),(7,28,1,NULL,4,NULL,'',0,'',7,28),(8,29,1,NULL,NULL,NULL,'',0,'',8,29),(8,30,1,NULL,NULL,NULL,'',0,'',8,30),(5,31,1,NULL,3,3,'',0,'',5,31),(9,32,1,NULL,NULL,NULL,'',0,'',9,32),(9,33,1,NULL,NULL,NULL,'',0,'',9,33);
/*!40000 ALTER TABLE `page_article` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `page_lang`
--

DROP TABLE IF EXISTS `page_lang`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `page_lang` (
  `id_page` int(11) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `lang` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `nav_title` varchar(255) DEFAULT NULL,
  `subnav_title` varchar(255) DEFAULT NULL,
  `meta_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `online` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `home` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `page_lang`
--

LOCK TABLES `page_lang` WRITE;
/*!40000 ALTER TABLE `page_lang` DISABLE KEYS */;
INSERT INTO `page_lang` VALUES (1,'home-page','en','','Home page',NULL,'','','',NULL,NULL,0,1,1),(2,'services','en','','Our Services.',NULL,'Services','','Our services',NULL,NULL,0,2,NULL),(3,'our-works','en','','Featured works.',NULL,'Our works','','Our works',NULL,NULL,0,3,NULL),(5,'about-us','en','','About us.',NULL,'About us','','About us',NULL,NULL,0,5,0),(6,'more-about-us','en','','More about us',NULL,'','','',NULL,NULL,0,6,0),(7,'our-team','en','','Our-team',NULL,'','','',NULL,NULL,0,7,0),(8,'links','en','','Links',NULL,'','','',NULL,NULL,0,8,0),(9,'testimonials','en','','Testimonials',NULL,'','','',NULL,NULL,1,9,NULL);
/*!40000 ALTER TABLE `page_lang` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-04-26 13:46:48

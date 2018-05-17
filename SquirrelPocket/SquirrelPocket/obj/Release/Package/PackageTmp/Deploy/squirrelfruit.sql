/*
Navicat MySQL Data Transfer
Source Host     : localhost:3306
Source Database : squirrelfruit
Target Host     : localhost:3306
Target Database : squirrelfruit
Date: 2016-10-09 14:01:40
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for t_delivery
-- ----------------------------
DROP TABLE IF EXISTS `t_delivery`;
CREATE TABLE `t_delivery` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderid` int(11) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `count` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;



-- ----------------------------
-- Table structure for t_deliveryfruits
-- ----------------------------
DROP TABLE IF EXISTS `t_deliveryfruits`;
CREATE TABLE `t_deliveryfruits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deliveryid` int(11) DEFAULT NULL,
  `fruitid` varchar(20) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for t_order
-- ----------------------------
DROP TABLE IF EXISTS `t_order`;
CREATE TABLE `t_order` (
  `orderid` int(11) NOT NULL AUTO_INCREMENT,
  `outtradeno` varchar(500) DEFAULT NULL,
  `transaction_id` varchar(500) DEFAULT NULL,
  `openid` varchar(200) DEFAULT NULL,
  `fruittype` varchar(200) DEFAULT NULL,
  `unitprice` varchar(200) DEFAULT NULL,
  `startdate` varchar(200) DEFAULT NULL,
  `enddate` varchar(200) DEFAULT NULL,
  `days` varchar(200) DEFAULT NULL,
  `count` varchar(200) DEFAULT NULL,
  `deliveryaddr` varchar(200) DEFAULT NULL,
  `user` varchar(200) DEFAULT NULL,
  `mp` varchar(200) DEFAULT NULL,
  `totalprice` varchar(200) DEFAULT NULL,
  `status` varchar(200) DEFAULT NULL,
  `createdate` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`orderid`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8;

-
-- ----------------------------
-- Table structure for t_orderfruts
-- ----------------------------
DROP TABLE IF EXISTS `t_orderfruts`;
CREATE TABLE `t_orderfruts` (
  `id` int(200) NOT NULL AUTO_INCREMENT,
  `orderid` int(11) DEFAULT NULL,
  `fruitid` varchar(255) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for t_user
-- ----------------------------
DROP TABLE IF EXISTS `t_user`;
CREATE TABLE `t_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `openid` varchar(200) DEFAULT NULL,
  `nickname` varchar(200) DEFAULT NULL,
  `headimgurl` varchar(2000) DEFAULT NULL,
  `country` varchar(500) DEFAULT NULL,
  `province` varchar(500) DEFAULT NULL,
  `city` varchar(500) DEFAULT NULL,
  `sex` varchar(20) DEFAULT NULL,
  `MP` varchar(20) DEFAULT NULL,
  `createddate` varchar(50) DEFAULT NULL,
  `lastlogindate` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

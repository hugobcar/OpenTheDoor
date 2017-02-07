-- MySQL dump 10.13  Distrib 5.5.44, for debian-linux-gnu (armv7l)
--
-- Host: localhost    Database: openthedoor
-- ------------------------------------------------------
-- Server version	5.5.44-0+deb8u1

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
-- Current Database: `openthedoor`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `openthedoor` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `openthedoor`;

--
-- Table structure for table `configuracoes`
--

DROP TABLE IF EXISTS `configuracoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `configuracoes` (
  `id_configuracao` int(1) NOT NULL AUTO_INCREMENT,
  `hr_inicial` varchar(4) NOT NULL,
  `hr_final` varchar(4) NOT NULL,
  `intervalo` int(2) NOT NULL,
  `bloquearfds` varchar(3) NOT NULL,
  PRIMARY KEY (`id_configuracao`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
  `id_device` int(3) NOT NULL AUTO_INCREMENT,
  `datahora` varchar(25) NOT NULL,
  `deviceId` varchar(100) NOT NULL DEFAULT '0',
  `nome` varchar(60) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `enable` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_device`),
  UNIQUE KEY `deviceId_unique` (`deviceId`),
  KEY `deviceId` (`deviceId`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `log_acoes_admanager`
--

DROP TABLE IF EXISTS `log_acoes_admanager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log_acoes_admanager` (
  `id_log` int(15) NOT NULL AUTO_INCREMENT,
  `id_acao` int(3) NOT NULL,
  `parametros` varchar(40) DEFAULT NULL,
  `parametros1` varchar(40) DEFAULT NULL,
  `usuario` varchar(40) DEFAULT NULL,
  `ip` varchar(15) NOT NULL,
  `datahora` int(15) NOT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id_log` bigint(15) NOT NULL AUTO_INCREMENT,
  `datahora` varchar(25) NOT NULL,
  `status` varchar(4) NOT NULL,
  `ip` varchar(15) NOT NULL,
  `id_device` int(3) NOT NULL DEFAULT '0',
  `msg` varchar(150) NOT NULL,
  `cod_msg` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_log`),
  KEY `ip` (`ip`),
  KEY `status` (`status`),
  KEY `datahora` (`datahora`),
  KEY `id_device` (`id_device`),
  KEY `cod_msg` (`cod_msg`)
) ENGINE=InnoDB AUTO_INCREMENT=2920 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `menu`
--

DROP TABLE IF EXISTS `menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menu` (
  `id_menu` int(3) NOT NULL AUTO_INCREMENT,
  `menu` varchar(15) NOT NULL,
  `link` varchar(60) NOT NULL,
  `contem_submenu` int(1) NOT NULL,
  `super` int(1) NOT NULL,
  `ativo` int(1) NOT NULL,
  PRIMARY KEY (`id_menu`),
  UNIQUE KEY `menu` (`menu`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `parametros`
--

DROP TABLE IF EXISTS `parametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `parametros` (
  `id_parametros` int(1) NOT NULL AUTO_INCREMENT,
  `nome_empresa` varchar(25) NOT NULL,
  `numero_tronco` bigint(11) NOT NULL,
  `tronco_saida` varchar(35) NOT NULL,
  `faixa_ramal` varchar(4) NOT NULL,
  `ramal_telefonista` int(4) NOT NULL,
  `ddr_chave` varchar(4) NOT NULL,
  `prefixo_bina` bigint(11) DEFAULT NULL,
  `ddr_operadora` int(1) NOT NULL,
  `operadora_celular` int(2) NOT NULL,
  `operadora_fixo` int(2) NOT NULL,
  `tempo_toquedial` int(2) NOT NULL,
  `email_erros` varchar(40) DEFAULT NULL,
  `disco_porcentagem` int(2) DEFAULT NULL,
  `aviso_sistemareiniciado` int(1) DEFAULT NULL,
  `mostrar_agendapublica` int(1) NOT NULL,
  `tempo_ramalagenda` int(2) NOT NULL,
  `discagens_ramalagenda` int(2) NOT NULL,
  `email_faxerro` varchar(40) DEFAULT NULL,
  `assinatura_fax` varchar(25) DEFAULT NULL,
  `voicemail_nome` varchar(35) DEFAULT NULL,
  `voicemail_email` varchar(40) DEFAULT NULL,
  `voicemail_assinatura` varchar(35) DEFAULT NULL,
  `prepago_diarenovacao` int(2) DEFAULT NULL,
  `servidor_smtp` varchar(40) DEFAULT NULL,
  `servidor_requerautenticacao` int(1) DEFAULT '0',
  `usuario_smtp` varchar(40) DEFAULT NULL,
  `senha_smtp` varchar(20) DEFAULT NULL,
  `email_smtp` varchar(40) DEFAULT NULL,
  `datahora` int(15) NOT NULL,
  PRIMARY KEY (`id_parametros`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plano_menu`
--

DROP TABLE IF EXISTS `plano_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plano_menu` (
  `id_planomenu` int(3) NOT NULL AUTO_INCREMENT,
  `id_menu` int(3) NOT NULL,
  PRIMARY KEY (`id_planomenu`),
  UNIQUE KEY `id_menu` (`id_menu`)
) ENGINE=MyISAM AUTO_INCREMENT=638 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plano_submenu`
--

DROP TABLE IF EXISTS `plano_submenu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plano_submenu` (
  `id_planosubmenu` int(3) NOT NULL AUTO_INCREMENT,
  `id_submenu` int(3) NOT NULL,
  `id_menu` int(3) NOT NULL,
  PRIMARY KEY (`id_planosubmenu`),
  UNIQUE KEY `id_submenu` (`id_submenu`)
) ENGINE=MyISAM AUTO_INCREMENT=510 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `submenu`
--

DROP TABLE IF EXISTS `submenu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `submenu` (
  `id_submenu` int(4) NOT NULL AUTO_INCREMENT,
  `submenu` varchar(30) NOT NULL,
  `link` varchar(60) NOT NULL,
  `prefixo_arquivos` varchar(60) NOT NULL,
  `ativo` int(1) NOT NULL,
  `super` int(1) NOT NULL,
  `id_menu` int(3) NOT NULL,
  PRIMARY KEY (`id_submenu`)
) ENGINE=MyISAM AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuario_admanager`
--

DROP TABLE IF EXISTS `usuario_admanager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario_admanager` (
  `id_usuario` int(3) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(15) NOT NULL,
  `senha` varchar(20) NOT NULL,
  `nome` varchar(45) DEFAULT NULL,
  `slack` varchar(60) NOT NULL,
  `nivel` varchar(1) NOT NULL,
  `datahora` int(15) NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `usuario` (`usuario`)
) ENGINE=MyISAM AUTO_INCREMENT=252 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuario_menu`
--

DROP TABLE IF EXISTS `usuario_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario_menu` (
  `id_usuariomenu` int(3) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(3) NOT NULL,
  `id_menu` int(3) NOT NULL,
  PRIMARY KEY (`id_usuariomenu`)
) ENGINE=MyISAM AUTO_INCREMENT=655 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuario_submenu`
--

DROP TABLE IF EXISTS `usuario_submenu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario_submenu` (
  `id_usuariosubmenu` int(3) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(3) NOT NULL,
  `id_submenu` int(3) NOT NULL,
  `id_menu` int(3) NOT NULL,
  PRIMARY KEY (`id_usuariosubmenu`)
) ENGINE=MyISAM AUTO_INCREMENT=1838 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-07 14:54:19

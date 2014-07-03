-- phpMyAdmin SQL Dump
-- version 3.2.4
-- http://www.phpmyadmin.net
--
-- Serveur: localhost
-- Généré le : Mer 02 Juillet 2014 à 12:55
-- Version du serveur: 5.1.44
-- Version de PHP: 5.3.1

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `database`
--

-- --------------------------------------------------------

--
-- Structure de la table `photos`
--

CREATE TABLE IF NOT EXISTS `photos` (
  `idphoto` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `title` varchar(40) NOT NULL,
  `type` varchar(40) NOT NULL,
  PRIMARY KEY (`idphoto`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Contenu de la table `photos`
--


-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `iduser` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL,
  `firstname` varchar(40) NOT NULL,
  `lastname` varchar(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `birthdate` date NOT NULL,
  `adress1` varchar(45) NOT NULL,
  `adress2` varchar(45) NOT NULL,
  `country` varchar(35) NOT NULL,
  `zipcode` int(5) unsigned NOT NULL,
  `city` varchar(45) NOT NULL,
  `lastconnection` datetime NOT NULL,
  `connected` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`iduser`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Contenu de la table `users`
--

INSERT INTO `users` (`iduser`, `username`, `password`, `firstname`, `lastname`, `email`, `birthdate`, `adress1`, `adress2`, `country`, `zipcode`, `city`, `lastconnection`, `connected`) VALUES
(1, 'user1', '.qÃ[Â“Ã‹Â€ÃÃ½hÃ©Ã¨ÂÂ‡ÂÂŸ', 'User1-firstname', 'USER1-lastname', 'user1@mail.com', '2011-01-01', 'user1 adressLine1', 'user1 adressLine2', 'FR', 75000, 'PARIS', '2014-06-29 13:10:00', 0),
(2, 'user2', '.qÃ[Â“Ã‹Â€ÃÃ½hÃ©Ã¨ÂÂ‡ÂÂŸ', '', '', 'user2@mail.com', '0000-00-00', '', '', '', 0, '', '0000-00-00 00:00:00', 0),
(3, 'user3', '.qÃ[Â“Ã‹Â€ÃÃ½hÃ©Ã¨ÂÂ‡ÂÂŸ', '', '', 'user3@mail.com', '0000-00-00', '', '', '', 0, '', '0000-00-00 00:00:00', 0),
(4, 'user4', '.qÃ[Â“Ã‹Â€ÃÃ½hÃ©Ã¨ÂÂ‡ÂÂŸ', '', '', 'user4@mail.com', '0000-00-00', '', '', '', 0, '', '0000-00-00 00:00:00', 0),
(5, 'user5', '.qÃ[Â“Ã‹Â€ÃÃ½hÃ©Ã¨ÂÂ‡ÂÂŸ', '', '', 'user5@mail.com', '0000-00-00', '', '', '', 0, '', '0000-00-00 00:00:00', 0),
(6, 'user6', '.qÃ[Â“Ã‹Â€ÃÃ½hÃ©Ã¨ÂÂ‡ÂÂŸ', 'Georges', 'DUPONT', 'gdupont@mail.com', '0000-00-00', '', '', 'US', 0, 'LAS VEGAS', '0000-00-00 00:00:00', 0);

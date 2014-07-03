MyWebService
============

App using SQL database on web server for user/password connection

(English translation coming soon...)

# Avant propos

Je tiens à préciser que j’ai développé cette application en travaillant seul chez moi avec une connexion internet. Cela fait maintenant plus d’un an que j’utilise Xcode et j’ai commencé avec de simples bases en langage C et C++, c’est pourquoi je vous demande d’être indulgent s’il vous plait :blush:
Mais je reste attentif à toutes remarques (cf. Contact) et bien évidemment je serai ravi d’avoir un peu d’aide (cf. Participer).

Pourquoi MyWebService ? Tout a commencé en voulant porter un ancien projet PHP sur application iOS, et ce projet utilise une base SQL… Dès lors j’ai commencé à chercher sur internet pour finalement ne pas trouver grand choses, si ce n’est un résultat récurrent : AFNetworking (Merci les gars, bon boulot !). J’ai donc consultés tutoriels et beaucoup d’exemple de code, puis j’ai décidé de créer un projet « coquille » avec une base SQL incluant des tables d’utilisateurs pour se connecter… C’est à ce moment que MyWebService est née ! :smirk:

# Introduction

MyWebService est un exemple d’application qui se connecte à un serveur web  regroupant une base de données SQL et un serveur FTP. 
Elle a pour principale fonctionnalité de communiquer avec une base de données SQL via un encodage au format JSON des données transférées.


![Image](/readme-image/SchemaFlux.png)

•	Fonctionnalités essentielles :
-	Connexion à une base SQL
-	Enregistrer de nouvelles données dans une base SQL
-	Modifier, lire et supprimer des données dans une base SQL
-	Télécharger, lire et supprimer une image sur un serveur FTP 

•	Fonctionnalités importantes :
-	Créer un utilisateur dans la base de données
-	Se connecter via mes identifiants créés au préalable
-	Consulter la liste de tous les utilisateurs
-	Trier la liste des utilisateurs (nom, date, connectés)
-	Lire les informations des autres utilisateurs
-	Modifier mes informations de profil
-	Ajouter ou supprimer une photo de profil
-	Apparaître en ligne ou non auprès des autres utilisateurs
-	Bouton UISwitch permettant de se souvenir de l’utilisateur
-	Animation du logo dans la vue de connexion

•	Utilisation du système ARC (Automatic Reference Counting)  et de l’Auto Layout

![Image](/readme-image/MainStoryboard.png)

•	Exclusivité iPad avec orientation en mode paysage pour simplifier la programmation

•	Incorporation et utilisation de divers projets (cf. Remerciements) :
-	AFNetworking 2.0 (par Scott Raymond et Mattt Thompson)
-	CountryPicker (par Nick Lockwood)
-	Reachability (par Apple)
-	SVProgressHUD (par Sam Vermette)
-	UIImage+Alpha+Resize+RoundedCorner (par Trevor Harmon)

#Prérequis

Pour commencer il est indispensable d’avoir un serveur web et bien évidemment d’une connexion réseau ou internet reliant l’iPad à ce serveur.

##Serveur Web
Votre serveur web doit contenir les 3 fonctionnalités suivantes :

1.	phpMyAdmin
2.	Serveur FTP
3.	MySQL

Je vous conseille de commencer par installer un logiciel tel que XAMPP ou MAMP sur votre Mac pour effectuer des tests avant de le mettre en place sur un serveur distant.
Ces logiciels ont pour fonctions de créer un serveur web sur votre machine avec les 3 fonctionnalités précédentes.

##Adresse IP ou nom de domaine du serveur

•	Dans le cas où vous auriez suivi mon conseil précédemment, vous devez impérativement bien prendre note de l’adresse IP de votre serveur web, autrement dit  l’adresse IP de votre ordinateur sur lequel vous avez installé le logiciel XAMPP, MAMP ou autre…
Pour ce faire il vous suffit de noter l’adresse de type 192.168.1.2 affichée dans les préférences réseau de votre Mac.

•	Si vous avez décidé de ne pas suivre mon conseil en mettant un nom de domaine à votre serveur web, c’est que vous devez déjà « toucher votre bille » en réseau et je vous conseille simplement de bien prendre note du chemin d’accès web.

# Installation

##Modification sur serveur

On commence par effectuer des modifications sur le serveur web récemment installé. Dans un premier temps il faut copier les fichiers PHP sur le serveur, et dans un deuxième temps, importer la base SQL via phpMyAdmin.

##Copier les fichiers PHP

1.	Ouvrir le dossier du projet
2.	Copier le dossier « mywebservice »
3.	Coller le dans le dossier « /htdocs » du serveur web
4.	Créer un dossier « upload »  s’il est inexistant
5.	Aller dans les propriétés du dossier « upload » et changer l’accès en lecture et écriture pour tous

![Image](/readme-image/FichiersPHP.png)

PS : Ne pas oublier de bien activer l’accès au serveur FTP !

##Importer la base SQL

1.	Ouvrir le dossier  du projet
2.	Vérifier que le fichier « database.sql » soit bien présent
3.	Démarrer votre navigateur web et connecté vous à phpMyAdmin
4.	Sélectionner l’onglet « Importer » en haut à droite
5.	Choisir le fichier « database.sql » et exécuter l’importation de la base

![Image](/readme-image/BaseSQL.png)

[PHP] 

La connexion entre la base SQL et les fichiers PHP s’effectue dans le fichier « lib.php ». Vérifier que les données renseignées correspondent avec les utilisateurs de votre base SQL (sélectionner l’onglet « Privilèges »). 

##Modification sur l’application (Xcode)

Ces modifications sont indispensables dans la mesure où elles permettent de renseigner le chemin réseau à emprunter pour communiquer avec le serveur web.

###Modification de l’URL du serveur web dans le fichier API.m

[Xcode]

C’est ici qu’il faut renseigner l’adresse IP ou le nom de domaine du serveur web ; celui que j’ai précédemment demandé de bien noter ☺

###Modification de la clé de sécurité dans le fichier API.h

[Xcode]

```objective-c
// Cryptage Key (= 45 char.)
#define kSalt @"Choose%a%new%key%here%:%change%it%by%your%key"
```

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```


Il est possible de changer la clé de sécurité permettant de crypter les mots de passe, il suffit de changer la ligne ci-dessus.

ATTENTION !! Si vous changer cette clé de sécurité TOUS les utilisateurs ayant déjà été enregistrés ne pourront plus se connecter, et leur compte deviendront inutilisables !!

Il est donc recommandé de vider les tables « photos » et « users » avant tout changement de clé de sécurité.

#Utilisation

##LoginViewController : se connecter

Il s’agit de la première vue lorsque l’on démarre l’application, elle permet de s’identifier pour se connecter et démarrer une session.

Si vous n’avez pas changé la clé de sécurité (cf. ci-dessus), il vous est possible de vous connecter avec les identifiants suivant :

•	Username = user1

•	Password = password

Des utilisateurs témoins sont déjà renseignés, ils possèdent tous le même mot de passe, seuls leurs noms changent.

![Image](/readme-image/loginViewController.png)

Pour ceux ayant changé de clé de sécurité vous n’avez pas d’autres choix que d’enregistrer de nouveaux utilisateurs. Pour ce faire cliquer sur le bouton « Register »

##RegisterViewController : s’enregistrer

Cette vue permet d’enregistrer de nouveaux utilisateurs, seuls les champs indiqués d’un astérisque sont obligatoires (username, password, email adress).

![Image](/readme-image/RegisterViewController.png)

##TabBarController : ajouter une nouvelle vue

C’est le menu apparaissant en bas de l’écran lorsque l’on est connecté, il regroupe les différentes vues associées sous forme d’onglet de navigation.

Si l’on souhaite ajouter une nouvelle vue, permettant d’effectuer des requêtes SQL lorsque l’utilisateur est connecté,  c’est avec ce TabBarController qu’il faut créer une liaison. Pour cela il suffit de faire un clique droit sur la nouvelle vue, de rester appuyé, de glisser sur le TabBarController, lâcher le clique droit, et sélectionner « Relationship Segue : view controllers ».

![Image](/readme-image/TabBarController.png)

PS : Ne pas oublier d’ajouter « api.h » en entête des pages Xcode qui exécutent des requêtes vers le serveur web.

#Exemple d’un requête SQL

##1. Fichier « index.php »
Ouvrer le fichier et modifier le de la façon suivante :

[PHP]

Ce fichier va permettre d’appeler une fonction, selon le POST, dans laquelle sera exécuter la requête SQL

##2. Fichier « api.php »
Modifier le fichier comme suit :

[PHP]

C’est ici que la requête SQL est défini et exécutée dans une fonction.

##3. Xcode
Créer un bouton sur la vue « MyProfil » associer le en tant qu’action au fichier « MyProfilViewController.h » (clique droit, glisser, id= action).
Ci-dessous une image du résultat :

[Xcode]

Ensuite dans « MyProfilViewController.h » aller tout en bas et ajouter ce qu’il manque :

[Xcode]

#Remerciements

Je remercie internet et tous ceux qui en font une plateforme libre en partageant leurs idées et leurs créations.

Merci particulièrement à tous les développeurs suivants : Scott Raymond, Mattt Thompson, Nick Lockwood, Apple, Sam Vermette,  Trevor Harmon, et beaucoup d’autres proposant des tutoriels ou des exemples de code sur internet.

Et surtout je vous remercie de votre intérêt pour ce projet. :wink:

#Contact

###[Viadeo](http://www.viadeo.com/fr/profile/alexis.renart)

###[LinkedIn](fr.linkedin.com/pub/alexis-renart/72/59a/64b/)

###dev.alexis.renart@gmail.com

#Participer

Il vous est possible de participer à l’évolution du projet, pour cela n’hésitez pas à me contacter par mail et me faire part de vos remarques, de vos conseils et de lignes de code.

Si votre participation contribue à faire évoluer le projet, à l’optimiser, votre nom ainsi que votre mail (si vous le souhaitez) apparaitront dans le projet en tant que collaborateurs.

#Licence  et copyright

Le Logo BlueFox est un logo sous copyright. Merci de ne pas copier, modifier, fusionner, publier, distribuer, ou vendre ce logo.

*Copyright (c) 2014 Alexis RENART (dev.alexis.renart@gmail.com)*

MyWebService est disponible sous une licence CeCILL-C.  (Voir le fichier de licence pour plus d’informations.)

*« CeCILL-C est une licence bien adaptée à la distribution de bibliothèques et plus généralement de composants logiciels. Tout distributeur d'une application incorporant des logiciels régis par CeCILL-C doit mettre à disposition de la communauté et soumettre à cette licence les modifications apportées à leur code source tout en gardant la liberté de choisir une autre licence pour le reste de son application. »* http://www.cecill.info/









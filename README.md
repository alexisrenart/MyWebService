MyWebService
============

App using SQL database on web server for user/password connection

(English translation comming soon...)

# Avant propos

Je tiens à préciser que j’ai développé cette application en travaillant seul chez moi avec une connexion internet. Cela fait maintenant plus d’un an que j’utilise Xcode et j’ai commencé avec de simples bases en langage C et C++, c’est pourquoi je vous demande d’être indulgent s’il vous plait ☺ 
Mais je reste attentif à toutes remarques (cf. Contact) et bien évidemment je serai ravi d’avoir un peu d’aide (cf. Participer).

Pourquoi MyWebService ? Tout a commencé en voulant porter un ancien projet PHP sur application iOS, et ce projet utilise une base SQL… Dès lors j’ai commencé à chercher sur internet pour finalement ne pas trouver grand choses, si ce n’est un résultat récurrent : AFNetworking (Merci les gars, bon boulot !). J’ai donc consultés tutoriels et beaucoup d’exemple de code, puis j’ai décidé de créer un projet « coquille » avec une base SQL incluant des tables d’utilisateurs pour se connecter… C’est à ce moment que MyWebService est née !

# Introduction

MyWebService est un exemple d’application qui se connecte à un serveur web  regroupant une base de données SQL et un serveur FTP. 
Elle a pour principale fonctionnalité de communiquer avec une base de données SQL via un encodage au format JSON des données transférées.


![Image](../readme-image/SchemaFlux.png)

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


## titre 2

### titre

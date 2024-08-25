<!--
╔════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                    ║
║   Copyright (c) 2020 https://prrvchr.github.io                                     ║
║                                                                                    ║
║   Permission is hereby granted, free of charge, to any person obtaining            ║
║   a copy of this software and associated documentation files (the "Software"),     ║
║   to deal in the Software without restriction, including without limitation        ║
║   the rights to use, copy, modify, merge, publish, distribute, sublicense,         ║
║   and/or sell copies of the Software, and to permit persons to whom the Software   ║
║   is furnished to do so, subject to the following conditions:                      ║
║                                                                                    ║
║   The above copyright notice and this permission notice shall be included in       ║
║   all copies or substantial portions of the Software.                              ║
║                                                                                    ║
║   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                  ║
║   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                  ║
║   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.        ║
║   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY             ║
║   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,             ║
║   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE       ║
║   OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                    ║
║                                                                                    ║
╚════════════════════════════════════════════════════════════════════════════════════╝
-->
# [![JaybirdOOo logo][1]][2] Documentation

**This [document][3] in English.**

**L'utilisation de ce logiciel vous soumet à nos [Conditions d'utilisation][4].**

# version [1.0.3][5]

## Introduction:

**JaybirdOOo** fait partie d'une [Suite][6] d'extensions [LibreOffice][7] ~~et/ou [OpenOffice][8]~~ permettant de vous offrir des services inovants dans ces suites bureautique.  

Cette extension vous permet d'utiliser la base de données [Firebird][9] en mode intégré, rendant la base de donnée portable (un seul fichier odb).  
Elle permet de profiter des propriétés [ACID][10] de la base de données [Firebird][11] sous jancente.

**Cette implémentation utilise Jaybird 6.0.0 qui est une version non finalisée. Veuillez utiliser avec précaution.**

Etant un logiciel libre je vous encourage:
- A dupliquer son [code source][12].
- A apporter des modifications, des corrections, des améliorations.
- D'ouvrir un [dysfonctionnement][13] si nécessaire.

Bref, à participer au developpement de cette extension.  
Car c'est ensemble que nous pouvons rendre le Logiciel Libre plus intelligent.

___

## Prérequis:

L'extension JaybirdOOo utilise l'extension jdbcDriverOOo pour fonctionner.  
Elle doit donc répondre aux [prérequis de l'extension jdbcDriverOOo][14].

**Seul LibreOffice 24.2.x ou supérieur est pris en charge.**

L'utilisation de Jaybird 6.0.0 nécessite un JRE **[Java version 17][15] ou supérieure.**

___

## Installation:

Il semble important que le fichier n'ait pas été renommé lors de son téléchargement.  
Si nécessaire, renommez-le avant de l'installer.

- [![jdbcDriverOOo logo][17]][18] Installer l'extension **[jdbcDriverOOo.oxt][19]** [![Version][20]][19]

    Cette extension est nécessaire pour utiliser Firebird avec toutes ses fonctionnalités.

- ![JaybirdOOo logo][21] Installer l'extension **[JaybirdOOo.oxt][22]** [![Version][23]][22]

Redémarrez LibreOffice après l'installation.  
**Attention, redémarrer LibreOffice peut ne pas suffire.**
- **Sous Windows** pour vous assurer que LibreOffice redémarre correctement, utilisez le Gestionnaire de tâche de Windows pour vérifier qu'aucun service LibreOffice n'est visible après l'arrêt de LibreOffice (et tuez-le si ç'est le cas).
- **Sous Linux ou macOS** vous pouvez également vous assurer que LibreOffice redémarre correctement, en le lançant depuis un terminal avec la commande `soffice` et en utilisant la combinaison de touches `Ctrl + C` si après l'arrêt de LibreOffice, le terminal n'est pas actif (pas d'invité de commande).

___

## Utilisation:

### Comment créer une nouvelle base de données:

Dans LibreOffice / OpenOffice aller à: Fichier -> Nouveau -> Base de données...:

![JaybirdOOo screenshot 1][24]

A l'étape: Sélectionner une base de données:
- selectionner: Créer une nouvelle base de données
- Dans: Base de données intégrée: choisir: **Pilote Firebird intégré**
- cliquer sur le bouton: Suivant

![JaybirdOOo screenshot 2][25]

A l'étape: Enregistrer et continuer:
- ajuster les paramètres selon vos besoins...
- cliquer sur le bouton: Terminer

![JaybirdOOo screenshot 3][26]

Maintenant à vous d'en profiter...

___

## Comment ça marche:

JaybirdOOo est un service [com.sun.star.sdbc.Driver][27] UNO écrit en Python.  
Il s'agit d'une surcouche à l'extension [jdbcDriverOOo][18] permettant de stocker la base de données Firebird dans un fichier odb (qui est, en fait, un fichier compressé).

Son fonctionnement est assez basique, à savoir:

- Lors d'une demande de connexion, plusieurs choses sont faites:
  - S'il n'existe pas déjà, un **sous-répertoire** avec le nom: `.` + `nom_du_fichier_odb` + `.lck` est créé à l'emplacement du fichier odb dans lequel tous les fichiers Firebird sont extraits du répertoire **database** du fichier odb (décompression).
  - L'extension [jdbcDriverOOo][18] est utilisée pour obtenir l'interface [com.sun.star.sdbc.XConnection][28] à partir du chemin du **sous-répertoire** + `/jaybird`.
  - Si la connexion réussi, un [DocumentHandler][29] est ajouté en tant que [com.sun.star.util.XCloseListener][30] et [com.sun.star.document.XStorageChangeListener][31] au fichier odb.
  - Si la connexion échoue et que les fichiers ont été extraits lors de la phase 1, le **sous-répertoire** est supprimé.
- Lors de la fermeture ou du changement de nom (Enregistrer sous) du fichier odb, si la connexion a réussi, le [DocumentHandler][29] copie tous les fichiers présents dans le **sous-répertoire** dans le (nouveau) répertoire **database** du fichier odb (zip), puis supprime le **sous-répertoire**.

Le but principal de ce mode de fonctionnement est de profiter des caractéristiques ACID de la base de données sous-jacente en cas de fermeture anormale de LibreOffice.
En contre partie, la fonction: **fichier -> Sauvegarder** n'a **aucun effet sur la base de données sous jacente**. Seul la fermeture du fichier odb ou son enregistrement sous un nom different (Fichier -> Enregistrer sous) effectura la sauvegarde de la base de donnée dans le fichier odb.

___

## A été testé avec:

* LibreOffice 24.2.1.2 (x86_64)- Windows 10

* LibreOffice 24.2.1.2 - Lubuntu 22.04

Je vous encourage en cas de problème :confused:  
de créer un [dysfonctionnement][13]  
J'essaierai de le résoudre :smile:

___

## Historique:

### Ce qui a été fait pour la version 1.0.0:

- Tout d'abord je tiens à remercier [rotteveel][32] pour [l'amélioration #629][33] qui a permis de publier cette extension.
- Cette extension est basée sur la [correction #154989][34] disponible depuis LibreOffice 24.2.x. Elle peut donc fonctionner avec les autres extensions proposant des services de bases de données intégrées.
- JaybirdOOo nécessite **LibreOffice 24.2.x** et **Java 17** au minimum. Il se chargera pour l'url: `sdbc:embedded:jaybird`.

### Ce qui a été fait pour la version 1.0.1:

- Support de la nouvelle version 1.4.0 de jdbcDriverOOo.
- L'utilisation de fichiers odb créés avec une version précédente de JaybirdOOo, nécessite de modifier le paramètre : `Requête des valeurs générées` accessible par le menu : **Edition -> Base de données -> Paramètres avancés... -> Valeurs générées** par la valeur : `SELECT * FROM %s WHERE %s`.

### Ce qui a été fait pour la version 1.0.2:

- Mise à jour du paquet [Python packaging][35] vers la version 24.1.
- Mise à jour du paquet [Python setuptools][36] vers la version 72.1.0.
- L'extension vous demandera d'installer l'extensions jdbcDriverOOo en version 1.4.2 minimum.

### Ce qui a été fait pour la version 1.0.3:

- Mise à jour du paquet [Python setuptools][36] vers la version 73.0.1.
- La journalisation accessible dans les options de l’extension s’affiche désormais correctement sous Windows.

### Que reste-t-il à faire pour la version 1.0.3:

- Ajouter de nouvelles langue pour l'internationalisation...

- Tout ce qui est bienvenu...

[1]: </img/jaybird.svg#collapse>
[2]: <https://prrvchr.github.io/JaybirdOOo/>
[3]: <https://prrvchr.github.io/JaybirdOOo/>
[4]: <https://prrvchr.github.io/JaybirdOOo/source/JaybirdOOo/registration/TermsOfUse_fr>
[5]: <https://prrvchr.github.io/JaybirdOOo/README_fr#historique>
[6]: <https://prrvchr.github.io/README_fr>
[7]: <https://fr.libreoffice.org/download/telecharger-libreoffice/>
[8]: <https://www.openoffice.org/fr/Telecharger/>
[9]: <https://www.firebirdsql.org/>
[10]: <https://en.wikipedia.org/wiki/ACID>
[11]: <https://firebirdsql.org/file/documentation/papers_presentations/html/fr/paper-fbent-acid-fr.html>
[12]: <https://github.com/prrvchr/JaybirdOOo/>
[13]: <https://github.com/prrvchr/JaybirdOOo/issues/new>
[14]: <https://prrvchr.github.io/jdbcDriverOOo/README_fr#pr%C3%A9requis>
[15]: <https://adoptium.net/fr/temurin/archive/?version=17>
[17]: <https://prrvchr.github.io/jdbcDriverOOo/img/jdbcDriverOOo.svg#middle>
[18]: <https://prrvchr.github.io/jdbcDriverOOo/README_fr>
[19]: <https://github.com/prrvchr/jdbcDriverOOo/releases/latest/download/jdbcDriverOOo.oxt>
[20]: <https://img.shields.io/github/v/tag/prrvchr/jdbcDriverOOo?label=latest#right>
[21]: <img/JaybirdOOo.svg#middle>
[22]: <https://github.com/prrvchr/JaybirdOOo/releases/latest/download/JaybirdOOo.oxt>
[23]: <https://img.shields.io/github/downloads/prrvchr/JaybirdOOo/latest/total?label=v1.0.3#right>
[24]: <img/JaybirdOOo-1_fr.png>
[25]: <img/JaybirdOOo-2_fr.png>
[26]: <img/JaybirdOOo-3_fr.png>
[27]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/sdbc/Driver.html>
[28]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/sdbc/XConnection.html>
[29]: <https://github.com/prrvchr/JaybirdOOo/blob/main/uno/lib/uno/embedded/documenthandler.py>
[30]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/util/XCloseListener.html>
[31]: <http://www.openoffice.org/api/docs/common/ref/com/sun/star/document/XStorageChangeListener.html>
[32]: <https://github.com/mrotteveel>
[33]: <https://github.com/FirebirdSQL/jaybird/issues/629>
[34]: <https://gerrit.libreoffice.org/c/core/+/154989>
[35]: <https://pypi.org/project/packaging/>
[36]: <https://pypi.org/project/setuptools/>

<!--
╔════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                    ║
║   Copyright (c) 2020-25 https://prrvchr.github.io                                  ║
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

# version [1.1.3][5]

## Introduction:

**JaybirdOOo** fait partie d'une [Suite][6] d'extensions [LibreOffice][7] ~~et/ou [OpenOffice][8]~~ permettant de vous offrir des services inovants dans ces suites bureautique.  

Cette extension vous permet d'utiliser la base de données [Firebird][9] en mode intégré, rendant la base de donnée portable (un seul fichier odb).  
Elle permet de profiter des propriétés [ACID][10] de la base de données [Firebird][11] sous jancente.

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
Elle nécessite que l'extension jdbcDriverOOo soit configurée pour charger les pilotes JDBC dans le ClassPath de Java comme c'est le cas par défaut.

Le pilote Java sous jacent [Jaybird][15] utilise pour son fonctionnement en mode intégré l'archive Java [JaybirdEmbedded][16] qui permet d'émuler la présence d'un [Serveur Firebird 5.0.3][17] pour les architectures Windows et Linux en x86 64 bits.  
Pour toutes autres architectures vous devez installer le [Serveur Firebird 5.x][17] correspondant à votre architecture.

De plus, en raison du [dysfonctionnement #156471][18] et suivant le [PR#154989][19], l'extension JaybirdOOo nécessite **LibreOffice version 24.2.x** minimum pour fonctionner.

___

## Installation:

Il semble important que le fichier n'ait pas été renommé lors de son téléchargement.  
Si nécessaire, renommez-le avant de l'installer.

- [![jdbcDriverOOo logo][20]][21] Installer l'extension **[jdbcDriverOOo.oxt][22]** [![Version][23]][22]

    Cette extension est nécessaire pour utiliser Firebird avec toutes ses fonctionnalités.

- ![JaybirdOOo logo][24] Installer l'extension **[JaybirdOOo.oxt][25]** [![Version][26]][25]

Redémarrez LibreOffice après l'installation.  
**Attention, redémarrer LibreOffice peut ne pas suffire.**
- **Sous Windows** pour vous assurer que LibreOffice redémarre correctement, utilisez le Gestionnaire de tâche de Windows pour vérifier qu'aucun service LibreOffice n'est visible après l'arrêt de LibreOffice (et tuez-le si ç'est le cas).
- **Sous Linux ou macOS** vous pouvez également vous assurer que LibreOffice redémarre correctement, en le lançant depuis un terminal avec la commande `soffice` et en utilisant la combinaison de touches `Ctrl + C` si après l'arrêt de LibreOffice, le terminal n'est pas actif (pas d'invité de commande).

Après avoir redémarré LibreOffice, vous pouvez vous assurer que l'extension et son pilote sont correctement installés en vérifiant que le pilote `io.github.prrvchr.JaybirdOOo.Driver` est répertorié dans le **Pool de Connexions**, accessible via le menu: **Outils -> Options -> LibreOffice Base -> Connexions**. Il n'est pas nécessaire d'activer le pool de connexions.

Si le pilote n'est pas répertorié, la raison de l'échec du chargement du pilote peut être trouvée dans la journalisation de l'extension. Cette journalisation est accessible via le menu: **Outils -> Options -> LibreOffice Base -> Pilote Jaybird intégré -> Options de journalisation**.  
La journalisation `JaybirdLogger` doit d'abord être activée, puis LibreOffice redémarré pour obtenir le message d'erreur dans le journal.

___

## Utilisation:

### Comment créer une nouvelle base de données:

Dans LibreOffice / OpenOffice aller à: Fichier -> Nouveau -> Base de données...:

![JaybirdOOo screenshot 1][27]

A l'étape: Sélectionner une base de données:
- selectionner: Créer une nouvelle base de données
- Dans: Base de données intégrée: choisir: **Pilote Jaybird intégré**
- cliquer sur le bouton: Suivant

![JaybirdOOo screenshot 2][28]

A l'étape: Enregistrer et continuer:
- ajuster les paramètres selon vos besoins...
- cliquer sur le bouton: Terminer

![JaybirdOOo screenshot 3][29]

Maintenant à vous d'en profiter...

___

## Comment ça marche:

JaybirdOOo est un service [com.sun.star.sdbc.Driver][30] UNO écrit en Python.  
Il s'agit d'une surcouche à l'extension [jdbcDriverOOo][21] permettant de stocker la base de données Firebird dans un fichier odb (qui est, en fait, un fichier compressé).

Son fonctionnement est assez basique, à savoir:

- Lors d'une demande de connexion, plusieurs choses sont faites:
  - S'il n'existe pas déjà, un **sous-répertoire** avec le nom: `.` + `nom_du_fichier_odb` + `.lck` est créé à l'emplacement du fichier odb dans lequel tous les fichiers Firebird sont extraits du répertoire **database** du fichier odb (décompression).
  - L'extension [jdbcDriverOOo][21] est utilisée pour obtenir l'interface [com.sun.star.sdbc.XConnection][31] à partir du chemin du **sous-répertoire** + `/jaybird`.
  - Si la connexion réussi, un [DocumentHandler][32] est ajouté en tant que [com.sun.star.util.XCloseListener][33] et [com.sun.star.document.XStorageChangeListener][34] au fichier odb.
  - Si la connexion échoue et que les fichiers ont été extraits lors de la phase 1, le **sous-répertoire** est supprimé.
- Lors de la fermeture ou du changement de nom (Enregistrer sous) du fichier odb, si la connexion a réussi, le [DocumentHandler][32] copie tous les fichiers présents dans le **sous-répertoire** dans le (nouveau) répertoire **database** du fichier odb (zip), puis supprime le **sous-répertoire**.

Le but principal de ce mode de fonctionnement est de profiter des caractéristiques ACID de la base de données sous-jacente en cas de fermeture anormale de LibreOffice.
En contre partie, la fonction: **fichier -> Sauvegarder** n'a **aucun effet sur la base de données sous jacente**. Seul la fermeture du fichier odb ou son enregistrement sous un nom different (Fichier -> Enregistrer sous) effectura la sauvegarde de la base de donnée dans le fichier odb.

___

## Comment créer l'extension:

Normalement, l'extension est créée avec Eclipse pour Java et [LOEclipse][35]. Pour contourner Eclipse, j'ai modifié LOEclipse afin de permettre la création de l'extension avec Apache Ant.  
Pour créer l'extension JaybirdOOo avec l'aide d'Apache Ant, vous devez:
- Installer le [SDK Java][36] version 8 ou supérieure.
- Installer [Apache Ant][37] version 1.10.0 ou supérieure.
- Installer [LibreOffice et son SDK][38] version 7.x ou supérieure.
- Cloner le dépôt [JaybirdOOo][39] sur GitHub dans un dossier.
- Depuis ce dossier, accédez au répertoire: `source/JaybirdOOo/`
- Dans ce répertoire, modifiez le fichier `build.properties` afin que les propriétés `office.install.dir` et `sdk.dir` pointent vers les dossiers d'installation de LibreOffice et de son SDK, respectivement.
- Lancez la création de l'archive avec la commande: `ant`
- Vous trouverez l'archive générée dans le sous-dossier: `dist/`

___

## A été testé avec:

* LibreOffice 24.2.1.2 (x86_64)- Windows 10

* LibreOffice 24.2.1.2 - Lubuntu 22.04

* LibreOffice 24.8.0.3 (X86_64) - Windows 10(x64) - Python version 3.9.19 (sous Lubuntu 22.04 / VirtualBox 6.1.38)

Je vous encourage en cas de problème :confused:  
de créer un [dysfonctionnement][13]  
J'essaierai de le résoudre :smile:

___

## Historique:

### Ce qui a été fait pour la version 1.0.0:

- Tout d'abord je tiens à remercier [rotteveel][40] pour [l'amélioration #629][41] qui a permis de publier cette extension.
- Cette extension est basée sur la [correction #154989][19] disponible depuis LibreOffice 24.2.x. Elle peut donc fonctionner avec les autres extensions proposant des services de bases de données intégrées.
- JaybirdOOo nécessite **LibreOffice 24.2.x** et **Java 17** au minimum. Il se chargera pour l'url: `sdbc:embedded:jaybird`.

### Ce qui a été fait pour la version 1.0.1:

- Support de la nouvelle version 1.4.0 de jdbcDriverOOo.
- L'utilisation de fichiers odb créés avec une version précédente de JaybirdOOo, nécessite de modifier le paramètre : `Requête des valeurs générées` accessible par le menu : **Edition -> Base de données -> Paramètres avancés... -> Valeurs générées** par la valeur : `SELECT * FROM %s WHERE %s`.

### Ce qui a été fait pour la version 1.0.2:

- Mise à jour du paquet [Python packaging][42] vers la version 24.1.
- Mise à jour du paquet [Python setuptools][43] vers la version 72.1.0.
- L'extension vous demandera d'installer l'extensions jdbcDriverOOo en version 1.4.2 minimum.

### Ce qui a été fait pour la version 1.0.3:

- Mise à jour du paquet [Python setuptools][43] vers la version 73.0.1.
- La journalisation accessible dans les options de l’extension s’affiche désormais correctement sous Windows.
- Les options de l'extension sont désormais accessibles via: **Outils -> Options... -> LibreOffice Base -> Pilote Jaybird intégré**
- Les modifications apportées aux options de l'extension, qui nécessitent un redémarrage de LibreOffice, entraîneront l'affichage d'un message.
- Support de LibreOffice version 24.8.x.

### Ce qui a été fait pour la version 1.0.4:

- Nécessite la dernière version de **jdbcDriverOOo 1.4.4**.
- Dans les options de l'extension il est possible de définir les options: **Afficher les tables système**, **Utiliser les signets** et **Forcer le mode SQL** qui seront spécifiques à ce pilote.
- Afin de ne pas entrer en conflit avec le pilote Firebird intégré à LibreOffice, le pilote a été renommé en **Pilote Jaybird intégré**.

### Ce qui a été fait pour la version 1.0.5:

- L'extension vous demandera d'installer l'extensions jdbcDriverOOo en version 1.4.6 minimum.
- Modification des options de l'extension accessibles via : **Outils -> Options... -> LibreOffice Base -> Pilote Jaybird intégré** afin de respecter la nouvelle charte graphique.

### Ce qui a été fait pour la version 1.1.0:

- Déploiement de l'enregistrement passif permettant une installation beaucoup plus rapide des extensions et de différencier les services UNO enregistrés de ceux fournis par une implémentation Java ou Python. Cet enregistrement passif est assuré par l'extension [LOEclipse][35] via les [PR#152][44] et [PR#157][45].
- Modification de [LOEclipse][35] pour prendre en charge le nouveau format de fichier `rdb` produit par l'utilitaire de compilation `unoidl-write`. Les fichiers `idl` ont été mis à jour pour prendre en charge les deux outils de compilation disponibles: idlc et unoidl-write.
- Il est désormais possible de créer le fichier oxt de l'extension JaybirdOOo uniquement avec Apache Ant et une copie du dépôt GitHub. La section [Comment créer l'extension][46] a été ajoutée à la documentation.
- Toute erreur survenant lors du chargement du pilote sera consignée dans le journal de l'extension si la journalisation a été préalablement activé. Cela facilite l'identification des problèmes d'installation sous Windows.
- Nécessite l'extension **jdbcDriverOOo en version 1.5.0 minimum**.

### Ce qui a été fait pour la version 1.1.1:

- De nombreuses corrections qui empêchaient le bon fonctionnement ont été apportées au pilote écrit en Python et enveloppant le pilote fourni par jdbcDriverOOo.
- Modification des prérequis pour indiquer clairement que le serveur Firebird doit être installé pour que l'extension JaybirdOoo fonctionne. Malheureusement, je ne m'en suis rendu compte que tardivement... :-(
- Nécessite l'extension **jdbcDriverOOo en version 1.5.1 minimum**.

### Ce qui a été fait pour la version 1.1.2:

- Les binaires du Serveur Firebird 5.0.3 sont désormais fournis par l'extension jdbcDriverOOo via l'archive `JaybirdEmbedded.jar` pour Windows et Linux dans l'architecture x86 64 bits.
- Nécessite l'extension **jdbcDriverOOo en version 1.5.4 minimum**.

### Ce qui a été fait pour la version 1.1.3:

- Nécessite l'extension **jdbcDriverOOo en version 1.5.7 minimum**.

### Que reste-t-il à faire pour la version 1.1.3:

- Ajouter de nouvelles langue pour l'internationalisation...

- Tout ce qui est bienvenu...

[1]: </img/jaybird.svg#collapse>
[2]: <https://prrvchr.github.io/JaybirdOOo/>
[3]: <https://prrvchr.github.io/JaybirdOOo/>
[4]: <https://prrvchr.github.io/JaybirdOOo/source/JaybirdOOo/registration/TermsOfUse_fr>
[5]: <https://prrvchr.github.io/JaybirdOOo/README_fr#ce-qui-a-%C3%A9t%C3%A9-fait-pour-la-version-113>
[6]: <https://prrvchr.github.io/README_fr>
[7]: <https://fr.libreoffice.org/download/telecharger-libreoffice/>
[8]: <https://www.openoffice.org/fr/Telecharger/>
[9]: <https://www.firebirdsql.org/>
[10]: <https://en.wikipedia.org/wiki/ACID>
[11]: <https://firebirdsql.org/file/documentation/papers_presentations/html/fr/paper-fbent-acid-fr.html>
[12]: <https://github.com/prrvchr/JaybirdOOo/>
[13]: <https://github.com/prrvchr/JaybirdOOo/issues/new>
[14]: <https://prrvchr.github.io/jdbcDriverOOo/#requirement>
[15]: <https://github.com/FirebirdSQL/jaybird>
[16]: <https://prrvchr.github.io/JaybirdEmbedded/README_fr>
[17]: <https://firebirdsql.org/en/firebird-5-0-3>
[18]: <https://bugs.documentfoundation.org/show_bug.cgi?id=156471>
[19]: <https://gerrit.libreoffice.org/c/core/+/154989>
[20]: <https://prrvchr.github.io/jdbcDriverOOo/img/jdbcDriverOOo.svg#middle>
[21]: <https://prrvchr.github.io/jdbcDriverOOo/README_fr>
[22]: <https://github.com/prrvchr/jdbcDriverOOo/releases/latest/download/jdbcDriverOOo.oxt>
[23]: <https://img.shields.io/github/v/tag/prrvchr/jdbcDriverOOo?label=latest#right>
[24]: <img/JaybirdOOo.svg#middle>
[25]: <https://github.com/prrvchr/JaybirdOOo/releases/latest/download/JaybirdOOo.oxt>
[26]: <https://img.shields.io/github/downloads/prrvchr/JaybirdOOo/latest/total?label=v1.1.3#right>
[27]: <img/JaybirdOOo-1_fr.png>
[28]: <img/JaybirdOOo-2_fr.png>
[29]: <img/JaybirdOOo-3_fr.png>
[30]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/sdbc/Driver.html>
[31]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/sdbc/XConnection.html>
[32]: <https://github.com/prrvchr/JaybirdOOo/blob/main/uno/lib/uno/embedded/documenthandler.py>
[33]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/util/XCloseListener.html>
[34]: <http://www.openoffice.org/api/docs/common/ref/com/sun/star/document/XStorageChangeListener.html>
[35]: <https://github.com/LibreOffice/loeclipse>
[36]: <https://adoptium.net/temurin/releases/?version=8&package=jdk>
[37]: <https://ant.apache.org/manual/install.html>
[38]: <https://downloadarchive.documentfoundation.org/libreoffice/old/7.6.7.2/>
[39]: <https://github.com/prrvchr/JaybirdOOo.git>
[40]: <https://github.com/mrotteveel>
[41]: <https://github.com/FirebirdSQL/jaybird/issues/629>
[42]: <https://pypi.org/project/packaging/>
[43]: <https://pypi.org/project/setuptools/>
[44]: <https://github.com/LibreOffice/loeclipse/pull/152>
[45]: <https://github.com/LibreOffice/loeclipse/pull/157>
[46]: <https://prrvchr.github.io/JaybirdOOo/README_fr#comment-cr%C3%A9er-lextension>

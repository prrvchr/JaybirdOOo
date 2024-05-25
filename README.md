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

**Ce [document][3] en français.**

**The use of this software subjects you to our [Terms Of Use][4].**

# version [1.0.0][5]

## Introduction:

**JaybirdOOo** is part of a [Suite][6] of [LibreOffice][7] ~~and/or [OpenOffice][8]~~ extensions allowing to offer you innovative services in these office suites.  

This extension allows you to use [Firebird][9] in embedded mode, making the database portable (a single odb file).  
It allows you to take advantage of the [ACID][10] properties of the underlying [Firebird][11] database.

Being free software I encourage you:
- To duplicate its [source code][12].
- To make changes, corrections, improvements.
- To open [issue][13] if needed.

In short, to participate in the development of this extension.  
Because it is together that we can make Free Software smarter.

___

## Requirement:

The JaybirdOOo extension uses the jdbcDriverOOo extension to work.  
It must therefore meet the [requirement of the jdbcDriverOOo extension][14].

**Only LibreOffice 24.2.x or higher is supported.**

**On Linux and macOS the Python packages** used by the extension, if already installed, may come from the system and therefore **may not be up to date**.  
To ensure that your Python packages are up to date it is recommended to use the **System Info** option in the extension Options accessible by:  
**Tools -> Options -> Base drivers -> Embedded SQLite Driver -> View log -> System Info**  
If outdated packages appear, you can update them with the command:  
`pip install --upgrade <package-name>`

___

## Installation:

It seems important that the file was not renamed when it was downloaded.  
If necessary, rename it before installing it.

- [![jdbcDriverOOo logo][17]][18] Install **[jdbcDriverOOo.oxt][19]** extension [![Version][20]][19]

    This extension is necessary to use H2 Database with all its features.

- ![JaybirdOOo logo][21] Install **[JaybirdOOo.oxt][22]** extension [![Version][23]][22]

Restart LibreOffice after installation.  
**Be careful, restarting LibreOffice may not be enough.**
- **On Windows** to ensure that LibreOffice restarts correctly, use Windows Task Manager to verify that no LibreOffice services are visible after LibreOffice shuts down (and kill it if so).
- **Under Linux or macOS** you can also ensure that LibreOffice restarts correctly, by launching it from a terminal with the command `soffice` and using the key combination `Ctrl + C` if after stopping LibreOffice, the terminal is not active (no command prompt).

___

## Use:

### How to create a new database:

In LibreOffice / OpenOffice go to File -> New -> Database...:

![JaybirdOOo screenshot 1][24]

In step: Select database:
- select: Create a new database
- in: Emdedded database: choose: **Embedded Firebird Driver**
- click on button: Next

![JaybirdOOo screenshot 2][25]

In step: Save and proceed:
- adjust the parameters according to your needs...
- click on button: Finish

![JaybirdOOo screenshot 3][26]

Have fun...

___

## How does it work:

JaybirdOOo is an [com.sun.star.sdbc.Driver][27] UNO service written in Python.  
It is an overlay to the [jdbcDriverOOo][18] extension allowing to store the Firebird database in an odb file (which is, in fact, a compressed file).

Its operation is quite basic, namely:

- When requesting a connection, several things are done:
  - If it does not already exist, a **subdirectory** with name: `.` + `odb_file_name` + `.lck` is created in the location of the odb file where all Firebird files are extracted from the **database** directory of the odb file (unzip).
  - The [jdbcDriverOOo][18] extension is used to get the [com.sun.star.sdbc.XConnection][28] interface from the **subdirectory** path + `/jaybird`.
  - If the connection is successful, a [DocumentHandler][29] is added as an [com.sun.star.util.XCloseListener][30] and [com.sun.star.document.XStorageChangeListener][31] to the odb file.
  - If the connection is unsuccessful and the files was extracted in phase 1, the **subdirectory** will be deleted.
- When closing or renaming (Save As) the odb file, if the connection was successful, the [DocumentHandler][29] copies all files present in the **subdirectory** into the (new) **database** directory of the odb file (zip), then delete the **subdirectory**.

The main purpose of this mode of operation is to take advantage of the ACID characteristics of the underlying database in the event of an abnormal closure of LibreOffice.
On the other hand, the function: **file -> Save** has **no effect on the underlying database**. Only closing the odb file or saving it under a different name (File -> Save As) will save the database in the odb file.

___

## Has been tested with:

* LibreOffice 24.2.1.2 - Ubuntu 22.04

I encourage you in case of problem :confused:  
to create an [issue][13]  
I will try to solve it :smile:

___

## Historical:

### What has been done for version 1.0.0:

- This version is based on [fix #154989][32] available since LibreOffice 24.2.x. It can therefore work with other extensions offering integrated database services.
- Now JaybirdOOo requires LibreOffice 24.2.x minimum and will load for the url: `sdbc:embedded:jaybird`.

### What remains to be done for version 1.0.0:

- Add new language for internationalization...

- Anything welcome...

[1]: </img/h2db.svg#collapse>
[2]: <https://prrvchr.github.io/JaybirdOOo/>
[3]: <https://prrvchr.github.io/JaybirdOOo/README_fr>
[4]: <https://prrvchr.github.io/JaybirdOOo/source/JaybirdOOo/registration/TermsOfUse_en>
[5]: <https://prrvchr.github.io/JaybirdOOo#historical>
[6]: <https://prrvchr.github.io/>
[7]: <https://www.libreoffice.org/download/download/>
[8]: <https://www.openoffice.org/download/index.html>
[9]: <https://www.firebirdsql.org/>
[10]: <https://en.wikipedia.org/wiki/ACID>
[11]: <https://firebirdsql.org/file/documentation/papers_presentations/html/paper-fbent-acid.html>
[12]: <https://github.com/prrvchr/JaybirdOOo/>
[13]: <https://github.com/prrvchr/JaybirdOOo/issues/new>
[14]: <https://prrvchr.github.io/jdbcDriverOOo/#requirement>
[17]: <https://prrvchr.github.io/jdbcDriverOOo/img/jdbcDriverOOo.svg#middle>
[18]: <https://prrvchr.github.io/jdbcDriverOOo>
[19]: <https://github.com/prrvchr/jdbcDriverOOo/releases/latest/download/jdbcDriverOOo.oxt>
[20]: <https://img.shields.io/github/v/tag/prrvchr/jdbcDriverOOo?label=latest#right>
[21]: <img/JaybirdOOo.svg#middle>
[22]: <https://github.com/prrvchr/JaybirdOOo/releases/latest/download/JaybirdOOo.oxt>
[23]: <https://img.shields.io/github/downloads/prrvchr/JaybirdOOo/latest/total?label=v1.1.0#right>
[24]: <img/JaybirdOOo-1.png>
[25]: <img/JaybirdOOo-2.png>
[26]: <img/JaybirdOOo-3.png>
[27]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/sdbc/Driver.html>
[28]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/sdbc/XConnection.html>
[29]: <https://github.com/prrvchr/JaybirdOOo/blob/main/uno/lib/uno/embedded/documenthandler.py>
[30]: <https://www.openoffice.org/api/docs/common/ref/com/sun/star/util/XCloseListener.html>
[31]: <http://www.openoffice.org/api/docs/common/ref/com/sun/star/document/XStorageChangeListener.html>
[32]: <https://gerrit.libreoffice.org/c/core/+/154989>

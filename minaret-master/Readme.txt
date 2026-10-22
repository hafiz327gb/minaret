COMPUTING THE ISLAMIC PRAYER HOURS, THE QIBLA DIRECTION, 
AND THE HIJRI CALENDAR

This Visual Basic 6 program computes prayer hours and the qibla,
and converts dates between the Hijri and Western (CE) calendars.


*** DIRECTORIES ***

-  vb6-src
This directory contains the VB6 source files to make the executive
Minaret4.exe. The code consists primarily of Module (*.bas) and 
Form (*.frm and VB-generated *.frx) files. In addition, there 
are "project" files (*.vbp and VB6-generated *.vbw), image files 
(*.gif and *.ico), binary data files for which I use the 
extension ".dta", and the "compiled HTML help" file (*.chm).

-  chm-src
This directory contains the htm, index, and content files to 
regenerate the compiled HTML help file *.chm that is already 
provided. To modify the Help contents, you need to decompile the 
*.chm, edit the resulting *.htm files, and then recompile 
these to generate a new *.chm. In case a decompiler is not 
available, you can work with the files in the present directory.
But a compiler, such as Microsoft's HTML Help Workshop is
indispensable.

-  distrib
This directory contains the files that the user needs for running
the executive. It includes one dll and two ocx files that are 
needed by the program. These files are usually already in the OS 
but occasionally they are missing. A zip of the files in this 
directory is a convenient way to distribute the program. Such a  
zip is downloadable from http://geomete.com/minaret/minar40.zip.


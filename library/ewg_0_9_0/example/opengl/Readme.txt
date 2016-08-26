
This example demonstrates how to wrap and use opengl.
Please note that not only must opengl runtime be installed, 
but also the opengl development files must be present.

Windows does not come with a GLUT implementation.
A GLUT implementation for Windows can be downloaded from
http://www.xmission.com/~nate/glut/glut-3.7.6-bin.zip
Install this package into a directory of you choice and set the 
environment variable GLUT_INCLUDE to where the header files of
this package are. GLUT_LIB needs to set to where the ".lib" 
file is.

Visual Eiffel (4.1) on Linux crashes on my machine when compiling
any EWG OpenGL applications because it runs out of memory. After
obtaining a specially tuned version from Object Tools, the problem
disapeared though.
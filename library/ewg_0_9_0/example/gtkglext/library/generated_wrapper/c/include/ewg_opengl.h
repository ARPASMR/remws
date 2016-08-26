#ifndef __EWG_OPENGL__
#define __EWG_OPENGL__

#ifdef _WIN32
#include <windows.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <glut.h>
typedef GLvoid (*_GLUfuncptr)(GLvoid);

#else
#ifdef __APPLE__
#include <OpenGL/gl.h>
#include <GLUT/glut.h>
#include <OpenGL/glu.h>
typedef GLvoid (*_GLUfuncptr)(GLvoid);
#else
#include <GL/gl.h>
#include <GL/glut.h>
#include <GL/glu.h>
#endif
#endif

#include<ewg_opengl_constants.h>
#include<ewg_openglu_constants.h>
#include<ewg_openglut_constants.h>

#endif


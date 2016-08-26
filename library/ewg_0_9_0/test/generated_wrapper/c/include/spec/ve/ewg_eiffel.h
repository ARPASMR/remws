#ifndef eif_h
#define eif_h

#include <cecil.h>

#ifndef EIF_OBJ
#ifndef EIF_OBJ
#define EIF_OBJ EIF_REFERENCE
#endif
#ifndef EIF_PROCEDURE
#define EIF_PROCEDURE EIF_PROC
#endif

// TODO: VE provides `eif_access', `eif_adopt' and `eif_wean'
// but `eif_adopt' doesn't return anything, find a way to overcome
// this incompatibility
#define eif_access(x)x
#define eif_adopt(x)x
#define eif_wean(x)
#endif

#ifndef NULL
#define NULL ((void*)0)
#endif

#endif

#ifndef eif_h
#define eif_h

// TODO: on SE eif_adopt/eif_wean need to lock/unlock the object (so that it wont be collected)
#define eif_access(x)x
#define eif_adopt(x)x
#define eif_wean(x)

#ifndef NULL
#define NULL ((void*)0)
#endif

#endif

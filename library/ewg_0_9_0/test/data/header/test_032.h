// shows that typedefs and structs/enums/unions
// do not share one type namespace

typedef struct _IO_FILE _IO_FILE;

extern struct _IO_FILE *stdin;		 

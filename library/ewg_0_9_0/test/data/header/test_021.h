// Microsofts C extension
// that allows anonymous struct members


typedef struct foo {
	union {
		int a;
	};
};

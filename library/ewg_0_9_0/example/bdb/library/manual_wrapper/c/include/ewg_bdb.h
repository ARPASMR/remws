
#ifndef __EWG_DB__
#define __EWG_DB__

#include<db.h>

typedef int (*ewg_db_open) (DB *, DB_TXN *, const char *,
				const char *, DBTYPE, u_int32_t, int);
typedef int (*ewg_db_put_or_get) (DB *, DB_TXN *, DBT *, DBT *, u_int32_t);

#endif

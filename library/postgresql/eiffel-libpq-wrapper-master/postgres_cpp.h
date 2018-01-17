# 1 "/home/berend/src/psql/include/my_postgres.h"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/home/berend/src/psql/include/my_postgres.h"
# 1 "/usr/include/postgresql/libpq-fe.h" 1 3 4
# 23 "/usr/include/postgresql/libpq-fe.h" 3 4



__extension__ typedef signed long long int __int64_t;
__extension__ typedef unsigned long long int __uint64_t;







__extension__ typedef long long int __quad_t;
__extension__ typedef unsigned long long int __u_quad_t;
# 131 "/usr/include/bits/types.h" 3 4
# 1 "/usr/include/bits/typesizes.h" 1 3 4
# 132 "/usr/include/bits/types.h" 2 3 4


__extension__ typedef __u_quad_t __dev_t;
__extension__ typedef unsigned int __uid_t;
__extension__ typedef unsigned int __gid_t;
__extension__ typedef unsigned long int __ino_t;
__extension__ typedef __u_quad_t __ino64_t;
__extension__ typedef unsigned int __mode_t;
__extension__ typedef unsigned int __nlink_t;
__extension__ typedef long int __off_t;
__extension__ typedef __quad_t __off64_t;
__extension__ typedef int __pid_t;
__extension__ typedef struct { int __val[2]; } __fsid_t;
__extension__ typedef long int __clock_t;
__extension__ typedef unsigned long int __rlim_t;
__extension__ typedef __u_quad_t __rlim64_t;
__extension__ typedef unsigned int __id_t;
__extension__ typedef long int __time_t;
__extension__ typedef unsigned int __useconds_t;
__extension__ typedef long int __suseconds_t;

__extension__ typedef int __daddr_t;
__extension__ typedef long int __swblk_t;
__extension__ typedef int __key_t;


__extension__ typedef int __clockid_t;


__extension__ typedef void * __timer_t;


__extension__ typedef long int __blksize_t;




__extension__ typedef long int __blkcnt_t;
__extension__ typedef __quad_t __blkcnt64_t;


__extension__ typedef unsigned long int __fsblkcnt_t;
__extension__ typedef __u_quad_t __fsblkcnt64_t;


__extension__ typedef unsigned long int __fsfilcnt_t;
__extension__ typedef __u_quad_t __fsfilcnt64_t;

__extension__ typedef int __ssize_t;
__extension__ typedef int size_t;



typedef __off64_t __loff_t;
typedef __quad_t *__qaddr_t;
typedef char *__caddr_t;


__extension__ typedef int __intptr_t;


__extension__ typedef unsigned int __socklen_t;
struct _IO_FILE;



typedef struct _IO_FILE FILE;





extern int remove (__const char *__filename) __attribute__ ((__nothrow__));

extern int rename (__const char *__old, __const char *__new) __attribute__ ((__nothrow__));




extern int renameat (int __oldfd, __const char *__old, int __newfd,
       __const char *__new) __attribute__ ((__nothrow__));








extern FILE *tmpfile (void) ;
# 206 "/usr/include/stdio.h" 3 4
extern char *tmpnam (char *__s) __attribute__ ((__nothrow__)) ;





extern char *tmpnam_r (char *__s) __attribute__ ((__nothrow__)) ;
# 224 "/usr/include/stdio.h" 3 4
extern char *tempnam (__const char *__dir, __const char *__pfx)
     __attribute__ ((__nothrow__)) __attribute__ ((__malloc__)) ;








extern int fclose (FILE *__stream);




extern int fflush (FILE *__stream);

# 249 "/usr/include/stdio.h" 3 4
extern int fflush_unlocked (FILE *__stream);
# 263 "/usr/include/stdio.h" 3 4






extern FILE *fopen (__const char *__restrict __filename,
      __const char *__restrict __modes) ;




extern FILE *freopen (__const char *__restrict __filename,
        __const char *__restrict __modes,
        FILE *__restrict __stream) ;
# 292 "/usr/include/stdio.h" 3 4





extern int fgetc (FILE *__stream);
extern int getc (FILE *__stream);





extern int getchar (void);

# 552 "/usr/include/stdio.h" 3 4
extern int getc_unlocked (FILE *__stream);
extern int getchar_unlocked (void);
# 563 "/usr/include/stdio.h" 3 4
extern int fgetc_unlocked (FILE *__stream);











extern int fputc (int __c, FILE *__stream);
extern int putc (int __c, FILE *__stream);





extern int putchar (int __c);

# 596 "/usr/include/stdio.h" 3 4
extern int fputc_unlocked (int __c, FILE *__stream);







extern int putc_unlocked (int __c, FILE *__stream);
extern int putchar_unlocked (int __c);






extern int getw (FILE *__stream);


extern int putw (int __w, FILE *__stream);








extern char *fgets (char *__restrict __s, int __n, FILE *__restrict __stream)
     ;









extern int fputs (__const char *__restrict __s, FILE *__restrict __stream);





extern int puts (__const char *__s);






extern int ungetc (int __c, FILE *__stream);





extern int fseek (FILE *__stream, long int __off, int __whence);




extern long int ftell (FILE *__stream) ;




extern void rewind (FILE *__stream);

# 766 "/usr/include/stdio.h" 3 4
extern int fseeko (FILE *__stream, __off_t __off, int __whence);




extern __off_t ftello (FILE *__stream) ;
# 785 "/usr/include/stdio.h" 3 4






extern void clearerr (FILE *__stream) __attribute__ ((__nothrow__));

extern int feof (FILE *__stream) __attribute__ ((__nothrow__)) ;

extern int ferror (FILE *__stream) __attribute__ ((__nothrow__)) ;




extern void clearerr_unlocked (FILE *__stream) __attribute__ ((__nothrow__));
extern int feof_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
extern int ferror_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;








extern void perror (__const char *__s);






# 1 "/usr/include/bits/sys_errlist.h" 1 3 4
# 27 "/usr/include/bits/sys_errlist.h" 3 4
extern int sys_nerr;
extern __const char *__const sys_errlist[];
# 847 "/usr/include/stdio.h" 2 3 4




extern int fileno (FILE *__stream) __attribute__ ((__nothrow__)) ;




extern int fileno_unlocked (FILE *__stream) __attribute__ ((__nothrow__)) ;
# 866 "/usr/include/stdio.h" 3 4
extern FILE *popen (__const char *__command, __const char *__modes) ;





extern int pclose (FILE *__stream);





extern char *ctermid (char *__s) __attribute__ ((__nothrow__));
# 906 "/usr/include/stdio.h" 3 4
extern void flockfile (FILE *__stream) __attribute__ ((__nothrow__));



extern int ftrylockfile (FILE *__stream) __attribute__ ((__nothrow__)) ;


extern void funlockfile (FILE *__stream) __attribute__ ((__nothrow__));
# 936 "/usr/include/stdio.h" 3 4

# 24 "/usr/include/postgresql/libpq-fe.h" 2 3 4





# 1 "/usr/include/postgresql/postgres_ext.h" 1 3 4
# 29 "/usr/include/postgresql/postgres_ext.h" 3 4
typedef unsigned int Oid;
# 30 "/usr/include/postgresql/libpq-fe.h" 2 3 4
# 41 "/usr/include/postgresql/libpq-fe.h" 3 4
typedef enum
{





 CONNECTION_OK,
 CONNECTION_BAD,






 CONNECTION_STARTED,
 CONNECTION_MADE,
 CONNECTION_AWAITING_RESPONSE,

 CONNECTION_AUTH_OK,

 CONNECTION_SETENV,
 CONNECTION_SSL_STARTUP,
 CONNECTION_NEEDED
} ConnStatusType;

typedef enum
{
 PGRES_POLLING_FAILED = 0,
 PGRES_POLLING_READING,
 PGRES_POLLING_WRITING,
 PGRES_POLLING_OK,
 PGRES_POLLING_ACTIVE

} PostgresPollingStatusType;

typedef enum
{
 PGRES_EMPTY_QUERY = 0,
 PGRES_COMMAND_OK,


 PGRES_TUPLES_OK,


 PGRES_COPY_OUT,
 PGRES_COPY_IN,
 PGRES_BAD_RESPONSE,

 PGRES_NONFATAL_ERROR,
 PGRES_FATAL_ERROR
} ExecStatusType;

typedef enum
{
 PQTRANS_IDLE,
 PQTRANS_ACTIVE,
 PQTRANS_INTRANS,
 PQTRANS_INERROR,
 PQTRANS_UNKNOWN
} PGTransactionStatusType;

typedef enum
{
 PQERRORS_TERSE,
 PQERRORS_DEFAULT,
 PQERRORS_VERBOSE
} PGVerbosity;




typedef struct pg_conn PGconn;






typedef struct pg_result PGresult;





typedef struct pg_cancel PGcancel;







typedef struct pgNotify
{
 char *relname;
 int be_pid;
 char *extra;

 struct pgNotify *next;
} PGnotify;


typedef void (*PQnoticeReceiver) (void *arg, const PGresult *res);
typedef void (*PQnoticeProcessor) (void *arg, const char *message);


typedef char pqbool;

typedef struct _PQprintOpt
{
 pqbool header;
 pqbool align;
 pqbool standard;
 pqbool html3;
 pqbool expanded;
 pqbool pager;
 char *fieldSep;
 char *tableOpt;
 char *caption;
 char **fieldName;

} PQprintOpt;
# 174 "/usr/include/postgresql/libpq-fe.h" 3 4
typedef struct _PQconninfoOption
{
 char *keyword;
 char *envvar;
 char *compiled;
 char *val;
 char *label;
 char *dispchar;




 int dispsize;
} PQconninfoOption;





typedef struct
{
 int len;
 int isint;
 union
 {
  int *ptr;
  int integer;
 } u;
} PQArgBlock;





typedef struct pgresAttDesc
{
 char *name;
 Oid tableid;
 int columnid;
 int format;
 Oid typid;
 int typlen;
 int atttypmod;
} PGresAttDesc;
# 228 "/usr/include/postgresql/libpq-fe.h" 3 4
extern PGconn *PQconnectStart(const char *conninfo);
extern PostgresPollingStatusType PQconnectPoll(PGconn *conn);


extern PGconn *PQconnectdb(const char *conninfo);
extern PGconn *PQsetdbLogin(const char *pghost, const char *pgport,
    const char *pgoptions, const char *pgtty,
    const char *dbName,
    const char *login, const char *pwd);





extern void PQfinish(PGconn *conn);


extern PQconninfoOption *PQconndefaults(void);


extern PQconninfoOption *PQconninfoParse(const char *conninfo, char **errmsg);


extern void PQconninfoFree(PQconninfoOption *connOptions);






extern int PQresetStart(PGconn *conn);
extern PostgresPollingStatusType PQresetPoll(PGconn *conn);


extern void PQreset(PGconn *conn);


extern PGcancel *PQgetCancel(PGconn *conn);


extern void PQfreeCancel(PGcancel *cancel);


extern int PQcancel(PGcancel *cancel, char *errbuf, int errbufsize);


extern int PQrequestCancel(PGconn *conn);


extern char *PQdb(const PGconn *conn);
extern char *PQuser(const PGconn *conn);
extern char *PQpass(const PGconn *conn);
extern char *PQhost(const PGconn *conn);
extern char *PQport(const PGconn *conn);
extern char *PQtty(const PGconn *conn);
extern char *PQoptions(const PGconn *conn);
extern ConnStatusType PQstatus(const PGconn *conn);
extern PGTransactionStatusType PQtransactionStatus(const PGconn *conn);
extern const char *PQparameterStatus(const PGconn *conn,
      const char *paramName);
extern int PQprotocolVersion(const PGconn *conn);
extern int PQserverVersion(const PGconn *conn);
extern char *PQerrorMessage(const PGconn *conn);
extern int PQsocket(const PGconn *conn);
extern int PQbackendPID(const PGconn *conn);
extern int PQconnectionNeedsPassword(const PGconn *conn);
extern int PQconnectionUsedPassword(const PGconn *conn);
extern int PQclientEncoding(const PGconn *conn);
extern int PQsetClientEncoding(PGconn *conn, const char *encoding);



extern void *PQgetssl(PGconn *conn);


extern void PQinitSSL(int do_init);


extern void PQinitOpenSSL(int do_ssl, int do_crypto);


extern PGVerbosity PQsetErrorVerbosity(PGconn *conn, PGVerbosity verbosity);


extern void PQtrace(PGconn *conn, FILE *debug_port);
extern void PQuntrace(PGconn *conn);


extern PQnoticeReceiver PQsetNoticeReceiver(PGconn *conn,
     PQnoticeReceiver proc,
     void *arg);
extern PQnoticeProcessor PQsetNoticeProcessor(PGconn *conn,
      PQnoticeProcessor proc,
      void *arg);
# 330 "/usr/include/postgresql/libpq-fe.h" 3 4
typedef void (*pgthreadlock_t) (int acquire);

extern pgthreadlock_t PQregisterThreadLock(pgthreadlock_t newhandler);




extern PGresult *PQexec(PGconn *conn, const char *query);
extern PGresult *PQexecParams(PGconn *conn,
    const char *command,
    int nParams,
    const Oid *paramTypes,
    const char *const * paramValues,
    const int *paramLengths,
    const int *paramFormats,
    int resultFormat);
extern PGresult *PQprepare(PGconn *conn, const char *stmtName,
    const char *query, int nParams,
    const Oid *paramTypes);
extern PGresult *PQexecPrepared(PGconn *conn,
      const char *stmtName,
      int nParams,
      const char *const * paramValues,
      const int *paramLengths,
      const int *paramFormats,
      int resultFormat);


extern int PQsendQuery(PGconn *conn, const char *query);
extern int PQsendQueryParams(PGconn *conn,
      const char *command,
      int nParams,
      const Oid *paramTypes,
      const char *const * paramValues,
      const int *paramLengths,
      const int *paramFormats,
      int resultFormat);
extern int PQsendPrepare(PGconn *conn, const char *stmtName,
     const char *query, int nParams,
     const Oid *paramTypes);
extern int PQsendQueryPrepared(PGconn *conn,
     const char *stmtName,
     int nParams,
     const char *const * paramValues,
     const int *paramLengths,
     const int *paramFormats,
     int resultFormat);
extern PGresult *PQgetResult(PGconn *conn);


extern int PQisBusy(PGconn *conn);
extern int PQconsumeInput(PGconn *conn);


extern PGnotify *PQnotifies(PGconn *conn);


extern int PQputCopyData(PGconn *conn, const char *buffer, int nbytes);
extern int PQputCopyEnd(PGconn *conn, const char *errormsg);
extern int PQgetCopyData(PGconn *conn, char **buffer, int async);


extern int PQgetline(PGconn *conn, char *string, int length);
extern int PQputline(PGconn *conn, const char *string);
extern int PQgetlineAsync(PGconn *conn, char *buffer, int bufsize);
extern int PQputnbytes(PGconn *conn, const char *buffer, int nbytes);
extern int PQendcopy(PGconn *conn);


extern int PQsetnonblocking(PGconn *conn, int arg);
extern int PQisnonblocking(const PGconn *conn);
extern int PQisthreadsafe(void);


extern int PQflush(PGconn *conn);





extern PGresult *PQfn(PGconn *conn,
  int fnid,
  int *result_buf,
  int *result_len,
  int result_is_int,
  const PQArgBlock *args,
  int nargs);


extern ExecStatusType PQresultStatus(const PGresult *res);
extern char *PQresStatus(ExecStatusType status);
extern char *PQresultErrorMessage(const PGresult *res);
extern char *PQresultErrorField(const PGresult *res, int fieldcode);
extern int PQntuples(const PGresult *res);
extern int PQnfields(const PGresult *res);
extern int PQbinaryTuples(const PGresult *res);
extern char *PQfname(const PGresult *res, int field_num);
extern int PQfnumber(const PGresult *res, const char *field_name);
extern Oid PQftable(const PGresult *res, int field_num);
extern int PQftablecol(const PGresult *res, int field_num);
extern int PQfformat(const PGresult *res, int field_num);
extern Oid PQftype(const PGresult *res, int field_num);
extern int PQfsize(const PGresult *res, int field_num);
extern int PQfmod(const PGresult *res, int field_num);
extern char *PQcmdStatus(PGresult *res);
extern char *PQoidStatus(const PGresult *res);
extern Oid PQoidValue(const PGresult *res);
extern char *PQcmdTuples(PGresult *res);
extern char *PQgetvalue(const PGresult *res, int tup_num, int field_num);
extern int PQgetlength(const PGresult *res, int tup_num, int field_num);
extern int PQgetisnull(const PGresult *res, int tup_num, int field_num);
extern int PQnparams(const PGresult *res);
extern Oid PQparamtype(const PGresult *res, int param_num);


extern PGresult *PQdescribePrepared(PGconn *conn, const char *stmt);
extern PGresult *PQdescribePortal(PGconn *conn, const char *portal);
extern int PQsendDescribePrepared(PGconn *conn, const char *stmt);
extern int PQsendDescribePortal(PGconn *conn, const char *portal);


extern void PQclear(PGresult *res);


extern void PQfreemem(void *ptr);
# 464 "/usr/include/postgresql/libpq-fe.h" 3 4
extern PGresult *PQmakeEmptyPGresult(PGconn *conn, ExecStatusType status);
extern PGresult *PQcopyResult(const PGresult *src, int flags);
extern int PQsetResultAttrs(PGresult *res, int numAttributes, PGresAttDesc *attDescs);
extern void *PQresultAlloc(PGresult *res, size_t nBytes);
extern int PQsetvalue(PGresult *res, int tup_num, int field_num, char *value, int len);


extern size_t PQescapeStringConn(PGconn *conn,
       char *to, const char *from, size_t length,
       int *error);
extern unsigned char *PQescapeByteaConn(PGconn *conn,
      const unsigned char *from, size_t from_length,
      size_t *to_length);
extern unsigned char *PQunescapeBytea(const unsigned char *strtext,
    size_t *retbuflen);


extern size_t PQescapeString(char *to, const char *from, size_t length);
extern unsigned char *PQescapeBytea(const unsigned char *from, size_t from_length,
     size_t *to_length);





extern void
PQprint(FILE *fout,
  const PGresult *res,
  const PQprintOpt *ps);




extern void
PQdisplayTuples(const PGresult *res,
    FILE *fp,
    int fillAlign,
    const char *fieldSep,
    int printHeader,
    int quiet);

extern void
PQprintTuples(const PGresult *res,
     FILE *fout,
     int printAttName,
     int terseOutput,
     int width);





extern int lo_open(PGconn *conn, Oid lobjId, int mode);
extern int lo_close(PGconn *conn, int fd);
extern int lo_read(PGconn *conn, int fd, char *buf, size_t len);
extern int lo_write(PGconn *conn, int fd, const char *buf, size_t len);
extern int lo_lseek(PGconn *conn, int fd, int offset, int whence);
extern Oid lo_creat(PGconn *conn, int mode);
extern Oid lo_create(PGconn *conn, Oid lobjId);
extern int lo_tell(PGconn *conn, int fd);
extern int lo_truncate(PGconn *conn, int fd, size_t len);
extern int lo_unlink(PGconn *conn, Oid lobjId);
extern Oid lo_import(PGconn *conn, const char *filename);
extern Oid lo_import_with_oid(PGconn *conn, const char *filename, Oid lobjId);
extern int lo_export(PGconn *conn, Oid lobjId, const char *filename);




extern int PQmblen(const char *s, int encoding);


extern int PQdsplen(const char *s, int encoding);


extern int PQenv2encoding(void);



extern char *PQencryptPassword(const char *passwd, const char *user);



extern int pg_char_to_encoding(const char *name);
extern const char *pg_encoding_to_char(int encoding);
extern int pg_valid_server_encoding_id(int encoding);
# 1 "/home/berend/src/psql/include/my_postgres.h" 2


// Wraps call to function 'PQconnectStart' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconnectStart(ewg_param_conninfo) PQconnectStart ((char const*)ewg_param_conninfo)

PGconn * ewg_function_PQconnectStart (char const *conninfo);
// Wraps call to function 'PQconnectPoll' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconnectPoll(ewg_param_conn) PQconnectPoll ((PGconn*)ewg_param_conn)

PostgresPollingStatusType  ewg_function_PQconnectPoll (PGconn *conn);
// Wraps call to function 'PQconnectdb' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconnectdb(ewg_param_conninfo) PQconnectdb ((char const*)ewg_param_conninfo)

PGconn * ewg_function_PQconnectdb (char const *conninfo);
// Wraps call to function 'PQsetdbLogin' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetdbLogin(ewg_param_pghost, ewg_param_pgport, ewg_param_pgoptions, ewg_param_pgtty, ewg_param_dbName, ewg_param_login, ewg_param_pwd) PQsetdbLogin ((char const*)ewg_param_pghost, (char const*)ewg_param_pgport, (char const*)ewg_param_pgoptions, (char const*)ewg_param_pgtty, (char const*)ewg_param_dbName, (char const*)ewg_param_login, (char const*)ewg_param_pwd)

PGconn * ewg_function_PQsetdbLogin (char const *pghost, char const *pgport, char const *pgoptions, char const *pgtty, char const *dbName, char const *login, char const *pwd);
// Wraps call to function 'PQfinish' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfinish(ewg_param_conn) PQfinish ((PGconn*)ewg_param_conn)

void  ewg_function_PQfinish (PGconn *conn);
// Wraps call to function 'PQconndefaults' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconndefaults PQconndefaults ()

PQconninfoOption * ewg_function_PQconndefaults (void);
// Wraps call to function 'PQconninfoParse' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconninfoParse(ewg_param_conninfo, ewg_param_errmsg) PQconninfoParse ((char const*)ewg_param_conninfo, (char**)ewg_param_errmsg)

PQconninfoOption * ewg_function_PQconninfoParse (char const *conninfo, char **errmsg);
// Wraps call to function 'PQconninfoFree' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconninfoFree(ewg_param_connOptions) PQconninfoFree ((PQconninfoOption*)ewg_param_connOptions)

void  ewg_function_PQconninfoFree (PQconninfoOption *connOptions);
// Wraps call to function 'PQresetStart' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresetStart(ewg_param_conn) PQresetStart ((PGconn*)ewg_param_conn)

int  ewg_function_PQresetStart (PGconn *conn);
// Wraps call to function 'PQresetPoll' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresetPoll(ewg_param_conn) PQresetPoll ((PGconn*)ewg_param_conn)

PostgresPollingStatusType  ewg_function_PQresetPoll (PGconn *conn);
// Wraps call to function 'PQreset' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQreset(ewg_param_conn) PQreset ((PGconn*)ewg_param_conn)

void  ewg_function_PQreset (PGconn *conn);
// Wraps call to function 'PQgetCancel' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetCancel(ewg_param_conn) PQgetCancel ((PGconn*)ewg_param_conn)

PGcancel * ewg_function_PQgetCancel (PGconn *conn);
// Wraps call to function 'PQfreeCancel' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfreeCancel(ewg_param_cancel) PQfreeCancel ((PGcancel*)ewg_param_cancel)

void  ewg_function_PQfreeCancel (PGcancel *cancel);
// Wraps call to function 'PQcancel' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQcancel(ewg_param_cancel, ewg_param_errbuf, ewg_param_errbufsize) PQcancel ((PGcancel*)ewg_param_cancel, (char*)ewg_param_errbuf, (int)ewg_param_errbufsize)

int  ewg_function_PQcancel (PGcancel *cancel, char *errbuf, int errbufsize);
// Wraps call to function 'PQrequestCancel' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQrequestCancel(ewg_param_conn) PQrequestCancel ((PGconn*)ewg_param_conn)

int  ewg_function_PQrequestCancel (PGconn *conn);
// Wraps call to function 'PQdb' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQdb(ewg_param_conn) PQdb ((PGconn const*)ewg_param_conn)

char * ewg_function_PQdb (PGconn const *conn);
// Wraps call to function 'PQuser' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQuser(ewg_param_conn) PQuser ((PGconn const*)ewg_param_conn)

char * ewg_function_PQuser (PGconn const *conn);
// Wraps call to function 'PQpass' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQpass(ewg_param_conn) PQpass ((PGconn const*)ewg_param_conn)

char * ewg_function_PQpass (PGconn const *conn);
// Wraps call to function 'PQhost' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQhost(ewg_param_conn) PQhost ((PGconn const*)ewg_param_conn)

char * ewg_function_PQhost (PGconn const *conn);
// Wraps call to function 'PQport' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQport(ewg_param_conn) PQport ((PGconn const*)ewg_param_conn)

char * ewg_function_PQport (PGconn const *conn);
// Wraps call to function 'PQtty' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQtty(ewg_param_conn) PQtty ((PGconn const*)ewg_param_conn)

char * ewg_function_PQtty (PGconn const *conn);
// Wraps call to function 'PQoptions' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQoptions(ewg_param_conn) PQoptions ((PGconn const*)ewg_param_conn)

char * ewg_function_PQoptions (PGconn const *conn);
// Wraps call to function 'PQstatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQstatus(ewg_param_conn) PQstatus ((PGconn const*)ewg_param_conn)

ConnStatusType  ewg_function_PQstatus (PGconn const *conn);
// Wraps call to function 'PQtransactionStatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQtransactionStatus(ewg_param_conn) PQtransactionStatus ((PGconn const*)ewg_param_conn)

PGTransactionStatusType  ewg_function_PQtransactionStatus (PGconn const *conn);
// Wraps call to function 'PQparameterStatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQparameterStatus(ewg_param_conn, ewg_param_paramName) PQparameterStatus ((PGconn const*)ewg_param_conn, (char const*)ewg_param_paramName)

char const * ewg_function_PQparameterStatus (PGconn const *conn, char const *paramName);
// Wraps call to function 'PQprotocolVersion' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQprotocolVersion(ewg_param_conn) PQprotocolVersion ((PGconn const*)ewg_param_conn)

int  ewg_function_PQprotocolVersion (PGconn const *conn);
// Wraps call to function 'PQserverVersion' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQserverVersion(ewg_param_conn) PQserverVersion ((PGconn const*)ewg_param_conn)

int  ewg_function_PQserverVersion (PGconn const *conn);
// Wraps call to function 'PQerrorMessage' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQerrorMessage(ewg_param_conn) PQerrorMessage ((PGconn const*)ewg_param_conn)

char * ewg_function_PQerrorMessage (PGconn const *conn);
// Wraps call to function 'PQsocket' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsocket(ewg_param_conn) PQsocket ((PGconn const*)ewg_param_conn)

int  ewg_function_PQsocket (PGconn const *conn);
// Wraps call to function 'PQbackendPID' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQbackendPID(ewg_param_conn) PQbackendPID ((PGconn const*)ewg_param_conn)

int  ewg_function_PQbackendPID (PGconn const *conn);
// Wraps call to function 'PQconnectionNeedsPassword' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconnectionNeedsPassword(ewg_param_conn) PQconnectionNeedsPassword ((PGconn const*)ewg_param_conn)

int  ewg_function_PQconnectionNeedsPassword (PGconn const *conn);
// Wraps call to function 'PQconnectionUsedPassword' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconnectionUsedPassword(ewg_param_conn) PQconnectionUsedPassword ((PGconn const*)ewg_param_conn)

int  ewg_function_PQconnectionUsedPassword (PGconn const *conn);
// Wraps call to function 'PQclientEncoding' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQclientEncoding(ewg_param_conn) PQclientEncoding ((PGconn const*)ewg_param_conn)

int  ewg_function_PQclientEncoding (PGconn const *conn);
// Wraps call to function 'PQsetClientEncoding' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetClientEncoding(ewg_param_conn, ewg_param_encoding) PQsetClientEncoding ((PGconn*)ewg_param_conn, (char const*)ewg_param_encoding)

int  ewg_function_PQsetClientEncoding (PGconn *conn, char const *encoding);
// Wraps call to function 'PQgetssl' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetssl(ewg_param_conn) PQgetssl ((PGconn*)ewg_param_conn)

void * ewg_function_PQgetssl (PGconn *conn);
// Wraps call to function 'PQinitSSL' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQinitSSL(ewg_param_do_init) PQinitSSL ((int)ewg_param_do_init)

void  ewg_function_PQinitSSL (int do_init);
// Wraps call to function 'PQinitOpenSSL' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQinitOpenSSL(ewg_param_do_ssl, ewg_param_do_crypto) PQinitOpenSSL ((int)ewg_param_do_ssl, (int)ewg_param_do_crypto)

void  ewg_function_PQinitOpenSSL (int do_ssl, int do_crypto);
// Wraps call to function 'PQsetErrorVerbosity' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetErrorVerbosity(ewg_param_conn, ewg_param_verbosity) PQsetErrorVerbosity ((PGconn*)ewg_param_conn, (PGVerbosity)ewg_param_verbosity)

PGVerbosity  ewg_function_PQsetErrorVerbosity (PGconn *conn, PGVerbosity verbosity);
// Wraps call to function 'PQtrace' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQtrace(ewg_param_conn, ewg_param_debug_port) PQtrace ((PGconn*)ewg_param_conn, (FILE*)ewg_param_debug_port)

void  ewg_function_PQtrace (PGconn *conn, FILE *debug_port);
// Wraps call to function 'PQuntrace' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQuntrace(ewg_param_conn) PQuntrace ((PGconn*)ewg_param_conn)

void  ewg_function_PQuntrace (PGconn *conn);
// Wraps call to function 'PQsetNoticeReceiver' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetNoticeReceiver(ewg_param_conn, ewg_param_proc, ewg_param_arg) PQsetNoticeReceiver ((PGconn*)ewg_param_conn, (PQnoticeReceiver)ewg_param_proc, (void*)ewg_param_arg)

PQnoticeReceiver  ewg_function_PQsetNoticeReceiver (PGconn *conn, PQnoticeReceiver proc, void *arg);
// Wraps call to function 'PQsetNoticeProcessor' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetNoticeProcessor(ewg_param_conn, ewg_param_proc, ewg_param_arg) PQsetNoticeProcessor ((PGconn*)ewg_param_conn, (PQnoticeProcessor)ewg_param_proc, (void*)ewg_param_arg)

PQnoticeProcessor  ewg_function_PQsetNoticeProcessor (PGconn *conn, PQnoticeProcessor proc, void *arg);
// Wraps call to function 'PQregisterThreadLock' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQregisterThreadLock(ewg_param_newhandler) PQregisterThreadLock ((pgthreadlock_t)ewg_param_newhandler)

pgthreadlock_t  ewg_function_PQregisterThreadLock (pgthreadlock_t newhandler);
// Wraps call to function 'PQexec' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQexec(ewg_param_conn, ewg_param_query) PQexec ((PGconn*)ewg_param_conn, (char const*)ewg_param_query)

PGresult * ewg_function_PQexec (PGconn *conn, char const *query);
// Wraps call to function 'PQexecParams' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQexecParams(ewg_param_conn, ewg_param_command, ewg_param_nParams, ewg_param_paramTypes, ewg_param_paramValues, ewg_param_paramLengths, ewg_param_paramFormats, ewg_param_resultFormat) PQexecParams ((PGconn*)ewg_param_conn, (char const*)ewg_param_command, (int)ewg_param_nParams, (Oid const*)ewg_param_paramTypes, (char const*const *)ewg_param_paramValues, (int const*)ewg_param_paramLengths, (int const*)ewg_param_paramFormats, (int)ewg_param_resultFormat)

PGresult * ewg_function_PQexecParams (PGconn *conn, char const *command, int nParams, Oid const *paramTypes, char const *const *paramValues, int const *paramLengths, int const *paramFormats, int resultFormat);
// Wraps call to function 'PQprepare' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQprepare(ewg_param_conn, ewg_param_stmtName, ewg_param_query, ewg_param_nParams, ewg_param_paramTypes) PQprepare ((PGconn*)ewg_param_conn, (char const*)ewg_param_stmtName, (char const*)ewg_param_query, (int)ewg_param_nParams, (Oid const*)ewg_param_paramTypes)

PGresult * ewg_function_PQprepare (PGconn *conn, char const *stmtName, char const *query, int nParams, Oid const *paramTypes);
// Wraps call to function 'PQexecPrepared' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQexecPrepared(ewg_param_conn, ewg_param_stmtName, ewg_param_nParams, ewg_param_paramValues, ewg_param_paramLengths, ewg_param_paramFormats, ewg_param_resultFormat) PQexecPrepared ((PGconn*)ewg_param_conn, (char const*)ewg_param_stmtName, (int)ewg_param_nParams, (char const*const *)ewg_param_paramValues, (int const*)ewg_param_paramLengths, (int const*)ewg_param_paramFormats, (int)ewg_param_resultFormat)

PGresult * ewg_function_PQexecPrepared (PGconn *conn, char const *stmtName, int nParams, char const *const *paramValues, int const *paramLengths, int const *paramFormats, int resultFormat);
// Wraps call to function 'PQsendQuery' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsendQuery(ewg_param_conn, ewg_param_query) PQsendQuery ((PGconn*)ewg_param_conn, (char const*)ewg_param_query)

int  ewg_function_PQsendQuery (PGconn *conn, char const *query);
// Wraps call to function 'PQsendQueryParams' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsendQueryParams(ewg_param_conn, ewg_param_command, ewg_param_nParams, ewg_param_paramTypes, ewg_param_paramValues, ewg_param_paramLengths, ewg_param_paramFormats, ewg_param_resultFormat) PQsendQueryParams ((PGconn*)ewg_param_conn, (char const*)ewg_param_command, (int)ewg_param_nParams, (Oid const*)ewg_param_paramTypes, (char const*const *)ewg_param_paramValues, (int const*)ewg_param_paramLengths, (int const*)ewg_param_paramFormats, (int)ewg_param_resultFormat)

int  ewg_function_PQsendQueryParams (PGconn *conn, char const *command, int nParams, Oid const *paramTypes, char const *const *paramValues, int const *paramLengths, int const *paramFormats, int resultFormat);
// Wraps call to function 'PQsendPrepare' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsendPrepare(ewg_param_conn, ewg_param_stmtName, ewg_param_query, ewg_param_nParams, ewg_param_paramTypes) PQsendPrepare ((PGconn*)ewg_param_conn, (char const*)ewg_param_stmtName, (char const*)ewg_param_query, (int)ewg_param_nParams, (Oid const*)ewg_param_paramTypes)

int  ewg_function_PQsendPrepare (PGconn *conn, char const *stmtName, char const *query, int nParams, Oid const *paramTypes);
// Wraps call to function 'PQsendQueryPrepared' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsendQueryPrepared(ewg_param_conn, ewg_param_stmtName, ewg_param_nParams, ewg_param_paramValues, ewg_param_paramLengths, ewg_param_paramFormats, ewg_param_resultFormat) PQsendQueryPrepared ((PGconn*)ewg_param_conn, (char const*)ewg_param_stmtName, (int)ewg_param_nParams, (char const*const *)ewg_param_paramValues, (int const*)ewg_param_paramLengths, (int const*)ewg_param_paramFormats, (int)ewg_param_resultFormat)

int  ewg_function_PQsendQueryPrepared (PGconn *conn, char const *stmtName, int nParams, char const *const *paramValues, int const *paramLengths, int const *paramFormats, int resultFormat);
// Wraps call to function 'PQgetResult' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetResult(ewg_param_conn) PQgetResult ((PGconn*)ewg_param_conn)

PGresult * ewg_function_PQgetResult (PGconn *conn);
// Wraps call to function 'PQisBusy' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQisBusy(ewg_param_conn) PQisBusy ((PGconn*)ewg_param_conn)

int  ewg_function_PQisBusy (PGconn *conn);
// Wraps call to function 'PQconsumeInput' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQconsumeInput(ewg_param_conn) PQconsumeInput ((PGconn*)ewg_param_conn)

int  ewg_function_PQconsumeInput (PGconn *conn);
// Wraps call to function 'PQnotifies' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQnotifies(ewg_param_conn) PQnotifies ((PGconn*)ewg_param_conn)

PGnotify * ewg_function_PQnotifies (PGconn *conn);
// Wraps call to function 'PQputCopyData' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQputCopyData(ewg_param_conn, ewg_param_buffer, ewg_param_nbytes) PQputCopyData ((PGconn*)ewg_param_conn, (char const*)ewg_param_buffer, (int)ewg_param_nbytes)

int  ewg_function_PQputCopyData (PGconn *conn, char const *buffer, int nbytes);
// Wraps call to function 'PQputCopyEnd' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQputCopyEnd(ewg_param_conn, ewg_param_errormsg) PQputCopyEnd ((PGconn*)ewg_param_conn, (char const*)ewg_param_errormsg)

int  ewg_function_PQputCopyEnd (PGconn *conn, char const *errormsg);
// Wraps call to function 'PQgetCopyData' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetCopyData(ewg_param_conn, ewg_param_buffer, ewg_param_async) PQgetCopyData ((PGconn*)ewg_param_conn, (char**)ewg_param_buffer, (int)ewg_param_async)

int  ewg_function_PQgetCopyData (PGconn *conn, char **buffer, int async);
// Wraps call to function 'PQgetline' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetline(ewg_param_conn, ewg_param_string, ewg_param_length) PQgetline ((PGconn*)ewg_param_conn, (char*)ewg_param_string, (int)ewg_param_length)

int  ewg_function_PQgetline (PGconn *conn, char *string, int length);
// Wraps call to function 'PQputline' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQputline(ewg_param_conn, ewg_param_string) PQputline ((PGconn*)ewg_param_conn, (char const*)ewg_param_string)

int  ewg_function_PQputline (PGconn *conn, char const *string);
// Wraps call to function 'PQgetlineAsync' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetlineAsync(ewg_param_conn, ewg_param_buffer, ewg_param_bufsize) PQgetlineAsync ((PGconn*)ewg_param_conn, (char*)ewg_param_buffer, (int)ewg_param_bufsize)

int  ewg_function_PQgetlineAsync (PGconn *conn, char *buffer, int bufsize);
// Wraps call to function 'PQputnbytes' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQputnbytes(ewg_param_conn, ewg_param_buffer, ewg_param_nbytes) PQputnbytes ((PGconn*)ewg_param_conn, (char const*)ewg_param_buffer, (int)ewg_param_nbytes)

int  ewg_function_PQputnbytes (PGconn *conn, char const *buffer, int nbytes);
// Wraps call to function 'PQendcopy' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQendcopy(ewg_param_conn) PQendcopy ((PGconn*)ewg_param_conn)

int  ewg_function_PQendcopy (PGconn *conn);
// Wraps call to function 'PQsetnonblocking' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetnonblocking(ewg_param_conn, ewg_param_arg) PQsetnonblocking ((PGconn*)ewg_param_conn, (int)ewg_param_arg)

int  ewg_function_PQsetnonblocking (PGconn *conn, int arg);
// Wraps call to function 'PQisnonblocking' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQisnonblocking(ewg_param_conn) PQisnonblocking ((PGconn const*)ewg_param_conn)

int  ewg_function_PQisnonblocking (PGconn const *conn);
// Wraps call to function 'PQisthreadsafe' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQisthreadsafe PQisthreadsafe ()

int  ewg_function_PQisthreadsafe (void);
// Wraps call to function 'PQflush' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQflush(ewg_param_conn) PQflush ((PGconn*)ewg_param_conn)

int  ewg_function_PQflush (PGconn *conn);
// Wraps call to function 'PQfn' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfn(ewg_param_conn, ewg_param_fnid, ewg_param_result_buf, ewg_param_result_len, ewg_param_result_is_int, ewg_param_args, ewg_param_nargs) PQfn ((PGconn*)ewg_param_conn, (int)ewg_param_fnid, (int*)ewg_param_result_buf, (int*)ewg_param_result_len, (int)ewg_param_result_is_int, (PQArgBlock const*)ewg_param_args, (int)ewg_param_nargs)

PGresult * ewg_function_PQfn (PGconn *conn, int fnid, int *result_buf, int *result_len, int result_is_int, PQArgBlock const *args, int nargs);
// Wraps call to function 'PQresultStatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresultStatus(ewg_param_res) PQresultStatus ((PGresult const*)ewg_param_res)

ExecStatusType  ewg_function_PQresultStatus (PGresult const *res);
// Wraps call to function 'PQresStatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresStatus(ewg_param_status) PQresStatus ((ExecStatusType)ewg_param_status)

char * ewg_function_PQresStatus (ExecStatusType status);
// Wraps call to function 'PQresultErrorMessage' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresultErrorMessage(ewg_param_res) PQresultErrorMessage ((PGresult const*)ewg_param_res)

char * ewg_function_PQresultErrorMessage (PGresult const *res);
// Wraps call to function 'PQresultErrorField' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresultErrorField(ewg_param_res, ewg_param_fieldcode) PQresultErrorField ((PGresult const*)ewg_param_res, (int)ewg_param_fieldcode)

char * ewg_function_PQresultErrorField (PGresult const *res, int fieldcode);
// Wraps call to function 'PQntuples' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQntuples(ewg_param_res) PQntuples ((PGresult const*)ewg_param_res)

int  ewg_function_PQntuples (PGresult const *res);
// Wraps call to function 'PQnfields' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQnfields(ewg_param_res) PQnfields ((PGresult const*)ewg_param_res)

int  ewg_function_PQnfields (PGresult const *res);
// Wraps call to function 'PQbinaryTuples' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQbinaryTuples(ewg_param_res) PQbinaryTuples ((PGresult const*)ewg_param_res)

int  ewg_function_PQbinaryTuples (PGresult const *res);
// Wraps call to function 'PQfname' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfname(ewg_param_res, ewg_param_field_num) PQfname ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

char * ewg_function_PQfname (PGresult const *res, int field_num);
// Wraps call to function 'PQfnumber' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfnumber(ewg_param_res, ewg_param_field_name) PQfnumber ((PGresult const*)ewg_param_res, (char const*)ewg_param_field_name)

int  ewg_function_PQfnumber (PGresult const *res, char const *field_name);
// Wraps call to function 'PQftable' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQftable(ewg_param_res, ewg_param_field_num) PQftable ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

Oid  ewg_function_PQftable (PGresult const *res, int field_num);
// Wraps call to function 'PQftablecol' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQftablecol(ewg_param_res, ewg_param_field_num) PQftablecol ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

int  ewg_function_PQftablecol (PGresult const *res, int field_num);
// Wraps call to function 'PQfformat' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfformat(ewg_param_res, ewg_param_field_num) PQfformat ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

int  ewg_function_PQfformat (PGresult const *res, int field_num);
// Wraps call to function 'PQftype' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQftype(ewg_param_res, ewg_param_field_num) PQftype ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

Oid  ewg_function_PQftype (PGresult const *res, int field_num);
// Wraps call to function 'PQfsize' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfsize(ewg_param_res, ewg_param_field_num) PQfsize ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

int  ewg_function_PQfsize (PGresult const *res, int field_num);
// Wraps call to function 'PQfmod' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfmod(ewg_param_res, ewg_param_field_num) PQfmod ((PGresult const*)ewg_param_res, (int)ewg_param_field_num)

int  ewg_function_PQfmod (PGresult const *res, int field_num);
// Wraps call to function 'PQcmdStatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQcmdStatus(ewg_param_res) PQcmdStatus ((PGresult*)ewg_param_res)

char * ewg_function_PQcmdStatus (PGresult *res);
// Wraps call to function 'PQoidStatus' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQoidStatus(ewg_param_res) PQoidStatus ((PGresult const*)ewg_param_res)

char * ewg_function_PQoidStatus (PGresult const *res);
// Wraps call to function 'PQoidValue' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQoidValue(ewg_param_res) PQoidValue ((PGresult const*)ewg_param_res)

Oid  ewg_function_PQoidValue (PGresult const *res);
// Wraps call to function 'PQcmdTuples' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQcmdTuples(ewg_param_res) PQcmdTuples ((PGresult*)ewg_param_res)

char * ewg_function_PQcmdTuples (PGresult *res);
// Wraps call to function 'PQgetvalue' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetvalue(ewg_param_res, ewg_param_tup_num, ewg_param_field_num) PQgetvalue ((PGresult const*)ewg_param_res, (int)ewg_param_tup_num, (int)ewg_param_field_num)

char * ewg_function_PQgetvalue (PGresult const *res, int tup_num, int field_num);
// Wraps call to function 'PQgetlength' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetlength(ewg_param_res, ewg_param_tup_num, ewg_param_field_num) PQgetlength ((PGresult const*)ewg_param_res, (int)ewg_param_tup_num, (int)ewg_param_field_num)

int  ewg_function_PQgetlength (PGresult const *res, int tup_num, int field_num);
// Wraps call to function 'PQgetisnull' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQgetisnull(ewg_param_res, ewg_param_tup_num, ewg_param_field_num) PQgetisnull ((PGresult const*)ewg_param_res, (int)ewg_param_tup_num, (int)ewg_param_field_num)

int  ewg_function_PQgetisnull (PGresult const *res, int tup_num, int field_num);
// Wraps call to function 'PQnparams' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQnparams(ewg_param_res) PQnparams ((PGresult const*)ewg_param_res)

int  ewg_function_PQnparams (PGresult const *res);
// Wraps call to function 'PQparamtype' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQparamtype(ewg_param_res, ewg_param_param_num) PQparamtype ((PGresult const*)ewg_param_res, (int)ewg_param_param_num)

Oid  ewg_function_PQparamtype (PGresult const *res, int param_num);
// Wraps call to function 'PQdescribePrepared' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQdescribePrepared(ewg_param_conn, ewg_param_stmt) PQdescribePrepared ((PGconn*)ewg_param_conn, (char const*)ewg_param_stmt)

PGresult * ewg_function_PQdescribePrepared (PGconn *conn, char const *stmt);
// Wraps call to function 'PQdescribePortal' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQdescribePortal(ewg_param_conn, ewg_param_portal) PQdescribePortal ((PGconn*)ewg_param_conn, (char const*)ewg_param_portal)

PGresult * ewg_function_PQdescribePortal (PGconn *conn, char const *portal);
// Wraps call to function 'PQsendDescribePrepared' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsendDescribePrepared(ewg_param_conn, ewg_param_stmt) PQsendDescribePrepared ((PGconn*)ewg_param_conn, (char const*)ewg_param_stmt)

int  ewg_function_PQsendDescribePrepared (PGconn *conn, char const *stmt);
// Wraps call to function 'PQsendDescribePortal' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsendDescribePortal(ewg_param_conn, ewg_param_portal) PQsendDescribePortal ((PGconn*)ewg_param_conn, (char const*)ewg_param_portal)

int  ewg_function_PQsendDescribePortal (PGconn *conn, char const *portal);
// Wraps call to function 'PQclear' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQclear(ewg_param_res) PQclear ((PGresult*)ewg_param_res)

void  ewg_function_PQclear (PGresult *res);
// Wraps call to function 'PQfreemem' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQfreemem(ewg_param_ptr) PQfreemem ((void*)ewg_param_ptr)

void  ewg_function_PQfreemem (void *ptr);
// Wraps call to function 'PQmakeEmptyPGresult' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQmakeEmptyPGresult(ewg_param_conn, ewg_param_status) PQmakeEmptyPGresult ((PGconn*)ewg_param_conn, (ExecStatusType)ewg_param_status)

PGresult * ewg_function_PQmakeEmptyPGresult (PGconn *conn, ExecStatusType status);
// Wraps call to function 'PQcopyResult' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQcopyResult(ewg_param_src, ewg_param_flags) PQcopyResult ((PGresult const*)ewg_param_src, (int)ewg_param_flags)

PGresult * ewg_function_PQcopyResult (PGresult const *src, int flags);
// Wraps call to function 'PQsetResultAttrs' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetResultAttrs(ewg_param_res, ewg_param_numAttributes, ewg_param_attDescs) PQsetResultAttrs ((PGresult*)ewg_param_res, (int)ewg_param_numAttributes, (PGresAttDesc*)ewg_param_attDescs)

int  ewg_function_PQsetResultAttrs (PGresult *res, int numAttributes, PGresAttDesc *attDescs);
// Wraps call to function 'PQresultAlloc' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQresultAlloc(ewg_param_res, ewg_param_nBytes) PQresultAlloc ((PGresult*)ewg_param_res, (size_t)ewg_param_nBytes)

void * ewg_function_PQresultAlloc (PGresult *res, size_t nBytes);
// Wraps call to function 'PQsetvalue' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQsetvalue(ewg_param_res, ewg_param_tup_num, ewg_param_field_num, ewg_param_value, ewg_param_len) PQsetvalue ((PGresult*)ewg_param_res, (int)ewg_param_tup_num, (int)ewg_param_field_num, (char*)ewg_param_value, (int)ewg_param_len)

int  ewg_function_PQsetvalue (PGresult *res, int tup_num, int field_num, char *value, int len);
// Wraps call to function 'PQescapeStringConn' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQescapeStringConn(ewg_param_conn, ewg_param_to, ewg_param_from, ewg_param_length, ewg_param_error) PQescapeStringConn ((PGconn*)ewg_param_conn, (char*)ewg_param_to, (char const*)ewg_param_from, (size_t)ewg_param_length, (int*)ewg_param_error)

size_t  ewg_function_PQescapeStringConn (PGconn *conn, char *to, char const *from, size_t length, int *error);
// Wraps call to function 'PQescapeByteaConn' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQescapeByteaConn(ewg_param_conn, ewg_param_from, ewg_param_from_length, ewg_param_to_length) PQescapeByteaConn ((PGconn*)ewg_param_conn, (unsigned char const*)ewg_param_from, (size_t)ewg_param_from_length, (size_t*)ewg_param_to_length)

unsigned char * ewg_function_PQescapeByteaConn (PGconn *conn, unsigned char const *from, size_t from_length, size_t *to_length);
// Wraps call to function 'PQunescapeBytea' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQunescapeBytea(ewg_param_strtext, ewg_param_retbuflen) PQunescapeBytea ((unsigned char const*)ewg_param_strtext, (size_t*)ewg_param_retbuflen)

unsigned char * ewg_function_PQunescapeBytea (unsigned char const *strtext, size_t *retbuflen);
// Wraps call to function 'PQescapeString' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQescapeString(ewg_param_to, ewg_param_from, ewg_param_length) PQescapeString ((char*)ewg_param_to, (char const*)ewg_param_from, (size_t)ewg_param_length)

size_t  ewg_function_PQescapeString (char *to, char const *from, size_t length);
// Wraps call to function 'PQescapeBytea' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQescapeBytea(ewg_param_from, ewg_param_from_length, ewg_param_to_length) PQescapeBytea ((unsigned char const*)ewg_param_from, (size_t)ewg_param_from_length, (size_t*)ewg_param_to_length)

unsigned char * ewg_function_PQescapeBytea (unsigned char const *from, size_t from_length, size_t *to_length);
// Wraps call to function 'PQprint' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQprint(ewg_param_fout, ewg_param_res, ewg_param_ps) PQprint ((FILE*)ewg_param_fout, (PGresult const*)ewg_param_res, (PQprintOpt const*)ewg_param_ps)

void  ewg_function_PQprint (FILE *fout, PGresult const *res, PQprintOpt const *ps);
// Wraps call to function 'PQdisplayTuples' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQdisplayTuples(ewg_param_res, ewg_param_fp, ewg_param_fillAlign, ewg_param_fieldSep, ewg_param_printHeader, ewg_param_quiet) PQdisplayTuples ((PGresult const*)ewg_param_res, (FILE*)ewg_param_fp, (int)ewg_param_fillAlign, (char const*)ewg_param_fieldSep, (int)ewg_param_printHeader, (int)ewg_param_quiet)

void  ewg_function_PQdisplayTuples (PGresult const *res, FILE *fp, int fillAlign, char const *fieldSep, int printHeader, int quiet);
// Wraps call to function 'PQprintTuples' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQprintTuples(ewg_param_res, ewg_param_fout, ewg_param_printAttName, ewg_param_terseOutput, ewg_param_width) PQprintTuples ((PGresult const*)ewg_param_res, (FILE*)ewg_param_fout, (int)ewg_param_printAttName, (int)ewg_param_terseOutput, (int)ewg_param_width)

void  ewg_function_PQprintTuples (PGresult const *res, FILE *fout, int printAttName, int terseOutput, int width);
// Wraps call to function 'PQmblen' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQmblen(ewg_param_s, ewg_param_encoding) PQmblen ((char const*)ewg_param_s, (int)ewg_param_encoding)

int  ewg_function_PQmblen (char const *s, int encoding);
// Wraps call to function 'PQdsplen' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQdsplen(ewg_param_s, ewg_param_encoding) PQdsplen ((char const*)ewg_param_s, (int)ewg_param_encoding)

int  ewg_function_PQdsplen (char const *s, int encoding);
// Wraps call to function 'PQenv2encoding' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQenv2encoding PQenv2encoding ()

int  ewg_function_PQenv2encoding (void);
// Wraps call to function 'PQencryptPassword' in a macro
#include <my_postgres.h>

#define ewg_function_macro_PQencryptPassword(ewg_param_passwd, ewg_param_user) PQencryptPassword ((char const*)ewg_param_passwd, (char const*)ewg_param_user)

char * ewg_function_PQencryptPassword (char const *passwd, char const *user);
// Wraps call to function 'pg_char_to_encoding' in a macro
#include <my_postgres.h>

#define ewg_function_macro_pg_char_to_encoding(ewg_param_name) pg_char_to_encoding ((char const*)ewg_param_name)

int  ewg_function_pg_char_to_encoding (char const *name);
// Wraps call to function 'pg_encoding_to_char' in a macro
#include <my_postgres.h>

#define ewg_function_macro_pg_encoding_to_char(ewg_param_encoding) pg_encoding_to_char ((int)ewg_param_encoding)

char const * ewg_function_pg_encoding_to_char (int encoding);
// Wraps call to function 'pg_valid_server_encoding_id' in a macro
#include <my_postgres.h>

#define ewg_function_macro_pg_valid_server_encoding_id(ewg_param_encoding) pg_valid_server_encoding_id ((int)ewg_param_encoding)

int  ewg_function_pg_valid_server_encoding_id (int encoding);
// Wraps call to function 'get_pqnotice_receiver_stub' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_get_pqnotice_receiver_stub get_pqnotice_receiver_stub ()

void * ewg_function_get_pqnotice_receiver_stub (void);
// Wraps call to function 'set_pqnotice_receiver_entry' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_set_pqnotice_receiver_entry(ewg_param_a_class, ewg_param_a_feature) set_pqnotice_receiver_entry ((void*)ewg_param_a_class, (void*)ewg_param_a_feature)

void  ewg_function_set_pqnotice_receiver_entry (void *a_class, void *a_feature);
// Wraps call to function 'call_pqnotice_receiver' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_call_pqnotice_receiver(ewg_param_a_function, ewg_param_arg, ewg_param_res) call_pqnotice_receiver ((void*)ewg_param_a_function, (void*)ewg_param_arg, (PGresult const*)ewg_param_res)

void  ewg_function_call_pqnotice_receiver (void *a_function, void *arg, PGresult const *res);
// Wraps call to function 'get_pqnotice_processor_stub' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_get_pqnotice_processor_stub get_pqnotice_processor_stub ()

void * ewg_function_get_pqnotice_processor_stub (void);
// Wraps call to function 'set_pqnotice_processor_entry' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_set_pqnotice_processor_entry(ewg_param_a_class, ewg_param_a_feature) set_pqnotice_processor_entry ((void*)ewg_param_a_class, (void*)ewg_param_a_feature)

void  ewg_function_set_pqnotice_processor_entry (void *a_class, void *a_feature);
// Wraps call to function 'call_pqnotice_processor' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_call_pqnotice_processor(ewg_param_a_function, ewg_param_arg, ewg_param_message) call_pqnotice_processor ((void*)ewg_param_a_function, (void*)ewg_param_arg, (char const*)ewg_param_message)

void  ewg_function_call_pqnotice_processor (void *a_function, void *arg, char const *message);
// Wraps call to function 'get_pgthreadlock_t_stub' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_get_pgthreadlock_t_stub get_pgthreadlock_t_stub ()

void * ewg_function_get_pgthreadlock_t_stub (void);
// Wraps call to function 'set_pgthreadlock_t_entry' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_set_pgthreadlock_t_entry(ewg_param_a_class, ewg_param_a_feature) set_pgthreadlock_t_entry ((void*)ewg_param_a_class, (void*)ewg_param_a_feature)

void  ewg_function_set_pgthreadlock_t_entry (void *a_class, void *a_feature);
// Wraps call to function 'call_pgthreadlock_t' in a macro
#include <ewg_postgres_callback_c_glue_code.h>

#define ewg_function_macro_call_pgthreadlock_t(ewg_param_a_function, ewg_param_acquire) call_pgthreadlock_t ((void*)ewg_param_a_function, (int)ewg_param_acquire)

void  ewg_function_call_pgthreadlock_t (void *a_function, int acquire);

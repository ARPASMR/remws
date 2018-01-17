#ifndef EWG_CALLBACK_POSTGRES___
#define EWG_CALLBACK_POSTGRES___

#include <my_postgres.h>

typedef void (*pqnotice_receiver_eiffel_feature) (void *a_class, void *arg, PGresult const *res);

void* get_pqnotice_receiver_stub ();

struct pqnotice_receiver_entry_struct
{
	void* a_class;
	pqnotice_receiver_eiffel_feature feature;
};

void set_pqnotice_receiver_entry (void* a_class, void* a_feature);

void call_pqnotice_receiver (void *a_function, void *arg, PGresult const *res);


#include <my_postgres.h>

typedef void (*pqnotice_processor_eiffel_feature) (void *a_class, void *arg, char const *message);

void* get_pqnotice_processor_stub ();

struct pqnotice_processor_entry_struct
{
	void* a_class;
	pqnotice_processor_eiffel_feature feature;
};

void set_pqnotice_processor_entry (void* a_class, void* a_feature);

void call_pqnotice_processor (void *a_function, void *arg, char const *message);


#include <my_postgres.h>

typedef void (*pgthreadlock_t_eiffel_feature) (void *a_class, int acquire);

void* get_pgthreadlock_t_stub ();

struct pgthreadlock_t_entry_struct
{
	void* a_class;
	pgthreadlock_t_eiffel_feature feature;
};

void set_pgthreadlock_t_entry (void* a_class, void* a_feature);

void call_pgthreadlock_t (void *a_function, int acquire);


#endif

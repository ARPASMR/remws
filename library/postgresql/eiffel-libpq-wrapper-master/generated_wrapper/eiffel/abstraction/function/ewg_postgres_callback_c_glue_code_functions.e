-- This file has been generated by EWG. Do not edit. Changes will be lost!
-- functions wrapper
class EWG_POSTGRES_CALLBACK_C_GLUE_CODE_FUNCTIONS

obsolete
	"Use class EWG_POSTGRES_CALLBACK_C_GLUE_CODE_FUNCTIONS_EXTERNAL instead."

inherit

	EWG_POSTGRES_CALLBACK_C_GLUE_CODE_FUNCTIONS_EXTERNAL

feature
	get_pqnotice_receiver_stub: POINTER is
		local
		do
			Result := get_pqnotice_receiver_stub_external
		end

	set_pqnotice_receiver_entry (a_class: PQNOTICE_RECEIVER_DISPATCHER; a_feature: POINTER) is
		local
		do
			set_pqnotice_receiver_entry_external (a_class, a_feature)
		end

	call_pqnotice_receiver (a_function: POINTER; arg: POINTER; res: POINTER) is
		local
		do
			call_pqnotice_receiver_external (a_function, arg, res)
		end

	get_pqnotice_processor_stub: POINTER is
		local
		do
			Result := get_pqnotice_processor_stub_external
		end

	set_pqnotice_processor_entry (a_class: PQNOTICE_PROCESSOR_DISPATCHER; a_feature: POINTER) is
		local
		do
			set_pqnotice_processor_entry_external (a_class, a_feature)
		end

	call_pqnotice_processor (a_function: POINTER; arg: POINTER; message: STRING) is
		local
			message_c_string: EWG_ZERO_TERMINATED_STRING
		do
			create message_c_string.make_shared_from_string (message)
			call_pqnotice_processor_external (a_function, arg, message_c_string.item)
		end

	get_pgthreadlock_t_stub: POINTER is
		local
		do
			Result := get_pgthreadlock_t_stub_external
		end

	set_pgthreadlock_t_entry (a_class: PGTHREADLOCK_T_DISPATCHER; a_feature: POINTER) is
		local
		do
			set_pgthreadlock_t_entry_external (a_class, a_feature)
		end

	call_pgthreadlock_t (a_function: POINTER; acquire: INTEGER) is
		local
		do
			call_pgthreadlock_t_external (a_function, acquire)
		end

end
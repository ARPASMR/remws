-- enum wrapper
class EXEC_STATUS_TYPE_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = pgres_empty_query or a_value = pgres_command_ok or a_value = pgres_tuples_ok or a_value = pgres_copy_out or a_value = pgres_copy_in or a_value = pgres_bad_response or a_value = pgres_nonfatal_error or a_value = pgres_fatal_error
		end

	pgres_empty_query: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_EMPTY_QUERY"
		end

	pgres_command_ok: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_COMMAND_OK"
		end

	pgres_tuples_ok: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_TUPLES_OK"
		end

	pgres_copy_out: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_COPY_OUT"
		end

	pgres_copy_in: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_COPY_IN"
		end

	pgres_bad_response: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_BAD_RESPONSE"
		end

	pgres_nonfatal_error: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_NONFATAL_ERROR"
		end

	pgres_fatal_error: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PGRES_FATAL_ERROR"
		end

end

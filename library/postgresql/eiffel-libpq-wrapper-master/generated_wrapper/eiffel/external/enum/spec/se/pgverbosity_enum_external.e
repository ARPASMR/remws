-- enum wrapper
class PGVERBOSITY_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = pqerrors_terse or a_value = pqerrors_default or a_value = pqerrors_verbose
		end

	pqerrors_terse: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PQERRORS_TERSE"
		end

	pqerrors_default: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PQERRORS_DEFAULT"
		end

	pqerrors_verbose: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"PQERRORS_VERBOSE"
		end

end

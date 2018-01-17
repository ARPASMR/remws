-- enum wrapper
class CONN_STATUS_TYPE_ENUM_EXTERNAL

feature {ANY}

	is_valid_enum (a_value: INTEGER): BOOLEAN is
			-- Is `a_value' a valid integer code for this enum ?
		do
			Result := a_value = connection_ok or a_value = connection_bad or a_value = connection_started or a_value = connection_made or a_value = connection_awaiting_response or a_value = connection_auth_ok or a_value = connection_setenv or a_value = connection_ssl_startup or a_value = connection_needed
		end

	connection_ok: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_OK"
		end

	connection_bad: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_BAD"
		end

	connection_started: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_STARTED"
		end

	connection_made: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_MADE"
		end

	connection_awaiting_response: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_AWAITING_RESPONSE"
		end

	connection_auth_ok: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_AUTH_OK"
		end

	connection_setenv: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_SETENV"
		end

	connection_ssl_startup: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_SSL_STARTUP"
		end

	connection_needed: INTEGER is
		external
			"C macro use <my_postgres.h>"
		alias
			"CONNECTION_NEEDED"
		end

end

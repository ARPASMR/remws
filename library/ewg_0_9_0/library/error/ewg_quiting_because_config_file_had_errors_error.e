indexing

	description:

		"Error: TODO:"

	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/19 23:49:31 $"
	revision: "$Revision: 1.1 $"

class EWG_QUITING_BECAUSE_CONFIG_FILE_HAD_ERRORS_ERROR

inherit

	UT_ERROR

creation

	make

feature {NONE} -- Initialization

	make (a_parameter_name: STRING) is
			-- Create a new error reporting that parameter
			-- `a_parameter_name' has not been provided with
			-- a value.
		require
			a_parameter_name_not_void: a_parameter_name /= Void
		do
			create parameters.make (1, 1)
			parameters.put (a_parameter_name, 1)
		end

feature -- Access

	default_template: STRING is "$0: Quiting because of errors found in config file '$1'."
			-- Default template used to built the error message

	code: STRING is "EWG0003"
			-- Error code

invariant

	-- dollar0: $0 = program name
	-- dollar1: $1 = config file name

end

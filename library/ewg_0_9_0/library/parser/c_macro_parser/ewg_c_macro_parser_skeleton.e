indexing

	description:

		"Abstract skeleton for EWG_C_MACRO_PARSER"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/11/02 19:46:28 $"
	revision: "$Revision: 1.2 $"

deferred class EWG_C_MACRO_PARSER_SKELETON

inherit

	EWG_PARSER_SKELETON
		rename
			make as make_ewg_parser
		end

	EWG_C_MACRO_SCANNER
		rename
			make as make_c_scanner
		end

feature -- Initialization

	make (a_error_handler: like error_handler) is
			-- Create a new parser.
		require
			a_error_handler_not_void: a_error_handler /= Void
		do
			make_c_scanner ("")
		ensure
			error_handler_set: error_handler = a_error_handler
		end

	parse_buffer (a_buffer: KI_CHARACTER_INPUT_STREAM) is
		do
			set_input_buffer (new_file_buffer (a_buffer))
			parse
		end
	
	
invariant

	error_handler_not_void: error_handler /= Void

end

indexing

	description:

		"Base class for EWG parser test cases"

	library: "EWG Library test"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/03/19 17:23:54 $"
	revision: "$Revision: 1.15 $"

deferred class EWG_TEST_CASE

inherit

	TS_TEST_CASE

	KL_SHARED_STANDARD_FILES

	EWG_SHARED_C_SYSTEM
		export {NONE} all end

feature -- EWG asserts


feature {NONE} -- Test helpers

	assert_no_syntax_error (a_tag: STRING; a_preprocessed_header_file_name: STRING) is
		require
			a_tag_not_void: a_tag /= Void
			a_preprocessed_header_file_name_not_void: a_preprocessed_header_file_name /= Void
		do
			process (a_preprocessed_header_file_name)
			assert (a_tag, not c_parser.syntax_error)
		end

	assert_no_syntax_error_with_msc_extensions (a_tag: STRING; a_preprocessed_header_file_name: STRING) is
		require
			a_tag_not_void: a_tag /= Void
			a_preprocessed_header_file_name_not_void: a_preprocessed_header_file_name /= Void
		do
			process_with_msc_extensions (a_preprocessed_header_file_name)
			assert (a_tag, not c_parser.syntax_error)
		end

	assert_cast_from_type (an_expected_cast: STRING;
								  a_type: EWG_C_AST_TYPE) is
		require
			an_expected_cast_not_void: an_expected_cast /= Void
			an_expected_cast_not_empty: an_expected_cast.count > 0
			a_type_not_void: a_type /= Void
		local
			printer: EWG_C_TYPE_CAST_PRINTER
			output: STRING
		do
			output := STRING_.make (an_expected_cast.count)
			create printer.make_string (output)
			printer.print_declaration_from_type (a_type, "")
			assert_equal ("correct cast", an_expected_cast, output)
		end

	assert_declaration_from_type (an_expected_declaration: STRING;
											a_type: EWG_C_AST_TYPE; a_declarator: STRING) is
		require
			an_expected_declaration_not_void: an_expected_declaration /= Void
			an_expected_declaration_not_empty: an_expected_declaration.count > 0
			a_type_not_void: a_type /= Void
			a_declarator_not_void: a_declarator /= Void
			a_declarator_not_empty: a_declarator.count > 0
		local
			printer: EWG_C_DECLARATION_PRINTER
			output: STRING
		do
			output := STRING_.make (an_expected_declaration.count)
			create printer.make_string (output)
			printer.print_declaration_from_type (a_type, a_declarator)
			debug ("aleitner")
				print ("decl-test: [" + an_expected_declaration + "] [" + output + "]")
				if not STRING_.same_string (an_expected_declaration, output) then
					print (" <-----")
				end
				print ("%N")
			end
			assert_equal ("correct declaration", an_expected_declaration, output)
		end

	assert_cast_from_source (an_expected_cast: STRING; a_c_source: STRING) is
		require
			an_expected_cast_not_void: an_expected_cast /= Void
			an_expected_cast_not_empty: an_expected_cast.count > 0
			a_c_source_not_void: a_c_source /= Void
			a_c_source_not_empty: a_c_source.count > 0
		do
			parse_string (a_c_source)
			assert_cast_from_type (an_expected_cast,
										  c_system.declarations.last_declaration.type)
		end

	assert_declaration_from_source (an_expected_declaration: STRING; a_c_source: STRING) is
		require
			an_expected_declaration_not_void: an_expected_declaration /= Void
			an_expected_declaration_not_empty: an_expected_declaration.count > 0
			a_c_source_not_void: a_c_source /= Void
			a_c_source_not_empty: a_c_source.count > 0
		do
			parse_string (a_c_source)
			assert_declaration_from_type (an_expected_declaration,
													c_system.declarations.last_declaration.type,
													c_system.declarations.last_declaration.declarator)
		end

feature {NONE} -- Parser

	c_parser: EWG_C_PARSER

	error_handler: EWG_ERROR_HANDLER
			-- Error handler

	eiffel_wrapper_builder: EWG_EIFFEL_WRAPPER_BUILDER
			-- Builds Eiffel wrappers from C AST

	post_parser_processor: EWG_POST_PARSER_PROCESSOR
			-- Post Parser Processor

	config_system: EWG_CONFIG_SYSTEM

	ewg_generator: EWG_GENERATOR
			-- Generator for Eiffel wrappers

	eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET is
		require
			config_system_not_void: config_system /= Void
		do
			Result := config_system.eiffel_wrapper_set
		ensure
			result_not_void: eiffel_wrapper_set /= Void
		end

	process_correct (a_file_name: STRING) is
		require
			a_file_name_not_void: a_file_name /= Void
		do
			process (a_file_name)
			assert_no_syntax_error ("no syntax error", a_file_name)
		end

	process (a_file_name: STRING) is
		require
			a_file_name_not_void: a_file_name /= Void
		local
			in_file: KL_TEXT_INPUT_FILE
		do
			create_new_config_system (a_file_name)
			create error_handler.make
			create c_parser.make (error_handler)
			c_system.reset
			create post_parser_processor.make (error_handler)
			create eiffel_wrapper_builder.make (error_handler,
															config_system.directory_structure,
															a_file_name,
															config_system.eiffel_wrapper_set,
															config_system)
			create ewg_generator.make (a_file_name,
												error_handler,
												config_system.directory_structure,
												config_system.eiffel_wrapper_set)
			create in_file.make (a_file_name)
			error_handler.start_task ("phase 1: parsing")
			error_handler.set_current_task_total_ticks (in_file.count)
			in_file.open_read
			if in_file.is_open_read then
				c_parser.parse_buffer (in_file)
				error_handler.stop_task
				post_parser_processor.post_process
				eiffel_wrapper_builder.build
				in_file.close
			else
				assert ("required input file not found", False)
				error_handler.stop_task
			end
		end

	process_with_msc_extensions (a_file_name: STRING) is
		require
			a_file_name_not_void: a_file_name /= Void
		local
			in_file: KL_TEXT_INPUT_FILE
		do
			create_new_config_system (a_file_name)
			create error_handler.make
			create c_parser.make (error_handler)
			c_parser.enable_msc_extensions
			c_system.reset
			create post_parser_processor.make (error_handler)
			create eiffel_wrapper_builder.make (error_handler,
															config_system.directory_structure,
															a_file_name,
															config_system.eiffel_wrapper_set,
															config_system)
			create ewg_generator.make (a_file_name,
												error_handler,
												config_system.directory_structure,
												config_system.eiffel_wrapper_set)
			create in_file.make (a_file_name)
			error_handler.start_task ("phase 1: parsing")
			error_handler.set_current_task_total_ticks (in_file.count)
			in_file.open_read
			if in_file.is_open_read then
				c_parser.parse_buffer (in_file)
				error_handler.stop_task
				post_parser_processor.post_process
				eiffel_wrapper_builder.build
				in_file.close
			else
				assert ("required input file not found: " + a_file_name, False)
				error_handler.stop_task
			end
		end

	create_new_config_system (a_file_name: STRING) is
		require
			a_file_name_not_void: a_file_name /= Void
		local
			rule: EWG_CONFIG_RULE
			matching_clause: EWG_CONFIG_MATCHING_CLAUSE
			wrapper_clause: EWG_CONFIG_DEFAULT_WRAPPER_CLAUSE
		do
			create config_system.make (a_file_name)
			config_system.set_output_directory_name ("/tmp")

			create matching_clause.make
			create wrapper_clause.make
			create rule.make (matching_clause, wrapper_clause)
			config_system.append_rule (rule)
		end

	parse_string (a_c_source: STRING) is
		require
			a_c_source_not_void: a_c_source /= Void
			a_c_source_not_empty: a_c_source.count > 0
		local
			in_stream: KL_STRING_INPUT_STREAM
		do
			create in_stream.make (a_c_source)
			create error_handler.make
			create c_parser.make (error_handler)
			c_system.reset
			error_handler.start_task ("phase 1: parsing")
			error_handler.set_current_task_total_ticks (a_c_source.count)
			c_parser.parse_buffer (in_stream)
			if c_parser.syntax_error then
				assert ("syntax error", False)
			end
			error_handler.stop_task
		end

end

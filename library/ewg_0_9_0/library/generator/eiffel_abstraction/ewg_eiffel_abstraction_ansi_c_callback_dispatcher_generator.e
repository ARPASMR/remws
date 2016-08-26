indexing

	description:

		"Generates Eiffel dispatcher class for C callbacks"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:46 $"
	revision: "$Revision: 1.4 $"

class EWG_EIFFEL_ABSTRACTION_ANSI_C_CALLBACK_DISPATCHER_GENERATOR

inherit

	EWG_ABSTRACT_GENERATOR

	EWG_EIFFEL_ABSTRACTION_ANSI_C_CALLBACK_SIGNATURE_GENERATOR
		export {NONE} all end

	EWG_SHARED_TEMPLATE_EXPANDER
		export {NONE} all end

	EWG_RENAMER
		export {NONE} all end

creation

	make

feature -- Generation

	generate (a_eiffel_wrapper_set: EWG_EIFFEL_WRAPPER_SET) is
		local
			cs: DS_BILINEAR_CURSOR [EWG_CALLBACK_WRAPPER]
			file_name: STRING
			file: KL_TEXT_OUTPUT_FILE
		do
			from
				cs := a_eiffel_wrapper_set.new_callback_wrapper_cursor
				cs.start
			until
				cs.off
			loop
				if cs.item /= Void then

					file_name := file_system.pathname (directory_structure.eiffel_abstraction_callback_directory_name, STRING_.as_lower (eiffel_class_name_from_c_callback_name (cs.item.mapped_eiffel_name) + "_DISPATCHER") + ".e")

					create file.make (file_name)
					file.recursive_open_write

					if not file.is_open_write then
						error_handler.report_cannot_write_error (file_name)
					else
						file.put_line (Generated_file_warning_eiffel_comment)
						file.put_new_line
						output_stream := file
						generate_callback_wrapper (cs.item)
						file.close
					end
				end
				cs.forth
				error_handler.tick
			end
		end

feature {NONE} -- Implementation

	generate_callback_wrapper (a_callback_wrapper: EWG_CALLBACK_WRAPPER) is
		require
			a_callback_wrapper_not_void: a_callback_wrapper /= Void
		local
			class_name: STRING
			upper_name: STRING
			ext_class_name: STRING
		do
			class_name := eiffel_class_name_from_c_callback_name (a_callback_wrapper.mapped_eiffel_name) + "_DISPATCHER"
			upper_name := eiffel_class_name_from_c_callback_name (a_callback_wrapper.mapped_eiffel_name)

			ext_class_name := c_header_file_name_to_eiffel_class_name (directory_structure.relative_callback_c_glue_header_file_name)
			template_expander.expand_into_stream_from_array (output_stream,
																			 dispatcher_class_template,
																			 <<upper_name,
																				a_callback_wrapper.set_entry_struct.mapped_eiffel_name,
																				on_callback (a_callback_wrapper, "on_callback", "callback.on_callback"), -- TODO: big mem waster (write to stream directly instead of creating temp string!)
																				ext_class_name,
																				a_callback_wrapper.get_stub.mapped_eiffel_name>>)
		end

feature {NONE} -- Templates

	dispatcher_class_template: STRING is
			-- $1 ... callback name in upper case
			-- $2 ... "set_entry_*_struct" function name
			-- $3 ... on_callback
			-- $4 ... class name of external function wrapper for callback glue
			-- $5 ... "get_*_stub" function name
		once
			Result := "class $1_DISPATCHER%N" +
				"%N" +
				"inherit%N" +
				"%N" +
				"%TANY%N" +
				"%N" +
				"%T$4_FUNCTIONS_EXTERNAL%N" +
				"%T%Texport {NONE} all end%N" +
				"%N" +
				"creation%N" +
				"%N" +
				"%Tmake%N" +
				"%N" +
				"feature {NONE}%N" +
				"%N" +
				"%Tmake (a_callback: $1_CALLBACK) is%N" +
				"%T%Trequire%N" +
				"%T%T%Ta_callback_not_void: a_callback /= Void%N" +
				"%T%Tdo%N" +
				"%T%T%Tcallback := a_callback%N" +
				"%T%T%T$2_external (Current, $on_callback)%N" +
				"%T%Tend%N" +
				"%N" +
				"feature {ANY}%N" +
				"%N" +
				"%Tcallback: $1_CALLBACK%N" +
				"%N" +
				"%Tc_dispatcher: POINTER is%N" +
				"%T%Tdo%N" +
				"%T%T%TResult := $5_external%N" +
				"%T%Tend%N" +
				"%N" +
				"feature {NONE} -- Implementation%N" +
				"%N" +
				"%Tfrozen $3" +
				"%N" +
				"invariant%N" +
				"%N" +
				"%T callback_not_void: callback /= Void%N" +
				"%N" +
				"end%N"
			end

end

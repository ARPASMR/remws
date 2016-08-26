indexing

	description:

		"Common routines for abstraction callback generators"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:46 $"
	revision: "$Revision: 1.2 $"

class EWG_EIFFEL_ABSTRACTION_ANSI_C_CALLBACK_SIGNATURE_GENERATOR

inherit

	ANY

	EWG_SHARED_TEMPLATE_EXPANDER
		export {NONE} all end

	EWG_RENAMER
		export {NONE} all end

feature

	on_callback (a_callback_wrapper: EWG_CALLBACK_WRAPPER; a_feature_name: STRING; a_delegation_feature_name: STRING): STRING is
		require
			a_callback_wrapper_not_void: a_callback_wrapper /= Void
			a_feature_name_not_void: a_feature_name /= Void
			a_delegation_feature_name_not_void: a_delegation_feature_name /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
		do
			Result := STRING_.make (100)
			Result.append_string (on_callback_signature (a_callback_wrapper, a_feature_name))
			Result.append_character ('%N')
			Result.append_string ("%T%Tdo%N%T%T%T")
			if a_callback_wrapper.return_type /= Void then
				Result.append_string ("Result := ")
			end
			Result.append_string (a_delegation_feature_name)
			Result.append_character (' ')
			if a_callback_wrapper.members.count > 0 then
				Result.append_string ("(")
				from
					cs := a_callback_wrapper.members.new_cursor
					cs.start
				until
					cs.off
				loop
					Result.append_string ("a_")
					Result.append_string (cs.item.mapped_eiffel_name)
					if not cs.is_last then
						Result.append_string (", ")
					end
					cs.forth
				end
				Result.append_string (") ")
			end
			Result.append_string ("%N%T%Tend%N")
		end

	on_callback_signature (a_callback_wrapper: EWG_CALLBACK_WRAPPER; a_feature_name: STRING): STRING is
		require
			a_callback_wrapper_not_void: a_callback_wrapper /= Void
			a_feature_name_not_void: a_feature_name /= Void
		local
			cs: DS_BILINEAR_CURSOR [EWG_MEMBER_WRAPPER]
			native_member_wrapper: EWG_NATIVE_MEMBER_WRAPPER
		do
			Result := STRING_.make (100)
			Result.append_string (a_feature_name)
			Result.append_character (' ')
			if a_callback_wrapper.members.count > 0 then
				Result.append_string ("(")
				from
					cs := a_callback_wrapper.members.new_cursor
					cs.start
				until
					cs.off
				loop
					native_member_wrapper ?= cs.item
						check
							no_other_wrapper_supported_yet: native_member_wrapper /= Void
						end
					Result.append_string ("a_")
					Result.append_string(native_member_wrapper.mapped_eiffel_name)
					Result.append_string (": ")
					Result.append_string (native_member_wrapper.c_declaration.type.corresponding_eiffel_type)

					if not cs.is_last then
						Result.append_string ("; ")
					end
					cs.forth
				end
				Result.append_string (")")
			end
			if a_callback_wrapper.return_type /= Void then
				native_member_wrapper ?= a_callback_wrapper.return_type
					check
						no_other_wrapper_supported_yet: native_member_wrapper /= Void
					end
				Result.append_string (": ")
				Result.append_string (native_member_wrapper.c_declaration.type.corresponding_eiffel_type)
			end
			Result.append_string (" is ")
		end

end

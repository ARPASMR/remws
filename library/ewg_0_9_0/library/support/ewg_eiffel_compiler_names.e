indexing

	description:

		"Names of various Eiffel compilers"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/02/27 12:18:32 $"
	revision: "$Revision: 1.2 $"

class EWG_EIFFEL_COMPILER_NAMES

inherit

	ANY

	EWG_SHARED_STRING_EQUALITY_TESTER
		export {NONE} all end

creation {EWG_SHARED_EIFFEL_COMPILER_NAMES}

	make

feature {NONE} -- Initialization

	make is
		do
		end

feature {ANY} -- Eiffel compiler names

	se_name: STRING is "se"
	ise_name: STRING is "ise"
	ve_name: STRING is "ve"

feature {ANY} -- Eiffel compiler codes

	se_code: INTEGER is unique
	ise_code: INTEGER is unique
	ve_code: INTEGER is unique

feature {ANY} -- Status

	is_valid_eiffel_compiler_name (a_name: STRING): BOOLEAN is
			-- Is `a_name' a valid Eiffel compiler name?
		require
			a_name_not_void: a_name /= Void
		do
			Result := eiffel_compiler_name_table.has (a_name)
		end

	is_valid_eiffel_compiler_code (a_code: INTEGER): BOOLEAN is
			-- Is `a_code' a valid Eiffel compiler code?
		do
			Result := eiffel_compiler_name_table.has_item (a_code)
		end

	eiffel_compiler_code_from_mode_name (a_name: STRING): INTEGER is
			-- Eiffel compiler code from Eiffel compiler name `a_name'
		require
			a_name_not_void: a_name /= Void
			a_name_valid: is_valid_eiffel_compiler_name (a_name)
		do
			Result := eiffel_compiler_name_table.item (a_name)
		ensure
			valid_eiffel_compiler_code: is_valid_eiffel_compiler_code (Result)
		end

	eiffel_compiler_name_from_code (a_code: INTEGER): STRING is
			-- Eiffel compiler name from eiffel compiler code `a_code'
		require
			a_code_valid: is_valid_eiffel_compiler_code (a_code)
		local
			cs: DS_HASH_TABLE_CURSOR [INTEGER, STRING]
		do
			from
				cs := eiffel_compiler_name_table.new_cursor
				cs.start
			until
				cs.off
			loop
				if cs.item = a_code then
					Result := cs.key
				end
				cs.forth
			end
		ensure
			eiffel_compiler_name_not_void: Result /= Void
			valid_eiffel_compiler_name: is_valid_eiffel_compiler_name (Result)
		end

feature {NONE} -- Implementation

	eiffel_compiler_name_table: DS_HASH_TABLE [INTEGER, STRING] is
			-- Mapping Eiffel compiler names -> Eiffel compiler codes
		once
			create Result.make_map (3)
			Result.set_key_equality_tester (string_equality_tester)
			Result.put_new (se_code, se_name)
			Result.put_new (ise_code, ise_name)
			Result.put_new (ve_code, ve_name)
		end

end

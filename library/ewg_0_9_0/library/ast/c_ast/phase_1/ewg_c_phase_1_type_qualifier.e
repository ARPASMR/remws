indexing

	description:

		"AST Element of Phase 1, represents type qualifiers"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/04/20 21:09:03 $"
	revision: "$Revision: 1.3 $"

class EWG_C_PHASE_1_TYPE_QUALIFIER

inherit

	ANY
		redefine
			out
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		undefine
			out
		end
	
creation

	make

feature

	make is
		do
		end

feature

	set_const is
		do
			is_const := True
		ensure
			set_is_const: is_const
		end
	
	set_volatile is
		do
			is_volatile := True
		ensure
			set_is_volatile: is_volatile
		end
	
feature

	none_set: BOOLEAN is
		do
			Result := not is_const and not is_volatile
		end

	merge (other: EWG_C_PHASE_1_TYPE_QUALIFIER) is
		do
			if other.is_const then
				set_const
			end
			if other.is_volatile then
				set_volatile
			end
		end

feature

	is_const: BOOLEAN

	is_volatile: BOOLEAN

feature

	c_code: STRING is
		local
			count: INTEGER
		do
			if is_const then
				count := count + 6
			end
			if is_volatile then
				count := count + 9
			end
			Result := STRING_.make (count)
			if is_const then
				Result.append_string ("const ")
			end
			if is_volatile then
				Result.append_string ("volatile ")
			end
			
		end
	
	out: STRING is
		do
			Result := ""
			if is_const then
				Result := Result + "const "
			end
			if is_volatile then
				Result := Result + "volatile "
			end
		end
	

end

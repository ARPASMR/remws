indexing

	description:

		"Comparators for ordering options"

	library: "Gobo Eiffel Argument Library"
	copyright: "Copyright (c) 2006, Bernd Schoeller and others"
	license: "MIT License"
	date: "$Date: 2008-10-05 12:21:37 +0200 (Sun, 05 Oct 2008) $"
	revision: "$Revision: 6530 $"

class AP_OPTION_COMPARATOR

inherit

	KL_COMPARATOR [AP_OPTION]

	KL_IMPORTED_STRING_ROUTINES

feature -- Status report

	less_than (u, v: AP_OPTION): BOOLEAN is
			-- Is `u' considered less than `v'?
		local
			u_string, v_string: STRING
		do
			if u.has_long_form then
				u_string := u.long_form
			else
				u_string := u.short_form.out
			end
			if v.has_long_form then
				v_string := v.long_form
			else
				v_string := v.short_form.out
			end
			Result := STRING_.three_way_comparison (u_string, v_string) = -1
		end

end

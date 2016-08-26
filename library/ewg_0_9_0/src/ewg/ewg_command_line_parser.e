indexing

	description:

		"Command-line parsers for 'ewg'"

	copyright: "Copyright (c) 2004, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2004/11/11 17:33:41 $"
	revision: "$Revision: 1.3 $"

class EWG_COMMAND_LINE_PARSER

inherit

	GEXACE_COMMAND_LINE_PARSER

	KL_IMPORTED_STRING_ROUTINES

creation

	make

feature -- Status report

	has_long_option (an_option_name: STRING): BOOLEAN is
			-- Is there a long option on the command-line whose name is
			-- `an_option_name' (note that `an_option_name' does not
			-- contain the leading '--' characters)?
		require
			an_option_name_not_void: an_option_name /= Void
		local
			i: INTEGER
			arg: STRING
			nb: INTEGER
		do
			from
				i := 1
			until
				(i > Arguments.argument_count) or Result
			loop
				arg := Arguments.argument (i)
				nb := an_option_name.count + 2
				if
					arg.count >= nb and then
					(arg.item (1) = '-' and
					 arg.item (2) = '-') and then
						STRING_.same_string (arg.substring (3, nb), an_option_name)
				then
					Result := (arg.count = nb or else arg.item (nb + 1) = '=')
				end

				i := i + 1
			end
		end

end

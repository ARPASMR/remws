indexing

	description:

		"Routines that help with string manipulations"

	library: "Eiffel Wrapper Generator Library"
	copyright: "Copyright (c) 1999, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/02/13 16:39:45 $"
	revision: "$Revision: 1.3 $"

class EWG_PRINT_ROUTINES

inherit

	ANY

	KL_SHARED_FILE_SYSTEM
		export {NONE} all end

	KL_IMPORTED_STRING_ROUTINES
		export {NONE} all end
feature

	print_char_multiple_times (a_output_stream: KI_TEXT_OUTPUT_STREAM; a_char: CHARACTER; a_n: INTEGER) is
		require
			a_output_stream_not_void: a_output_stream /= Void
			a_n_greater_equal_zero: a_n >= 0
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_n
			loop
				a_output_stream.put_character (a_char)
				i := i + 1
			end
		end

	print_string_multiple_times (a_output_stream: KI_TEXT_OUTPUT_STREAM; a_string: STRING; a_n: INTEGER) is
		require
			a_output_stream_not_void: a_output_stream /= Void
			a_n_greater_equal_zero: a_n >= 0
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_n
			loop
				a_output_stream.put_string (a_string)
				i := i + 1
			end
		end

	append_char_multiple_times (a_string: STRING; a_char: CHARACTER; a_n: INTEGER) is
		require
			a_string_not_void: a_string /= Void
			a_n_greater_equal_zero:  a_n >= 0
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_n
			loop
				a_string.append_character (a_char)
				i := i + 1
			end
		end

	append_string_multiple_times (a_string: STRING; a_s: STRING; a_n: INTEGER) is
		require
			a_string_not_void: a_string /= Void
			a_s_not_void: a_s /= Void
			a_n_greater_equal_zero:  a_n >= 0
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_n
			loop
				a_string.append_string (a_s)
				i := i + 1
			end
		end

	char_multiple_times (a_char: CHARACTER; a_n: INTEGER): STRING is
		require
			a_n_greater_equal_zero: a_n >= 0
		do
			if a_n > 0 then
				Result := STRING_.make_filled (a_char, a_n)
			else
				Result := clone ("")
			end
		ensure
			result_not_void: Result /= Void
		end

	string_multiple_times (a_string: STRING; a_n: INTEGER): STRING is
		require
			a_n_greater_equal_zero: a_n >= 0
		local
			i: INTEGER
		do
			Result := STRING_.make (a_string.count * a_n)
			from
				i := 1
			until
				i > a_n
			loop
				Result.append_string (a_string)
				i := i + 1
			end
		ensure
			result_not_void: Result /= Void
		end

	file_name_without_extension_and_path (a_file_name: STRING): STRING is
			-- Return `a_file_name' without it's extension.
		require
			a_file_name_not_void: a_file_name /= Void
		do
			Result := file_system.basename (clone (a_file_name))
			STRING_.remove_tail (Result, file_system.extension (a_file_name).count)
		ensure
			result_not_void: Result /= Void
		end


	replace_all (a_string: STRING; a_from: CHARACTER; a_to: CHARACTER) is
		require
			a_string_not_void: a_string /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_string.count
			loop
				if a_string.item (i) = a_from then
					a_string.put (a_to, i)
				end
				i := i + 1
			end
		end

	remove_all (a_string: STRING; a_character: CHARACTER) is
		require
			a_string_not_void: a_string /= Void
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > a_string.count
			loop
				if a_string.item (i) = a_character then
					a_string.remove (i)
				else
					i := i + 1
				end
			end
		end

end

indexing
	description: "Scan C header file for type definitions"
	status: "See notice at end of class"
	author: "Based on http://www.lysator.liu.se/c"
	date: "$Date: 2005/10/12 08:32:45 $"
	revision: "$Revision: 1.8 $"
	note: "Based on: http://www.lysator.liu.se/c"

deferred class EWG_C_SCANNER

inherit

	EWG_C_SCANNER_SKELETON


feature -- Status report

	valid_start_condition (sc: INTEGER): BOOLEAN is
			-- Is `sc' a valid start condition?
		do
			Result := (INITIAL <= sc and sc <= SC_GCC_ATTRIBUTE)
		end

feature {NONE} -- Implementation

	yy_build_tables is
			-- Build scanner tables.
		do
			yy_nxt := yy_nxt_template
			yy_chk := yy_chk_template
			yy_base := yy_base_template
			yy_def := yy_def_template
			yy_ec := yy_ec_template
			yy_meta := yy_meta_template
			yy_accept := yy_accept_template
		end

	yy_execute_action (yy_act: INTEGER) is
			-- Execute semantic action.
		do
if yy_act <= 66 then
if yy_act <= 33 then
if yy_act <= 17 then
if yy_act <= 9 then
if yy_act <= 5 then
if yy_act <= 3 then
if yy_act <= 2 then
if yy_act = 1 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 37 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 37")
end

				set_start_condition (SC_FILE)
				less (0)
			
else
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 48 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 48")
end
 -- GNU CPP style
				set_header_line_number ((text_substring (3, text_count - 2)).to_integer)
				
end
else
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 51 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 51")
end
  -- Visual C++ style
				set_header_line_number ((text_substring (7, text_count - 2)).to_integer)
			
end
else
if yy_act = 4 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 54 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 54")
end
  set_start_condition (INITIAL) 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 55 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 55")
end
 set_header_file_name (text) 
end
end
else
if yy_act <= 7 then
if yy_act = 6 then
	yy_line := yy_line + 1
	yy_column := 1
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 56 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 56")
end
set_start_condition (INITIAL) 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 59 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 59")
end

					implementation_bracket_counter := implementation_bracket_counter + 1
				
end
else
if yy_act = 8 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 62 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 62")
end

					implementation_bracket_counter := implementation_bracket_counter - 1
					if implementation_bracket_counter = 0 then
						last_token := Right_brace_code
						last_string_value := text
					end
				
else
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 70 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 70")
end
 
end
end
end
else
if yy_act <= 13 then
if yy_act <= 11 then
if yy_act = 10 then
yy_set_line_column
	yy_position := yy_position + 1
--|#line 72 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 72")
end
 
else
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 75 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 75")
end

					check
						msc_declspec_bracket_counter_is_zero: msc_declspec_bracket_counter = 0
					end
					if is_msc_extensions_enabled then
						-- grammar for "__declspec" construct is ambiguos.
						-- we don't need this information -> we ignore it
						-- (now we need to the "(dllimport)" part too)
						set_start_condition (SC_MSC_DECLSPEC)
					else
						report_type_or_identifier (text)
					end
				
end
else
if yy_act = 12 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 88 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 88")
end

				msc_declspec_bracket_counter := msc_declspec_bracket_counter + 1
			
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 91 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 91")
end

					msc_declspec_bracket_counter := msc_declspec_bracket_counter - 1
					if msc_declspec_bracket_counter = 0 then
						set_start_condition (INITIAL)
					end
			
end
end
else
if yy_act <= 15 then
if yy_act = 14 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 97 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 97")
end

else
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 102 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 102")
end
 last_token := TOK_AUTO; last_string_value := text
end
else
if yy_act = 16 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 103 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 103")
end
 last_token := TOK_BREAK; last_string_value := text 
else
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 104 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 104")
end
 last_token := TOK_CASE; last_string_value := text 
end
end
end
end
else
if yy_act <= 25 then
if yy_act <= 21 then
if yy_act <= 19 then
if yy_act = 18 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 105 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 105")
end
 last_token := TOK_CHAR; last_string_value := text 
else
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 106 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 106")
end
 last_token := TOK_CONST; last_string_value := text 
end
else
if yy_act = 20 then
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 107 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 107")
end
 last_token := TOK_CONTINUE; last_string_value := text 
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 108 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 108")
end
 last_token := TOK_DEFAULT; last_string_value := text 
end
end
else
if yy_act <= 23 then
if yy_act = 22 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 109 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 109")
end
 last_token := TOK_DO; last_string_value := text 
else
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 110 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 110")
end
 last_token := TOK_DOUBLE; last_string_value := text 
end
else
if yy_act = 24 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 111 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 111")
end
 last_token := TOK_ELSE; last_string_value := text 
else
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 112 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 112")
end
 last_token := TOK_ENUM; last_string_value := text 
end
end
end
else
if yy_act <= 29 then
if yy_act <= 27 then
if yy_act = 26 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 113 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 113")
end
 last_token := TOK_EXTERN; last_string_value := text 
else
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 114 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 114")
end
 last_token := TOK_FLOAT; last_string_value := text 
end
else
if yy_act = 28 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 115 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 115")
end
 last_token := TOK_FOR; last_string_value := text 
else
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 116 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 116")
end
 last_token := TOK_GOTO; last_string_value := text 
end
end
else
if yy_act <= 31 then
if yy_act = 30 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 117 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 117")
end
 last_token := TOK_IF; last_string_value := text 
else
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 118 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 118")
end
 last_token := TOK_INT; last_string_value := text 
end
else
if yy_act = 32 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 119 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 119")
end
 last_token := TOK_LONG; last_string_value := text 
else
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 120 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 120")
end
 last_token := TOK_REGISTER; last_string_value := text 
end
end
end
end
end
else
if yy_act <= 50 then
if yy_act <= 42 then
if yy_act <= 38 then
if yy_act <= 36 then
if yy_act <= 35 then
if yy_act = 34 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 121 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 121")
end
 last_token := TOK_RETURN; last_string_value := text 
else
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 122 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 122")
end
 last_token := TOK_SHORT; last_string_value := text 
end
else
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 123 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 123")
end
 last_token := TOK_SIGNED; last_string_value := text 
end
else
if yy_act = 37 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 124 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 124")
end
 last_token := TOK_SIZEOF; last_string_value := text 
else
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 125 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 125")
end
 last_token := TOK_STATIC; last_string_value := text 
end
end
else
if yy_act <= 40 then
if yy_act = 39 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 126 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 126")
end
 last_token := TOK_INLINE; last_string_value := text 
else
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 127 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 127")
end
 last_token := TOK_STRUCT; last_string_value := text 
end
else
if yy_act = 41 then
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 128 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 128")
end
 last_token := TOK_SWITCH; last_string_value := text 
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 129 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 129")
end
 last_token := TOK_TYPEDEF; last_string_value := text 
end
end
end
else
if yy_act <= 46 then
if yy_act <= 44 then
if yy_act = 43 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 130 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 130")
end
 last_token := TOK_UNION; last_string_value := text 
else
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 131 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 131")
end
 last_token := TOK_UNSIGNED; last_string_value := text 
end
else
if yy_act = 45 then
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 132 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 132")
end
 last_token := TOK_VOID; last_string_value := text 
else
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 133 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 133")
end
 last_token := TOK_VOLATILE; last_string_value := text 
end
end
else
if yy_act <= 48 then
if yy_act = 47 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 134 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 134")
end
 last_token := TOK_WHILE; last_string_value := text 
else
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 135 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 135")
end

				-- gcc extension
				last_token := TOK_SIGNED; last_string_value := text 			   
end
else
if yy_act = 49 then
	yy_column := yy_column + 13
	yy_position := yy_position + 13
--|#line 140 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 140")
end
 
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 143 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 143")
end
 last_token := TOK_CONST; last_string_value := text 
end
end
end
end
else
if yy_act <= 58 then
if yy_act <= 54 then
if yy_act <= 52 then
if yy_act = 51 then
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 144 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 144")
end
 
else
	yy_column := yy_column + 13
	yy_position := yy_position + 13
--|#line 145 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 145")
end

				 -- eat, hopefully this thing is not usefull for us
					gcc_attribute_bracket_counter := 0
					set_start_condition (SC_GCC_ATTRIBUTE)
				
end
else
if yy_act = 53 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 151 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 151")
end

				gcc_attribute_bracket_counter := gcc_attribute_bracket_counter + 1
			 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 154 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 154")
end

				gcc_attribute_bracket_counter := gcc_attribute_bracket_counter - 1
				if gcc_attribute_bracket_counter = 0 then
					set_start_condition (INITIAL)
				end
			 
end
end
else
if yy_act <= 56 then
if yy_act = 55 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 160 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 160")
end

else
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 162 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 162")
end

end
else
if yy_act = 57 then
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 164 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 164")
end

else
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 167 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 167")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_INT_8
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
end
end
end
else
if yy_act <= 62 then
if yy_act <= 60 then
if yy_act = 59 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 175 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 175")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_INT_16
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 183 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 183")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_INT_32
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
end
else
if yy_act = 61 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 191 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 191")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_INT_64
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 199 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 199")
end

					if is_msc_extensions_enabled then
						-- ignore, we don't need it
					else
						report_type_or_identifier (text)
					end
				
end
end
else
if yy_act <= 64 then
if yy_act = 63 then
	yy_column := yy_column + 10
	yy_position := yy_position + 10
--|#line 206 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 206")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_FASTCALL
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 214 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 214")
end

					if is_msc_extensions_enabled then
						-- last_token := TOK_CL_BASED
						-- last_string_value := text
						-- ignore, we don't need it
					else
						report_type_or_identifier (text)
					end
				
end
else
if yy_act = 65 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 223 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 223")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_ASM
						last_string_value := text
					else
						-- This is a gcc extension, we ignore it
						gcc_attribute_bracket_counter := 0
						set_start_condition (SC_GCC_ATTRIBUTE)
					end
				
else
	yy_column := yy_column + 4
	yy_position := yy_position + 4
--|#line 233 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 233")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_ASM
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
end
end
end
end
end
end
else
if yy_act <= 99 then
if yy_act <= 83 then
if yy_act <= 75 then
if yy_act <= 71 then
if yy_act <= 69 then
if yy_act <= 68 then
if yy_act = 67 then
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 241 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 241")
end

					if is_msc_extensions_enabled then
						-- last_token := TOK_CL_INLINE
						-- last_string_value := text
						-- ignore, we don't need it
					else
						report_type_or_identifier (text)
					end
				
else
	yy_column := yy_column + 7
	yy_position := yy_position + 7
--|#line 250 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 250")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_CDECL
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
end
else
	yy_column := yy_column + 6
	yy_position := yy_position + 6
--|#line 258 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 258")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_CDECL
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
end
else
if yy_act = 70 then
	yy_column := yy_column + 9
	yy_position := yy_position + 9
--|#line 266 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 266")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_STDCALL
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
				
else
	yy_column := yy_column + 8
	yy_position := yy_position + 8
--|#line 274 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 274")
end

					if is_msc_extensions_enabled then
						last_token := TOK_CL_STDCALL
						last_string_value := text
					else
						report_type_or_identifier (text)
					end
					
end
end
else
if yy_act <= 73 then
if yy_act = 72 then
	yy_column := yy_column + 12
	yy_position := yy_position + 12
--|#line 282 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 282")
end

					if is_msc_extensions_enabled then
						-- ignore, we don't need it
					else
						report_type_or_identifier (text)
					end
					
else
	yy_column := yy_column + 13
	yy_position := yy_position + 13
--|#line 289 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 289")
end

					if is_msc_extensions_enabled then
						-- ignore, we don't need it
					else
						report_type_or_identifier (text)
					end
					
end
else
if yy_act = 74 then
	yy_column := yy_column + 5
	yy_position := yy_position + 5
--|#line 297 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 297")
end
 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 299 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 299")
end
 report_type_or_identifier (text)	
end
end
end
else
if yy_act <= 79 then
if yy_act <= 77 then
if yy_act = 76 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 301 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 301")
end
 last_token := TOK_CONSTANT; last_string_value := text 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 302 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 302")
end
 last_token := TOK_CONSTANT; last_string_value := text 
end
else
if yy_act = 78 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 303 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 303")
end
 last_token := TOK_CONSTANT; last_string_value := text 
else
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 304 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 304")
end
 last_token := TOK_CONSTANT; last_string_value := text 
end
end
else
if yy_act <= 81 then
if yy_act = 80 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 306 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 306")
end
 last_token := TOK_CONSTANT; last_string_value := text 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 307 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 307")
end
 last_token := TOK_CONSTANT; last_string_value := text 
end
else
if yy_act = 82 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 308 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 308")
end
 last_token := TOK_CONSTANT; last_string_value := text 
else
yy_set_line_column
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 310 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 310")
end
 last_token := TOK_STRING_LITERAL; last_string_value := text 
end
end
end
end
else
if yy_act <= 91 then
if yy_act <= 87 then
if yy_act <= 85 then
if yy_act = 84 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 312 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 312")
end
 last_token := TOK_ELLIPSIS; last_string_value := text 
else
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 313 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 313")
end
 last_token := TOK_RIGHT_ASSIGN; last_string_value := text 
end
else
if yy_act = 86 then
	yy_column := yy_column + 3
	yy_position := yy_position + 3
--|#line 314 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 314")
end
 last_token := TOK_LEFT_ASSIGN; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 315 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 315")
end
 last_token := TOK_ADD_ASSIGN; last_string_value := text 
end
end
else
if yy_act <= 89 then
if yy_act = 88 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 316 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 316")
end
 last_token := TOK_SUB_ASSIGN; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 317 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 317")
end
 last_token := TOK_MUL_ASSIGN; last_string_value := text 
end
else
if yy_act = 90 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 318 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 318")
end
 last_token := TOK_DIV_ASSIGN; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 319 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 319")
end
 last_token := TOK_MOD_ASSIGN; last_string_value := text 
end
end
end
else
if yy_act <= 95 then
if yy_act <= 93 then
if yy_act = 92 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 320 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 320")
end
 last_token := TOK_AND_ASSIGN; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 321 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 321")
end
 last_token := TOK_XOR_ASSIGN; last_string_value := text 
end
else
if yy_act = 94 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 322 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 322")
end
 last_token := TOK_OR_ASSIGN; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 323 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 323")
end
 last_token := TOK_RIGHT_OP; last_string_value := text 
end
end
else
if yy_act <= 97 then
if yy_act = 96 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 324 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 324")
end
 last_token := TOK_LEFT_OP; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 325 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 325")
end
 last_token := TOK_INC_OP; last_string_value := text 
end
else
if yy_act = 98 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 326 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 326")
end
 last_token := TOK_DEC_OP; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 327 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 327")
end
 last_token := TOK_PTR_OP; last_string_value := text 
end
end
end
end
end
else
if yy_act <= 116 then
if yy_act <= 108 then
if yy_act <= 104 then
if yy_act <= 102 then
if yy_act <= 101 then
if yy_act = 100 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 328 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 328")
end
 last_token := TOK_AND_OP; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 329 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 329")
end
 last_token := TOK_OR_OP; last_string_value := text 
end
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 330 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 330")
end
 last_token := TOK_LE_OP; last_string_value := text 
end
else
if yy_act = 103 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 331 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 331")
end
 last_token := TOK_GE_OP; last_string_value := text 
else
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 332 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 332")
end
 last_token := TOK_EQ_OP; last_string_value := text 
end
end
else
if yy_act <= 106 then
if yy_act = 105 then
	yy_column := yy_column + 2
	yy_position := yy_position + 2
--|#line 333 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 333")
end
 last_token := TOK_NE_OP; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 335 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 335")
end
 last_token := Semicolon_code; last_string_value := text
end
else
if yy_act = 107 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 336 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 336")
end
 last_token := Left_brace_code; last_string_value := text 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 337 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 337")
end
 last_token := Right_brace_code; last_string_value := text 
end
end
end
else
if yy_act <= 112 then
if yy_act <= 110 then
if yy_act = 109 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 338 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 338")
end
 last_token := Comma_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 339 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 339")
end
 last_token := Colon_code; last_string_value := text 
end
else
if yy_act = 111 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 340 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 340")
end
 last_token := Equal_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 341 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 341")
end
 last_token := Left_parenthesis_code; last_string_value := text 
end
end
else
if yy_act <= 114 then
if yy_act = 113 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 342 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 342")
end
 last_token := Right_parenthesis_code; last_string_value := text 
else
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 343 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 343")
end
 last_token := Left_bracket_code; last_string_value := text 
end
else
if yy_act = 115 then
	yy_column := yy_column + yy_end - yy_start - yy_more_len
	yy_position := yy_position + yy_end - yy_start - yy_more_len
--|#line 344 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 344")
end
 last_token := Right_bracket_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 345 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 345")
end
 last_token := Dot_code; last_string_value := text 
end
end
end
end
else
if yy_act <= 124 then
if yy_act <= 120 then
if yy_act <= 118 then
if yy_act = 117 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 346 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 346")
end
 last_token := 38; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 347 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 347")
end
 last_token := Exclamation_code; last_string_value := text 
end
else
if yy_act = 119 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 348 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 348")
end
 last_token := 126; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 349 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 349")
end
 last_token := Minus_code; last_string_value := text 
end
end
else
if yy_act <= 122 then
if yy_act = 121 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 350 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 350")
end
 last_token := Plus_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 351 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 351")
end
 last_token := Star_code; last_string_value := text 
end
else
if yy_act = 123 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 352 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 352")
end
 last_token := Slash_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 353 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 353")
end
 last_token := 37; last_string_value := text 
end
end
end
else
if yy_act <= 128 then
if yy_act <= 126 then
if yy_act = 125 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 354 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 354")
end
 last_token := Less_than_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 355 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 355")
end
 last_token := Greater_than_code; last_string_value := text 
end
else
if yy_act = 127 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 356 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 356")
end
 last_token := Caret_code; last_string_value := text 
else
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 357 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 357")
end
 last_token := Bar_code; last_string_value := text 
end
end
else
if yy_act <= 130 then
if yy_act = 129 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 358 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 358")
end
 last_token := Question_mark_code; last_string_value := text 
else
yy_set_line_column
	yy_position := yy_position + 1
--|#line 360 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 360")
end
 
end
else
if yy_act = 131 then
	yy_column := yy_column + 1
	yy_position := yy_position + 1
--|#line 361 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 361")
end
 
else
yy_set_line_column
	yy_position := yy_position + 1
--|#line 0 "ewg_c_scanner.l"
debug ("GELEX")
	std.error.put_line ("Executing scanner user-code from file 'ewg_c_scanner.l' at line 0")
end
default_action
end
end
end
end
end
end
end
			yy_set_beginning_of_line
		end

	yy_execute_eof_action (yy_sc: INTEGER) is
			-- Execute EOF semantic action.
		do
			terminate
		end

feature {NONE} -- Table templates

	yy_nxt_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,   12,   13,   14,   13,   15,   16,   12,   17,   18,
			   19,   20,   21,   22,   23,   24,   25,   26,   27,   28,
			   29,   29,   29,   29,   29,   29,   29,   30,   31,   32,
			   33,   34,   35,   36,   36,   36,   36,   37,   36,   36,
			   38,   12,   39,   40,   41,   42,   43,   44,   45,   46,
			   47,   48,   36,   49,   36,   50,   36,   36,   36,   36,
			   51,   52,   53,   54,   55,   56,   36,   36,   36,   57,
			   58,   59,   60,   61,   83,   64,   65,  452,   62,   66,
			   67,   64,   65,   65,   92,   66,   67,   69,   69,   70,
			   70,   76,   77,   65,   87,   65,  451,   65,   85,   86,

			   93,   76,   77,   79,   80,   79,   80,   94,  128,   84,
			   71,   71,  112,  113,  107,   88,   82,  129,   72,   72,
			  115,   95,   96,   97,  148,   98,   98,   98,   98,   98,
			   98,   98,   98,  108,  133,  109,  110,  134,  117,  118,
			  150,  119,  136,  153,  120,  151,  162,  121,  154,  137,
			   73,   73,   74,   74,  100,  122,  101,  101,  101,  101,
			  101,  101,  101,  101,  149,  125,  130,   83,  131,  140,
			  141,  102,  126,  453,  103,  103,  104,  132,  127,  142,
			   89,  163,  143,  166,  208,  211,  102,  157,  158,  157,
			  216,  209,  103,  220,  237,  238,  212,  103,  103,  214,

			  103,  221,   84,  104,  100,  217,  105,  105,  105,  105,
			  105,  105,  105,  105,   90,  103,  215,  222,  235,  223,
			  235,  102,  150,  103,  103,  103,  153,  151,  158,  158,
			  158,  154,  249,  235,  450,  244,  102,  162,  235,  240,
			  159,  250,  103,  449,  160,  157,  158,  157,  245,  241,
			  103,   98,   98,   98,   98,   98,   98,   98,   98,  261,
			  262,  287,  287,  287,  301,  448,  168,  169,  174,  169,
			  174,  302,  163,  175,  175,  175,  175,  175,  175,  175,
			  175,  168,  169,  173,  173,  447,  446,  169,  170,  170,
			  170,  170,  170,  170,  170,  170,  420,  445,  159,  421,

			  444,  173,  160,  171,  172,  229,  172,  229,  443,  173,
			  230,  230,  230,  230,  230,  230,  230,  230,  171,  172,
			  231,  232,  442,  232,  172,  100,  441,  101,  101,  101,
			  101,  101,  101,  101,  101,  231,  232,  440,  236,  236,
			  439,  232,  102,  236,  236,  173,  173,  175,  175,  175,
			  175,  175,  175,  175,  175,  438,  236,  102,  286,  287,
			  286,  236,  333,  173,  236,  437,  287,  287,  287,  236,
			  333,  173,  179,  180,  181,  182,  183,  184,  436,  345,
			  185,  346,  435,  434,  347,  348,  186,  187,  188,  372,
			  373,  372,  189,  157,  158,  157,  233,  433,  233,  420,

			  431,  234,  234,  234,  234,  234,  234,  234,  234,  430,
			  225,  225,  225,  225,  225,  225,  225,  225,  286,  287,
			  286,  230,  230,  230,  230,  230,  230,  230,  230,  169,
			  429,  169,  373,  373,  373,  225,  225,  225,  225,  225,
			  225,  225,  225,  428,  169,  290,  427,  290,  426,  169,
			  291,  291,  291,  291,  291,  291,  291,  291,  234,  234,
			  234,  234,  234,  234,  234,  234,  172,  425,  172,  291,
			  291,  291,  291,  291,  291,  291,  291,  232,  424,  232,
			  423,  172,  419,  419,  419,  422,  172,  418,  419,  418,
			  417,  432,  232,  416,  415,  414,  413,  232,  372,  373,

			  372,  419,  419,  419,  412,  432,  176,  176,  176,  176,
			  176,  411,  410,  409,  408,  400,  400,  400,  400,  400,
			  400,  400,  400,  418,  419,  418,  226,  226,  407,  406,
			  226,  226,  226,  175,  175,  175,  405,  175,  404,  175,
			  400,  400,  400,  400,  400,  400,  400,  400,   63,   63,
			   63,   63,   63,   63,   63,   63,   63,   63,   63,   63,
			   63,   63,   63,   63,   68,   68,   68,   68,   68,   68,
			   68,   68,   68,   68,   68,   68,   68,   68,   68,   68,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   78,   78,   78,   78,

			   78,   78,   78,   78,   78,   78,   78,   78,   78,   78,
			   78,   78,   82,   82,   82,   82,   82,   82,   82,   82,
			   82,   82,   82,   82,   82,   82,   82,   82,   89,   89,
			   89,   89,  403,   89,   89,   89,   89,   89,   89,   89,
			   89,   89,   89,   89,  114,  114,  114,  114,  114,  114,
			  114,  114,  114,  114,  114,  151,  151,  402,  151,  151,
			  151,  151,  151,  151,  151,  151,  151,  151,  151,  151,
			  151,  152,  152,  399,  398,  152,  152,  152,  152,  152,
			  152,  152,  152,  152,  152,  152,  152,  155,  155,  155,
			  155,  155,  155,  155,  155,  155,  155,  155,  155,  155,

			  155,  155,  155,  161,  161,  161,  161,  161,  161,  161,
			  161,  161,  161,  161,  161,  161,  161,  161,  161,  230,
			  230,  230,  397,  230,  396,  230,  234,  234,  234,  395,
			  234,  394,  234,  291,  291,  291,  393,  291,  392,  291,
			  401,  401,  391,  390,  401,  401,  401,  402,  402,  402,
			  402,  402,  402,  402,  402,  402,  402,  402,  402,  402,
			  402,  402,  402,  421,  421,  421,  421,  421,  421,  421,
			  421,  421,  421,  421,  421,  421,  421,  421,  421,  389,
			  388,  387,  386,  385,  384,  383,  382,  381,  380,  379,
			  378,  377,  376,  375,  374,  371,  370,  369,  368,  367,

			  366,  365,  364,  363,  362,  361,  360,  359,  358,  357,
			  356,  355,  354,  353,  352,  351,  350,  349,  344,  343,
			  342,  341,  340,  339,  338,  337,  336,  335,  334,  332,
			  331,  330,  329,  328,  327,  326,  325,  324,  323,  322,
			  321,  320,  319,  318,  317,  316,  315,  314,  313,  312,
			  311,  310,  309,  308,  307,  306,  305,  304,  303,  300,
			  299,  298,  297,  296,  295,  294,  293,  292,  289,  288,
			  285,  284,  283,  282,  281,  280,  279,  278,  277,  276,
			  275,  274,  273,  272,  271,  270,  269,  268,  267,  266,
			  265,  264,  263,  260,  259,  258,  257,  256,  255,  254,

			  253,  252,  251,  248,  247,  246,  243,  242,  239,  453,
			  228,  227,  156,  224,  219,  218,  213,  210,  207,  206,
			  205,  204,  203,  202,  201,  200,  199,  198,  197,  196,
			  195,  194,  193,  192,  191,  190,   90,  178,  177,  167,
			  453,  161,  165,  164,  156,  147,  146,  145,  144,  139,
			  138,  135,  124,  123,  116,  111,  106,   99,   91,   90,
			   81,  453,   11,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,

			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453, yy_Dummy>>)
		end

	yy_chk_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    2,   16,    3,    3,  448,    2,    3,
			    3,    4,    4,    7,   23,    4,    4,    5,    6,    5,
			    6,    7,    7,    8,   18,    9,  447,   10,   17,   17,

			   23,    8,    8,    9,    9,   10,   10,   25,   45,   16,
			    5,    6,   34,   34,   32,   18,   37,   45,    5,    6,
			   37,   25,   25,   26,   58,   26,   26,   26,   26,   26,
			   26,   26,   26,   32,   47,   32,   32,   47,   41,   41,
			   61,   41,   49,   64,   41,   61,   69,   41,   64,   49,
			    5,    6,    5,    6,   28,   41,   28,   28,   28,   28,
			   28,   28,   28,   28,   58,   44,   46,   82,   46,   52,
			   52,   28,   44,   90,   28,   28,   28,   46,   44,   52,
			   90,   69,   52,   89,  137,  139,   28,   67,   67,   67,
			  142,  137,   28,  145,  179,  179,  139,  103,  103,  141,

			   28,  145,   82,   28,   29,  142,   29,   29,   29,   29,
			   29,   29,   29,   29,   89,  103,  141,  146,  175,  146,
			  175,   29,  150,  103,   29,   29,  153,  150,  158,  158,
			  158,  153,  188,  175,  446,  184,   29,  161,  175,  181,
			   67,  188,   29,  445,   67,  154,  154,  154,  184,  181,
			   29,   98,   98,   98,   98,   98,   98,   98,   98,  199,
			  199,  226,  226,  226,  246,  444,   98,   98,  102,   98,
			  102,  246,  161,  102,  102,  102,  102,  102,  102,  102,
			  102,   98,   98,  173,  173,  443,  442,   98,  100,  100,
			  100,  100,  100,  100,  100,  100,  402,  441,  154,  402,

			  437,  173,  154,  100,  100,  168,  100,  168,  435,  173,
			  168,  168,  168,  168,  168,  168,  168,  168,  100,  100,
			  170,  170,  433,  170,  100,  101,  431,  101,  101,  101,
			  101,  101,  101,  101,  101,  170,  170,  429,  176,  176,
			  428,  170,  101,  236,  236,  101,  101,  174,  174,  174,
			  174,  174,  174,  174,  174,  427,  176,  101,  286,  286,
			  286,  236,  286,  101,  176,  426,  287,  287,  287,  236,
			  287,  101,  117,  117,  117,  117,  117,  117,  425,  302,
			  117,  302,  424,  423,  302,  302,  117,  117,  117,  334,
			  334,  334,  117,  157,  157,  157,  171,  422,  171,  421,

			  412,  171,  171,  171,  171,  171,  171,  171,  171,  411,
			  157,  157,  157,  157,  157,  157,  157,  157,  225,  225,
			  225,  229,  229,  229,  229,  229,  229,  229,  229,  230,
			  410,  230,  373,  373,  373,  225,  225,  225,  225,  225,
			  225,  225,  225,  409,  230,  231,  408,  231,  407,  230,
			  231,  231,  231,  231,  231,  231,  231,  231,  233,  233,
			  233,  233,  233,  233,  233,  233,  234,  406,  234,  290,
			  290,  290,  290,  290,  290,  290,  290,  291,  405,  291,
			  404,  234,  401,  401,  401,  403,  234,  418,  418,  418,
			  399,  418,  291,  398,  396,  394,  393,  291,  372,  372,

			  372,  419,  419,  419,  391,  419,  465,  465,  465,  465,
			  465,  390,  389,  388,  383,  372,  372,  372,  372,  372,
			  372,  372,  372,  400,  400,  400,  466,  466,  382,  381,
			  466,  466,  466,  467,  467,  467,  380,  467,  379,  467,
			  400,  400,  400,  400,  400,  400,  400,  400,  454,  454,
			  454,  454,  454,  454,  454,  454,  454,  454,  454,  454,
			  454,  454,  454,  454,  455,  455,  455,  455,  455,  455,
			  455,  455,  455,  455,  455,  455,  455,  455,  455,  455,
			  456,  456,  456,  456,  456,  456,  456,  456,  456,  456,
			  456,  456,  456,  456,  456,  456,  457,  457,  457,  457,

			  457,  457,  457,  457,  457,  457,  457,  457,  457,  457,
			  457,  457,  458,  458,  458,  458,  458,  458,  458,  458,
			  458,  458,  458,  458,  458,  458,  458,  458,  459,  459,
			  459,  459,  375,  459,  459,  459,  459,  459,  459,  459,
			  459,  459,  459,  459,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  461,  461,  374,  461,  461,
			  461,  461,  461,  461,  461,  461,  461,  461,  461,  461,
			  461,  462,  462,  371,  370,  462,  462,  462,  462,  462,
			  462,  462,  462,  462,  462,  462,  462,  463,  463,  463,
			  463,  463,  463,  463,  463,  463,  463,  463,  463,  463,

			  463,  463,  463,  464,  464,  464,  464,  464,  464,  464,
			  464,  464,  464,  464,  464,  464,  464,  464,  464,  468,
			  468,  468,  369,  468,  362,  468,  469,  469,  469,  358,
			  469,  357,  469,  470,  470,  470,  356,  470,  355,  470,
			  471,  471,  354,  352,  471,  471,  471,  472,  472,  472,
			  472,  472,  472,  472,  472,  472,  472,  472,  472,  472,
			  472,  472,  472,  473,  473,  473,  473,  473,  473,  473,
			  473,  473,  473,  473,  473,  473,  473,  473,  473,  351,
			  350,  349,  347,  346,  345,  344,  343,  342,  341,  340,
			  339,  338,  337,  336,  335,  331,  330,  328,  327,  326,

			  325,  324,  323,  321,  320,  319,  317,  316,  315,  314,
			  311,  310,  309,  308,  306,  305,  304,  303,  301,  300,
			  299,  298,  297,  296,  295,  294,  293,  289,  288,  285,
			  284,  282,  281,  280,  279,  278,  277,  276,  275,  274,
			  273,  272,  270,  268,  267,  264,  263,  262,  261,  258,
			  256,  255,  254,  253,  251,  250,  249,  248,  247,  245,
			  244,  243,  242,  241,  240,  239,  238,  237,  228,  227,
			  224,  223,  222,  221,  220,  219,  218,  217,  216,  215,
			  214,  213,  212,  211,  210,  208,  207,  205,  204,  203,
			  202,  201,  200,  198,  197,  196,  195,  194,  193,  192,

			  191,  190,  189,  187,  186,  185,  183,  182,  180,  163,
			  160,  159,  155,  147,  144,  143,  140,  138,  135,  134,
			  133,  132,  131,  130,  129,  128,  127,  126,  125,  124,
			  123,  122,  121,  120,  119,  118,  115,  113,  109,   97,
			   84,   72,   71,   70,   66,   56,   55,   54,   53,   51,
			   50,   48,   43,   42,   40,   33,   30,   27,   22,   19,
			   15,   11,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,

			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453, yy_Dummy>>)
		end

	yy_base_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,   71,   73,   79,   81,   82,   80,   90,   92,
			   94,  961,  962,  962,  962,  930,   68,   68,   85,  918,
			  962,  962,  928,   70,  962,   91,  106,  927,  137,  187,
			  925,  962,  106,  925,   82,  962,    0,  110,  962,  962,
			  924,   94,  890,  892,  120,   59,  111,   79,  893,   92,
			  892,  900,  117,  881,  890,  888,  893,  962,   94,  962,
			  962,  138,    0,    0,  141,  962,  941,  185,  962,  140,
			  912,  934,  935,  962,  962,  962,  962,  962,  962,  962,
			  962,  962,  161,  962,  937,  962,  962,  962,  962,  173,
			  170,  962,  962,  962,  962,  962,  962,  922,  232,  962,

			  269,  308,  254,  160,    0,    0,  962,  962,  962,  908,
			  962,  962,  962,  907,    0,  895,  962,  327,  874,  886,
			  875,  875,  869,  868,  880,  867,  882,  869,  875,  861,
			  862,  859,  859,  862,  859,  856,    0,  129,  860,  134,
			  858,  148,  145,  862,  855,  140,  164,  860,  962,  962,
			  220,    0,    0,  224,  243,  909,  962,  391,  226,  858,
			  850,  231,  962,  906,  962,  962,  962,  962,  291,  962,
			  286,  382,  962,  246,  328,  183,  301,  962,  962,  133,
			  863,  191,  858,  840,  190,  848,  842,  854,  179,  877,
			  845,  851,  839,  843,  849,  838,  850,  845,  833,  198,

			  847,  845,  841,  833,  839,  842,    0,  828,  832,    0,
			  833,  830,  819,  821,  823,  830,  816,  814,  814,  826,
			  816,  820,  824,  826,  815,  416,  259,  812,  823,  402,
			  394,  431,  962,  439,  431,  962,  306,  811,  804,  804,
			  815,  806,  815,  799,  799,  799,  209,  798,  796,  805,
			  807,  831,    0,  806,  805,  798,  803,    0,  795,    0,
			    0,  786,  794,  783,  790,    0,    0,  784,  781,    0,
			  785,    0,  780,  780,  777,  789,  779,  783,  788,  787,
			  785,  775,  780,    0,  768,  780,  356,  364,  779,  776,
			  450,  442,    0,  766,  776,  777,  762,  767,  772,  758,

			  772,  765,  359,  792,  754,  758,  767,    0,  758,  763,
			  754,  765,    0,    0,  752,  753,  758,  749,    0,  756,
			  742,  746,    0,  754,  751,  753,  737,  746,  748,    0,
			  739,  742,    0,  962,  387,  738,  740,  744,  736,  728,
			  728,  731,  740,  737,  728,  759,  762,  759,    0,  758,
			  720,  730,  698,    0,  689,  689,  681,  668,  667,    0,
			    0,    0,  675,    0,    0,    0,    0,    0,    0,  672,
			  625,  618,  496,  430,  612,  586,    0,    0,    0,  479,
			  475,  484,  475,  465,    0,    0,    0,    0,  460,  464,
			  456,  447,    0,  441,  446,    0,  434,    0,  445,  441,

			  521,  480,  293,  422,  431,  425,  412,  391,  402,  396,
			  386,  354,  345,    0,    0,    0,    0,    0,  485,  499,
			  962,  396,  335,  336,  324,  323,  310,  311,  278,  293,
			    0,  273,  962,  273,    0,  251,    0,  247,    0,    0,
			    0,  240,  242,  241,  208,  194,  190,   52,   28,    0,
			    0,    0,    0,  962,  547,  563,  579,  595,  611,  627,
			  638,  654,  670,  686,  702,  500,  524,  527,  713,  720,
			  727,  738,  746,  762, yy_Dummy>>)
		end

	yy_def_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,  453,    1,  454,  454,  455,  455,  456,  456,  457,
			  457,  453,  453,  453,  453,  453,  458,  453,  453,  459,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  460,  460,  453,  453,
			  453,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  453,  453,  453,
			  453,  453,  461,  462,  462,  453,  463,  462,  453,  464,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  458,  453,  458,  453,  453,  453,  453,  459,
			  459,  453,  453,  453,  453,  453,  453,  453,  453,  453,

			  453,  453,  453,  453,  465,   29,  453,  453,  453,  453,
			  453,  453,  453,  453,  460,  459,  453,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  453,  453,
			  453,  461,  462,  462,  462,  463,  453,  462,  466,  462,
			  462,  464,  453,  464,  453,  453,  453,  453,  453,  453,
			  100,  453,  453,  453,  453,  467,  465,  453,  453,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,

			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  462,  466,  462,  462,  453,
			  468,  453,  453,  453,  469,  453,  453,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  462,  453,  462,  462,
			  453,  470,  460,  460,  460,  460,  460,  460,  460,  460,

			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  453,  462,  462,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  462,  471,  462,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,

			  462,  471,  472,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  462,  453,
			  453,  473,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  453,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,  460,  460,  460,  460,  460,  460,  460,
			  460,  460,  460,    0,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453,  453,  453,  453,  453,  453,  453,
			  453,  453,  453,  453, yy_Dummy>>)
		end

	yy_ec_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    1,    1,    1,    1,    1,    1,    1,    2,
			    3,    1,    4,    4,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    2,    5,    6,    7,    1,    8,    9,   10,
			   11,   12,   13,   14,   15,   16,   17,   18,   19,   20,
			   21,   22,   23,   24,   25,   24,   26,   24,   27,   28,
			   29,   30,   31,   32,    1,   33,   33,   33,   33,   34,
			   35,   36,   36,   36,   36,   36,   37,   36,   36,   36,
			   36,   36,   36,   36,   36,   38,   36,   36,   39,   36,
			   36,   40,   41,   42,   43,   44,    1,   45,   46,   47,

			   48,   49,   50,   51,   52,   53,   36,   54,   55,   56,
			   57,   58,   59,   36,   60,   61,   62,   63,   64,   65,
			   66,   67,   68,   69,   70,   71,   72,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,

			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
			    1,    1,    1,    1,    1,    1,    1, yy_Dummy>>)
		end

	yy_meta_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    1,    2,    3,    2,    1,    4,    1,    1,    1,
			    5,    1,    1,    1,    1,    1,    1,    1,    1,    6,
			    6,    6,    6,    6,    6,    7,    8,    1,    1,    1,
			    1,    1,    1,    9,    9,   10,   11,   12,   13,   14,
			    1,    1,    1,    1,   11,    9,    9,    9,    9,    9,
			   10,   11,   11,   11,   11,   12,   11,   11,   11,   11,
			   11,   11,   11,   11,   11,   11,   11,   15,   16,    1,
			    1,    1,    1, yy_Dummy>>)
		end

	yy_accept_template: SPECIAL [INTEGER] is
		once
			Result := yy_fixed_array (<<
			    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
			    0,  133,  131,  130,  130,  118,  131,  124,  117,  131,
			  112,  113,  122,  121,  109,  120,  116,  123,   78,   78,
			  110,  106,  125,  111,  126,  129,   75,   75,  114,  115,
			  127,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,  107,  128,  108,
			  119,  130,    1,    5,    5,  132,  132,    5,   10,   10,
			   10,   10,   10,    7,    8,   14,   12,   13,   55,   53,
			   54,  105,    0,   83,    0,   91,  108,  100,   92,    0,
			    0,   89,   97,   87,   98,   88,   99,    0,   81,   90,

			   82,   77,    0,   78,    0,   78,  115,  107,  114,   96,
			  102,  104,  103,   95,   75,    0,   93,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   22,
			   75,   75,   75,   75,   75,   75,   30,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   94,  101,
			    0,    1,    5,    5,    5,    0,    6,    5,    0,    5,
			    5,    0,    9,    0,    8,    7,   79,   84,    0,   81,
			   81,    0,   82,   77,    0,   80,   76,   86,   85,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,

			   75,   75,   75,   75,   75,   75,   28,   75,   75,   31,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,    5,    0,    5,    5,    0,
			   81,    0,   81,    0,   82,   80,   76,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   66,   75,   75,   75,   75,   15,   75,   17,
			   18,   75,   75,   75,   75,   24,   25,   75,   75,   29,
			   75,   32,   75,   75,   75,   75,   75,   75,   75,   75,
			   75,   75,   75,   45,   75,   75,    5,    0,    5,    5,
			    0,   81,   65,   75,   75,   75,   75,   75,   75,   75,

			   75,   75,   75,   75,   75,   75,   75,   74,   75,   75,
			   75,   75,   16,   19,   75,   75,   75,   75,   27,   75,
			   75,   75,   35,   75,   75,   75,   75,   75,   75,   43,
			   75,   75,   47,    2,    5,    5,   75,   75,   75,   75,
			   75,   75,   75,   75,   75,   75,   75,   75,   58,   75,
			   75,   75,   75,   69,   75,   75,   75,   75,   75,   23,
			   26,   39,   75,   34,   36,   37,   38,   40,   41,   75,
			   75,   75,    5,    0,    5,   75,   64,   68,   50,   75,
			   75,   75,   75,   75,   59,   60,   61,   62,   75,   75,
			   75,   75,   67,   75,   75,   21,   75,   42,   75,   75,

			    5,    0,    5,   75,   75,   75,   75,   75,   56,   75,
			   75,   75,   75,   71,   20,   33,   44,   46,    5,    0,
			    4,    0,   75,   75,   75,   75,   75,   75,   75,   75,
			   70,   75,    3,   75,   11,   75,   63,   75,   57,   51,
			   48,   75,   75,   75,   75,   75,   75,   75,   75,   72,
			   52,   49,   73,    0, yy_Dummy>>)
		end

feature {NONE} -- Constants

	yyJam_base: INTEGER is 962
			-- Position in `yy_nxt'/`yy_chk' tables
			-- where default jam table starts

	yyJam_state: INTEGER is 453
			-- State id corresponding to jam state

	yyTemplate_mark: INTEGER is 454
			-- Mark between normal states and templates

	yyNull_equiv_class: INTEGER is 1
			-- Equivalence code for NULL character

	yyReject_used: BOOLEAN is false
			-- Is `reject' called?

	yyVariable_trail_context: BOOLEAN is false
			-- Is there a regular expression with
			-- both leading and trailing parts having
			-- variable length?

	yyReject_or_variable_trail_context: BOOLEAN is false
			-- Is `reject' called or is there a
			-- regular expression with both leading
			-- and trailing parts having variable length?

	yyNb_rules: INTEGER is 132
			-- Number of rules

	yyEnd_of_buffer: INTEGER is 133
			-- End of buffer rule code

	yyLine_used: BOOLEAN is true
			-- Are line and column numbers used?

	yyPosition_used: BOOLEAN is true
			-- Is `position' used?

	INITIAL: INTEGER is 0
	SC_FILE: INTEGER is 1
	SC_IMPL: INTEGER is 2
	SC_MSC_DECLSPEC: INTEGER is 3
	SC_GCC_ATTRIBUTE: INTEGER is 4
			-- Start condition codes

feature -- User-defined features


feature
end

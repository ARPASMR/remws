note
	description: "MATISSE-Eiffel Binding: define the SQL prepared statement class"
	license: "[
	The contents of this file are subject to the Matisse Interfaces 
	Public License Version 1.0 (the 'License'); you may not use this 
	file except in compliance with the License. You may obtain a copy of
	the License at http://www.matisse.com/pdf/developers/MIPL.html

	Software distributed under the License is distributed on an 'AS IS'
	basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See 
	the License for the specific language governing rights and
	limitations under the License.

	The Original Code was created by Matisse Software Inc. 
	and its successors.

	The Initial Developer of the Original Code is Matisse Software Inc. 
	Portions created by Matisse Software are Copyright (C) 
	Matisse Software Inc. All Rights Reserved.

	Contributor(s): Kazuhiro Nakao
                   Didier Cabannes
                   Neal Lester
                   Luca Paganotti
	]"

class
	MT_PREPARED_STATEMENT

inherit
	MT_STATEMENT
		rename
			make as make_stmt,
			execute as execute_stmt,
			execute_query as execute_query_stmt,
			execute_update as execute_update_stmt
		end

create
	make

feature -- Constants

	Mt_Max_parameters: INTEGER_32 = 64

feature {MT_DATABASE} -- Initialization

	make (a_db: MT_DATABASE)
		require
			valid_a_db: a_db /= Void
		do
			make_stmt(a_db)
			prepared := False
			create param_values.make_filled (Void, 1, Mt_Max_parameters)
			create param_types.make_filled ({MTTYPE}.Mt_Min_Type, 1, Mt_Max_parameters)
		end

feature -- Parameters

	set_null (param_idx: INTEGER_32)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(Void, param_idx)
			param_types.force({MTTYPE}.Mt_Null, param_idx)
		end

	set_oid (param_idx: INTEGER_32; val: MTOBJECT)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Oid, param_idx)
		end

	set_selection (param_idx: INTEGER_32; val: ARRAY[MTOBJECT])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Selection, param_idx)
		end

	set_text (param_idx: INTEGER_32; val: STRING)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Text, param_idx)
		end

	set_char (param_idx: INTEGER_32; val: CHARACTER)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Char, param_idx)
		end


	set_boolean (param_idx: INTEGER_32; val: BOOLEAN)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Boolean, param_idx)
		end

	set_boolean_list (param_idx: INTEGER_32; val: ARRAY[BOOLEAN])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Boolean_List, param_idx)
		end

	set_string (param_idx: INTEGER_32; val: STRING)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_String, param_idx)
		end

	set_string_list (param_idx: INTEGER_32; val: ARRAY[STRING])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_String_List, param_idx)
		end

	set_double (param_idx: INTEGER_32; val: DOUBLE)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Double, param_idx)
		end

	set_double_list (param_idx: INTEGER_32; val: ARRAY[DOUBLE])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Double_List, param_idx)
		end

	set_float (param_idx: INTEGER_32; val: REAL)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Float, param_idx)
		end

	set_float_list (param_idx: INTEGER_32; val: ARRAY[REAL])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Float_List, param_idx)
		end

	set_date (param_idx: INTEGER_32; val: DATE)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Date, param_idx)
		end

	set_date_list (param_idx: INTEGER_32; val: ARRAY[DATE])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Date_List, param_idx)
		end

	set_timestamp (param_idx: INTEGER_32; val: DATE_TIME)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Timestamp, param_idx)
		end

	set_timestamp_list (param_idx: INTEGER_32; val: ARRAY[DATE_TIME])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Timestamp_List, param_idx)
		end


	set_interval (param_idx: INTEGER_32; val: DATE_TIME_DURATION)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Interval, param_idx)
		end

	set_interval_list (param_idx: INTEGER_32; val: ARRAY[DATE_TIME_DURATION])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Interval_List, param_idx)
		end

	set_byte (param_idx: INTEGER_32; val: INTEGER_8)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Byte, param_idx)
		end

	set_short (param_idx: INTEGER_32; val: INTEGER_16)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Short, param_idx)
		end

	set_short_list (param_idx: INTEGER_32; val: ARRAY[INTEGER_16])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Short_List, param_idx)
		end

	set_int, set_integer (param_idx: INTEGER_32; val: INTEGER_32)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Integer, param_idx)
		end

	set_integer_list (param_idx: INTEGER_32; val: ARRAY[INTEGER_32])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Integer_List, param_idx)
		end

	set_long (param_idx: INTEGER_32; val: INTEGER_64)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Long, param_idx)
		end

	set_long_list (param_idx: INTEGER_32; val: ARRAY[INTEGER_64])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Long_List, param_idx)
		end

	set_numeric (param_idx: INTEGER_32; val: DECIMAL)
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Numeric, param_idx)
		end

	set_numeric_list (param_idx: INTEGER_32; val: ARRAY[DECIMAL])
		require
			valid_a_idx: param_idx > 0 and param_idx <= Mt_Max_parameters
		do
			prepared := False
			param_values.force(val, param_idx)
			param_types.force({MTTYPE}.Mt_Numeric_List, param_idx)
		end


feature -- Output

	stmt_text, get_stmt_text () : STRING
		do
			prepare ()
			Result := stmt_to_be_executed.twin
		end

feature -- Execution

	execute (): BOOLEAN
		do
			prepare ()
			Result := execute_stmt (stmt_to_be_executed)
		end

	execute_query (): MT_RESULT_SET
		do
			prepare ()
			Result := execute_query_stmt (stmt_to_be_executed)
		end

	execute_update (): INTEGER_32
		do
			prepare ()
			Result := execute_update_stmt (stmt_to_be_executed)
		end


feature {MT_DATABASE} -- Set attributes

	set_command (a_cmd_text: STRING)
		require
			not_void: a_cmd_text /= Void
			not_empty: not a_cmd_text.is_empty
		do
			cmd_text := a_cmd_text.twin
			prepared := False
		end

feature {NONE} -- Implementation

	convert_parameter(param_idx: INTEGER_32) : STRING
		local
			mttype: INTEGER_32
			vstr, strval: STRING
			vchar: CHARACTER
			vobj: MTOBJECT
			vsel: ARRAY[MTOBJECT]
			vbool: BOOLEAN
			vbool_list: ARRAY[BOOLEAN]
			vstr_list: ARRAY[STRING]
			i, vint: INTEGER_32
			vdouble: DOUBLE
			vfloat: REAL
			vdate: DATE
			vtimestamp: DATE_TIME
			vinterval: DATE_TIME_DURATION
			vshort: INTEGER_16
			vlong: INTEGER_64
			vnumeric: DECIMAL
			vbyte: INTEGER_8
		do
			mttype:= param_types.item(param_idx)

			inspect mttype
			when {MTTYPE}.Mt_Oid then
				strval := ""
				vobj ?= param_values.item(param_idx)
				if vobj /= Void then
					strval := "'" + vobj.oid.out + "'"
				end
			when {MTTYPE}.Mt_Selection then
				strval := "SELECTION("
				vsel ?= param_values.item(param_idx)
				if vsel /= Void then
					from
						i := vsel.lower
					until
						i > vsel.upper
					loop
						if i > vsel.lower then
							strval := strval +  ", "
						end
						strval := strval +  "'" + vsel.item(i).oid.out  + "' "
 						i := i + 1
					end
				end
				strval := strval + ")"
			when {MTTYPE}.Mt_Any then
				-- Not supported
				strval := ""
			when {MTTYPE}.Mt_Null then
				strval := "NULL"
			when {MTTYPE}.Mt_Audio then
				-- Not supported
				strval := ""
			when {MTTYPE}.Mt_Image then
				-- Not supported
				  strval := ""
			when {MTTYPE}.Mt_Video then
				-- Not supported
				  strval := ""
			when {MTTYPE}.Mt_Text then
				vstr ?= param_values.item(param_idx)
				if vstr /= Void then
					strval := "'" + vstr + "'"
				end
			when {MTTYPE}.Mt_Char then
				strval := ""
				vchar ?= param_values.item(param_idx)
				if vobj /= Void then
					strval := "'" + vchar.out + "'"
				end
			when {MTTYPE}.Mt_Boolean then
				strval := ""
				vbool ?= param_values.item(param_idx)
				strval := vbool.out
			when {MTTYPE}.Mt_Boolean_List then
				strval := "LIST(BOOLEAN)("
				vbool_list ?= param_values.item(param_idx)
				if vbool_list /= Void then
					from
						i := vbool_list.lower
					until
						i > vbool_list.upper
					loop
						if i > vbool_list.lower then
							strval := strval +  ", "
						end
						strval := strval + vbool_list.item(i).out  + " "
 						i := i + 1
					end
				end
				strval := strval + ")"
			when {MTTYPE}.Mt_String then
				vstr ?= param_values.item(param_idx)
				if vstr /= Void then
					strval := "'" + vstr + "'"
				end
			when {MTTYPE}.Mt_String_List then
				strval := "LIST(STRING)("
				vstr_list ?= param_values.item(param_idx)
				if vstr_list /= Void then
					from
						i := vstr_list.lower
					until
						i > vstr_list.upper
					loop
						if i > vstr_list.lower then
							strval := strval +  ", "
						end
						strval := strval  + "'" + vstr_list.item(i)  + "' "
 						i := i + 1
					end
				end
				strval := strval + ")"
			when {MTTYPE}.Mt_Double then
				strval := ""
				vdouble ?= param_values.item(param_idx)
				strval := vdouble.out
			when {MTTYPE}.Mt_Double_List then
				-- TBD
				  strval := ""
			when {MTTYPE}.Mt_Float then
				strval := ""
				vfloat ?= param_values.item(param_idx)

				strval := vfloat.out

			when {MTTYPE}.Mt_Float_List then
				-- TBD
				  strval := ""
			when {MTTYPE}.Mt_Date then
				strval := ""
				vdate ?= param_values.item(param_idx)
				if vdate /= Void then
					strval := "DATE '" + vdate.formatted_out("yyyy-[0]mm-[0]dd") + "'"
				end
			when {MTTYPE}.Mt_Date_List then
				-- TBD
				  strval := ""

			when {MTTYPE}.Mt_Timestamp then
				strval := ""
				vtimestamp ?= param_values.item(param_idx)
				if vtimestamp /= Void then
					strval := "TIMESTAMP '" + vtimestamp.formatted_out("yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss") + "'"
				end
			when {MTTYPE}.Mt_Timestamp_List then
				-- TBD
				  strval := ""

			when {MTTYPE}.Mt_Interval then
				strval := ""
				vinterval ?= param_values.item(param_idx)
				if vinterval /= Void then
					strval := "INTERVAL '" + vinterval.out + "'"
				end
			when {MTTYPE}.Mt_Interval_List then
				-- TBD
				  strval := ""

			when {MTTYPE}.Mt_Byte then
				strval := ""
				vbyte ?= param_values.item(param_idx)

				strval := "X '" + vbyte.out + "'"

			when {MTTYPE}.Mt_Bytes then
				  strval := ""
			when {MTTYPE}.Mt_Short then
				strval := ""
				vshort ?= param_values.item(param_idx)

				strval := vshort.out

			when {MTTYPE}.Mt_Short_List then
				-- TBD
				  strval := ""
			when {MTTYPE}.Mt_Integer then
				strval := ""
				vint ?= param_values.item(param_idx)

				strval := vint.out

			when {MTTYPE}.Mt_Integer_List then
				-- TBD
				  strval := ""
			when {MTTYPE}.Mt_Long then
				strval := ""
				vlong ?= param_values.item(param_idx)

				strval := vlong.out

			when {MTTYPE}.Mt_Long_List then
				-- TBD
				  strval := ""

			when {MTTYPE}.Mt_Numeric then
				strval := ""
				vnumeric ?= param_values.item(param_idx)
				if vnumeric /= Void then
					strval := vnumeric.out
				end
			when {MTTYPE}.Mt_Numeric_List then
				-- TBD
				  strval := ""

			when {MTTYPE}.Mt_Table then
				-- Not supported
				 strval := ""
			else strval := ""
			end
			Result := strval
		end

	prepare ()
		-- replace the parameters (?) in cmd_text with values registered
		-- in 'param_values' with the actual values converted to
		-- string by 'convert_parameter'
		local
			split_cmd: LIST[STRING]
			i: INTEGER_32
		do
			if prepared = False then
				create stmt_to_be_executed.make_empty
				-- split
				split_cmd := cmd_text.split('?')
				if (split_cmd.count > 1) then
					from
						split_cmd.start
						i := 1
					until
						split_cmd.off
					loop
						stmt_to_be_executed.append (split_cmd.item)
						stmt_to_be_executed.append (convert_parameter (i))
						split_cmd.forth
						i := i + 1
					end
				else
					stmt_to_be_executed := cmd_text.twin
				end
				prepared := True
			end
		end

	-- text of the command including the '?'
	cmd_text: STRING

	-- indicate that command has been parsed
	-- and a statement is ready
	prepared: BOOLEAN

	stmt_to_be_executed: STRING

	param_values: ARRAY[ANY]
	param_types: ARRAY[INTEGER_32]


end -- class MT_PREPARED_STATEMENT

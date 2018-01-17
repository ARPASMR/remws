note
	description : "Summary description for {MUNICIPALITY_LIST_RESPONSE}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:33 (dom 10 dic 2017, 19.44.33, CET) buck $"
	revision    : "$Revision 48 $"

--| ----------------------------------------------------------------------------
--| This is the message structure for the municipalities_list response message,
--| for the time being only json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for example:
--| token_id can be an empty string
--|
--| {
--|   "header": {
--|     "id": <municipality_list_request_id> + 1000
--|   },
--|   "data": {
--|     "outcome": a_number,
--|     "message": "a_message",
--|     "municipalitiess_list": [{"id": a_id, "istat_code": a_code, "name": "a_name", "province": "a_province"},
--|                              {"id": a_id, "istat_code": a_code, "name": "a_name", "province": "a_province"},
--|                              ... ,
--|                              {"id": a_id, "istat_code": a_code, "name": "a_name", "province": "a_province"}]
--|   }
--| }
--|
--| ----------------------------------------------------------------------------


class
	MUNICIPALITY_LIST_RESPONSE

inherit
	RESPONSE_I

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create message.make_empty

			create content.make_empty
			create current_tag.make_empty

			create municipalities_list.make (0)
		end

feature -- Access

	id:                  INTEGER do Result := municipality_list_response_id end

	outcome:             INTEGER
	message:             detachable STRING

	municipalities_list: ARRAYED_LIST [MUNICIPALITY]

feature -- Status setting

	set_outcome (o: INTEGER)
			-- Sets `outcome'
		do
			outcome := o
		end

	set_message (m: STRING)
			-- Sets `message'
		do
			message := m.twin
		end

	set_logger (a_logger: LOG_LOGGING_FACILITY)
			-- Sets the logger
		require
			logger_not_void: a_logger /= Void
		do
			logger := a_logger
		ensure
			logger_not_void: logger /= Void
		end

	reset
			-- reset contents
		do
			outcome := 0
			message := null
		end

feature -- Status report

	is_error_response: BOOLEAN
			-- Tells wether the response contains an error
		do
			Result := outcome /= success
		end

feature -- Conversion

	to_json: STRING
			-- json representation
		do
			create Result.make_empty
			if is_error_response then
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + municipality_list_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes)
				if attached message as l_message then
					Result.append(l_message.to_string_8)
				else
					Result.append(null)
				end
				Result.append (double_quotes)
				Result.append (right_brace)
				Result.append (right_brace)
			else
				Result.append (left_brace)
				Result.append (double_quotes + json_header_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_id_tag + double_quotes + colon + space + municipality_list_response_id.out)
				Result.append (right_brace + comma)
				Result.append (double_quotes + json_data_tag + double_quotes + colon + space + left_brace)
				Result.append (double_quotes + json_outcome_tag + double_quotes + colon + space + outcome.out)
				Result.append (comma + double_quotes + json_message_tag + double_quotes + colon + space + double_quotes)
				if attached message as l_message then
					Result.append(l_message.to_string_8)
				else
					Result.append(null)
				end
				Result.append (double_quotes)
				Result.append (comma + double_quotes + json_municipalities_list_tag + double_quotes + colon + space + left_bracket)

				from municipalities_list.start
				until municipalities_list.after
				loop
					if attached municipalities_list.item then
						Result.append (left_brace + double_quotes + json_id_tag + double_quotes + colon + space + municipalities_list.item.id.out +
						               comma + double_quotes + json_istat_code_tag + double_quotes + colon + space + municipalities_list.item.istat_code.out +
					                   comma + double_quotes + json_name_tag + double_quotes + colon + space + double_quotes + municipalities_list.item.name + double_quotes +
					                   comma + double_quotes + json_province_tag + double_quotes + colon+ space + double_quotes + municipalities_list.item.province + double_quotes + right_brace)
						if not municipalities_list.islast then
							Result.append (comma)
						end
						municipalities_list.forth
					else
						municipalities_list.forth
					end
				end

				Result.append (right_bracket)
				Result.append (right_brace)
				Result.append (right_brace)
			end
		end

	from_xml(xml: STRING; parser: XML_STANDARD_PARSER)
			-- Parse XML message
	do
		municipalities_list.wipe_out
		parser.set_callbacks (Current)
		set_associated_parser (parser)
		parser.parse_from_string (xml)
		parser.reset
	end

	to_xml: STRING
			-- xml representation
		do
			create Result.make_empty
			-- should never be called for response messages
		end

	from_json (json: STRING; parser: JSON_PARSER)
			-- Parse json message
		require else
			json_valid: attached json and then not json.is_empty
			json_parser_valid: attached parser and then parser.is_valid
		do
		 	parser.set_representation (json)
			parser.parse_content
			if parser.is_valid and then attached parser.parsed_json_value as jv then
				if not (attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_header_tag) as j_header
					and then attached {JSON_NUMBER} j_header.item (json_id_tag) as j_id)
				then
					print (msg_json_header_not_found)
				end

				if attached {JSON_OBJECT} jv as j_object and then attached {JSON_OBJECT} j_object.item (json_data_tag) as j_data
					and then attached {JSON_ARRAY} j_data.item (json_municipalities_list_tag) as j_municipalities_list then

					municipalities_list.wipe_out

					from j_municipalities_list.array_representation.start
					until j_municipalities_list.array_representation.after
					loop
						if attached {JSON_OBJECT} j_municipalities_list.array_representation.item as j_municipality
						and then attached {JSON_NUMBER} j_municipality.item (json_id_tag) as j_id
						and then attached {JSON_NUMBER} j_municipality.item (json_istat_code_tag) as j_istat_code
						and then attached {JSON_STRING} j_municipality.item (json_name_tag) as j_name
						and then attached {JSON_STRING} j_municipality.item (json_province_tag) as j_province
						then
							municipalities_list.extend (create {MUNICIPALITY}.make_from_parameters (j_id.integer_64_item.to_integer, j_istat_code.integer_64_item.to_integer, j_name.item, j_province.item))
						end
						j_municipalities_list.array_representation.forth
					end
				end
			else
				print (msg_json_parser_error + parser.errors_as_string + lf_s)
			end
		end

feature -- {DISPOSABLE}

	dispose
			--
		do
		end

feature -- XML Callbacks

	on_start
			-- Called when parsing starts.
		do
		end

	on_finish
			-- Called when parsing finished.
		do
		end

	on_xml_declaration (a_version: READABLE_STRING_32; an_encoding: detachable READABLE_STRING_32; a_standalone: BOOLEAN)
			-- XML declaration.
		do
		end

	on_error (a_message: READABLE_STRING_32)
			-- Event producer detected an error.
		do
			outcome := {ERROR_CODES}.err_xml_parsing_failed
			message := {ERROR_CODES}.msg_xml_parser_failed
		end

	on_processing_instruction (a_name: READABLE_STRING_32; a_content: READABLE_STRING_32)
			-- Processing instruction.
			--| See http://en.wikipedia.org/wiki/Processing_instruction
		do
		end

	on_comment (a_content: READABLE_STRING_32)
			-- Processing a comment.
			-- Atomic: single comment produces single event
		do
		end

	on_start_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- Start of start tag.
		do
			current_tag := a_local_part
		end

	on_attribute (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32; a_value: READABLE_STRING_32)
			-- Start of attribute.
		do
			if attached current_tag as l_current_tag and then l_current_tag.is_equal (it_xml_municipality) then
				if a_local_part.is_equal (it_xml_id) then
					municipalities_list.extend (create {MUNICIPALITY}.make_from_parameters (a_value.to_integer, 0, null, null))
				elseif a_local_part.is_equal (it_xml_istat_code) then
					municipalities_list.last.set_istat_code (a_value.to_integer)
				elseif a_local_part.is_equal (it_xml_name) then
					municipalities_list.last.set_name (a_value)
				elseif a_local_part.is_equal (it_xml_province) then
					municipalities_list.last.set_province (a_value)
				end
			end
		end

	on_start_tag_finish
			-- End of start tag.
		do
		end

	on_end_tag (a_namespace: detachable READABLE_STRING_32; a_prefix: detachable READABLE_STRING_32; a_local_part: READABLE_STRING_32)
			-- End tag.
		do
		end

	on_content (a_content: READABLE_STRING_32)
			-- Text content.
			-- NOT atomic: two on_content events may follow each other
			-- without a markup event in between.
			--| this should not occur, but I leave this comment just in case
		do
			if attached current_tag as l_current_tag then
				if l_current_tag.is_equal (it_xml_outcome) then
					outcome := a_content.to_integer
				elseif l_current_tag.is_equal (it_xml_message) then
					message := a_content
				end
			end
		end

feature {NONE} -- Implementation

	current_tag:         detachable STRING
			-- used by `XML_CALLBACKS' features
	content:             detachable STRING
			-- used by `XML_CALLBACKS' features

invariant
	invariant_clause: True -- Your invariant here

end

note
	description: "Summary description for {ERROR_CODES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ERROR_CODES

feature


	err_internal:                  INTEGER = -1
			-- an internal application error happened error code

	msg_internal:                  STRING  = "Unfortunately this is an internal error, you must read the log file"
			-- an internal application error happened error message

	success:                       INTEGER = 0
			-- succesfull operation

	err_no_json_parser:            INTEGER = 1
			-- unable to create or reference a valid json parser error code

	msg_no_json_parser:            STRING  = "Unable to create or reference a valid json parser"
			-- unable to create or reference a valid json parser error message

	err_invalid_json:              INTEGER = 2
			-- json parser failed, not a json message error code

	msg_invalid_json:              STRING  = "Json parser failed, not a json message"
			-- json parser failed, not a json message error message

	err_xml_parsing_failed:        INTEGER = 4
			-- xml parser failed error code

	msg_xml_parser_failed:         STRING = "XML parser failed"
			-- xml parser failed error message

end

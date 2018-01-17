note
	description : "Summary description for {ERROR_CODES}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

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

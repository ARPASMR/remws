note
	description : "Summary description for {INTERNAL_MESSAGES}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

class
	INTERNAL_MESSAGES

feature -- Internal text messags

	msg_json_header_not_found:                           STRING = "JSON header was not found!%N"
			-- Internal message JSON header not found
	msg_json_parser_error:                               STRING = "JSON parser error: "
			-- Internal message JSON parser error

end

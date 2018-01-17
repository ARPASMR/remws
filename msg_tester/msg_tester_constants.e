note
	description : "Summary description for {MSG_TESTER_CONSTANTS}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:18:06 (dom 10 dic 2017, 19.18.06, CET) buck $"
	revision    : "$Revision 48 $"

class
	MSG_TESTER_CONSTANTS

feature {MSG_TESTER} -- Message tester constants

	default_cycles: INTEGER = 100
			-- Default message tester cycles

	all_messages:   INTEGER = 9999
			-- Test all messages

end

note
	description : "Summary description for {RESPONSE_I}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:14 (dom 10 dic 2017, 19.44.14, CET) buck $"
	revision    : "$Revision 48 $"

deferred class
	RESPONSE_I

inherit
	MSG
	XML_CALLBACKS

feature --Access

	outcome:     INTEGER deferred end
	message:     detachable STRING  deferred end

	current_tag: detachable STRING deferred end
	content:     detachable STRING deferred end

feature -- Status setting

	set_outcome (o: INTEGER) deferred end
	set_message (m: STRING)  deferred end

end

note
	description: "Summary description for {RESPONSE_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

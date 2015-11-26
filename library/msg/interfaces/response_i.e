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
	message:     STRING  deferred end

	current_tag: STRING deferred end
	content:     STRING deferred end

feature -- Status setting

--	set_parameters_number (pn: INTEGER)
--			-- Sets `parameters_number'
--		deferred
--		end

	set_outcome (o: INTEGER) deferred end
	set_message (m: STRING)  deferred end

end

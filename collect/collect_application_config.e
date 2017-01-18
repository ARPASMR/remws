note
	description: "Summary description for {COLLECT_APPLICATION_CONFIG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLLECT_APPLICATION_CONFIG

create
	make

feature {NONE} -- Initialization

	make (a_loc: PATH)
		do
			location := a_loc
			credential_file_path := a_loc.extended (credential_file_name)
			log_path := a_loc.extended ("log").extended ("collect.log")
		end

feature -- Access

	location: PATH

	credential_file_path: PATH

	credential_file_name: STRING_8 = "credentials.conf"

	is_utc_set: BOOLEAN assign set_is_utc_set

	use_testing_ws: BOOLEAN assign set_use_testing_ws

	log_level: INTEGER

	log_path: PATH

feature -- Change

	set_is_utc_set (b: BOOLEAN)
		do
			is_utc_set := b
		end

	set_use_testing_ws (b: BOOLEAN)
		do
			use_testing_ws := b
		end

	set_log_level (n: INTEGER)
		do
			log_level := n
		end

	set_log_path (p: PATH)
		do
			log_path := p
		end

invariant
	credential_file_path_not_empty: not credential_file_path.is_empty

end

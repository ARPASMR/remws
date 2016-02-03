note
	description : "nmarzi application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	NMARZI_APPLICATION

inherit
	ARGUMENTS
	EXECUTION_ENVIRONMENT
		rename
			command_line as env_command_line
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("NMARZI%N")

			init_preferences

		end

feature -- Initialization

	init_preferences
			-- Init `PREFERENCES' object
		do
			create preferences_storage.make_with_location ("/home/buck/.nmarzi/nmarzi.preferences.xml")

			create preferences.make_with_storage (preferences_storage)
		end


feature -- Preferences

	preferences:         PREFERENCES
			-- `PREFERENCES' object
	preferences_storage: PREFERENCES_STORAGE_XML
			-- Preferences storage

end

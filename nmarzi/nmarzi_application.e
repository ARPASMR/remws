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

			init
			init_default_sensors_list
			init_preferences

		end

feature -- Initialization

	init
			-- general initialization
		do

		end

	init_preferences
			-- Init `PREFERENCES' object
		local
			factory: BASIC_PREFERENCE_FACTORY
		do
			create preferences_storage.make_with_location ("/home/buck/.nmarzi/nmarzi.preferences.xml")
			create preferences.make_with_storage (preferences_storage)
			preferences_manager := preferences.new_manager ("NMARZI")
			create factory

			sensors_list := factory.new_array_preference_value (preferences_manager, "NMARZI.Sensors", default_sensors_list.to_array)
			output_dir   := factory.new_string_preference_value (preferences_manager, "NMARZI.OutputFolder", "~/.nmarzi/out")

			--sensors_list.value_as_list_of_text.count

			preferences.save_preferences

		end

	init_default_sensors_list
			-- Default sensors list
		do
			create default_sensors_list.make (0)


			default_sensors_list.extend ("14313")
			default_sensors_list.extend ("14759")
			default_sensors_list.extend ("14760")
			default_sensors_list.extend ("11165")
			default_sensors_list.extend ("14304")
			default_sensors_list.extend ("11988")
			default_sensors_list.extend ("16")
			default_sensors_list.extend ("14129")

		end

feature -- Preferences

	output_dir:          STRING_PREFERENCE
			-- <sensor_id>_R.txt files output directory
	sensors_list: ARRAY_PREFERENCE
		-- sensors id list

	preferences:         PREFERENCES
			-- `PREFERENCES' object
	preferences_manager: PREFERENCE_MANAGER
			-- Preference manager object
	preferences_storage: PREFERENCES_STORAGE_XML
			-- Preferences storage

feature {NONE} -- sensors list

	default_sensors_list: ARRAYED_LIST[STRING]
		-- default sensors list

end

note
	description: "Summary description for {APP_LOGGER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	APP_LOGGER

inherit
	LOGGING_I

	LOG_PRIORITY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_log_path: PATH)
			-- Initialize log on file
		local
			path: PATH
		do
			path := a_log_path
			create logger.make
			create file_logger.make_at_location (path)
			file_logger.enable_debug_log_level
			if attached logger as l_logger then
				l_logger.register_log_writer (file_logger)
				log_display (Void, "Log system initialized", log_information, True, True)
			end
		end

feature -- Access

	file_logger:  LOG_WRITER_FILE
			-- the logger		

feature -- Change

	set_log_level (a_log_level: INTEGER)
		do
			if     a_log_level = log_debug       then file_logger.enable_debug_log_level          -- 7
			elseif a_log_level = log_information then file_logger.enable_information_log_level    -- 6
			elseif a_log_level = log_notice      then file_logger.enable_notice_log_level         -- 5
			elseif a_log_level = log_warning     then file_logger.enable_warning_log_level        -- 4
			elseif a_log_level = log_error       then file_logger.enable_error_log_level          -- 3
			elseif a_log_level = log_critical    then file_logger.enable_critical_log_level       -- 2
			elseif a_log_level = log_alert       then file_logger.enable_alert_log_level          -- 1
			elseif a_log_level = log_emergency   then file_logger.enable_emergency_log_level      -- 0
			else
				file_logger.enable_error_log_level -- 3
			end
		end

feature -- Basic operation

	log (a_string: STRING; priority: INTEGER)
			-- Logs `a_string'
		do
			if attached logger as l_logger then
				if priority = log_debug then l_logger.write_debug (a_string)
					elseif priority = log_emergency   then l_logger.write_emergency (a_string)
					elseif priority = log_alert       then l_logger.write_alert (a_string)
					elseif priority = log_critical    then l_logger.write_critical (a_string)
					elseif priority = log_error       then l_logger.write_error (a_string)
					elseif priority = log_information then l_logger.write_information (a_string)
					elseif priority = log_notice      then l_logger.write_notice (a_string)
					elseif priority = log_warning     then l_logger.write_warning (a_string)
				end
			end
		end

	log_display (obj: detachable ANY; a_string: STRING; priority: INTEGER; to_file, to_display: BOOLEAN)
			-- Combined file and display log
		local
			l_string: STRING
		do
			if attached {EXCEPTIONS} obj as e and then attached e.class_name as cn then
				l_string := "{" + cn + "} " + a_string
			else
				l_string := "{NO_CLASS_NAME} " + a_string
			end

			if to_file then
				log (l_string, priority)
			end
			if to_display then
				io.put_string (l_string)
				io.put_new_line
			end

			l_string.wipe_out
		end

feature -- Status report

	is_logging_enabled: BOOLEAN
		do
			Result := logger /= Void
		end

end

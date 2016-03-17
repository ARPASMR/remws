note
	description: "Summary description for {MSG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

--| ----------------------------------------------------------------------------
--| This is the message structure for an input message, for the time being only
--| json is a supported format
--| ----------------------------------------------------------------------------
--| The message is an unnamed json object composed by a header and a data part
--| for exemple:
--|
--| {
--|   "header": {
--|     "message_id":        1,
--|     "parameters_number": <a_number>
--|   },
--|   "data": {
--|     ...
--|   }
--| }
--|
--| The data part could be anything but json-expressed. Relating to the message
--| it coulbe a set of plain values/object or an array of object.
--| ----------------------------------------------------------------------------

deferred class
	MSG

inherit
	LOG_PRIORITY_CONSTANTS
	REMWS_CONSTANTS
	MSG_CONSTANTS
	ERROR_CODES
	DEFAULTS
	LOGGING_I
	MEMORY

feature -- Access

	id:                INTEGER deferred end
	--parameters_number: INTEGER deferred end

feature -- Conversion

	from_json(json: STRING)
			-- Parse json message
		deferred
		end

	to_xml: STRING
			-- XML representation
		deferred
		end

	to_json: STRING
			-- json representation
		deferred
		end

	from_xml(xml: STRING)
			-- Parse XML message
		deferred
		end

feature -- Logging

	is_logging_enabled: BOOLEAN
			-- Is logging enabled
		do
			Result := attached logger
		end

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

feature -- Implementation

	json_representation: STRING  deferred end
	xml_representation:  STRING  deferred end

end

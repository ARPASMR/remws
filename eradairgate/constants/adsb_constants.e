note
	description: "Summary description for {ADSB_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ADSB_CONSTANTS

feature -- ADSB Constants

	default_modes_port:       INTEGER = 30003
			-- Default mode s default port
	default_listening_port:   INTEGER = 4004
			-- Default listening port
	default_commands_port:    INTEGER = 4040
			-- Defaut commands port
	default_date_time_format: STRING  = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"
			-- Default date time format string


end

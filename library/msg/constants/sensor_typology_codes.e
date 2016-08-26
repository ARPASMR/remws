note
	description: "Summary description for {SENSOR_TYPOLOGY_CODES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SENSOR_TYPOLOGY_CODES

feature -- Constants

	temperature:          STRING = "T"
			-- 2m Temperature
	wind_speed:           STRING = "VV"
			-- Wind speed
	wind_direction:       STRING = "DV"
			-- Wind direction
	relative_humidity:    STRING = "UR"
			-- Relative humidity
	rainfall:             STRING = "PP"
			-- Rainfall
	global_radiation:     STRING = "RG"
			-- Global radiation
	atmospheric_pressure: STRING = "PA"
			-- Atmospheric pressure
	snow:                 STRING = "N"
			-- Snow
end

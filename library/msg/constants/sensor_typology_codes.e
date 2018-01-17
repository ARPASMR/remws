note
	description : "Summary description for {SENSOR_TYPOLOGY_CODES}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

class
	SENSOR_TYPOLOGY_CODES

feature -- Constants

	temperature:          STRING = "T"
			-- 2m Temperature
	wind_speed:           STRING = "VV"
			-- Wind speed
	sonic_wind_speed:     STRING = "VVS"
			-- Sonic wind speed
	wind_direction:       STRING = "DV"
			-- Wind direction
	sonic_wind_direction: STRING = "DVS"
			-- Sonic wind direction
	relative_humidity:    STRING = "UR"
			-- Relative humidity
	rainfall:             STRING = "PP"
			-- Rainfall
	global_radiation:     STRING = "RG"
			-- Global radiation
	net_radiation:        STRING = "RN"
			-- Net radiation
	atmospheric_pressure: STRING = "PA"
			-- Atmospheric pressure
	snow:                 STRING = "N"
			-- Snow
	idro:                 STRING = "I"
			-- Idro
	present_time:         STRING = "TP"
			-- Present time
end

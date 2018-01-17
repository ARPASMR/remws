note
	description : "Summary description for {SENSOR_STATUS}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

class
	SENSOR_STATUS

inherit
	STATION_STATUS

create
	make,
	make_from_id_and_name

end

note
	description : "Summary description for {TIME_GRANULARITY_CODES}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

class
	TIME_GRANULARITY_CODES

feature -- Constants

	one_minute: INTEGER = 5
			-- One minute time interval

	five_minutes: INTEGER = 10
			-- Five minutes time interval

	ten_minutes: INTEGER = 1
			-- Ten minutes time interval

	thirty_minutes: INTEGER = 2
			-- Thirty minutes time interval

	sixty_minutes: INTEGER = 3
			-- Sixty minutes time nterval

	two_hours: INTEGER = 8
			-- Two hours time interval

	three_hours: INTEGER = 6
			-- Three hours time interval

	four_hours: INTEGER = 9
			-- Four hours time interval

	one_day: INTEGER = 4
			-- One day time interval

end

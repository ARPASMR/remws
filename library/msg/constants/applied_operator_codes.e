note
	description : "Summary description for {APPLIED_OPERATOR_CODES}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:02 (dom 10 dic 2017, 19.44.02, CET) buck $"
	revision    : "$Revision 48 $"

class
	APPLIED_OPERATOR_CODES

feature -- Constants

	average: INTEGER = 1
			-- Average operator

	minimum: INTEGER = 2
			-- Minimum operator

	maximum: INTEGER = 3
			-- Maximum operator

	cumulated: INTEGER = 4
			-- Cumulative operator

	moving_average: INTEGER = 10
			-- 8 hours moving average

end

note
	description: "MATISSE-Eiffel Binding: define the storable class which is the base class for persistence."
	license: "[
	The contents of this file are subject to the Matisse Interfaces 
	Public License Version 1.0 (the 'License'); you may not use this 
	file except in compliance with the License. You may obtain a copy of
	the License at http://www.matisse.com/pdf/developers/MIPL.html

	Software distributed under the License is distributed on an 'AS IS'
	basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See 
	the License for the specific language governing rights and
	limitations under the License.

	The Original Code was created by Matisse Software Inc. 
	and its successors.

	The Initial Developer of the Original Code is Matisse Software Inc. 
	Portions created by Matisse Software are Copyright (C) 
	Matisse Software Inc. All Rights Reserved.

	Contributor(s): Kazuhiro Nakao
                   Didier Cabannes
                   Neal Lester
                   Luca Paganotti
	]"


deferred class
	MT_DATETIME

feature {NONE} -- DATE_TIME utilities

	milliseconds_per_day: INTEGER_32 is 86400000

	date_time_duration_from_days_fsecs (days: INTEGER_32; fine_secs: DOUBLE; negative: BOOLEAN): DATE_TIME_DURATION
		local
			date: DATE_DURATION
			time: TIME_DURATION
		do
			create date.make_by_days (days)
			create time.make_by_fine_seconds (fine_secs)
			if negative then
				create Result.make_by_date_time (- date, - time)
			else
				create Result.make_by_date_time (date, time)
			end
		end

	date_time_duration_from_milliseconds (milliseconds: INTEGER_64): DATE_TIME_DURATION
		local
			-- date: DATE_DURATION
			-- time: TIME_DURATION
			days: INTEGER_64
			negative: BOOLEAN
			fine_seconds: DOUBLE
		do
			negative := (milliseconds < 0)
			days := milliseconds // milliseconds_per_day
			fine_seconds := milliseconds \\ milliseconds_per_day
			Result := date_time_duration_from_days_fsecs (days.as_integer_32.abs, (fine_seconds.abs / 1000), negative)
		end

end -- class MT_DATETIME

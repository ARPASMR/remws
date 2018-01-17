note
	description : "Summary description for {AVAILABLE_DATA}."
	copyright   : "$Copyright Copyright (c) 2015-2017 ARPA Lombardia $"
	license     : "$License General Public License v2 (see http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt) $"
	author      : "$Author Luca Paganotti < luca.paganotti (at) gmail.com > $"
	date        : "$Date 2017-12-10 19:44:21 (dom 10 dic 2017, 19.44.21, CET) buck $"
	revision    : "$Revision 48 $"

class
	AVAILABLE_DATA

inherit
	ANY

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create realtime_segment.make
			create standard_segment.make
		end

feature -- Access

	realtime_segment: DATA
	standard_segment: DATA

feature -- Status setting

	set_realtime_segment (a_segment: DATA)
			-- Sets `realtime_segment'
		require
			a_segment_not_void: a_segment /= Void
		do
			realtime_segment := a_segment.twin
		end

	set_standard_segment (a_segment: DATA)
			-- Sets `standad_segment'
		require
			a_segment_not_void: a_segment /= Void
		do
			standard_segment := a_segment.twin
		end

end

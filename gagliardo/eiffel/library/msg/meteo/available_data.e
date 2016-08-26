note
	description: "Summary description for {AVAILABLE_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

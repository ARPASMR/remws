indexing

	description:
		"The GTK_PROGRESS_BAR is typically used to display the progress of a long running"
		"operation. It provides a visual clue that processing is underway. The GTK_PROGRESS_BAR"
		"can be used in two different modes: percentage mode and activity mode."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.4 $"

class GTK_PROGRESS_BAR

inherit

	GTK_WIDGET

	GTKPROGRESSBAR_FUNCTIONS
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTK_PROGRESS_BAR_ORIENTATION_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_progress_bar_orientation
		undefine
			is_equal,
			copy
		end

creation

	make

feature {NONE} -- Initialization

	make is
			-- Creates a new GTK_PROGRESS_BAR widget.
		do
			make_shared (gtk_progress_bar_new)
		end

feature {ANY} -- Pulsing

	pulse is
			-- Indicates that some progress is made, but you don't know
			-- how much.  Causes the progress bar to enter "activity
			-- mode," where a block bounces back and forth. Each call to
			-- `pulse' causes the block to move by a little bit (the
			-- amount of movement per pulse is determined by
			-- `set_pulse_step'.
		do
			gtk_progress_bar_pulse (item)
		end

	set_pulse_step (a_value: DOUBLE) is
			-- Sets the fraction of total progress bar length to move the
			-- bouncing block for each call to `pulse'.
		require
			a_value_large_enough: a_value >= 0.0
			a_value_small_enough: a_value <= 1.0
		do
			gtk_progress_bar_set_pulse_step (item, a_value)
		ensure
			pulse_step_set: pulse_step = a_value
		end

	pulse_step: DOUBLE is
			-- Retrives the pulse step set with `set_pulse_step'.
		do
			Result := gtk_progress_bar_get_pulse_step (item)
		ensure
			result_large_enough: Result >= 0.0
			result_small_enough: Result <= 1.0
		end

feature {ANY}

	set_text (a_text: STRING) is
			-- Causes the given text to appear superimposed on the progress bar.
		require
			a_text_not_void: a_text /= Void
		do
			gtk_progress_bar_set_text (item, a_text)
		ensure
			has_text: has_text
			a_text_set: text.is_equal (a_text)
		end

	text: STRING is
			-- Returns the text currently superimposed on the progress bar.
		require
			has_text: has_text
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			-- TODO: this implemention is time and memory suboptimal
			create cstr.make_shared(gtk_progress_bar_get_text(item))
			Result := cstr.string
		ensure
			result_not_void: Result /= Void
		end

	has_text: BOOLEAN is
			-- Determines if text is currently superimposed on the progress bar.
		do
			Result := gtk_progress_bar_get_text(item) /= Default_pointer
		end

	remove_text is
			-- Makes the progress bar not have any text superimposed.
		require
			has_text: has_text
		do
			gtk_progress_bar_set_text_external (item, Default_pointer)
		ensure
			hasnt_text: not has_text
		end

	set_fraction (a_value: DOUBLE) is
			-- Cause the progress bar to "fill in" the given fraction of the bar.
			-- The fraction should be between 0.0 and 1.0, inclusive.
		require
			a_value_large_enough: a_value >= 0.0
			a_value_small_enough: a_value <= 1.0
		do
			gtk_progress_bar_set_fraction_external (item, a_value)
		ensure
			fraction_set: fraction = a_value
		end

	fraction: DOUBLE is
			-- Current fraction; See `set_fraction'.
		do
			Result := gtk_progress_bar_get_fraction_external (item)
		ensure
			result_large_enough: Result >= 0.0
			result_small_enough: Result <= 1.0
		end

	set_orientation (a_orientation: INTEGER) is
			-- Causes the progress bar to switch to a different
			-- orientation (left-to-right, right-to-left, top-to-bottom,
			-- or bottom-to-top).  See
			-- GTK_PROGRESS_BAR_ORIENTATION_ENUM_EXTERNAL
		require
			valid_a_orientation: is_valid_progress_bar_orientation (a_orientation)
		do
			gtk_progress_bar_set_orientation (item, a_orientation)
		ensure
			a_orientation_set: orientation = a_orientation
		end

	orientation: INTEGER is
			-- The current orientation of the progress bar
			-- See GTK_PROGRESS_BAR_ORIENTATION_ENUM_EXTERNAL
			-- and `set_orientation'
		do
			Result := gtk_progress_bar_get_orientation (item)
		ensure
			valid_orientation: is_valid_progress_bar_orientation (Result)
		end

end

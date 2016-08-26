indexing

	description:

		"A bin with a decorative frame and optional label."

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.4 $"

class GTK_FRAME

inherit

	GTK_BIN

	GTKFRAME_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

	GTK_SHADOW_TYPE_ENUM_EXTERNAL
		rename
			is_valid_enum as is_valid_shadow_type
		undefine
			is_equal,
			copy
		end

creation

	make,
	make_with_label

feature {NONE} -- Creation

	make is
			-- Create a new GTK_FRAME object, without a label.
		require
			toolkit_is_initialized: gtk_main.is_toolkit_initialized
		do
			make_shared (gtk_frame_new_external (Default_pointer))
		end

	make_with_label (a_label: STRING) is
			-- Create a new GTK_FRAME object, with the label `a_label'.
		require
			toolkit_is_initialized: gtk_main.is_toolkit_initialized
			a_label_not_void: a_label /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			make_shared (gtk_frame_new_external (cstr.item))
		end

feature {ANY} -- Status Access

	has_label: BOOLEAN is
			-- Does this frame have a label?
			-- It does have one, if one was set via `make_with_label' or
			-- `set_label'.
		do
			Result := gtk_frame_get_label_external (item) /= Default_pointer
		end

	label: STRING is
			-- Text of Label of current frame (if it has one)
		require
			has_label: has_label
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_shared (gtk_frame_get_label_external (item))
			Result := cstr.string
		ensure
			result_not_void: Result /= Void
		end

	shadow_type: INTEGER is
			-- Retrieves the shadow type of the frame.
			-- See `set_shadow_type'.
		do
			Result := gtk_frame_get_shadow_type_external (item)
		ensure
			valid_shadow_type: is_valid_shadow_type (Result)
		end

feature {ANY} -- Status Setting

	set_label (a_label: STRING) is
			-- Set the text of the label.
		require
			a_label_not_void: a_label /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_label)
			gtk_frame_set_label_external (item, cstr.item)
		ensure
			has_label: has_label
			label_set: STRING_.same_string (a_label, label)
		end

	remove_label is
			-- Remove current label of frame.
		do
			gtk_frame_set_label_external (item, Default_pointer)
		ensure
			not_has_label: not has_label
		end

	set_label_alignment (a_x_alignment: REAL; a_y_alignment: REAL) is
			-- Set the alignment of the Frame widget's label. The default
			-- value for a newly created Frame is 0.0.
			--
			-- `a_x_alignment':	The position of the label along the top edge of the widget.
			--					A value of 0.0 represents left alignment; 1.0 represents
			--					right alignment.
			-- `a_y_alignment':	The y alignment of the label. Currently ignored.
		require
			has_label: has_label
		do
			gtk_frame_set_label_align_external (item, a_x_alignment, a_y_alignment)
		ensure
			a_x_alignment_set: True -- TODO:
			a_y_alignment_set: True -- TODO:
		end

	set_shadow_type (a_type: INTEGER) is
			-- Set the shadow type for the Frame widget.
			-- `a_type' is one of GTK_SHADOW_TYPE_ENUM_EXTERNAL
		require
			a_type_is_shadow_type: is_valid_shadow_type (a_type)
		do
			gtk_frame_set_shadow_type_external (item, a_type)
		ensure
			shadow_type_set: a_type = shadow_type
		end

end

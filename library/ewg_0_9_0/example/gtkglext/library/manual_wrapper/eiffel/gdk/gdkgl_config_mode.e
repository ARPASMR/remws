

indexing
	description: "Interface to gdk_config routines"
	names: "GDK_CONFIG"
	representation: "None"
	access: "fixed"
	size: "fixed"
	contents: "GDK_CONFIG"
	patterns: "none"
	date: "$DateTime$"
	revision: "$Revision$"
	author: "$Author$"
	status: "unreviewed"

class GDKGL_CONFIG_MODE

inherit

	GDK_GLCONFIG_MODE_ENUM_EXTERNAL

	EWG_IMPORTED_EXTERNAL_ROUTINES
		
creation

	make

feature -- Initialization

	make, reset is
			-- Reset the mode
		do
			mode := 0
		end

feature -- Access

	mode: INTEGER
			-- The configuration mode for the gtk_gl_window
	
feature -- Status report

	valid_mode (the_mode: INTEGER): BOOLEAN is
			-- Is `the_mode' valid?
		do
			Result := the_mode = gdk_gl_mode_rgb or the_mode = gdk_gl_mode_rgba or
				the_mode = gdk_gl_mode_index or the_mode = gdk_gl_mode_single or
				the_mode = gdk_gl_mode_double or the_mode = gdk_gl_mode_stereo or
				the_mode = gdk_gl_mode_alpha or the_mode = gdk_gl_mode_depth or
				the_mode = gdk_gl_mode_stencil or the_mode = gdk_gl_mode_accum or
				the_mode = gdk_gl_mode_multisample
		end 

feature -- Element change

	add_mode (new_mode: INTEGER) is
			-- Add `new_mode' to `mode'
		require 
			valid_mode: valid_mode (new_mode)
		do
			mode := EXTERNAL_MEMORY_.bitwise_integer_or_external (mode, new_mode)
		ensure 
			mode_set :EXTERNAL_MEMORY_.bitwise_integer_and_external (mode, new_mode) = new_mode
		end 

	remove_mode (new_mode: INTEGER) is
			-- Remove `new_mode' from `mode'
		require 
			valid_mode: valid_mode (new_mode)
			has_mode: EXTERNAL_MEMORY_.bitwise_integer_and_external (mode, new_mode) = new_mode
		do
			mode := EXTERNAL_MEMORY_.bitwise_integer_xor_external (mode, new_mode)
		ensure 
			mode_set: EXTERNAL_MEMORY_.bitwise_integer_and_external (mode, new_mode) /= new_mode
		end 

end -- class GDKGL_CONFIG_MODE


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

class GDKGL_CONFIG

inherit

	GDKGLCONFIG_FUNCTIONS_EXTERNAL
		redefine
			out
		end

	GDKGLCONTEXT_FUNCTIONS_EXTERNAL
		undefine
			out
		end

creation
	make,
	make_with_mode

feature -- Initialization

	make is
			-- Initialize as depth, double_buffered, rgb
		local
			mode: GDKGL_CONFIG_MODE
		do
			create mode.make
			mode.add_mode (mode.gdk_gl_mode_rgb)
			mode.add_mode (mode.gdk_gl_mode_double)
			mode.add_mode (mode.gdk_gl_mode_depth)
			make_with_mode (mode)
		end

	make_with_mode (mode: GDKGL_CONFIG_MODE) is
			-- Create the configuration from `mode'
		do
			item := gdk_gl_config_new_by_mode_external (mode.mode)
		end

feature -- Access

	drawable: POINTER is
		do
			Result := gdk_gl_context_get_gl_drawable_external (item)
		end

feature -- Status report

	is_rgba: BOOLEAN is
			-- Is this configuration RGBA?
		do
			Result := false
			if gdk_gl_config_is_rgba_external (item) = 1 then
				Result := true
			end
		end

	is_double_buffered: BOOLEAN is
			-- Is this configuration double buffered?
		do
			Result := false
			if gdk_gl_config_is_double_buffered_external (item) = 1 then
				Result := true
			end
		end

	is_stereo: BOOLEAN is
			-- Is stereo set?
		do
			Result := false
			if gdk_gl_config_is_stereo_external (item) = 1 then
				Result := true
			end
		end

	has_alpha: BOOLEAN is
			-- Is alpha set?
		do
			Result := false
			if gdk_gl_config_has_alpha_external (item) = 1 then
				Result := true
			end
		end

	has_depth_buffer: BOOLEAN is
			-- Is depth set?
		do
			Result := false
			if gdk_gl_config_has_depth_buffer_external (item) = 1 then
				Result := true
			end
		end

	has_stencil_buffer: BOOLEAN is
			-- Is stencil set?
		do
			Result := false
			if gdk_gl_config_has_stencil_buffer_external (item) = 1 then
				Result := true
			end
		end

	has_accumulation_buffer: BOOLEAN is
			-- Is accum_buffer set?
		do
			Result := false
			if gdk_gl_config_has_accum_buffer_external (item) = 1 then
				Result := true
			end
		end

feature -- Basic operations

	out: STRING is
			-- Printable representation
		do
			create Result.make (40)
			Result.append_string ("OpenGL visual configurations :%N")
			Result.append_string ("%Tis_rgba = ")
			Result.append_string (is_rgba.out)
			Result.append_string ("%N")

			Result.append_string ("%Tis_double_buffered = ")
			Result.append_string (is_double_buffered.out)
			Result.append_string ("%N")

			Result.append_string ("%Tis_stereo = ")
			Result.append_string (is_stereo.out)
			Result.append_string ("%N")

			Result.append_string ("%Thas_alpha = ")
			Result.append_string (has_alpha.out)
			Result.append_string ("%N")

			Result.append_string ("%Thas_depth_buffer = ")
			Result.append_string (has_depth_buffer.out)
			Result.append_string ("%N")

			Result.append_string ("%Thas_stencil_buffer = ")
			Result.append_string (has_stencil_buffer.out)
			Result.append_string ("%N")

			Result.append_string ("%Thas_accumulation_buffer = ")
			Result.append_string (has_accumulation_buffer.out)
			Result.append_string ("%N")
			Result.append_string ("%N")

		end

feature {GTKGL_WIDGET} -- Implementation

	item: POINTER

invariant

	item_not_default_pointer: item /= Default_pointer

end -- class GDKGL_CONFIG


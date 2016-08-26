indexing

	description:

		"A GTK widget with OpenGL capabilities"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/05/21 13:28:22 $"
	revision: "$Revision: 1.2 $"

class GTKGL_WIDGET

inherit

	GTK_DRAWING_AREA
		rename
			make as make_drawing_area
		export
			{NONE} make_drawing_area
		end

	GTKGLWIDGET_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
	
	EWG_GTKGLEXT_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
	
	GDKGLDRAWABLE_FUNCTIONS_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
	
	GDK_GLRENDER_TYPE_ENUM_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
	
creation

	make,
	make_with_config

feature -- Initialization

	make is
			-- Create a gtkgl_widget with a default configuration
		local
			new_config: GDKGL_CONFIG
		do
			create new_config.make
			make_with_config (new_config)
		end
	
	make_with_config (a_config: GDKGL_CONFIG) is
			-- Creates a gtkgl_widget from `a_config' with RGBA draw type
		require
			a_config_not_void: a_config /= Void
		local
			ret: INTEGER
		do
			make_drawing_area
			config := a_config
			ret := gtk_widget_set_gl_capability_external (item, config.item,
																		 default_pointer,
																		 1,
																		 gdk_gl_rgba_type)
		ensure
			config_set: config = a_config
		end

feature -- Access

	config: GDKGL_CONFIG

feature -- Basic operations

	gl_begin: BOOLEAN is
			-- Prepare widget for OpenGL commands
			-- TODO: Command and Query separation
		do
			Result := gdk_gl_drawable_gl_begin_external (drawable,
														gtk_widget_get_gl_context_external (item)) /= 0
		end 

	gl_end is
			-- Notify widget of end of OpenGL commands
		do
			gdk_gl_drawable_gl_end_external (drawable)
		end

	swap_buffers is
			-- Swap the buffers
		require
			double_buffered: config.is_double_buffered
		do
			gdk_gl_drawable_swap_buffers_external (drawable)
		end
	
feature {NONE} -- Implementation

	drawable: POINTER is
			-- Pointer to the drawable area of `Current'; TODO: We should
			-- really return an object of type GDKGL_DRAWABLE instead of
			-- POINTER here.
		do
			Result := ewg_gtk_widget_get_gl_drawable_external (item)
		end
	
end

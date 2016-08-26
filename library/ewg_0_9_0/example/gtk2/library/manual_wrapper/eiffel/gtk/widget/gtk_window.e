indexing

	description:

		"Represents GTK top level windows"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GTK+ 2 Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.7 $"

class GTK_WINDOW

inherit

	GTK_BIN
		export
			{GTK_WIDGET} make_shared 
		end
	
	GTKWINDOW_FUNCTIONS
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end
 
	GTK_WINDOW_TYPE_ENUM_EXTERNAL
		export
			{NONE} all
		undefine
			is_equal,
			copy
		end

creation

	make_top_level,
	make_popup,
	make_shared
	
feature {NONE} -- Creation

	make_top_level is
			-- Creates a new GTK window, which is a toplevel
			-- window that can contain other widgets. Nearly
			-- always, you should create objects of this class
			-- via `make_top_level' (and not via `make_popup')
			-- If you're implementing something like a popup menu
			-- from scratch (which is a bad idea, just use GtkMenu),
			-- you might use `make_popup'. `make_popup' is not for dialogs,
			-- though in some other toolkits dialogs are called "popups".
			-- In GTK+, `make_popup' means a pop-up menu or pop-up tooltip.
			-- On X11, popup windows are not controlled by the window manager.
			-- If you simply want an undecorated window (no window borders),
			-- use `set_decorated', don't use `make_popup'.
		require
			toolkit_is_initialized: gtk_main.is_toolkit_initialized
		do
			make_shared (gtk_window_new_external (gtk_window_toplevel))
		end

	make_popup is
			-- Same as `make_top_level' but creates a popup window,
			-- instead of a regular top level window.
		require
			toolkit_is_initialized: gtk_main.is_toolkit_initialized
		do
			make_shared (gtk_window_new_external (gtk_window_popup))
		end
	

feature {ANY} -- Status

	is_resizable: BOOLEAN is
			-- Is window resizable?
		do
			if gtk_window_get_resizable_external (item) = 1 then
				Result := True
			end
		end

	is_modal: BOOLEAN is
			-- Is window modal?
		do
			Result := gtk_window_get_modal(item).to_boolean
		end

	is_destroyed_with_parent: BOOLEAN is
			-- Will Current window be destroyed with its transient parent?
		do
			Result := gtk_window_get_destroy_with_parent (item).to_boolean
		end
	
feature {ANY} -- Change Status

	set_resizable (a_yes: BOOLEAN) is
			-- Sets whether the user can resize a window.
			-- Windows are user resizable by default.
		local
			a_yes_int: INTEGER
		do
			if a_yes then
				a_yes_int := 1
			end
			gtk_window_set_resizable_external (item, a_yes_int)
		end

	set_modal (a_setting: BOOLEAN) is
			-- Sets a window modal or non-modal. Modal windows prevent
			-- interaction with other windows in the same application. To
			-- keep modal dialogs on top of main application windows, use
			-- set_transient_for to make the window transient for
			-- the parent; most window managers will then disallow
			-- lowering the dialog below the parent.
		do
			gtk_window_set_modal (item, a_setting.to_integer)
		ensure
			value_set: ((a_setting = True  and is_modal=True) or
							(a_setting = False and is_modal=True))
		end
		
	set_destroy_with_parent (a_setting: BOOLEAN) is
			-- If a_setting is true, then destroying the transient parent
			-- of Current window will also destroy window itself. This is
			-- useful for dialogs that shouldn't persist beyond the
			-- lifetime of the main window they're associated with, for
			-- example.
		do
			gtk_window_set_destroy_with_parent (item, a_setting.to_integer)
		ensure
			value_set: ((a_setting = True  and is_destroyed_with_parent=True) or
							(a_setting = False and is_destroyed_with_parent=True))
		end

	
	set_title (a_title: STRING) is
			-- Sets the title of the GTK_WINDOW. The title of a window
			-- will be displayed in its title bar; on the X Window System,
			-- the title bar is rendered by the window manager, so exactly
			-- how the title appears to users may vary according to a user's
			-- exact configuration. The title should help a user distinguish
			-- this window from other windows they may have open. A good title
			-- might include the application name and current document filename,
			-- for example.
		require
			a_title_not_void: a_title /= Void
		local
			cstr: EWG_ZERO_TERMINATED_STRING
		do
			create cstr.make_unshared_from_string (a_title)
			gtk_window_set_title_external (item, cstr.item)
		ensure
			title_set: True -- TODO:
		end

feature {ANY} -- Transient status

	set_transient_for (a_parent: GTK_WINDOW) is
			-- Make Current a transient window for a_parent. This feature
			-- is usually used for dialogs.
		do
			gtk_window_set_transient_for (item, a_parent.item)
		end

	transient_parent: GTK_WINDOW is
			-- Transient parent for Current window. Void if no transient
			-- parent has been set.
		local
			ptr: POINTER
		do
			ptr := gtk_window_get_transient_for(item)
			if ptr = default_pointer then
				Result := Void
			else
				create Result.make_shared (ptr)
			end
		end
end

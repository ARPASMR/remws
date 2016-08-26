indexing

	description:

		"GTK+ 2 example demostrating the use of dialogs"

	copyright: "Copyright (c) 2004, Paolo Redaelli"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2005/04/24 20:15:14 $"
	revision: "$Revision: 1.4 $"

class GTK_DIALOGS_DEMO

inherit
	
	GTK_SHARED_MAIN
		export {NONE} all
		end

	KL_SHARED_EXCEPTIONS
		export {NONE} all
		end
	
creation make

feature -- dialogs

	dialog: GTK_DIALOG

	label: GTK_LABEL

	message: GTK_MESSAGE_DIALOG

	file_chooser: GTK_FILE_CHOOSER_DIALOG
	
	file_selection: GTK_FILE_SELECTION

	answer: INTEGER
			-- answer code of the last dialog run
	
feature -- Initialisation
	
	make is
		do
			print ("Wrap GS_LIST[X->WRAPPED] and write GTK_FILE_CHOOSER's features `filenames', `uris' `shortcut_folders' `shortcut_folders_uris' !!!%N")
			initialize
			--run_some_dialogs
			--show_file_dialogs
			run_files_dialog
		end

	run_some_dialogs is
		do
			create dialog.make
			-- Add a label
			create label.make ("What's your favourite programming language?")
			label.show
			dialog.vbox.pack_start_defaults (label)			
			-- Add some buttons 
			dialog.add_button("Eiffel", 10)
			dialog.add_button("C#", 11)
			dialog.add_button("Python", 12)
			dialog.add_help_button
			-- TODO: 10,11,12 are response_id... is it clear enough?
						
			answer:=dialog.run
			print("Answer is: ") print(answer.out) print("%N")

			-- Old interface create message.make_message (Void, -- no
			-- parent gtk_dialog_modal, gtk_message_info,
			-- gtk_buttons_ok_cancel, "[ Ewg-GTK are Eiffel wrappers to
			-- the GTK+ libraries made with Eiffel Wrapper Generator
			-- created by Andreas Leitner.  ]"  )

			create message.make_info ("[
												Ewg-GTK are Eiffel wrappers to the
												GTK+ libraries made with Eiffel
												Wrapper Generator created by
												Andreas Leitner.
												]")
			message.set_modal (True)
			message.add_ok_cancel_buttons

			answer := message.run
			print("Answer is:") print(answer.out) print("%N")

			create message.make_question ("[
													 <b><big>Ewg-GTK</big> is a work in progress</b>.
													 We need volunteers. Would help us?
													 ]")
			message.set_modal (True)
			message.add_yes_no_buttons
														
			answer := message.run
			print("Answer is:") print(answer.out) print("%N")
			
		end

	show_file_dialogs is
		local filename: STRING; filenames: GS_LIST_STRING
		do
			create file_chooser.make_open ("Choose the Eiffelest file you have")
			file_chooser.add_ok_cancel_buttons
			answer := file_chooser.run
			print ("Answer: ") print (answer.out)
			filename := file_chooser.filename
			if filename = Void then
				print (". Sadly no file choosen%N")
			else
				print (". Happily you chose: '") print (filename) print("'%N")
			end
		end

	run_files_dialog is
		local filenames: GS_LIST_STRING
		do
			create file_chooser.make_open ("Choose some files")
			file_chooser.add_ok_cancel_buttons
			file_chooser.allow_multiple
			
			answer := file_chooser.run
			print ("Answer: ") print (answer.out)
			filenames := file_chooser.filenames
			from filenames.start print("Choosen files are:%N")
			until filenames.off -- after
			loop
				print (filenames.iteration_item) print ("%N")
				filenames.forth
			end
			print ("No more%N")
		end
	
	initialize is
		do
			-- Setup the locale for GTK and GDK according to the programs
			-- environment
			gtk_main.set_locale
			-- Initialize GTK
			gtk_main.initialize_toolkit
			-- If initialization went wrong for some reason,
			-- quit the application
			if not gtk_main.is_toolkit_initialized then
				print ("Unable to init GTK%N")
				Exceptions.die (1)
			end
		end
end

note
	description: "MATISSE-Eiffel Binding: define the class to control a Matisse connection."
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

class
	TASK
inherit
	THREAD

create
	make

feature {NONE} -- Initialization

	make (a_db : MT_DATABASE; io_m: MUTEX; i: INTEGER; n: INTEGER)
		require
			db_not_void: a_db /= Void
			io_m_not_void: io_m /= Void
			valid_i: i > 0
			valid_n: n > 0
		do
			db := a_db
			io_mutex := io_m
			id := i
			nb_loop := n
		end


feature {NONE} -- Implementation

	io_mutex: MUTEX

	id, nb_loop: INTEGER

	db: MT_DATABASE

	execute
		local
			cpt: INTEGER
			connected : BOOLEAN
		do

			connected := db.is_connection_open ( )
			if connected then
				from
					cpt := 1
				until
					cpt > nb_loop
				loop
					if cpt > nb_loop / 2 then
						db.start_version_access(Void)
					else
						db.start_transaction(db.mt_max_tran_priority)
					end

					io_mutex.lock
					print ("Thread #" + id.out + " connection and ")
					if db.is_version_access_in_progress() = True then
						print("read only access ")
					else
						print("read write access ")
					end
					print("#" + cpt.out + " to " + db.out + "%N")
					io_mutex.unlock

					if db.is_transaction_in_progress() = True then
						db.rollback()
					else
						db.end_version_access()
					end

					cpt := cpt + 1
				end
			end
		end


end  -- class TASK


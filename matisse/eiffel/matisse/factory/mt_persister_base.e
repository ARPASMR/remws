note
	description: "MATISSE-Eiffel Binding: define the database session class"
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
	MT_PERSISTER_BASE

create
	make

feature -- Initialization

	make (a_db: MT_DATABASE)
		require
			not_void: a_db /= Void
		do
			mtdb := a_db
		end

feature -- Implementation

	mtdb: MT_DATABASE

	version_access_started(new_version: INTEGER_32)
		-- A version access has just started
		do
		end

	version_access_ended
		-- A version access has just ended
		do
		end

	transaction_started(new_version: INTEGER_32)
		-- A transaction has just started
		do
		end

	transaction_committed
		-- A transaction has just been committed.
		do
		end

	transaction_aborted
		-- A transaction has just been aborted.
		do
		end

	connected
		-- The connection has just been connected.
		do
		end

	disconnected
		-- The connection has just been disconnected.
		do
		end

	flush_updated_objects
		do
		end
	
	eif_object_from_oid (a_mt_oid: INTEGER_32): MT_OBJECT
		require
			positive_oid: a_mt_oid /= 0
		do
		end

end -- class MT_PERSISTER_BASE
	

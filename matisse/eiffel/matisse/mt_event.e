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
	MT_EVENT

create
	make

feature -- Server Execution Priority

	Mt_Event1: INTEGER_32 = 0x1
	Mt_Event2: INTEGER_32 = 0x2
	Mt_Event3: INTEGER_32 = 0x4
	Mt_Event4: INTEGER_32 = 0x8
	Mt_Event5: INTEGER_32 = 0x10
	Mt_Event6: INTEGER_32 = 0x20
	Mt_Event7: INTEGER_32 = 0x40
	Mt_Event8: INTEGER_32 = 0x80
	Mt_Event9: INTEGER_32 = 0x100
	Mt_Event10: INTEGER_32 = 0x200
	Mt_Event11: INTEGER_32 = 0x400
	Mt_Event12: INTEGER_32 = 0x800
	Mt_Event13: INTEGER_32 = 0x1000
	Mt_Event14: INTEGER_32 = 0x2000
	Mt_Event15: INTEGER_32 = 0x4000
	Mt_Event16: INTEGER_32 = 0x8000
	Mt_Event17: INTEGER_32 = 0x10000
	Mt_Event18: INTEGER_32 = 0x20000
	Mt_Event19: INTEGER_32 = 0x40000
	Mt_Event20: INTEGER_32 = 0x80000
	Mt_Event21: INTEGER_32 = 0x100000
	Mt_Event22: INTEGER_32 = 0x200000
	Mt_Event23: INTEGER_32 = 0x400000
	Mt_Event24: INTEGER_32 = 0x800000
	Mt_Event25: INTEGER_32 = 0x1000000
	Mt_Event26: INTEGER_32 = 0x2000000
	Mt_Event27: INTEGER_32 = 0x4000000
	Mt_Event28: INTEGER_32 = 0x8000000
	Mt_Event29: INTEGER_32 = 0x10000000
	Mt_Event30: INTEGER_32 = 0x20000000
	Mt_Event31: INTEGER_32 = 0x40000000
	Mt_Event32: INTEGER_32 = 0x80000000


feature {NONE} -- Implementation

	db: MT_DATABASE


feature -- Initialization

	make (a_db: MT_DATABASE)
		-- create a  new instance of MT_EVENT with a database object
		do
			db := a_db
		end


feature -- Manage Events

	subscribe (posted_events: INTEGER_64)
		-- Subscribes to a set of events. Once the subscription is done,
		-- all the events that occurred are logged for this subscriber.
		-- You are notified that an event occurs by using
		-- wait
		do
			db.context.event_subscribe (posted_events)
		end

	unsubscribe ()
		-- Unsubscribes all events that you have subscribed to.
		do
			db.context.event_unsubscribe ()
		end

	wait (timeout : INTEGER_32): INTEGER_64
		-- Waits for the first coming event among the set of posted event
		-- the time out is in milliseconds
		-- return 0 if the timeout is reached before any event has occurred,
		-- return the combination of trigged events otherwise
		do
			Result := db.context.event_wait (timeout)
		end

	notify (events: INTEGER_64)
		--  Triggers one or more events
		do
			db.context.event_notify (events)
		end


end -- class MT_EVENT

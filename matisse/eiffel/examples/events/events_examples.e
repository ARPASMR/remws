note
	description: "MATISSE-Eiffel Binding: Matisse Events examples."
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
	EVENTS_EXAMPLES

create
	make

feature {NONE} -- Initialization

	make ()
		local
			host, db, operation: STRING
		do
			print("%NRunning Events Examples:%N")
			host := "localhost"
			db := "example"
			operation := "N"
			-- operation := "S"

			if operation.is_equal("N") then
				notify_of_changes (host, db)
			else
				subscribe_to_changes (host, db)
			end
		end

feature -- Application events

	Temperature_Changes_Evt: INTEGER
	Rainfall_Changes_Evt: INTEGER
	Himidity_Changes_Evt: INTEGER
	Windspeed_Changes_Evt: INTEGER

feature {NONE} -- Notify Of Changes

	init_constants ()
		do
			Temperature_Changes_Evt := {MT_EVENT}.Mt_Event1
			Rainfall_Changes_Evt := {MT_EVENT}.Mt_Event2
			Himidity_Changes_Evt := {MT_EVENT}.Mt_Event3
			Windspeed_Changes_Evt := {MT_EVENT}.Mt_Event4
		end

	notify_of_changes (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			notifier: MT_EVENT
			event_set: INTEGER_64
		do
			if impossible = False then
				print("%NTest Notify Of Changes:%N")

				init_constants ()

				create db.make(host, dbname)
				db.open ()

				create notifier.make (db)

				event_set := Temperature_Changes_Evt
				event_set := event_set + Windspeed_Changes_Evt

				-- Notify of some events
				notifier.notify(event_set)

				print ("Events notified: " + event_set.out + "%N")

				db.close ()
			end
		rescue
			dev_ex ?= (create {EXCEPTION_MANAGER}).last_exception
			if dev_ex /= Void then
				print("%NException occurred on " + db.out + "%N")
				print("%NERROR message: " + dev_ex.message + "%N")
				if {MT_EXCEPTIONS}.c_matisse_exception_code = {MT_EXCEPTIONS}.MATISSE_NOSUCHDB then
					print("Unable to connect to: " + db.out + "%N")
					print("Make sure the database is started%N")
				end
			end
			impossible := True
			retry
		end


feature {NONE} -- Subscribe To Changes

	subscribe_to_changes (host, dbname:STRING)
		local
			impossible: BOOLEAN
			dev_ex: DEVELOPER_EXCEPTION
			db: MT_DATABASE
			subscriber: MT_EVENT
			event_set, triggered_events: INTEGER_64
		do
			if impossible = False then
				print("%NTest Subscribe To Changes:%N")

				init_constants ()

				create db.make(host, dbname)
				db.open()

				create subscriber.make (db)

				-- Subscribe to all 4 events
				event_set := Temperature_Changes_Evt
				event_set := event_set + Rainfall_Changes_Evt
				event_set := event_set + Himidity_Changes_Evt
				event_set := event_set + Windspeed_Changes_Evt

				-- Subscribe
				subscriber.subscribe(event_set)

				-- Wait 1000 ms for events to be triggered
				-- return 0 if not event is triggered until the timeout is reached
				triggered_events := subscriber.wait(1000)
				if triggered_events /= 0 then
					print ("Events triggered: " + triggered_events.out + "%N")
				else
					print ("No events triggered%N")
				end

				-- Unsubscribe to all 4 events
				subscriber.unsubscribe()

				db.close()
			end
		rescue
			dev_ex ?= (create {EXCEPTION_MANAGER}).last_exception
			if dev_ex /= Void then
				print("%NException occurred on " + db.out + "%N")
				print("%NERROR message: " + dev_ex.message + "%N")
				if {MT_EXCEPTIONS}.c_matisse_exception_code = {MT_EXCEPTIONS}.MATISSE_NOSUCHDB then
					print("Unable to connect to: " + db.out + "%N")
					print("Make sure the database is started%N")
				end
			end
			impossible := True
			retry
		end




end -- class EVENTS_EXAMPLES

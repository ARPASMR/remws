note
	description: "A mt_subscriber used for unit tests."
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

	Contributor(s): Neal L Lester
	]"

	
class
	MY_SUBSCRIBER

inherit
	MT_SUBSCRIBER

feature
	
	notify_property_updated (the_object: MT_STORABLE; the_property: INTEGER)
			-- Notification that a property in mt_storable was updated
		do
			was_updated := True
		ensure then
			was_updated: was_updated
		end

	reset_was_updated
			-- Reset was_updated to False for additional tests
		do
			was_updated := False
		ensure
			not_was_updated: not was_updated
		end
	
	was_updated: BOOLEAN
			-- Was update notification received?

end -- class MY_SUBSCRIBER

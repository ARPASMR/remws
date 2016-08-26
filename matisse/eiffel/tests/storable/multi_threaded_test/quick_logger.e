note
	description: "A quick logging system"
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

	Contributor(s): Didier Cabannes
                   Neal Lester
	]"

class

	QUICK_LOGGER

feature

	id: STRING

	log (a_message: STRING) is
			-- Log a message
		require
			valid_a_message: a_message /= Void
		do
			io.put_string (id + ": " + a_message + "%N")
		end

invariant

	valid_id: id /= Void
end

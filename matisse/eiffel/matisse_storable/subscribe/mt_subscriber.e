note
	description: "MATISSE-Eiffel Binding: define a class to listen for MT_STORABLE updates"
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

	Contributor(s): Neal Lester
                   Luca Paganotti
	]"

deferred class
	MT_SUBSCRIBER

feature {MT_SUBSCRIPTION_MANAGER, MT_SUBSCRIPTION_MANAGER, TS_TEST_CASE} -- Subscriptions

	notify_property_updated (the_object: MT_STORABLE; the_property: INTEGER)
			-- Notify Current that the_property in object with the_oid was modified
		deferred
		end

	add_subscribed_property (new_property: STRING)
			-- Add new_property to list of subscribed_properties
		require
			valid_new_property: new_property /= void
			not_subscribed_properties_has_new_property: subscribed_properties /= Void implies not subscribed_properties.has (new_property)
		do
			if subscribed_properties = Void then
				create subscribed_properties.make
			end
			subscribed_properties.force (new_property)
		ensure
			subscribed_properties_has_new_property: subscribed_properties.has (new_property)
		end

	subscribed_properties: LINKED_LIST [STRING]
			-- properties to which this subscriber is listening for change notifications

end -- class MT_SUBSCRIBER

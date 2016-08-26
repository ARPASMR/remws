note
	description: "MATISSE-Eiffel Binding: define the class to manage subscriptions MT_STORABLE event listeners; intended for use as a once function"
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

class
	MT_SUBSCRIPTION_MANAGER

feature -- Subscriptions

	subscribe_property_updates (object_to_watch: MT_STORABLE; subscriber: MT_SUBSCRIBER; property_list: ARRAY[INTEGER])
			-- register subscriber for notification whenever a property in property_list is updated for object with OID
		require
			valid_objeect_to_watch: object_to_watch /= Void and then object_to_watch.is_persistent
			valid_subscriber: subscriber /= Void
			valid_property_list: property_list /= Void and then not property_list.is_empty
		local
			property_list_as_list: ARRAYED_LIST [INTEGER]
			the_key: STRING
			new_subscriber_list: LINKED_LIST [MT_SUBSCRIBER]
		do
			create property_list_as_list.make_from_array (property_list)
			from
				property_list_as_list.start
			until
				property_list_as_list.after
			loop
				the_key := key (object_to_watch.oid, property_list_as_list.item)
				if subscribers.has (the_key) then
					if not subscribers.item (the_key).has (subscriber) then
						subscribers.item (the_key).force (subscriber)
					end
				else
					create new_subscriber_list.make
					new_subscriber_list.force (subscriber)
					subscribers.force (new_subscriber_list, the_key)
				end
				subscriber.add_subscribed_property (the_key)
				property_list_as_list.forth
			end
		ensure
--			all properties are subscribed
		end

	subscribe_all_notifications (subscriber: MT_SUBSCRIBER)
			-- Subscribe subscriber to all notifications
			-- There can be only one such subscriber at a time; set a new one replaces old one
			-- Set to Void to disable all_notifications
		do
			all_notifications_subscriber := subscriber
		ensure
			all_notifications_subscriber_updated: subscriber = all_notifications_subscriber
		end

	unsubscribe_all_property_updates (subscriber: MT_SUBSCRIBER)
			-- Unsubscribe subscriber from all notifications
		require
			valid_subscriber: subscriber /= Void
		local
			the_subscriber_list: LINKED_LIST [MT_SUBSCRIBER]
		do
			if subscriber = all_notifications_subscriber then
				all_notifications_subscriber := Void
			end
			if subscriber.subscribed_properties /= Void then
				from
					subscriber.subscribed_properties.start
				until
					subscriber.subscribed_properties.after
				loop
					if subscribers.has (subscriber.subscribed_properties.item) then
						the_subscriber_list := subscribers.item (subscriber.subscribed_properties.item)
						if the_subscriber_list.has (subscriber) then
							the_subscriber_list.prune_all (subscriber)
							if the_subscriber_list.is_empty then
								subscribers.remove (subscriber.subscribed_properties.item)
							end
						end
					end
					subscriber.subscribed_properties.forth
				end
				subscriber.subscribed_properties.wipe_out
			end
		ensure
--			subscriber is no longer subscribed for any notifications
			subscribed_properties_is_empty: subscriber.subscribed_properties /= Void implies subscriber.subscribed_properties.is_empty
		end

	key (oid, property_number: INTEGER): STRING
			-- Create lookup key given oid and property number
		do
				Result := oid.out + "F" + property_number.out
		end

feature -- Subscription Status



feature {MT_PERSISTER} -- Notification

	notify_property_updated (the_object: MT_STORABLE; property_number: INTEGER)
			-- Notify listeners that the_property in the object was updated
		require
			valid_the_object: the_object /= Void
		local
			the_key: STRING
		do
			if all_notifications_subscriber /= Void then
				all_notifications_subscriber.notify_property_updated (the_object, property_number)
			end
			the_key := key (the_object.oid, property_number)
			if subscribers.has (the_key) then
				subscribers.item (the_key).do_all (agent notify_agent (?, the_object, property_number))
			end
		end

feature {NONE} -- Implementation

	subscribers: HASH_TABLE [LINKED_LIST [MT_SUBSCRIBER], STRING]
			-- Lookup table of subscribers, by key
		once
			create Result.make (1000)
		end

	all_notifications_subscriber: MT_SUBSCRIBER
			-- The subscriber which receives all notifications

	notify_agent (subscriber: MT_SUBSCRIBER; the_object: MT_STORABLE; property_number: INTEGER)
			-- Agent used to notify subscribers of a property change event
		require
			valid_subscriber: subscriber /= Void
			valid_the_object: the_object /= Void
		do
			subscriber.notify_property_updated (the_object, property_number)
		end

end -- class MT_SUBSCRIPTION_MANAGER

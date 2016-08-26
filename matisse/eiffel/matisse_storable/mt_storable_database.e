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
	MT_STORABLE_DATABASE

inherit
	MT_DATABASE
		undefine
			persister
		redefine
			make,
			upcast
		end


create
   make, make_storable_context

feature -- Initialization

	make (a_hostname, a_dbname: STRING)
		-- create a Matisse connection object to be used in a multi-threaded
		-- or not environment with a specific object factory
		require else
			arguments_exist: a_hostname /= Void and a_dbname /= Void
			arguments_not_empty: not (a_hostname.is_empty or a_dbname.is_empty)
		local
			vactx: MT_ASYNC_CONTEXT
			vfactory: MT_DYNAMIC_OBJECT_FACTORY
		do
			hostname := a_hostname.twin
			database_name := a_dbname.twin
			create vfactory.make ()
			factory := vfactory
			create vactx.make ()
			ctx := vactx
			-- cache & persistence mgmt
			create persister_storable.make (Current)
		end

	make_storable_context (a_hostname, a_dbname: STRING; a_ctx: MT_CONTEXT)
		-- create a Matisse connection object to be used in a multi-threaded
		-- or not environment with a specific object factory
		require
			arguments_exist: a_hostname /= Void and a_dbname /= Void
						     and a_ctx /= Void
			arguments_not_empty: not (a_hostname.is_empty or a_dbname.is_empty)
		local
			vfactory: MT_DYNAMIC_OBJECT_FACTORY
		do
			hostname := a_hostname.twin
			database_name := a_dbname.twin
			create vfactory.make ()
			factory := vfactory
			ctx := a_ctx
			-- cache & persistence mgmt
			create persister_storable.make (Current)
		end

feature -- upcast objects

	upcast (a_oid: INTEGER): MT_OBJECT
		do
			Result := persister.eif_object_from_oid (a_oid)
		end


feature -- Persister

	-- manage cache and persist objects
   persister_storable: MT_PERSISTER

	persister (): MT_PERSISTER
		do
			Result := persister_storable
		end

	persist (an_object: MT_STORABLE)
		do
			persister.persist(an_object)
		end


feature	-- Get a MtClass

	get_class, create_class (a_class_name: STRING): MT_CLASS
			-- create a class descriptor object from name
		require
			not_void: a_class_name /= Void
			not_empty: not a_class_name.is_empty
		do
			create Result.make_from_name_with_db (a_class_name, Current)
		end

feature	-- Get a MtAttribute

	get_attribute (a_att_name: STRING; a_mtcls: MT_CLASS): MT_ATTRIBUTE
			-- create an attribute descriptor object from a name and class
		require
			not_void: a_att_name /= Void and a_mtcls /= Void
			not_empty: not a_att_name.is_empty
		do
			create Result.make_from_names (a_att_name, a_mtcls.mt_name, Current)
		end

feature	-- Get a MtRelationship

	get_relationship (a_rel_name: STRING; a_mtcls: MT_CLASS): MT_RELATIONSHIP
			-- create a relationship descriptor object from a name and class
		require
			not_void: a_rel_name /= Void and a_mtcls /= Void
			not_empty: not a_rel_name.is_empty
		do
			create Result.make_from_names (a_rel_name, a_mtcls.mt_name, Current)
		end

feature	-- Get a MtIndex

	get_index, create_index (an_index_name: STRING): MT_INDEX
			-- create an index descriptor object from name
		require
			not_void: an_index_name /= Void
			not_empty: not an_index_name.is_empty
		do
			create Result.make_with_db (an_index_name, Current)
		end

feature -- Get a MtEntryPointDictionary

	get_entry_point_dictionary, create_entry_point_dictionary (ep_dict_name: STRING): MT_ENTRYPOINTDICTIONARY
			-- create an entry point dictionary descriptor object from name
		require
			not_void: ep_dict_name /= Void
			not_empty: not ep_dict_name.is_empty
		do
			create Result.make_with_db (ep_dict_name, Void, Current)
		end


feature -- Subscription
	set_subscription_manager (a_manager: MT_SUBSCRIPTION_MANAGER)
	  	do
	  		persister.set_subscription_manager (a_manager)
	  	end

	subscription_manager : MT_SUBSCRIPTION_MANAGER
    	do
    		Result := persister.subscription_manager
    	end

end -- class MT_STORABLE_DARABASE

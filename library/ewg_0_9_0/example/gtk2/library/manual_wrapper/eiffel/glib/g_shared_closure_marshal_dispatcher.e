indexing

	description:

		"Shared access to GCLOSURE_DISPATCHER Singleton"

	copyright: "Copyright (c) 2003, Andreas Leitner and others"
	library: "EWG GObject Library"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2003/10/25 19:26:08 $"
	revision: "$Revision: 1.3 $"

class G_SHARED_CLOSURE_MARSHAL_DISPATCHER
	
inherit

	GCLOSURE_MARSHAL_CALLBACK
		rename
			on_callback as on_marshal_callback
		end

	GCLOSURE_NOTIFY_CALLBACK
		rename
			on_callback as on_notify_callback
		end

	GCLOSURE_STRUCT_EXTERNAL
		export {NONE} all end

	EWG_IMPORTED_EXTERNAL_ROUTINES
		export {NONE} all end
	
feature {ANY}

	g_closure_dispatcher: GCLOSURE_MARSHAL_DISPATCHER is
			-- Access to GCLOSURE_MARSHAL_DISPATCHER Singleton.
		once
			create Result.make (Current)
		ensure
			g_closure_dispatcher_not_void: Result /= Void
		end
	
feature {GCLOSURE_MARSHAL_CALLBACK}

	on_marshal_callback (closure: POINTER;
				 return_value_p: POINTER;
				 n_param_values: INTEGER;
				 param_values: POINTER;
				 invocation_hint: POINTER;
				 marshal_data: POINTER) is
			-- Called from dispatcher whenever some closure is beeing called
			-- Delegates call to corresponding Eiffel G_CLOSURE object
			-- TODO: Handle `return_value', `invocation_hint' and `marshal_data'
		local
			closure_data: POINTER
			g_closure_wrapper: G_CLOSURE
			parameters: G_VALUE_ARRAY
			return_value: G_VALUE
		do
			closure_data := get_data_external (closure)
			g_closure_wrapper ?= external_garbage_collector.eif_access (closure_data)
				check
					g_closure_wrapper_not_void: g_closure_wrapper /= Void
				end
			if n_param_values > 0 then
				create parameters.make_shared (param_values, n_param_values)
			else
					check
						param_values_is_default_pointer: param_values = Default_pointer
					end
			end
			if return_value_p = Default_pointer then
				g_closure_wrapper.on_command (parameters)
			else
				create return_value.make_shared (return_value_p)
				g_closure_wrapper.on_query (return_value, parameters)
			end
		end

feature {GCLOSURE_NOTIFY_DISPATCHER}

	on_notify_callback (a_data: POINTER; a_closure_pointer: POINTER)is
		local
			closure: G_CLOSURE
		do
			-- A closure has been finalized
			-- Find the Eiffel Wrapper for it, wean its reference
			-- and make item = Default_pointer
				check
					data_not_default_pointer: a_data /= Default_pointer
				end
			closure ?= external_garbage_collector.eif_access (a_data)
				check
					closure_not_void: closure /= Void
					closure_exists: closure.exists
				end
			closure.set_inexistent
		end
	
feature {NONE}

	g_closure_notify_dispatcher: GCLOSURE_NOTIFY_DISPATCHER is
		once
			create Result.make (Current)
		ensure
			g_closure_notify_dispatcher_not_void: Result /= Void
		end

feature {NONE} -- Debug

	-- TODO: debug out parameter type names and return type name
	
end

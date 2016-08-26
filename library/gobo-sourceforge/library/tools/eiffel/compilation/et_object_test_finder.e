indexing

	description:

		"Eiffel object-test finders"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2008-04-19 12:52:26 +0200 (Sat, 19 Apr 2008) $"
	revision: "$Revision: 6363 $"

class ET_OBJECT_TEST_FINDER

inherit

	ET_AST_ITERATOR
		redefine
			process_object_test,
			process_do_function_inline_agent,
			process_do_procedure_inline_agent,
			process_external_function_inline_agent,
			process_external_procedure_inline_agent,
			process_once_function_inline_agent,
			process_once_procedure_inline_agent
		end

create

	make

feature -- Access

	object_tests: ET_OBJECT_TEST_SCOPE
			-- Object-tests found so far

feature -- Basic operations

	find_object_tests (a_ast_node: ET_AST_NODE; a_object_tests: ET_OBJECT_TEST_SCOPE) is
			-- Find all object-tests in `a_ast_node' and recursively its sub-nodes,
			-- and make them available in `a_object_tests'.
			-- Do not traverse inline agents.
		require
			a_ast_node_not_void: a_ast_node /= Void
			a_object_tests_not_void: a_object_tests /= Void
		local
			old_object_tests: ET_OBJECT_TEST_SCOPE
		do
			old_object_tests := object_tests
			object_tests := a_object_tests
			a_ast_node.process (Current)
			object_tests := old_object_tests
		end

feature {ET_AST_NODE} -- Processing

	process_object_test (an_expression: ET_OBJECT_TEST) is
			-- Process `an_expression'.
		do
			if object_tests /= Void then
				object_tests.add_object_test (an_expression)
			end
			an_expression.expression.process (Current)
		end

	process_do_function_inline_agent (an_expression: ET_DO_FUNCTION_INLINE_AGENT) is
			-- Process `an_expression'.
		local
			l_actual_arguments: ET_AGENT_ARGUMENT_OPERAND_LIST
		do
			l_actual_arguments ?= an_expression.actual_arguments
			if l_actual_arguments /= Void then
				l_actual_arguments.process (Current)
			end
		end

	process_do_procedure_inline_agent (an_expression: ET_DO_PROCEDURE_INLINE_AGENT) is
			-- Process `an_expression'.
		local
			l_actual_arguments: ET_AGENT_ARGUMENT_OPERAND_LIST
		do
			l_actual_arguments ?= an_expression.actual_arguments
			if l_actual_arguments /= Void then
				l_actual_arguments.process (Current)
			end
		end

	process_external_function_inline_agent (an_expression: ET_EXTERNAL_FUNCTION_INLINE_AGENT) is
			-- Process `an_expression'.
		local
			l_actual_arguments: ET_AGENT_ARGUMENT_OPERAND_LIST
		do
			l_actual_arguments ?= an_expression.actual_arguments
			if l_actual_arguments /= Void then
				l_actual_arguments.process (Current)
			end
		end

	process_external_procedure_inline_agent (an_expression: ET_EXTERNAL_PROCEDURE_INLINE_AGENT) is
			-- Process `an_expression'.
		local
			l_actual_arguments: ET_AGENT_ARGUMENT_OPERAND_LIST
		do
			l_actual_arguments ?= an_expression.actual_arguments
			if l_actual_arguments /= Void then
				l_actual_arguments.process (Current)
			end
		end

	process_once_function_inline_agent (an_expression: ET_ONCE_FUNCTION_INLINE_AGENT) is
			-- Process `an_expression'.
		local
			l_actual_arguments: ET_AGENT_ARGUMENT_OPERAND_LIST
		do
			l_actual_arguments ?= an_expression.actual_arguments
			if l_actual_arguments /= Void then
				l_actual_arguments.process (Current)
			end
		end

	process_once_procedure_inline_agent (an_expression: ET_ONCE_PROCEDURE_INLINE_AGENT) is
			-- Process `an_expression'.
		local
			l_actual_arguments: ET_AGENT_ARGUMENT_OPERAND_LIST
		do
			l_actual_arguments ?= an_expression.actual_arguments
			if l_actual_arguments /= Void then
				l_actual_arguments.process (Current)
			end
		end

end

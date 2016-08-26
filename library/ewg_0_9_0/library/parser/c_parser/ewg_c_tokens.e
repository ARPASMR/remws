indexing

	description: "Parser token codes"
	generator: "geyacc version 3.4"

class EWG_C_TOKENS

inherit

	YY_PARSER_TOKENS

feature -- Last values

	last_any_value: ANY
	last_string_value: STRING

feature -- Access

	token_name (a_token: INTEGER): STRING is
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when TOK_IDENTIFIER then
				Result := "TOK_IDENTIFIER"
			when TOK_CONSTANT then
				Result := "TOK_CONSTANT"
			when TOK_STRING_LITERAL then
				Result := "TOK_STRING_LITERAL"
			when TOK_SIZEOF then
				Result := "TOK_SIZEOF"
			when TOK_PTR_OP then
				Result := "TOK_PTR_OP"
			when TOK_INC_OP then
				Result := "TOK_INC_OP"
			when TOK_DEC_OP then
				Result := "TOK_DEC_OP"
			when TOK_LEFT_OP then
				Result := "TOK_LEFT_OP"
			when TOK_RIGHT_OP then
				Result := "TOK_RIGHT_OP"
			when TOK_LE_OP then
				Result := "TOK_LE_OP"
			when TOK_GE_OP then
				Result := "TOK_GE_OP"
			when TOK_EQ_OP then
				Result := "TOK_EQ_OP"
			when TOK_NE_OP then
				Result := "TOK_NE_OP"
			when TOK_AND_OP then
				Result := "TOK_AND_OP"
			when TOK_OR_OP then
				Result := "TOK_OR_OP"
			when TOK_MUL_ASSIGN then
				Result := "TOK_MUL_ASSIGN"
			when TOK_DIV_ASSIGN then
				Result := "TOK_DIV_ASSIGN"
			when TOK_MOD_ASSIGN then
				Result := "TOK_MOD_ASSIGN"
			when TOK_ADD_ASSIGN then
				Result := "TOK_ADD_ASSIGN"
			when TOK_SUB_ASSIGN then
				Result := "TOK_SUB_ASSIGN"
			when TOK_LEFT_ASSIGN then
				Result := "TOK_LEFT_ASSIGN"
			when TOK_RIGHT_ASSIGN then
				Result := "TOK_RIGHT_ASSIGN"
			when TOK_AND_ASSIGN then
				Result := "TOK_AND_ASSIGN"
			when TOK_XOR_ASSIGN then
				Result := "TOK_XOR_ASSIGN"
			when TOK_OR_ASSIGN then
				Result := "TOK_OR_ASSIGN"
			when TOK_TYPE_NAME then
				Result := "TOK_TYPE_NAME"
			when TOK_TYPEDEF then
				Result := "TOK_TYPEDEF"
			when TOK_EXTERN then
				Result := "TOK_EXTERN"
			when TOK_STATIC then
				Result := "TOK_STATIC"
			when TOK_AUTO then
				Result := "TOK_AUTO"
			when TOK_REGISTER then
				Result := "TOK_REGISTER"
			when TOK_CHAR then
				Result := "TOK_CHAR"
			when TOK_SHORT then
				Result := "TOK_SHORT"
			when TOK_INT then
				Result := "TOK_INT"
			when TOK_LONG then
				Result := "TOK_LONG"
			when TOK_SIGNED then
				Result := "TOK_SIGNED"
			when TOK_UNSIGNED then
				Result := "TOK_UNSIGNED"
			when TOK_FLOAT then
				Result := "TOK_FLOAT"
			when TOK_DOUBLE then
				Result := "TOK_DOUBLE"
			when TOK_CONST then
				Result := "TOK_CONST"
			when TOK_VOLATILE then
				Result := "TOK_VOLATILE"
			when TOK_VOID then
				Result := "TOK_VOID"
			when TOK_STRUCT then
				Result := "TOK_STRUCT"
			when TOK_UNION then
				Result := "TOK_UNION"
			when TOK_ENUM then
				Result := "TOK_ENUM"
			when TOK_ELLIPSIS then
				Result := "TOK_ELLIPSIS"
			when TOK_CASE then
				Result := "TOK_CASE"
			when TOK_DEFAULT then
				Result := "TOK_DEFAULT"
			when TOK_IF then
				Result := "TOK_IF"
			when TOK_ELSE then
				Result := "TOK_ELSE"
			when TOK_SWITCH then
				Result := "TOK_SWITCH"
			when TOK_WHILE then
				Result := "TOK_WHILE"
			when TOK_DO then
				Result := "TOK_DO"
			when TOK_FOR then
				Result := "TOK_FOR"
			when TOK_GOTO then
				Result := "TOK_GOTO"
			when TOK_CONTINUE then
				Result := "TOK_CONTINUE"
			when TOK_BREAK then
				Result := "TOK_BREAK"
			when TOK_RETURN then
				Result := "TOK_RETURN"
			when TOK_INLINE then
				Result := "TOK_INLINE"
			when TOK_CL_INT_8 then
				Result := "TOK_CL_INT_8"
			when TOK_CL_INT_16 then
				Result := "TOK_CL_INT_16"
			when TOK_CL_INT_32 then
				Result := "TOK_CL_INT_32"
			when TOK_CL_INT_64 then
				Result := "TOK_CL_INT_64"
			when TOK_CL_FASTCALL then
				Result := "TOK_CL_FASTCALL"
			when TOK_CL_BASED then
				Result := "TOK_CL_BASED"
			when TOK_CL_CDECL then
				Result := "TOK_CL_CDECL"
			when TOK_CL_STDCALL then
				Result := "TOK_CL_STDCALL"
			when TOK_CL_INLINE then
				Result := "TOK_CL_INLINE"
			when TOK_CL_ASM then
				Result := "TOK_CL_ASM"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	TOK_IDENTIFIER: INTEGER is 258
	TOK_CONSTANT: INTEGER is 259
	TOK_STRING_LITERAL: INTEGER is 260
	TOK_SIZEOF: INTEGER is 261
	TOK_PTR_OP: INTEGER is 262
	TOK_INC_OP: INTEGER is 263
	TOK_DEC_OP: INTEGER is 264
	TOK_LEFT_OP: INTEGER is 265
	TOK_RIGHT_OP: INTEGER is 266
	TOK_LE_OP: INTEGER is 267
	TOK_GE_OP: INTEGER is 268
	TOK_EQ_OP: INTEGER is 269
	TOK_NE_OP: INTEGER is 270
	TOK_AND_OP: INTEGER is 271
	TOK_OR_OP: INTEGER is 272
	TOK_MUL_ASSIGN: INTEGER is 273
	TOK_DIV_ASSIGN: INTEGER is 274
	TOK_MOD_ASSIGN: INTEGER is 275
	TOK_ADD_ASSIGN: INTEGER is 276
	TOK_SUB_ASSIGN: INTEGER is 277
	TOK_LEFT_ASSIGN: INTEGER is 278
	TOK_RIGHT_ASSIGN: INTEGER is 279
	TOK_AND_ASSIGN: INTEGER is 280
	TOK_XOR_ASSIGN: INTEGER is 281
	TOK_OR_ASSIGN: INTEGER is 282
	TOK_TYPE_NAME: INTEGER is 283
	TOK_TYPEDEF: INTEGER is 284
	TOK_EXTERN: INTEGER is 285
	TOK_STATIC: INTEGER is 286
	TOK_AUTO: INTEGER is 287
	TOK_REGISTER: INTEGER is 288
	TOK_CHAR: INTEGER is 289
	TOK_SHORT: INTEGER is 290
	TOK_INT: INTEGER is 291
	TOK_LONG: INTEGER is 292
	TOK_SIGNED: INTEGER is 293
	TOK_UNSIGNED: INTEGER is 294
	TOK_FLOAT: INTEGER is 295
	TOK_DOUBLE: INTEGER is 296
	TOK_CONST: INTEGER is 297
	TOK_VOLATILE: INTEGER is 298
	TOK_VOID: INTEGER is 299
	TOK_STRUCT: INTEGER is 300
	TOK_UNION: INTEGER is 301
	TOK_ENUM: INTEGER is 302
	TOK_ELLIPSIS: INTEGER is 303
	TOK_CASE: INTEGER is 304
	TOK_DEFAULT: INTEGER is 305
	TOK_IF: INTEGER is 306
	TOK_ELSE: INTEGER is 307
	TOK_SWITCH: INTEGER is 308
	TOK_WHILE: INTEGER is 309
	TOK_DO: INTEGER is 310
	TOK_FOR: INTEGER is 311
	TOK_GOTO: INTEGER is 312
	TOK_CONTINUE: INTEGER is 313
	TOK_BREAK: INTEGER is 314
	TOK_RETURN: INTEGER is 315
	TOK_INLINE: INTEGER is 316
	TOK_CL_INT_8: INTEGER is 317
	TOK_CL_INT_16: INTEGER is 318
	TOK_CL_INT_32: INTEGER is 319
	TOK_CL_INT_64: INTEGER is 320
	TOK_CL_FASTCALL: INTEGER is 321
	TOK_CL_BASED: INTEGER is 322
	TOK_CL_CDECL: INTEGER is 323
	TOK_CL_STDCALL: INTEGER is 324
	TOK_CL_INLINE: INTEGER is 325
	TOK_CL_ASM: INTEGER is 326

end

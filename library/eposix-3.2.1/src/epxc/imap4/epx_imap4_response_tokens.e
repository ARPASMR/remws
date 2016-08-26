note

	description: "Parser token codes"
	generator: "geyacc version 3.9"

deferred class EPX_IMAP4_RESPONSE_TOKENS

inherit

	YY_PARSER_TOKENS

feature -- Last values

	last_detachable_any_value: detachable ANY
	last_string_value: STRING
	last_integer_ref_value: INTEGER_REF

feature -- Access

	token_name (a_token: INTEGER): STRING
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when IMAP4_TAG then
				Result := "IMAP4_TAG"
			when IMAP4_TEXT then
				Result := "IMAP4_TEXT"
			when IMAP4_TEXT_MIME2 then
				Result := "IMAP4_TEXT_MIME2"
			when IMAP4_TEXT_WITHOUT_RIGHT_BRACKET then
				Result := "IMAP4_TEXT_WITHOUT_RIGHT_BRACKET"
			when IMAP4_NIL then
				Result := "IMAP4_NIL"
			when INT_NUMBER then
				Result := "INT_NUMBER"
			when QUOTED_STRING then
				Result := "QUOTED_STRING"
			when IMAP4_ATOM then
				Result := "IMAP4_ATOM"
			when FLAG_ANSWERED then
				Result := "FLAG_ANSWERED"
			when FLAG_FLAGGED then
				Result := "FLAG_FLAGGED"
			when FLAG_DELETED then
				Result := "FLAG_DELETED"
			when FLAG_RECENT then
				Result := "FLAG_RECENT"
			when FLAG_SEEN then
				Result := "FLAG_SEEN"
			when FLAG_DRAFT then
				Result := "FLAG_DRAFT"
			when FLAG_NOSELECT then
				Result := "FLAG_NOSELECT"
			when FLAG_UNMARKED then
				Result := "FLAG_UNMARKED"
			when FLAG_ATOM then
				Result := "FLAG_ATOM"
			when FLAG_STAR then
				Result := "FLAG_STAR"
			when IMAP4_FLAGS then
				Result := "IMAP4_FLAGS"
			when IMAP4_LIST then
				Result := "IMAP4_LIST"
			when IMAP4_LSUB then
				Result := "IMAP4_LSUB"
			when IMAP4_EXISTS then
				Result := "IMAP4_EXISTS"
			when IMAP4_RECENT then
				Result := "IMAP4_RECENT"
			when IMAP4_INBOX then
				Result := "IMAP4_INBOX"
			when MEDIA_TYPE_APPLICATION then
				Result := "MEDIA_TYPE_APPLICATION"
			when MEDIA_TYPE_AUDIO then
				Result := "MEDIA_TYPE_AUDIO"
			when MEDIA_TYPE_IMAGE then
				Result := "MEDIA_TYPE_IMAGE"
			when MEDIA_TYPE_MESSAGE then
				Result := "MEDIA_TYPE_MESSAGE"
			when MEDIA_TYPE_RFC822 then
				Result := "MEDIA_TYPE_RFC822"
			when MEDIA_TYPE_TEXT then
				Result := "MEDIA_TYPE_TEXT"
			when MEDIA_TYPE_VIDEO then
				Result := "MEDIA_TYPE_VIDEO"
			when IMAP4_EXPUNGE then
				Result := "IMAP4_EXPUNGE"
			when IMAP4_FETCH then
				Result := "IMAP4_FETCH"
			when IMAP4_BODY then
				Result := "IMAP4_BODY"
			when IMAP4_BODYSTRUCTURE then
				Result := "IMAP4_BODYSTRUCTURE"
			when IMAP4_ENVELOPE then
				Result := "IMAP4_ENVELOPE"
			when IMAP4_INTERNALDATE then
				Result := "IMAP4_INTERNALDATE"
			when IMAP4_RFC822 then
				Result := "IMAP4_RFC822"
			when IMAP4_RFC822_HEADER then
				Result := "IMAP4_RFC822_HEADER"
			when IMAP4_RFC822_SIZE then
				Result := "IMAP4_RFC822_SIZE"
			when IMAP4_RFC822_TEXT then
				Result := "IMAP4_RFC822_TEXT"
			when IMAP4_UID then
				Result := "IMAP4_UID"
			when IMAP4_BAD then
				Result := "IMAP4_BAD"
			when IMAP4_BYE then
				Result := "IMAP4_BYE"
			when IMAP4_OK then
				Result := "IMAP4_OK"
			when IMAP4_NO then
				Result := "IMAP4_NO"
			when IMAP4_ALERT then
				Result := "IMAP4_ALERT"
			when IMAP4_PARSE then
				Result := "IMAP4_PARSE"
			when IMAP4_PERMANENTFLAGS then
				Result := "IMAP4_PERMANENTFLAGS"
			when IMAP4_READ_ONLY then
				Result := "IMAP4_READ_ONLY"
			when IMAP4_READ_WRITE then
				Result := "IMAP4_READ_WRITE"
			when IMAP4_TRYCREATE then
				Result := "IMAP4_TRYCREATE"
			when IMAP4_UIDNEXT then
				Result := "IMAP4_UIDNEXT"
			when IMAP4_UIDVALIDITY then
				Result := "IMAP4_UIDVALIDITY"
			when IMAP4_UNSEEN then
				Result := "IMAP4_UNSEEN"
			when IMAP4_ATOM_WITHOUT_RIGHT_BRACKET then
				Result := "IMAP4_ATOM_WITHOUT_RIGHT_BRACKET"
			when IMAP4_MIME then
				Result := "IMAP4_MIME"
			when IMAP4_HEADER then
				Result := "IMAP4_HEADER"
			when IMAP4_HEADER_FIELDS then
				Result := "IMAP4_HEADER_FIELDS"
			when IMAP4_NOT then
				Result := "IMAP4_NOT"
			when CRLF then
				Result := "CRLF"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	IMAP4_TAG: INTEGER = 258
	IMAP4_TEXT: INTEGER = 259
	IMAP4_TEXT_MIME2: INTEGER = 260
	IMAP4_TEXT_WITHOUT_RIGHT_BRACKET: INTEGER = 261
	IMAP4_NIL: INTEGER = 262
	INT_NUMBER: INTEGER = 263
	QUOTED_STRING: INTEGER = 264
	IMAP4_ATOM: INTEGER = 265
	FLAG_ANSWERED: INTEGER = 266
	FLAG_FLAGGED: INTEGER = 267
	FLAG_DELETED: INTEGER = 268
	FLAG_RECENT: INTEGER = 269
	FLAG_SEEN: INTEGER = 270
	FLAG_DRAFT: INTEGER = 271
	FLAG_NOSELECT: INTEGER = 272
	FLAG_UNMARKED: INTEGER = 273
	FLAG_ATOM: INTEGER = 274
	FLAG_STAR: INTEGER = 275
	IMAP4_FLAGS: INTEGER = 276
	IMAP4_LIST: INTEGER = 277
	IMAP4_LSUB: INTEGER = 278
	IMAP4_EXISTS: INTEGER = 279
	IMAP4_RECENT: INTEGER = 280
	IMAP4_INBOX: INTEGER = 281
	MEDIA_TYPE_APPLICATION: INTEGER = 282
	MEDIA_TYPE_AUDIO: INTEGER = 283
	MEDIA_TYPE_IMAGE: INTEGER = 284
	MEDIA_TYPE_MESSAGE: INTEGER = 285
	MEDIA_TYPE_RFC822: INTEGER = 286
	MEDIA_TYPE_TEXT: INTEGER = 287
	MEDIA_TYPE_VIDEO: INTEGER = 288
	IMAP4_EXPUNGE: INTEGER = 289
	IMAP4_FETCH: INTEGER = 290
	IMAP4_BODY: INTEGER = 291
	IMAP4_BODYSTRUCTURE: INTEGER = 292
	IMAP4_ENVELOPE: INTEGER = 293
	IMAP4_INTERNALDATE: INTEGER = 294
	IMAP4_RFC822: INTEGER = 295
	IMAP4_RFC822_HEADER: INTEGER = 296
	IMAP4_RFC822_SIZE: INTEGER = 297
	IMAP4_RFC822_TEXT: INTEGER = 298
	IMAP4_UID: INTEGER = 299
	IMAP4_BAD: INTEGER = 300
	IMAP4_BYE: INTEGER = 301
	IMAP4_OK: INTEGER = 302
	IMAP4_NO: INTEGER = 303
	IMAP4_ALERT: INTEGER = 304
	IMAP4_PARSE: INTEGER = 305
	IMAP4_PERMANENTFLAGS: INTEGER = 306
	IMAP4_READ_ONLY: INTEGER = 307
	IMAP4_READ_WRITE: INTEGER = 308
	IMAP4_TRYCREATE: INTEGER = 309
	IMAP4_UIDNEXT: INTEGER = 310
	IMAP4_UIDVALIDITY: INTEGER = 311
	IMAP4_UNSEEN: INTEGER = 312
	IMAP4_ATOM_WITHOUT_RIGHT_BRACKET: INTEGER = 313
	IMAP4_MIME: INTEGER = 314
	IMAP4_HEADER: INTEGER = 315
	IMAP4_HEADER_FIELDS: INTEGER = 316
	IMAP4_NOT: INTEGER = 317
	CRLF: INTEGER = 318

end

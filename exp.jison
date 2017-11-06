/* description: Parses and executes mathematical expressions. */
// Field 4 [maros Entity] = the last 35 4-Time Unit 1(s), including the 4-Time Unit 1 that includes the day the user logs in 
/* lexical grammar */
%lex
%%

'EQUALS' 						return 'OPERATOR'
'NOT_EQUALS' 					return 'OPERATOR'
'GREATER_THAN' 					return 'OPERATOR'
'GREATER_THAN_OR_EQUALS' 		return 'OPERATOR'
'LESS_THAN' 					return 'OPERATOR'
'LESS_THAN_OR_EQUALS' 			return 'OPERATOR'
'LIKE' 							return 'OPERATOR'
'NOT_LIKE' 						return 'OPERATOR'
'BETWEEN' 						return 'OPERATOR'
'NOT_BETWEEN' 					return 'OPERATOR'
'IN_LIST' 						return 'OPERATOR'
'NOT_IN_LIST' 					return 'OPERATOR'

'THE_LAST'						return 'KEYWORD'
'OP2'							return 'KEYWORD'

\s*\n\s*						/*ignore*/
\s+								return 'SPACE'
[0-9]+	 						return 'NUMBER'
[a-zA-Z0-9_-]+					return 'STRING'

'('								return '('
')'								return ')'
'['								return '['
']'								return ']'
'"'								return '"'
','								return 'COMMA'
<<EOF>>							return 'EOF'

/lex

/* operator associations and precedence */

%right 'SPACE' 'OPERATOR' 'COMMA' 'KEYWORD'
%start program

%% /* language grammar */

program
	: e EOF
		{console.log(JSON.stringify($1, null, 4)); return $1; }
	;

e
	: KEYWORD SPACE NUMBER SPACE STRING
		{ $$ = {node: 'KEYWORD MM', left: $1, center: $3, right: $5}; }
	| KEYWORD
		{ $$ = {node: 'KEYWORD', value: yytext}; }
	| e COMMA SPACE e
		{ $$ = {node: 'COMMA', right: $4}}
	| e SPACE OPERATOR SPACE e
		{ $$ = {node: 'OPERATOR', type: $3, left: $1, right: $5}}
	| STRING
		{ $$ = {node: 'STRING', value: yytext}; }
	| NUMBER
		{ $$ = {node: 'NUMBER', value: yytext}; }
	| STRING '[' STRING ']'
		{ $$ = {node: 'FIELD_ENTITY', field: $1, entity: $3}; }
	| e SPACE e
		{ $$ = {node: 'EXPRESSIONS', left: $1, right: $3}; }
	| '(' e ')'
		{ $$ = {node: 'PARENTHESIS', content: $2}; }
	| '[' e ']'
		{ $$ = {node: 'SQUARE_BRACKETS', content: $2}; }
	| '"' e '"'
		{ $$ = {node: 'QUOTE', content: $2}; }
	;
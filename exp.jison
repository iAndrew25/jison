/* description: Parses and executes mathematical expressions. */
// Field 4 [maros Entity] = the last 35 4-Time Unit 1(s), including the 4-Time Unit 1 that includes the day the user logs in 
/* lexical grammar */
%lex
%%

'+' 							return 'MATHEMATICAL_OPERATOR'
'-' 							return 'MATHEMATICAL_OPERATOR'
'*' 							return 'MATHEMATICAL_OPERATOR'
'/' 							return 'MATHEMATICAL_OPERATOR'
'^' 							return 'MATHEMATICAL_OPERATOR'

'=' 							return 'COMPARISION_OPERATOR'
'<>' 							return 'COMPARISION_OPERATOR'
'>' 							return 'COMPARISION_OPERATOR'
'>=' 							return 'COMPARISION_OPERATOR'
'<' 							return 'COMPARISION_OPERATOR'
'<=' 							return 'COMPARISION_OPERATOR'
'LIKE' 							return 'COMPARISION_OPERATOR'
'NOT LIKE' 						return 'COMPARISION_OPERATOR'
'IN' 							return 'COMPARISION_OPERATOR'
'NOT IN' 						return 'COMPARISION_OPERATOR'
'BETWEEN' 						return 'COMPARISION_OPERATOR'
'NOT BETWEEN' 					return 'COMPARISION_OPERATOR'

'AND'							return 'LOGICAL_OPERATOR'
'OR'							return 'LOGICAL_OPERATOR'
'NOT'							return 'LOGICAL_OPERATOR'

'.'								return 'DOT'														






'THE_LAST'						return 'KEYWORD'
'OP2'							return 'KEYWORD'

\s*\n\s*						/*ignore*/
\s+								return 'SPACE'
[0-9]+	 						return 'NUMBER'
[a-zA-Z0-9_-]+				return 'STRING'

'('								return '('
')'								return ')'
'['								return '['
']'								return ']'
'"'								return '"'
','								return 'COMMA'
<<EOF>>							return 'EOF'

/lex

/* operator associations and precedence */

%right 'OPERATOR' 'SPACE' 'COMMA' 'KEYWORD'
%start program

%% /* language grammar */

program
	: e EOF
		{console.log(JSON.stringify($1, null, 4)); return $1; }
	;

e
	: NUMBER
		{ $$ = {node: 'NUMBER', value: yytext}; }
	| STRING
		{ $$ = {node: 'STRING', value: yytext}; }
	| KEYWORD SPACE NUMBER SPACE STRING
		{ $$ = {node: 'RANGE_PERIODS', left: $1, center: $3, right: $5}; }
	| KEYWORD
		{ $$ = {node: 'KEYWORD', value: yytext}; }
	| e SPACE LOGIC SPACE e
		{ $$ = {node: 'LOGIC', type: $3, left: $1, right: $5}}
	| e COMMA SPACE e
		{ $$ = {node: 'COMMA', left: $1, right: $4}}
	| e SPACE OPERATOR SPACE e
		{ $$ = {node: 'OPERATOR', type: $3, left: $1, right: $5}}
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
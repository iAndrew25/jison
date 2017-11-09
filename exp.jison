/* description: Parses and executes mathematical expressions. */
// Field 4 [maros Entity] = the last 35 4-Time Unit 1(s), including the 4-Time Unit 1 that includes the day the user logs in 
/* lexical grammar */
%lex
%%

//[a-zA-Z0-9_-\s]+				return 'FIELD_TEXT'

'+' 								return 'MATHEMATICAL_OPERATOR'
'-' 								return 'MATHEMATICAL_OPERATOR'
'*' 								return 'MATHEMATICAL_OPERATOR'
'/' 								return 'MATHEMATICAL_OPERATOR'
'^' 								return 'MATHEMATICAL_OPERATOR'

'=' 								return 'COMPARISION_OPERATOR'
'<>' 								return 'COMPARISION_OPERATOR'
'>' 								return 'COMPARISION_OPERATOR'
'>=' 								return 'COMPARISION_OPERATOR'
'<' 								return 'COMPARISION_OPERATOR'
'<=' 								return 'COMPARISION_OPERATOR'
'LIKE' 								return 'COMPARISION_OPERATOR'
'NOT LIKE' 							return 'COMPARISION_OPERATOR'
'IN' 								return 'COMPARISION_OPERATOR'
'NOT IN' 							return 'COMPARISION_OPERATOR'
'BETWEEN' 							return 'COMPARISION_OPERATOR'
'NOT BETWEEN' 						return 'COMPARISION_OPERATOR'

'AND'								return 'LOGICAL_OPERATOR'
'OR'								return 'LOGICAL_OPERATOR'
'NOT'								return 'LOGICAL_OPERATOR'

'AddDays' 							return 'DATE_FUNCTION'
'AddMonths' 						return 'DATE_FUNCTION'
'AddYears' 							return 'DATE_FUNCTION'
'Date' 								return 'DATE_FUNCTION'
'Datetime' 							return 'DATE_FUNCTION'
'Day' 								return 'DATE_FUNCTION'
'ElapsedDays' 						return 'DATE_FUNCTION'
'ElapsedMonths' 					return 'DATE_FUNCTION'
'ElapsedYears' 						return 'DATE_FUNCTION'
'FirstDayInPeriod' 					return 'DATE_FUNCTION'
'Hour' 								return 'DATE_FUNCTION'
'LastDayInPeriod' 					return 'DATE_FUNCTION'
'Max' 								return 'DATE_FUNCTION'
'Min' 								return 'DATE_FUNCTION'
'Minute' 							return 'DATE_FUNCTION'
'Month' 							return 'DATE_FUNCTION'
'Now' 								return 'DATE_FUNCTION'
'PeriodForDate' 					return 'DATE_FUNCTION'
'PeriodNumberForDate' 				return 'DATE_FUNCTION'
'PeriodYearForDate' 				return 'DATE_FUNCTION'
'Second' 							return 'DATE_FUNCTION'
'SubtractDays' 						return 'DATE_FUNCTION'
'SubtractMonths' 					return 'DATE_FUNCTION'
'SubtractYears' 					return 'DATE_FUNCTION'
'Today' 							return 'DATE_FUNCTION'
'Weekday' 							return 'DATE_FUNCTION'
'Year' 								return 'DATE_FUNCTION'
	
'If' 								return 'LOGIC_FUNCTION'
'IsAlpha' 							return 'LOGIC_FUNCTION'
'IsAlphanumeric' 					return 'LOGIC_FUNCTION'
'IsEmpty' 							return 'LOGIC_FUNCTION'
	
'Abs' 								return 'MATH_FUNCTION'
'Average' 							return 'MATH_FUNCTION'
'Ceiling' 							return 'MATH_FUNCTION'
'Floor' 							return 'MATH_FUNCTION'
'Max' 								return 'MATH_FUNCTION'
'Min' 								return 'MATH_FUNCTION'
'Mod' 								return 'MATH_FUNCTION'
'Round' 							return 'MATH_FUNCTION'
'RoundDown' 						return 'MATH_FUNCTION'
'RoundUp' 							return 'MATH_FUNCTION'
'Sqrt' 								return 'MATH_FUNCTION'

'AddPeriods' 						return 'PERIOD_FUNCTION'
'CorrespondingPeriod' 				return 'PERIOD_FUNCTION'
'FirstPeriodInCorrespondingPeriod' 	return 'PERIOD_FUNCTION'
'LastPeriodInCorrespondingPeriod' 	return 'PERIOD_FUNCTION'
'Max' 								return 'PERIOD_FUNCTION'
'Min' 								return 'PERIOD_FUNCTION'
'Period' 							return 'PERIOD_FUNCTION'
'PeriodNumberForPeriod' 			return 'PERIOD_FUNCTION'
'PeriodYearForPeriod' 				return 'PERIOD_FUNCTION'
'SubtractPeriods' 					return 'PERIOD_FUNCTION'
'String' 							return 'PERIOD_FUNCTION'
'Concatenate' 						return 'PERIOD_FUNCTION'
'Find' 								return 'PERIOD_FUNCTION'
'Left' 								return 'PERIOD_FUNCTION'
'Length' 							return 'PERIOD_FUNCTION'
'Lower' 							return 'PERIOD_FUNCTION'
'Max' 								return 'PERIOD_FUNCTION'
'Mid' 								return 'PERIOD_FUNCTION'
'Min' 								return 'PERIOD_FUNCTION'
'Right' 							return 'PERIOD_FUNCTION'

'Trim' 								return 'STRING_FUNCTION'
'Upper' 							return 'STRING_FUNCTION'
'Value' 							return 'STRING_FUNCTION'


'THE_LAST'							return 'KEYWORD'
'OP2'								return 'KEYWORD'

'Userentity'						return 'USERENTITY'


\s*\n\s*							/*ignore*/
\s+									//return 'SPACE'
//[0-9]+								return 'NUMBER'
//[_-]+								return 'SYMBOL'
//\[([a-zA-Z0-9-.\s]+)\]				return 'FIELD_TEXT'
[a-zA-Z0-9_-\s]+					return 'STRING'

'('									return '('
')'									return ')'
'['									return '['
']'									return ']'
'"'									return '"'
','									return 'COMMA'
'.'									return 'DOT'														
<<EOF>>								return 'EOF'

/lex

/* operator associations and precedence */
%right 'COMPARISION_OPERATOR' '[' ']' 'COMMA' 'KEYWORD'
%start program

%% /* language grammar */

program
	: e EOF
		{console.log(JSON.stringify($1, null, 4)); return $1; }
	;

e
	: NUMBER
		{ $$ = {node: 'NUMBER', value: parseInt(yytext)}; }
	| STRING
		{ $$ = {node: 'STRING', content: $1}; }
	| FIELD
		{ $$ = {node: 'FIELD', content: $1}; }
/*	| FIELD_TEXT 
		{ $$ = {node: 'FIELD_TEXT', content: $1}; }*/
	| FUNCTION
	//	{ $$ = {node: 'FUNCTION', content: $1}; }
	| KEYWORD
		{ $$ = {node: 'KEYWORD', value: yytext}; }
	| e COMPARISION_OPERATOR e
		{ $$ = {node: 'COMPARISION_OPERATOR', type: $2, left: $1, right: $3}}
/*	| e e
		{ $$ = {node: 'EXPRESSIONS', left: $1, right: $2}; }*/
	| '(' e ')'
		{ $$ = {node: 'PARENTHESIS', content: $2}; }
	| '"' e '"'
		{ $$ = {node: 'QUOTE', content: $2}; }
	;

IDENTIFIER
	: STRING
	| COMPARISION_OPERATOR
	| LOGICAL_OPERATOR
	| DATE_FUNCTION
	| LOGIC_FUNCTION
	| MATH_FUNCTION
	| PERIOD_FUNCTION
	| STRING_FUNCTION
	;

FUNCTION_NAME
	: DATE_FUNCTION
		{$$ = 'DATE_FUNCTION'}
	| LOGIC_FUNCTION
		{$$ = 'LOGIC_FUNCTION'}
	| MATH_FUNCTION
		{$$ = 'MATH_FUNCTION'}
	| PERIOD_FUNCTION
		{$$ = 'PERIOD_FUNCTION'}
	| STRING_FUNCTION
		{$$ = 'STRING_FUNCTION'}
	;

ARGS
	: FIELD
		{$$ = {current: $FIELD}}
	| ARGS COMMA FIELD
		{$$ = {previous: $ARGS, current: $FIELD}}
	;

FUNCTION
	: FUNCTION_NAME '(' ARGS ')'
		{$$ = {node: $1, args: $ARGS}}
	;

/*
ALPHANUM_STRING 
	: NUMBER STRING
		{$$ = {node: 'ALPHANUM_STRING', field: yytext};}
	| NUMBER SYMBOL STRING
		{$$ = {node: 'ALPHANUM_STRING', field: yytext};}
	| STRING
		{$$ = {node: 'ALPHANUM_STRING', field: yytext};}
	;*/

FIELD 
	: '[' IDENTIFIER ']'
		{ $$ = {node: 'FIELD_NO_ENTITY', field: $2}; }
	| '[' IDENTIFIER DOT IDENTIFIER ']'
		{ $$ = {node: 'FIELD_AND_ENTITY', field: $4, entity: $2}; }
	| '[' USERENTITY DOT IDENTIFIER ']'
		{ $$ = {node: 'FIELD_AND_USERENTITY', field: $4, userentity: $2}; }
	;
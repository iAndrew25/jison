/* description: Parses and executes mathematical expressions. */
/* lexical grammar */
%lex
%%

/*'+' 								return 'MATHEMATICAL_OPERATOR'
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
'NOT'								return 'LOGICAL_OPERATOR'*/

/*'AddDays' 							return 'DATE_FUNCTION'
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
'Value' 							return 'STRING_FUNCTION'*/

'Userentity'						return 'KEYWORD'

\s*\n\s*							/*ignore*/
\s+									//return 'SPACE'
//[_-]+								return 'SYMBOL'
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
%right '[' ']' 'COMMA'
%right 'MATHEMATICAL_OPERATOR'
%right 'COMPARISION_OPERATOR'
%start program

%% /* language grammar */

program
	: expression EOF
		{console.log(JSON.stringify($1, null, 4)); return $1; }
	;

expression
	: MATH_EXPRESSION
	| SEQUENCE
	;

MATH_EX
	: SEQUENCE_ITEMS MATHEMATICAL_OPERATOR SEQUENCE_ITEMS
		{$$ = {node: 'MATHEMATICAL_OPERATOR', type: $2, left: $1, right: $3}}
	| MATH_EX MATHEMATICAL_OPERATOR SEQUENCE_ITEMS
		{$$ = {node: 'MATHEMATICAL_OPERATOR', type: $2, left: $1, right: $3}}
	;

MATH_EXPRESSION
	: MATH_EX COMPARISION_OPERATOR SEQUENCE_ITEMS
		{$$ = {node: 'COMPARISION_OPERATOR', type: $2, left: $1, right: $3}}
	;

TEXT
	: STRING
	| COMPARISION_OPERATOR
	| LOGICAL_OPERATOR
	| DATE_FUNCTION
	| LOGIC_FUNCTION
	| MATH_FUNCTION
	| PERIOD_FUNCTION
	| STRING_FUNCTION
	;

QUOTE
	: '"' TEXT '"'
		{$$ = {node: 'QUOTE', content: $TEXT}}
	;

SEQUENCE
	: SEQUENCE_ITEMS 
		{$$ = [$1]}
	| SEQUENCE COMMA SEQUENCE_ITEMS
		{$1.push($3); $$ = $1}
	;

SEQUENCE_ITEMS
	: QUOTE
	| STRING
	| FUNCTION
	| FIELD
	;

FUNCTION
	: FUNCTION_NAME '(' ARGS ')'
		{$$ = {node: $1, args: $ARGS}}
	;

FUNCTION_NAME
	: DATE_FUNCTION
		{$$ = $DATE_FUNCTION + '-DATE_FUNCTION'}
	| LOGIC_FUNCTION
		{$$ = $LOGIC_FUNCTION + '-LOGIC_FUNCTION'}
	| MATH_FUNCTION
		{$$ = $MATH_FUNCTION + '-MATH_FUNCTION'}
	| PERIOD_FUNCTION
		{$$ = $PERIOD_FUNCTION + '-PERIOD_FUNCTION'}
	| STRING_FUNCTION
		{$$ = $STRING_FUNCTION + '-STRING_FUNCTION'}
	;

ARGS
	: SEQUENCE_ITEMS
		{$$ = [$1]}
	| ARGS COMMA SEQUENCE_ITEMS
		{$1.push($3); $$ = $1}
	;

FIELD 
	: '[' TEXT ']'
		{$$ = {node: 'FIELD_NO_ENTITY', field: $2}}
	| '[' TEXT DOT TEXT ']'
		{$$ = {node: 'FIELD_AND_ENTITY', field: $4, entity: $2}}
	| '[' KEYWORD DOT TEXT ']'
		{$$ = {node: 'FIELD_AND_USERENTITY', field: $4, userentity: $2}}
	;
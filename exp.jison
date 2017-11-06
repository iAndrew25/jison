/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                             return 'SPACE'
[0-9]+("."[0-9]+)?\b            return 'NUMBER'
(([A-Za-z]|[0-9]|_|\s)+)        return 'STRING'
"\""                            return '"'
"("                             return '('
")"                             return ')'
"["                             return '['
"]"                             return ']'

<<EOF>>                         return 'EOF'
.                               return 'INVALID'

/lex

/* operator associations and precedence */

%left '[' ']' '"'

%start program

%% /* language grammar */

program 
    : expressions EOF
        {console.log($1); return $1;}
    ;
expressions 
    : wrapper SPACE wrapper
        {$$ = $1 + ' ' + $3}
    | expression SPACE wrapper
        {$$ = $1 + ' ' + $3}
    | wrapper SPACE expression
        {$$ = $1 + ' ' + $3}
    | expression SPACE expression
        {$$ = $1 + ' ' + $3}
    ;
wrapper
    : '"' expression '"'
        {$$ = '> ' + $2 + ' <';}
    | '[' expression ']'
        {$$ = (n => ' | ' + n.toUpperCase() + ' | ')($2)}
    | '(' expression ')'
        {$$ = $2;}
    ;
expression
    : NUMBER
        {$$ = Number(yytext)}
    | STRING 
        {$$ = yytext.toString().toUpperCase()}
    ;
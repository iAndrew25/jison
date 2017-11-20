const Parser = require('jison').Parser;
const grammar = require('./grammar.json');

/*
	TODO:
	- IN / NOT IN
	- plus, minus
*/

let operatorsMock = [
	{
		category: 'Logical',
		name: 'AND',
		syntax: 'AND',
		description: 'condition1 AND condition2'
	}, {
		category: 'Logical',
		name: 'NOT',
		syntax: 'NOT',
		description: 'NOT condition2'
	}, {
		category: 'Logical',
		name: 'OR',
		syntax: 'OR',
		description: 'condition1 OR condition2'
	}, {
		name: '=',
		syntax: '=',
		category: 'Comparision',
		description: 'condition1 = condition2'
	}, {
		name: '<>',
		syntax: '<>',
		category: 'Comparision',
		description: 'condition1 <> condition2'
	}, {
		name: '>',
		syntax: '>',
		category: 'Comparision',
		description: 'condition1 > condition2'
	}, {
		name: '>=',
		syntax: '>=',
		category: 'Comparision',
		description: 'condition1 >= condition2'
	}, {
		name: '<',
		syntax: '<',
		category: 'Comparision',
		description: 'condition1 < condition2'
	}, {
		name: '<=',
		syntax: '<=',
		category: 'Comparision',
		description: 'condition1 <= condition2'
	}, {
		name: 'IN',
		syntax: 'IN',
		category: 'Comparision',
		description: 'condition1 IN (value1, value2)'
	}, {
		name: 'NOT IN',
		syntax: 'NOT IN',
		category: 'Comparision',
		description: 'condition1 NOT IN (value1, value2)'
	}, {
		name: 'LIKE',
		syntax: 'LIKE',
		category: 'Comparision',
		description: 'condition1 LIKE condition2'
	}, {
		name: 'NOT LIKE',
		syntax: 'NOT LIKE',
		category: 'Comparision',
		description: 'condition1 NOT LIKE condition2'
	}, {
		name: '+',
		syntax: '+',
		category: 'Mathematical',
		description: 'number1 + number2 | date + daystoadd | string1 + string2'
	}, {
		name: '-',
		syntax: '-',
		category: 'Mathematical',
		description: 'number1 - number2 | date - daystosubtract | date1 - date2'
	}, {
		name: '*',
		syntax: '*',
		category: 'Mathematical',
		description: 'number1 * number2'
	}, {
		name: '/',
		syntax: '/',
		category: 'Mathematical',
		description: 'number1 / number2'
	}, {
		name: '^',
		syntax: '^',
		category: 'Mathematical',
		description: 'number1 ^ number2'
	}];
let functionsMock = [
	{
		name: 'AddDays',
		category: 'DATE'
	}, {name: 'AddMonths',
		category: 'DATE'
	}, {name: 'AddYears',
		category: 'DATE'
	}, {name: 'Date',
		category: 'DATE'
	}, {name: 'Datetime',
		category: 'DATE'
	}, {name: 'Day',
		category: 'DATE'
	}, {name: 'ElapsedDays',
		category: 'DATE'
	}, {name: 'ElapsedMonths',
		category: 'DATE'
	}, {name: 'ElapsedYears',
		category: 'DATE'
	}, {name: 'FirstDayInPeriod',
		category: 'DATE'
	}, {name: 'Hour',
		category: 'DATE'
	}, {name: 'LastDayInPeriod',
		category: 'DATE'
	}, {name: 'Max',
		category: 'DATE'
	}, {name: 'Min',
		category: 'DATE'
	}, {name: 'Minute',
		category: 'DATE'
	}, {name: 'Month',
		category: 'DATE'
	}, {name: 'Now',
		category: 'DATE'
	}, {name: 'PeriodForDate',
		category: 'DATE'
	}, {name: 'PeriodNumberForDate',
		category: 'DATE'
	}, {name: 'PeriodYearForDate',
		category: 'DATE'
	}, {name: 'Second',
		category: 'DATE'
	}, {name: 'SubtractDays',
		category: 'DATE'
	}, {name: 'SubtractMonths',
		category: 'DATE'
	}, {name: 'SubtractYears',
		category: 'DATE'
	}, {name: 'Today',
		category: 'DATE'
	}, {name: 'Weekday',
		category: 'DATE'
	}, {name: 'Year',
		category: 'DATE'
	}];

const operatorToGrammar = operators => operators.map(({syntax, category}) => [`\\${syntax}`, `return '${category.toUpperCase()}_OPERATOR'`]);
const functionsToGrammar = fns => fns.map(({name, category}) => [name, `return '${category.toUpperCase()}_FUNCTION'`]);

grammar.lex.rules = [...operatorToGrammar(operatorsMock), ...functionsToGrammar(functionsMock), ...grammar.lex.rules];

console.log(JSON.stringify(grammar.lex.rules));
const parser = new Parser(grammar);

parser.parse(`FirstDayInPeriod([23-01-07-03-02-06-Employee.23-01-07-03-02-06-Hire Date], 3-5, "sdfh-dsfh") + PeriodYearForDate([23-01-07-03-02-06-Employee.Login ID], [Userentity.AG-N Percent 0 Decimals]) + 3 = PeriodYearForDate([23-01-07-03-02-06-Employee.Login ID])`);

//let result = parse(`FirstDayInPeriod([23-01-07-03-02-06-Employee.23-01-07-03-02-06-Hire Date], 3-5, "sdfh-dsfh") + PeriodYearForDate([23-01-07-03-02-06-Employee.Login ID], [Userentity.AG-N Percent 0 Decimals]) + 3 = PeriodYearForDate([23-01-07-03-02-06-Employee.Login ID])`);

/*function decode(result) {
	if(result instanceof Array) {
		if(result.length === 1) {
			return result[0];
		} else {
			return result;
		}
	} else if(result instanceof Object) {

	} else {

	}
}

console.log(decode(result));*/


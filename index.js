const Parser = require('jison').Parser;
const grammar = require('./grammar.json');

/*
	TODO:
	- IN / NOT IN
	- plus, minus
*/

let operatorsMock = [{
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

function toGrammar(operators) {
	return operators.map(({syntax, category}) => [`\\${syntax}`, `return "${category.toUpperCase()}-OPERATOR"`]);
}
//console.log(toGrammar(operatorsMock));
//let mockData = [
//["\\+","return 'MATHEMATICAL_OPERATOR'"],
//["-","return 'MATHEMATICAL_OPERATOR'"],
//["\\*","return 'MATHEMATICAL_OPERATOR'"],
//["\\/","return 'MATHEMATICAL_OPERATOR'"],
//["\\^","return 'MATHEMATICAL_OPERATOR'"],
//["=","return 'COMPARISION_OPERATOR'"],
//["<>","return 'COMPARISION_OPERATOR'"],
//[">","return 'COMPARISION_OPERATOR'"],
//[">=","return 'COMPARISION_OPERATOR'"],
//["<","return 'COMPARISION_OPERATOR'"],
//["<=","return 'COMPARISION_OPERATOR'"],
//["LIKE\\b","return 'COMPARISION_OPERATOR'"],
//["NOT LIKE\\b","return 'COMPARISION_OPERATOR'"],["IN\\b","return 'COMPARISION_OPERATOR'"],["NOT IN\\b","return 'COMPARISION_OPERATOR'"],["BETWEEN\\b","return 'COMPARISION_OPERATOR'"],["NOT BETWEEN\\b","return 'COMPARISION_OPERATOR'"],["AND\\b","return 'LOGICAL_OPERATOR'"],["OR\\b","return 'LOGICAL_OPERATOR'"],["NOT\\b","return 'LOGICAL_OPERATOR'"],["AddDays\\b","return 'DATE_FUNCTION'"],["AddMonths\\b","return 'DATE_FUNCTION'"],["AddYears\\b","return 'DATE_FUNCTION'"],["Date\\b","return 'DATE_FUNCTION'"],["Datetime\\b","return 'DATE_FUNCTION'"],["Day\\b","return 'DATE_FUNCTION'"],["ElapsedDays\\b","return 'DATE_FUNCTION'"],["ElapsedMonths\\b","return 'DATE_FUNCTION'"],["ElapsedYears\\b","return 'DATE_FUNCTION'"],["FirstDayInPeriod\\b","return 'DATE_FUNCTION'"],["Hour\\b","return 'DATE_FUNCTION'"],["LastDayInPeriod\\b","return 'DATE_FUNCTION'"],["Max\\b","return 'DATE_FUNCTION'"],["Min\\b","return 'DATE_FUNCTION'"],["Minute\\b","return 'DATE_FUNCTION'"],["Month\\b","return 'DATE_FUNCTION'"],["Now\\b","return 'DATE_FUNCTION'"],["PeriodForDate\\b","return 'DATE_FUNCTION'"],["PeriodNumberForDate\\b","return 'DATE_FUNCTION'"],["PeriodYearForDate\\b","return 'DATE_FUNCTION'"],["Second\\b","return 'DATE_FUNCTION'"],["SubtractDays\\b","return 'DATE_FUNCTION'"],["SubtractMonths\\b","return 'DATE_FUNCTION'"],["SubtractYears\\b","return 'DATE_FUNCTION'"],["Today\\b","return 'DATE_FUNCTION'"],["Weekday\\b","return 'DATE_FUNCTION'"],["Year\\b","return 'DATE_FUNCTION'"],["If\\b","return 'LOGIC_FUNCTION'"],["IsAlpha\\b","return 'LOGIC_FUNCTION'"],["IsAlphanumeric\\b","return 'LOGIC_FUNCTION'"],["IsEmpty\\b","return 'LOGIC_FUNCTION'"],["Abs\\b","return 'MATH_FUNCTION'"],["Average\\b","return 'MATH_FUNCTION'"],["Ceiling\\b","return 'MATH_FUNCTION'"],["Floor\\b","return 'MATH_FUNCTION'"],["Max\\b","return 'MATH_FUNCTION'"],["Min\\b","return 'MATH_FUNCTION'"],["Mod\\b","return 'MATH_FUNCTION'"],["Round\\b","return 'MATH_FUNCTION'"],["RoundDown\\b","return 'MATH_FUNCTION'"],["RoundUp\\b","return 'MATH_FUNCTION'"],["Sqrt\\b","return 'MATH_FUNCTION'"],["AddPeriods\\b","return 'PERIOD_FUNCTION'"],["CorrespondingPeriod\\b","return 'PERIOD_FUNCTION'"],["FirstPeriodInCorrespondingPeriod\\b","return 'PERIOD_FUNCTION'"],["LastPeriodInCorrespondingPeriod\\b","return 'PERIOD_FUNCTION'"],["Max\\b","return 'PERIOD_FUNCTION'"],["Min\\b","return 'PERIOD_FUNCTION'"],["Period\\b","return 'PERIOD_FUNCTION'"],["PeriodNumberForPeriod\\b","return 'PERIOD_FUNCTION'"],["PeriodYearForPeriod\\b","return 'PERIOD_FUNCTION'"],["SubtractPeriods\\b","return 'PERIOD_FUNCTION'"],["String\\b","return 'PERIOD_FUNCTION'"],["Concatenate\\b","return 'PERIOD_FUNCTION'"],["Find\\b","return 'PERIOD_FUNCTION'"],["Left\\b","return 'PERIOD_FUNCTION'"],["Length\\b","return 'PERIOD_FUNCTION'"],["Lower\\b","return 'PERIOD_FUNCTION'"],["Max\\b","return 'PERIOD_FUNCTION'"],["Mid\\b","return 'PERIOD_FUNCTION'"],["Min\\b","return 'PERIOD_FUNCTION'"],["Right\\b","return 'PERIOD_FUNCTION'"],["Trim\\b","return 'STRING_FUNCTION'"],["Upper\\b","return 'STRING_FUNCTION'"],["Value\\b","return 'STRING_FUNCTION'"]]
//grammar.lex.rules = [...toGrammar(operatorsMock), ...grammar.lex.rules];

const parser = new Parser(grammar);

parser.parse(`FirstDayInPeriod([23-01-07-03-02-06-Employee.23-01-07-03-02-06-Hire Date], 3-5, "sdfh-dsfh") + PeriodYearForDate([23-01-07-03-02-06-Employee.Login ID], [Userentity.AG-N Percent 0 Decimals]) + 3 = PeriodYearForDate([23-01-07-03-02-06-Employee.Login ID])`);

//const parse = require('./grammar').parse;

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


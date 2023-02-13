
********************************************************************************
*This do file illustrate ways in which replicability and quality of life can be improved using Stata 
*Authors: Andrew O´Brien, Ricardo Miranda, Maneerat Gonsiang
*Date: 02/12/2023 

********************************************************************************
*Reminder of for loops, if conditions and logical statements
********************************************************************************

forvalues i=1/5{
	display "Hello world"
	display `i'
}

foreach word in "World" "People" "Y'all"{
	di "Hello `word'"
}

forvalues i=1/5{
	if `i'>3 {
		display "Hello world"
	}
}

forvalues i=1/5{
	forvalues j=5/10{
		if `i'>3 & `j'>=8{
			display "Hello world"
		}	
	}
}

********************************************************************************
*Locals, globals and nice Stata tricks
********************************************************************************

*Initial commands
clear all
set more off

*Local variables are only stores in memory while the code runs
local HelloWorld= "Hello world"
local Nine=9

display "`HelloWorld'"
di `Nine'

*Global variables are stored even after code stops running (just as data)
global HelloWorld "Hello world"
global Eight=8
global Seven "7"

di "$HelloWorld"
di $Eight
di $Seven


*Note the flexibility, locals/globals are just strings that are stored in the memory and deppending on the context stata can treat them as numbers, strings, or even as code!!
di $Seven +7
di "$Seven"
forvalues i=1/$Seven{
	di `i'
}

********************************************************************************
*Big application of globals: Users/sessions and working directories
*Set working directory for a folder that will be shared 
global User "Ricardo"
if "$User"=="Ricardo"{
  
	global Directory "D:\DEAL\StataSpring2023"
	global Examples "$Directory\Examples"
	global Figures "$Directory\Figures"
	global Tables "$Directory\Tables"
	
}

if "$User"=="Andrew"{
	
}

if "$User"=="Maneerat"{
	
}
********************************************************************************
*More applications

*Create a toy dataset to illustrate
set obs 2000
gen Normal=rnormal(0,10)

*Application: Loop over observations
forvalues i=1/20{
	di Normal[`i']
}

*Application: Create multiple variables at once
* Create indicators of "larger than" (From 0 to 20 in steps of size 2)
forvalues i=0(2)20{
	gen LargerThan`i'=[Normal>`i']
}

*Application: Loop over variables with systematic names
forvalues i=0(2)20{
	tab LargerThan`i'
} 

*Trick: Locals/globals within locals/globals
local Who "World"
local HelloWorld "Hello `Who'"
di "`HelloWorld'"

global Who "World"
global HelloWorld "Hello ${Who}"
di "$HelloWorld"

*Application: Pre-written code (simple functions)
local TabCode "tabulate LargerThan0"
`TabCode' LargerThan2

forvalues i=2(2)8{
	`TabCode' LargerThan`i'
}

*Application: Read and save files in a systematic way (also pplies to figures, tables, csc, xlsx, etc..-)
forvalues i=1/5{
	clear
	set obs 200
	gen Uniform=runiform(0,1)
	save "$Examples\Uniform_`i'.dta", replace
}

forvalues i=1/5{
	use "$Examples\Uniform_`i'.dta", clear
}
********************************************************************************
*A command you should never use: 
gen Aux=0
capture gen Aux=0
di  _rc
cap gen Aux2="Hello"
di _rc

foreach var in "Aux" "Aux2" {
	capture confirm numeric variable `var'
	if !_rc{
		replace `var'=`var'+1
	}

}

********************************************************************************
*Variable naming

gen y=rnormal(0)
gen x=rnormal(0)

gen I=y
gen E=x

gen YearlyIncome=y
gen YearsOfEducation=x

gen yearly_income=y
gen years_education=x

*¿Which is more readable? ¿Which requires more comments?
correlate x yearly_income
correlate I E
correlate YearlyIncome YearsOfEducation
correlate yearly_income years_education




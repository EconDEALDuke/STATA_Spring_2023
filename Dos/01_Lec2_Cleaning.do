*********General+Loading in DATA************


clear

ssc install mdesc 		// for detecting missing values
ssc install fillmissing // for filling missing values
ssc install extremes 	// for extracting extreme values
ssc install winsor2		// for handling outliers



import excel "$Raw\StockPrices.xlsx", sheet ("Sheet1") firstrow clear

label variable AAPL "Apple stock prices"
label variable MSFT "Microsoft stock prices"
label variable GOOG "Google stock prices"
label variable AMZN "Amazon stock prices"
label variable TSLA "Tesla stock prices"

describe AAPL MSFT GOOG AMZN TSLA

sum AAPL MSFT GOOG AMZN TSLA, detail

******Do we have duplicate observations?******
duplicates report

******Explore missing values******

ds

quietly ds

local Varlist `r(varlist)'
    foreach var in `Varlist' {
	  qui gen `var'_M=missing(`var')
	  tab `var'_M
  
} 


******Generate Missing Values with Ioplate******

ipolate AAPL daten, gen(AAPL_ipo)
ipolate MSFT daten, gen(MSFT_ipo)
ipolate GOOG daten, gen(GOOG_ipo)
ipolate AMZN daten, gen(AMZN_ipo)
ipolate TSLA daten, gen(TSLA_ipo)


*********Variable Construction************

///Using bysort

egen month_year = concat(month year) ////sets up a categorical variable that corresponds to month and year

// two additional approaches
egen month_year_g=group(year month)

encode month_year, gen(month_year_c) ///encodes combinations of our month and year variable as an int. can now run a regresssion

encode month, gen(month_c)

bysort month_year : tab AAPL_ipo

bysort month_year : egen AAPL_mean = mean(AAPL_ipo) ///using egen, we have created a variable that is stored as the mean value of AAPL stock corresponding to month and year

sort daten

///Gen indicator variables

gen AAPL_mar2015 = 0

replace AAPL_mar2015 =1 if month_year == "mar2015" ///we now have an encoded (1) value for the corresponding obervations for AAPL in march 2015

///Create maximum and indicator of maximum 
bysort month_year: egen max_AAPL_ipo=max(AAPL_ipo)
gen max_AAPL_ipo_ind=[AAPL_ipo==max_AAPL_ipo]


foreach var in month {
	gen AAPL_i = 0
	replace AAPL_i = 1 if month == "jan"
	replace AAPL_i = 2 if month == "feb"
	replace AAPL_i = 3 if month == "mar"
	replace AAPL_i = 4 if month == "apr"
	replace AAPL_i = 5 if month == "may"
	replace AAPL_i = 6 if month == "jun"
	replace AAPL_i = 7 if month == "jul"
}

***Two more commands: collapse and reshape

*Plus to quality of life commandes: preserve and pause

pause on

preserve

******Collapse*******
collapse (mean) AAPL_ipo MSFT_ipo GOOG_ipo AMZN_ipo (max) max_AAPL_ipo=AAPL_ipo max_MSFT_ipo=MSFT_ipo  max_GOOG_ipo=GOOG_ipo  max_AMZN_ipo=AMZN_ipo, by (month_year_c)

pause 

******Reshape*******
keep AAPL_ipo MSFT_ipo GOOG_ipo AMZN_ipo month_year_c

rename AAPL_ipo Stock_1
rename MSFT_ipo Stock_2
rename GOOG_ipo Stock_3
rename AMZN_ipo Stock_4

reshape long Stock_, i(month_year_c) j(Firm)

pause

******Define panel and use panel structure*******
xtset Firm month_year_c  

reg Stock_ i.Firm i.month_year_c
predict p1
 
areg  Stock_ i.Firm , absorb(month_year_c)
predict p2
predict p2_bis, xbd

xtreg Stock_ i.month_year_c, fe
predict p3
predict p3_bis, xbu

pause 

restore







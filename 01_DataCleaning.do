/***************************************************************************************************
This script implements common methods for data cleaning.

*Author: Maneerat Gonsiang
*Collaborators: Andrew O´Brien, Ricardo Miranda
*Date: 02/12/2023 

***************************************************************************************************/

*Author: Maneerat Gonsiang
*Collaborators: Andrew O´Brien, Ricardo Miranda
*Date: 02/12/2023 

/* Install necessary packages */
ssc install mdesc 		// for detecting missing values
ssc install fillmissing // for filling missing values
ssc install extremes 	// for extracting extreme values
ssc install winsor2		// for handling outliers

/* Import data */
import excel "$Data/StockPrices.xlsx", sheet ("Sheet1") firstrow clear


/* Label variables for later use */
label variable AAPL "Apple stock prices"
label variable MSFT "Microsoft stock prices"
label variable GOOG "Google stock prices"
label variable AMZN "Amazon stock prices"
label variable TSLA "Tesla stock prices"

/***************************************************************************************************
Part 1: Describing data
***************************************************************************************************/

ds						// display a list of variables

summarize 				// display summary statistics for numerical variables
summarize AAPL, detail 	// display summary statistics in detail 
sum AAPL, d				// short version

tabulate month			// display frequency tables
tab year, sort			// display frequency tables and sort 
tab year, plot			// display frequency tables and simple plot

describe				// display data types

/*****************************************
Types of variables
	- String variables consist of a combination of characters and numbers
	- Numeric variables are limited to numbers only and can be stored in different data types such as byte, int, long, float, or double, which vary in their range of minimum and maximum values  that can be stored
******************************************/


/***************************************************************************************************
Part 2: Missing values

Handling missing values is an important step in preparing a dataset for analysis. The missing values can negatively impact the results of analysis, potentially leading to incorrect or misleading conclusions. In regression analysis, for example, incomplete data can result in missing information and inaccurate estimates of parameters.

There are several methods for handling missing data, including:

1. Deletion: Suitable when there is a large dataset with only a small portion of missing values. However, this method may not be appropriate for time-series analysis or connecting datasets where consistent dates are needed.

2. Filling with previous or following value

3. Filling with basic statistics such as mean, median, minimum, maximum, first, or last value

4. Linear interpolation between two known values  (linearly interpolate the price as a function of time)

5. Imputation using information from other variables in the dataset or external information (not covered in this script)
***************************************************************************************************/

/* Detect missing values */
inspect  					// display each variable in details including missing data
count if missing(AAPL)		// count missing values for a variable
mdesc						// count missing values for all variables using mdesc package 

/* Create 10 copies of the AAPL data for comparison */
forvalues i = 1/10 {
gen AAPL_`i' = AAPL
}

/* Treat missing values */
replace AAPL_1 = AAPL_1[_n-1] if missing(AAPL_1) 	// replace missing values with previous value
replace AAPL_3 = AAPL_3[_n+1] if missing(AAPL_3) 	// replace missing values with following value 

bro daten AAPL AAPL_1 AAPL_3 // Note: The problem occurs when there are consecutive missing values. Consider using the 'fillingmissing' package

fillmissing AAPL_2, with(previous)
fillmissing AAPL_4, with(next)

fillmissing AAPL_5, with(mean) 		// fill in with other basic statistics
fillmissing AAPL_6, with(median)
fillmissing AAPL_7, with(min)
fillmissing AAPL_8, with(first)
fillmissing AAPL_9, with(last)
fillmissing AAPL_10, with(max)	

ipolate AAPL daten, gen(AAPL_11) 	// linear interpolation 

/* Label variables for later use */
label variable AAPL_2 "previous value"
label variable AAPL_4 "following value"
label variable AAPL_5 "mean value"
label variable AAPL_6 "median value"
label variable AAPL_7 "min value"
label variable AAPL_8 "first value"
label variable AAPL_9 "last value"
label variable AAPL_10 "max value"
label variable AAPL_11 "interpolated value"

/* Compare the results */
bro daten AAPL AAPL_1 AAPL_2 AAPL_3 AAPL_4 AAPL_5 AAPL_6 AAPL_7 AAPL_8 AAPL_9 AAPL_10 AAPL_11 	// compare by data table

summarize  AAPL AAPL_2 AAPL_4 AAPL_5 AAPL_6 AAPL_7 AAPL_8 AAPL_9 AAPL_10 AAPL_11 				// compare by summary statistics

twoway (scatter AAPL daten if year >= 2021, mcolor(gs11)) (scatter AAPL_11 daten if year >= 2021, msize(1pt) mcolor(navy)), xtitle("Date") ytitle("AAPL and AAPL_11 Value") // compare using scatter plot --> there are more blue dots (data after filling missing values) than grey dots (original data)

/***************************************************************************************************
Part 3 : outliers

Continuing with the linear interpolation method, once we have our complete dataset, we can calculate the stock returns and identify any outliers or unusual data points.

There are several methods to detect outliers, including:
1. Visual inspection through scatter plots, histograms, and box plots

2. Statistical methods, such as defining outliers as observations outside of a certain criteria:
	- Values top max, top min
	- Values outside the 1st-99th percentile
	- Values outside the interquartile range (IQR)
	- Values that are more than 3 standard deviations away from the mean

There are several ways to handle outliers,
1. Doing nothing: If it is believed that the unusual data points accurately represent a specific situation (such as stock prices during the COVID-19 pandemic), it may be reasonable to keep the data as is.

2.Replacing the outliers with alternative values, such as previous values, the mean, or values at the 1st and 99th percentiles.
***************************************************************************************************/

/* Calculate the return to detect more unusual data */
gen AAPL_return = (AAPL_11 - AAPL_11[_n-1]) / AAPL_11[_n-1]
drop if AAPL_return == .

/* Create 4 copies of the AAPL_return for comparison */
forvalues i = 1/4 {
	gen AAPL_return_`i' = AAPL_return
	}

/* Detect outliers */
// Use visual inspection to identify potential outliers
scatter AAPL_return daten, msize(1pt) mcolor(navy) 						// scatter plot 
histogram AAPL_return, frequency										// histogram
graph box AAPL_return, mark(1,mlabel(daten) msize(1pt) mlabsize(5pt))	// box plot

// Use statistical methods to identify outliers
extremes AAPL_return								// Top 5 highest and lowest values
extremes AAPL_return, iqr(3)						// Values higher or lower than 3 times the interquartile range						
egen AAPL_return_std = std(AAPL_return)				// generate standard deviation to measure according to the criteria
egen AAPL_return_pct = xtile(AAPL_return), nq(100)	// generate percentile to measure according to the criteria

sum AAPL_return, d									// generate threshold percentile and stores value
scalar AAPL_return_pct99 = r(p99)
scalar AAPL_return_pct1  = r(p1)

/* Treat outliers */
// Replace outliers, defined as values greater than 3 standard deviations, with previous values
replace AAPL_return_1 = AAPL_return_1[_n-1] if abs(AAPL_return_std) > 3 	 

// Replace outliers, defined as values greater than 3 standard deviations, with the value at the 99th percentile
// Replace outliers, defined as values less than -3 standard deviations, with the value at the 1st percentile
replace AAPL_return_2 = AAPL_return_pct99 if AAPL_return_std > 3 			 
replace AAPL_return_2 = AAPL_return_pct1  if AAPL_return_std < -3 

// Replace outliers, defined as values above the 99th percentile, with the value at the 99th percentile
// Replace outliers, defined as values below the 1st percentile, with the value at the 1st percentile
replace AAPL_return_3 = AAPL_return_pct99 if AAPL_return > AAPL_return_pct99 
replace AAPL_return_3 = AAPL_return_pct1  if AAPL_return < AAPL_return_pct1	

// Easier implementation to replace outliers with the value at the 99th and 1st percentile
winsor2 AAPL_return_4, replace cut(1 99) 

/* Label variables for later use */
label variable AAPL_return "original returns"
label variable AAPL_return_1 "std + previous values"
label variable AAPL_return_2 "std + 1st and 99th values"
label variable AAPL_return_3 "pct + 1st and 99th values"
label variable AAPL_return_4 "winsor"

/* Compare the results */
bro AAPL_return AAPL_return_1 AAPL_return_2 AAPL_return_3 AAPL_return_4 		// Compare the variables using data table view

summarize AAPL_return AAPL_return_1 AAPL_return_2 AAPL_return_3 AAPL_return_4 	// Compare the variables using summary statistics

twoway (scatter AAPL_return daten if year >= 2021, mcolor(gs11)) (scatter AAPL_return_2 daten if year >= 2021, msize(1pt) mcolor(navy)), xtitle("Date") ytitle("AAPL_return and AAPL_return_fix Value") // Compare the original returns (grey dots) and the treated returns (blue dots) using scatter plot, with a focus on the data from 2021 onwards

/***************************************************************************************************
Part 4 : Creating more visuals!
***************************************************************************************************/

// compare stock prices using line graph
line AAPL GOOG daten, legend(size(small)) title("AAPL and GOOG Stock Prices") 

// compare stock prices using density graph
twoway (kdensity AAPL, color(olive)) (kdensity GOOG, color(cranberry)), title("Density Plot of AAPL and GOOG Stock Prices")

// compare stock prices using scatter plot  
twoway (scatter AAPL daten if year >= 2020, msize(2pt) mcolor(brown)) (scatter GOOG daten if year >= 2020, msize(1pt) mcolor(ltblue)), legend(size(small)) ytitle("Stock Price") xtitle("Date") title("AAPL and GOOG Stock Prices from 2020 onwards")

// compare average stock prices over year 
graph bar AAPL MSFT GOOG AMZN TSLA, over(year) ytitle("Stock Price") title("Average prices of AAPL MSFT GOOG AMZN TSLA")

// compare AAPL original prices and prices after interpolated missing value
twoway (scatter AAPL_11 daten if year >= 2022, msize(4pt) mcolor(maroon)) (scatter AAPL daten if year >= 2022, msize(4pt) mcolor(gs11)), legend(size(small)) ytitle("Stock Price") xtitle("Date") title("AAPL Stock Prices from 2020 onwards")

// plot AAPL returns using simple bar graph
twoway bar AAPL_return_4 daten if year == 2023, legend(size(small)) ytitle("Stock returns") xtitle("Date") title("AAPL Stock return")

// plot AAPL returns using histogram with a normal density curve overlai
histogram AAPL_return_4, normal title("Histogram of AAPL returns") ytitle("Frequency") xtitle("AAPL Return Value")

/* Resources
1. https://www.stata.com/features/basic-statistics/
2. https://www.stata.com/support/faqs/graphics/gph/stata-graphs/
*/

cd "D:\DEAL\StataSpring2023\168982-V2"

use "./DataFiles/FullData.dta" , clear

********************************************************************************
*Preeliminary variable construction
********************************************************************************
gen ParentIsWhite=[RaceParent==1]
gen ParentAgeAtBirth=YearIndivBornChild-YearIndivBornParent
gen Above62=[Age62Cutoff>0]

replace ParentAgeAtBirth=. if ParentAgeAtBirth<=0
replace ParentAgeAtBirth=. if ParentAgeAtBirth>100

********************************************************************************
*Summary statistics
********************************************************************************
*Commands: putexcel
*Options: Modify, replace
*Tricks: loop over variables, over cells(letters) and rows in excel.

*This line creates an excel file
putexcel set "./Output/DescriptiveSummaryStatistics.xlsx", modify

local j=3

*Exploratory summary statistics
*loop over variables of interest
foreach var in ParentIsWhite ParentAgeAtBirth YrsEducationParent MaritalStatusHeadParent YrsEducationChild RealIncParent RealIncChild {
    
	*Tip: 2 cells increments
	local j=`j'+2
	
	*Summarize to obtain ret variables
	qui sum `var', d
		
	local k=1
	
	*loop over ret-stats of interest
	foreach stat in mean sd p25 p50 p75 N{
	    
		local k=`k'+2
		
		local letter : word `k' of `c(ALPHA)'
		
		local aux=r(`stat')
		
		putexcel `letter'`j'=`aux'
		
		
	}
	
}



*Do the means alone tell a story?

putexcel set "./Output/SummaryStatistics.xlsx", modify

*loop over variables of interest
foreach var in ParentIsWhite ParentAgeAtBirth YrsEducationParent MaritalStatusHeadParent YrsEducationChild RealIncParent RealIncChild {
    
	
	*Tip: Trial and error with increments
	local j=`j'+4
	local jj=`j'+1
	
	*Summarize: All who ever gave a transfer
	qui sum `var' if ParentRecTransfers, d
		
	local aux=r(mean)	
	putexcel C`j'=`aux'
	
	local aux=r(sd)
	putexcel C`jj'=`aux'



	*Summarize: All who never gave a transfer	
	qui sum `var' if !ParentRecTransfers, d
	

	local aux=r(mean)	
	putexcel E`j'=`aux'
	
	local aux=r(sd)
	putexcel E`jj'=`aux'
	
	
	
	*Summarize: Sample who ever gave a transfer
	qui sum `var' if ParentRecTransfers &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, d
		
	local aux=r(mean)	
	putexcel G`j'=`aux'
	
	local aux=r(sd)
	putexcel G`jj'=`aux'
	
	
	
	*Summarize: Sample who never gave a transfer
	qui sum `var' if !ParentRecTransfers &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, d
	
	local aux=r(mean)	
	putexcel I`j'=`aux'
	
	local aux=r(sd)
	putexcel I`jj'=`aux'
	
	
}


********************************************************************************
*Descriptive figures
********************************************************************************
*Commands: twoway, scatter, lfit, hist, kdensity, graph export
*Graph options: title, schemme, legend, mtick, label, color, graphregion, mstyle, msymbol, mcolor, lstyle, lcolor, lpattern


***************************Scatter**********************************************
*Maybe we are missing the whole story? Lets look at the distribution of the data.
twoway (scatter RealIncChild RealIncParent)  (lfit RealIncChild RealIncParent ), xtitle("Child's real income'") ytitle("Parent's real income") scheme( s2color)

graph export "Output\LineFitScatter.png", as(png) name("Graph") replace

*What about the low and mid incomes in the sample?
twoway (scatter RealIncChild RealIncParent if RealIncChild<1000000 & RealIncParent<1000000)  (lfit RealIncChild RealIncParent  if RealIncChild<1000000 & RealIncParent<1000000), xtitle("Child's real income") ytitle("Parent's real income")  scheme( s1mono) 

graph export "Output\LineFitScatter_Restrict.png", as(png) name("Graph") replace


*What about the residuals
reg RealIncChild i.RaceParent ParentAgeAtBirth YearIndivBornChild YearIndivBornParent YrsEducationParent YrsEducationChild SexofHeadParent SexofHeadChild if RealIncChild<1000000 & RealIncParent<1000000

predict RealIncChild_res, r

reg RealIncParent i.RaceParent ParentAgeAtBirth YearIndivBornChild YearIndivBornParent YrsEducationParent YrsEducationChild SexofHeadParent SexofHeadChild if RealIncChild<1000000 & RealIncParent<1000000

predict RealIncParent_res, r

twoway (scatter RealIncChild_res RealIncParent_res  if RealIncChild<1000000 & RealIncParent<1000000, msymbol(T) mcolor(black) msize(tiny))  (lfit RealIncChild_res RealIncParent_res   if RealIncChild<1000000 & RealIncParent<1000000, lpattern(solid) lcolor(cranberry)), xtitle("Child's real income (residualized)") ytitle("Parent's real income (residualized)") graphregion(color(white)) legend(label (1 "Real income")) xlabel(-200000(200000)1000000) xmtick(-200000(200000)1000000) ylabel(-200000(500000)1000000,nogrid)

graph export "Output\LineFitScatter_Residuals.png", as(png) name("Graph") replace



***************************Density and kernel***********************************

*Densities and histograms usually tell a richer story than means or scatters
twoway(hist RealIncChild if ParentRecTransfers , w(100000) percent color(cranberry%30)) (hist RealIncChild if !ParentRecTransfers, w(100000) percent color(navy%30)), legend(label(1 "Gave transfer") label(2 "Never gave transfer"))

graph export "Output\Hist1.png", as(png) name("Graph") replace


twoway(hist RealIncChild if ParentRecTransfers & RealIncChild<800000 &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, w(10000) percent color(cranberry%30)) (hist RealIncChild if !ParentRecTransfers & RealIncChild<800000 &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, w(10000) percent color(navy%30)), legend(label(1 "Gave transfer") label(2 "Never gave transfer"))

graph export "Output\Hist2.png", as(png) name("Graph") replace

qui su RealIncChild if ParentRecTransfers & RealIncChild<800000 &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2

local RecMean=r(mean)

qui su RealIncChild if !ParentRecTransfers & RealIncChild<800000 &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2

local NoRecMean=r(mean)

twoway(kdensity RealIncChild if ParentRecTransfers & RealIncChild<800000 &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, w(10000)  color(cranberry%80)) (kdensity RealIncChild if !ParentRecTransfers & RealIncChild<800000 &  Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, w(10000)  color(navy%80)), legend(label(1 "Gave transfer") label(2 "Never gave transfer")) ytitle("Density") xtitle("Child's real income") scheme(s1color) ylabel(none) xlabel(0(250000)500000) xline(`RecMean', lpattern(dash) lcolor(cranberry%50)) xline(`NoRecMean', lpattern(dash) lcolor(navy%50))

graph export "Output\DensityComparison.png", as(png) name("Graph") replace


********************************************************************************
*Regression analysis
********************************************************************************
*Commands: outreg2, coefplot
*options: Addstat, replace, append gs(grey scale for plots)
*Tricks: Event study/RD/Coefficients over time or age/binscatter

*Discontinuity done with OLS
local r1 ""
local r2 "2.RaceParent SexofHeadChild"
local r3 "2.RaceParent SexofHeadChild YrsEducationParent YrsEducationChild"
local r4 "2.RaceParent SexofHeadChild YrsEducationParent YrsEducationChild YearIndivBornChild YearIndivBornParent"

*Make sure that we have a full sample
keep if !missing(ParentRecTransfers) & !missing(PerChangeWealth)

local aux=0
local action "replace"
forvalues i=1/4{
    
	foreach var in ParentRecTransfers PerChangeWealth{
		
		qui su `var'
		local DepVarMean=r(mean)
	
		reg `var' Above62 `r`i'' if Age62Cutoff >=-10 & Age62Cutoff <=10 & SexofHeadParent ==2, robust 
		
		outreg2 using "Output\RegressionTable.xls", `action' addstat(DepVarMean,`DepVarMean')
		
		if `aux'==0{
		    local aux=1
		    local action "append"
		}
	}
}

global X_below""
global X_above""
global label ""

gen Zero=Age62Cutoff==0
label variable Zero "0"

forvalues i=1/10{

		*Create indicator for all values of X
	    gen Below_`i'=Age62Cutoff==-`i'
		gen Above_`i'=Age62Cutoff==`i'
		
		global X_below "Below_`i' $X_below "
		global X_above "$X_above Above_`i'"
		
		label variable Below_`i' "-`i'"
		label variable Above_`i' "`i'"
}

*A more detailed approach
reg ParentRecTransfers o.Zero $X_below  $X_above RaceParent SexofHeadChild if Age62Cutoff >=-10 & Age62Cutoff <=10 & SexofHeadParent ==2, robust 


coefplot ,vertical keep( $X_below Zero $X_above) order( $X_below Zero $X_above) omitt label(Below_10 "") xtitle("Parent's age'") ytitle("Parent recieved transfer") scheme(s1mono) xline(11, lpattern(dash) lcolor(gs8)) yline(0, lpattern(dash) lcolor(gs8)) mcolor(gs2)


graph export "Output\OLS_Transfer.png", as(png) name("Graph") replace

reg PerChangeWealth o.Zero $X_below  $X_above RaceParent SexofHeadChild if Age62Cutoff >=-10 & Age62Cutoff <=10 & SexofHeadParent ==2, robust 


coefplot ,vertical keep( $X_below Zero $X_above) order( $X_below Zero $X_above) omitt label(Below_10 "") xtitle("Parent's age'") ytitle("Percent change in wealth") scheme(s1mono) xline(11, lpattern(dash) lcolor(gs8)) yline(0, lpattern(dash) lcolor(gs8)) mcolor(gs2)

graph export "Output\OLS_ChangeWealth.png", as(png) name("Graph") replace

*The figures from the paper: 
rdplot ParentRecTransfers Age62Cutoff if Age62Cutoff >=-10 & Age62Cutoff <=10 & SexofHeadParent ==2, p(2) binselect(qsmv) graph_options(title(Percentage of Female Parents Receiving Money Transfers) ytitle(% of Parents) xtitle(# Years of Parents Age above/below 62))

graph export "Output\RD_Transfer.png", as(png) name("Graph") replace


rdplot PerChangeWealth Age62Cutoff if Age62Cutoff >=-10 & Age62Cutoff <=10 & RaceChild ==2, p(1) binselect(qsmv) graph_options(title(Wealth of Black Children ) ytitle(Percent Change ) xtitle(# Years of Parents Age above/below 62))

graph export "Output\RD_ChangeWealth.png", as(png) name("Graph") replace

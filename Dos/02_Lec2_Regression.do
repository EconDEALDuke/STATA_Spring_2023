*********Regression********

///basic regression

reg AAPL_ipo daten //standard OLS regression command

qreg AAPL_ipo daten ///LAD regression command, resistant to outliers

///categorical regression

reg AAPL_ipo month_year_c 

*Regress on indicators
reg AAPL_ipo i.month_c

*Interact indicators
reg AAPL_ipo i.month_c#i.year

*Fully saturate
reg AAPL_ipo i.month_c##i.year

*Take means before running regression (faster and easier to interpret)
areg AAPL_ipo, absorb(month_year_c)

*Extensions: xtreg, treg, reghdfe

*Indicators interacted with continuous
reg AAPL_ipo i.month_c#c.GOOG_ipo

///robust standard errors

reg AAPL_ipo daten

reg AAPL_ipo daten, robust

reg AAPL_ipo daten, cluster(month_year_c)


//Test for Omitted variables + Ftest

reg AAPL_ipo GOOG_ipo daten

test GOOG_ipo daten ///F-test command. Allows you test join significance of variables, Must run regression before hand


ovtest ////test for ommited variables in data set

//General linear hypothesis
test GOOG_ipo+daten=7

//Nonlinear transformations of parameters
nlcom exp(_b[GOOG_ipo])^3-log(_b[daten])


///Predict in data and Exploration

reg AAPL_ipo daten

predict AAPL_ipo_fit

predict AAPL_ipo_e, resid



///An application: Are missing values random?

reg AAPL_ipo AMZN_M

reg AAPL_ipo GOOG_M

reg AAPL_ipo MSFT_M



********************************************************************************
*Preamble
********************************************************************************
global User "Ricardo"
if "$User"=="Ricardo"{
  
	global Directory "D:\DEAL\StataSpring2023"
	
	global Examples "$Directory\Examples"
	global Figures "$Directory\Figures"
	global Tables "$Directory\Tables"
	global Raw "$Directory\Raw"
	global Working "$Directory\Working"
	global Dos "$Directory\Dos"
	
}

if "$User"=="Andrew"{
	
}

if "$User"=="Maneerat"{
	
}

********************************************************************************
*Execute do files
********************************************************************************

do $Dos/01_DataCleaning
cap log close

log using "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\log\modelling_log_Jul25", append

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\sglt2i_investigation_read_Jul25.dta", clear


******************************************************************************************
* Table 4 - model for any CVD (CVD or HF)

preserve

putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vSep25.xlsx", sheet("Table 4 - raw") modify

keep if ascvd == 1 | hf == 1 

ta cvd_group ascvd, m

gen cvd_or_chf = 1 if ascvd == 1 & hf == 0
replace cvd_or_chf = 2 if ascvd == 0 & hf == 1
replace cvd_or_chf = 3 if ascvd == 1 & hf == 1

label def cvd_or_chf 1 "CVD" 2 "CHF" 3 "Both"

label val cvd_or_chf cvd_or_chf

logistic sglt2 i.ckd i.cvd_or_chf i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency 

est store ModelA

mat list r(table)
mat define X = r(table)
mat list X

* CKD

putexcel C8 = X[1,2]
putexcel F8 = X[4,2]
putexcel D8 = X[5,2]
putexcel E8 = X[6,2]

* CVD CHF

putexcel C11 = X[1,4]
putexcel F11 = X[4,4]
putexcel D11 = X[5,4]
putexcel E11 = X[6,4]

putexcel C12 = X[1,5]
putexcel F12 = X[4,5]
putexcel D12 = X[5,5]
putexcel E12 = X[6,5]


* age

local counter 6
local row 14

foreach x in 1 2 3 4 5 6 7 {

putexcel C`row' = X[1,`counter']
putexcel F`row' = X[4,`counter']
putexcel D`row' = X[5,`counter']
putexcel E`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1
}

* gender

local counter 13
local row 22

foreach x in 1 2 {

putexcel C`row' = X[1,`counter']
putexcel F`row' = X[4,`counter']
putexcel D`row' = X[5,`counter']
putexcel E`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1

}

* deprivation

local counter 15
local row 25

foreach x in 1 2 3 4 5 {

putexcel C`row' = X[1,`counter']
putexcel F`row' = X[4,`counter']
putexcel D`row' = X[5,`counter']
putexcel E`row' = X[6,`counter']
local counter = `counter' + 1
local row = `row' + 1

}

* ethnicity

local counter 20
local row 31

foreach x in 1 2 3 4 5 6 {

putexcel C`row' = X[1,`counter']
putexcel F`row' = X[4,`counter']
putexcel D`row' = X[5,`counter']
putexcel E`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1

}

* diagnosis

local counter 26
local row 38

foreach x in 1 2 3 4 5 6  {

putexcel C`row' = X[1,`counter']
putexcel F`row' = X[4,`counter']
putexcel D`row' = X[5,`counter']
putexcel E`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1

}

restore



****************************************************************************************

* Table W - seperate models comparison

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\sglt2i_investigation_read_Jul25.dta", clear

putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vSep25.xlsx", sheet("Table W - raw") modify

foreach group in cvd_only hf_only cvd_hf high_risk low_risk {

preserve
	
if "`group'" == "cvd_only" {	
keep if cvd_group == "cvd" & hf == 0
local col_or = "C"
local col_lo = "D"
local col_hi = "E"
local col_pv = "F"
}

if "`group'" == "hf_only" {	
keep if (cvd_group == "high_risk" | cvd_group == "low_risk") & hf == 1
local col_or = "I"
local col_lo = "J"
local col_hi = "K"
local col_pv = "L"
}

if "`group'" == "cvd_hf" {	
keep if cvd_group == "cvd" & hf == 1
local col_or = "O"
local col_lo = "P"
local col_hi = "Q"
local col_pv = "R"
}

if "`group'" == "high_risk" {	
keep if cvd_group == "high_risk" & hf == 0
local col_or = "U"
local col_lo = "V"
local col_hi = "W"
local col_pv = "X"
}

if "`group'" == "low_risk" {	
keep if cvd_group == "low_risk" & hf == 0
local col_or = "AA"
local col_lo = "AB"
local col_hi = "AC"
local col_pv = "AD"
}

logistic sglt2 i.ckd i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency 

est store ModelA

mat list r(table)
mat define X = r(table)
mat list X

* CKD

putexcel `col_or'10 = X[1,2]
putexcel `col_pv'10 = X[4,2]
putexcel `col_lo'10 = X[5,2]
putexcel `col_hi'10 = X[6,2]

* age

local counter 3
local row 12

foreach x in 1 2 3 4 5 6 7 {

putexcel `col_or'`row' = X[1,`counter']
putexcel `col_pv'`row' = X[4,`counter']
putexcel `col_lo'`row' = X[5,`counter']
putexcel `col_hi'`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1
}

* gender

local counter 10
local row 20

if "`group'" == "low_risk" {
local counter 8
}    
	

foreach x in 1 2 {

putexcel `col_or'`row' = X[1,`counter']
putexcel `col_pv'`row' = X[4,`counter']
putexcel `col_lo'`row' = X[5,`counter']
putexcel `col_hi'`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1

}

* deprivation

local counter 12
local row 23

if "`group'" == "low_risk" {
local counter 10
}    

foreach x in 1 2 3 4 5 {

putexcel `col_or'`row' = X[1,`counter']
putexcel `col_pv'`row' = X[4,`counter']
putexcel `col_lo'`row' = X[5,`counter']
putexcel `col_hi'`row' = X[6,`counter']
local counter = `counter' + 1
local row = `row' + 1

}

* ethnicity

local counter 17
local row 29

if "`group'" == "low_risk" {
local counter 15
}   

foreach x in 1 2 3 4 5 6 {

putexcel `col_or'`row' = X[1,`counter']
putexcel `col_pv'`row' = X[4,`counter']
putexcel `col_lo'`row' = X[5,`counter']
putexcel `col_hi'`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1

}

* diagnosis

local counter 23
local row 36

if "`group'" == "low_risk" {
local counter 21
}   

foreach x in 1 2 3 4 5 6  {

putexcel `col_or'`row' = X[1,`counter']
putexcel `col_pv'`row' = X[4,`counter']
putexcel `col_lo'`row' = X[5,`counter']
putexcel `col_hi'`row' = X[6,`counter']

local counter = `counter' + 1
local row = `row' + 1

}

restore

}






/*





cap log close

log using "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\log\sglt2i_log_Jul25", append

/* going to link in CVD risk status estimated using algorithm from Herret et al */

/* reducing variables prior to linkage */

import delimited "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\sglt2i_investigation_08_28.csv", clear

keep patid cvd_group

save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\cvd_risk_lookup", replace

/* importing prepared file and formatting / cleaning/ labelling data */

clear all

import delimited "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Patrick_SGLT2_table_2025_02_10.csv", clear

* cleaning and formatting

ta imd5, m
/* NB IMD deprivation status was mising for 0.3% of patients, who were dropped entirely from the analysis */
drop if imd5 == "NA"
destring imd5, gen(imd5_new)
lab def imd 1 "1 (least deprived)" 5 "5 (most deprived)"
label values imd5_new imd
drop imd5
rename imd5_new imd5

ta ckd_cat, m
replace ckd_cat = "." if ckd_cat == "NA"
replace ckd_cat = "1" if ckd_cat == "No CKD"
replace ckd_cat = "2" if ckd_cat == "Stage 1"
replace ckd_cat = "3" if ckd_cat == "Stage 2"
replace ckd_cat = "4" if ckd_cat == "Stage 3a"
replace ckd_cat = "5" if ckd_cat == "Stage 3b"
replace ckd_cat = "6" if ckd_cat == "Stage 4"
replace ckd_cat = "7" if ckd_cat == "Stage 5"

destring ckd_cat, gen(ckd_cat_new)

lab def ckd 1 "No CKD" 2 "Stage 1" 3 "Stage 2" 4 "Stage 3a" 5 "Stage 3b" 6 "Stage 4" 7 "Stage 5"
drop ckd_cat
rename ckd_cat_new ckd_cat
label values ckd_cat ckd 
ta ckd_cat, m

ta egfr_cat, m
replace egfr_cat = "." if egfr_cat == "NA"
replace egfr_cat = "1" if egfr_cat == "G1"
replace egfr_cat = "2" if egfr_cat == "G2"
replace egfr_cat = "3" if egfr_cat == "G3a"
replace egfr_cat = "4" if egfr_cat == "G3b"
replace egfr_cat = "5" if egfr_cat == "G4"
replace egfr_cat = "6" if egfr_cat == "G5"
destring egfr_cat, gen(egfr_cat_new)

lab def egfr 1 "G1" 2 "G2" 3 "G3a" 4 "G3b" 5 "G4" 6 "G5"
drop egfr_cat
rename egfr_cat_new egfr_cat
label values egfr_cat egfr
ta egfr_cat, m

codebook urine_acr, detail
replace urine_acr = "." if urine_acr == "NA"
destring urine_acr, gen(urine_acr_new)
summ urine_acr_new, detail
summ urine_acr_new if album_cat == "Missing"
summ urine_acr_new if album_cat == "A1"
summ urine_acr_new if album_cat == "A2"
summ urine_acr_new if album_cat == "A3"

ta album_cat, m
replace album_cat = "." if album_cat == "Missing"
replace album_cat = "1" if album_cat == "A1"
replace album_cat = "2" if album_cat == "A2"
replace album_cat = "3" if album_cat == "A3"
destring album_cat, gen(album_cat_new)

lab def acr 1 "A1" 2 "A2" 3 "A3"
drop album_cat
rename album_cat_new album_cat
label values album_cat acr
ta album_cat, m

drop ckd1_3 ckd_4

summ age_at_index, detail
egen agegroup = cut(age_at_index), at(0 40 50 60 70 80 90 150)
bysort agegroup: summ age_at_index

gen diagnosis_recency = 1 if t2dm_duration >= 0 & t2dm_duration < 1
replace diagnosis_recency = 2 if t2dm_duration >= 1 & t2dm_duration < 2
replace diagnosis_recency = 3 if t2dm_duration >= 2 & t2dm_duration < 3
replace diagnosis_recency = 4 if t2dm_duration >= 3 & t2dm_duration < 4
replace diagnosis_recency = 5 if t2dm_duration >= 4 & t2dm_duration < 5
replace diagnosis_recency = 6 if t2dm_duration >= 5 

lab def recency 1 "0-1 years" 2 "1-2 years" 3 "2-3 years" 4 "3-4 years" 5 "4-5 years" 6 ">=5 years"
label values diagnosis_recency recency

bysort diagnosis_recency: summ t2dm_duration

/* now going to link CVD risk */

merge 1:m patid using "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\cvd_risk_lookup.dta"
drop if _merge == 2
ta cvd_group ascvd, m

gen high_risk = 1 if cvd_group == "high_risk"
replace high_risk = 0 if high_risk ==.

gen low_risk = 1 if cvd_group == "low_risk"
replace low_risk = 0 if low_risk ==.

gen ckd = 1 if ckd_cat >1 & ckd_cat !=.
replace ckd = 0 if ckd_cat == 1

save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\sglt2i_investigation_read_Jul25.dta", replace

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\sglt2i_investigation_read_Jul25.dta", clear

** Analysis tables

/* Total counts macros */

*************************************************************************
/* Table 1 */

putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vSep25.xlsx", sheet("Table 1 - raw") modify

foreach group in cvd_only hf_only cvd_hf high_risk low_risk {

preserve
	
if "`group'" == "cvd_only" {	
keep if cvd_group == "cvd" & hf == 0
local col_n = "C"
local col_per = "D"
}

if "`group'" == "hf_only" {	
keep if (cvd_group == "high_risk" | cvd_group == "low_risk") & hf == 1
local col_n = "E"
local col_per = "F"
}

if "`group'" == "cvd_hf" {	
keep if cvd_group == "cvd" & hf == 1
local col_n = "G"
local col_per = "H"
}

if "`group'" == "high_risk" {	
keep if cvd_group == "high_risk" & hf == 0
local col_n = "I"
local col_per = "J"
}

if "`group'" == "low_risk" {	
keep if cvd_group == "low_risk" & hf == 0
local col_n = "K"
local col_per = "L"
}

count
local total = r(N)
putexcel `col_n'5 = (r(N))
putexcel `col_per'5 = (r(N)/`total')

count if ckd_cat == 1
putexcel `col_n'7 = (r(N))
putexcel `col_per'7 = (r(N)/`total')

count if ckd_cat > 1 & ckd_cat !=.
putexcel `col_n'8 = (r(N))
putexcel `col_per'8 = (r(N)/`total')

count if ckd_cat ==.
putexcel `col_n'9 = (r(N))
putexcel `col_per'9 = (r(N)/`total')

count if diagnosis_recency == 1 | diagnosis_recency == 2
putexcel `col_n'11 = (r(N))
putexcel `col_per'11 = (r(N)/`total')

count if diagnosis_recency > 2
putexcel `col_n'12 = (r(N))
putexcel `col_per'12 = (r(N)/`total')

summ age_at_index
putexcel `col_n'14 = (r(mean)) 

local counter = 15
foreach age of numlist 0 40 50 60 70 80 90 {
count if agegroup == `age' 
putexcel `col_n'`counter' = (r(N))
putexcel `col_per'`counter' = (r(N)/`total')
local counter = `counter' + 1 
}

count if gender == 1
putexcel `col_n'23 = (r(N))
putexcel `col_per'23 = (r(N)/`total')

count if gender == 2
putexcel `col_n'24 = (r(N))
putexcel `col_per'24 = (r(N)/`total')

local counter = 26
foreach dep of numlist 5 4 3 2 1 {
count if imd5 == `dep' 
putexcel `col_n'`counter' = (r(N))
putexcel `col_per'`counter' = (r(N)/`total')
local counter = `counter' + 1 
}

local counter = 32
foreach eth of numlist 1 2 3 4 5 6 {
count if eth_6 == `eth' 
putexcel `col_n'`counter' = (r(N))
putexcel `col_per'`counter' = (r(N)/`total')
local counter = `counter' + 1 
}

restore

}

*************************************************************************
/* Table 2 */



putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vSep25.xlsx", sheet("Table 2 - raw") modify

foreach group in all cvd_only hf_only cvd_hf high_risk low_risk {

preserve

if "`group'" == "all" {	
local col_n = "C"
local col_per = "D"
}
	
if "`group'" == "cvd_only" {	
keep if cvd_group == "cvd" & hf == 0
local col_n = "E"
local col_per = "F"
}

if "`group'" == "hf_only" {	
keep if (cvd_group == "high_risk" | cvd_group == "low_risk") & hf == 1
local col_n = "G"
local col_per = "H"
}

if "`group'" == "cvd_hf" {	
keep if cvd_group == "cvd" & hf == 1
local col_n = "I"
local col_per = "J"
}

if "`group'" == "high_risk" {	
keep if cvd_group == "high_risk" & hf == 0
local col_n = "K"
local col_per = "L"
}

if "`group'" == "low_risk" {	
keep if cvd_group == "low_risk" & hf == 0
local col_n = "M"
local col_per = "N"
}


count
putexcel `col_n'6 = (r(N))
count if sglt2 == 1
putexcel `col_per'6 = (r(N))

count if ckd == 0
putexcel `col_n'8 = (r(N))
count if ckd == 0 & sglt2 == 1
putexcel `col_per'8 = (r(N))

count if ckd == 1
putexcel `col_n'9 = (r(N))
count if ckd == 1 & sglt2 == 1
putexcel `col_per'9 = (r(N))

count if ckd == .
putexcel `col_n'10 = (r(N))
count if ckd == . & sglt2 == 1
putexcel `col_per'10 = (r(N))


count if diagnosis_recency == 1 | diagnosis_recency == 2
putexcel `col_n'12 = (r(N))
count if (diagnosis_recency == 1 | diagnosis_recency == 2) & sglt2 == 1
putexcel `col_per'12 = (r(N))

count if diagnosis_recency > 2
putexcel `col_n'13 = (r(N))
count if diagnosis_recency > 2  & sglt2 == 1
putexcel `col_per'13 = (r(N)) 


local counter = 15
foreach age of numlist 0 40 50 60 70 80 90 {

count if agegroup == `age'
putexcel `col_n'`counter' = (r(N))
count if agegroup == `age' & sglt2 == 1
putexcel `col_per'`counter' = (r(N))

local counter = `counter' + 1 
}


count if gender ==1
putexcel `col_n'23 = (r(N))
count if gender == 1 & sglt2 == 1
putexcel `col_per'23 = (r(N))

count if gender ==2
putexcel `col_n'24 = (r(N))
count if gender == 2 & sglt2 == 1
putexcel `col_per'24 = (r(N))


local counter = 26
foreach dep of numlist 5 4 3 2 1 {

count if imd5 == `dep'
putexcel `col_n'`counter' = (r(N))
count if imd5 == `dep' & sglt2 == 1
putexcel `col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

local counter = 32
foreach eth of numlist 1 2 3 4 5 6 {

count if eth_6 == `eth'
putexcel `col_n'`counter' = (r(N))
count if eth_6 == `eth' & sglt2 == 1
putexcel `col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

restore 

}



*************************************************************************
/* Table 3 */

putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vSep25.xlsx", sheet("Table 3 - raw") modify

foreach group in cvd_only hf_only cvd_hf {

preserve
	
if "`group'" == "cvd_only" {	
keep if cvd_group == "cvd" & hf == 0
local ckd_col_n = "C"
local ckd_col_per = "D"
local nockd_col_n = "E"
local nockd_col_per = "F"
}

if "`group'" == "hf_only" {	
keep if (cvd_group == "high_risk" | cvd_group == "low_risk") & hf == 1
local ckd_col_n = "G"
local ckd_col_per = "H"
local nockd_col_n = "I"
local nockd_col_per = "J"
}

if "`group'" == "cvd_hf" {	
keep if cvd_group == "cvd" & hf == 1
local ckd_col_n = "K"
local ckd_col_per = "L"
local nockd_col_n = "M"
local nockd_col_per = "N"
}

count if ckd == 1
putexcel `ckd_col_n'7 = (r(N))
count if ckd == 1 & sglt2 == 1
putexcel `ckd_col_per'7 = (r(N))

count if ckd == 0
putexcel `nockd_col_n'7 = (r(N))
count if ckd == 0 & sglt2 == 1
putexcel `nockd_col_per'7 = (r(N))



count if ckd == 1 & diagnosis_recency == 1 | diagnosis_recency == 2
putexcel `ckd_col_n'9 = (r(N))
count if ckd == 1 & diagnosis_recency == 1 | diagnosis_recency == 2 & sglt2 == 1
putexcel `ckd_col_per'9 = (r(N))

count if ckd == 0 & diagnosis_recency == 1 | diagnosis_recency == 2
putexcel `nockd_col_n'9 = (r(N))
count if ckd == 0 & diagnosis_recency == 1 | diagnosis_recency == 2 & sglt2 == 1
putexcel `nockd_col_per'9 = (r(N))

count if ckd == 1 & diagnosis_recency > 2
putexcel `ckd_col_n'10 = (r(N))
count if ckd == 1 & diagnosis_recency > 2 & sglt2 == 1
putexcel `ckd_col_per'10 = (r(N))

count if ckd == 0 & diagnosis_recency > 2
putexcel `nockd_col_n'10 = (r(N))
count if ckd == 0 & diagnosis_recency > 2 & sglt2 == 1
putexcel `nockd_col_per'10 = (r(N))



local counter = 12
foreach age of numlist 0 40 50 60 70 80 90 {

count if ckd == 1 & agegroup == `age'
putexcel `ckd_col_n'`counter' = (r(N))
count if ckd == 1 & agegroup == `age' & sglt2 == 1
putexcel `ckd_col_per'`counter' = (r(N))

count if ckd == 0 & agegroup == `age'
putexcel `nockd_col_n'`counter' = (r(N))
count if ckd == 0 & agegroup == `age' & sglt2 == 1
putexcel `nockd_col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

count if ckd == 1 & gender ==1
putexcel `ckd_col_n'20 = (r(N))
count if ckd == 1 & gender ==1 & sglt2 == 1
putexcel `ckd_col_per'20 = (r(N))

count if ckd == 0 & gender ==1
putexcel `nockd_col_n'20 = (r(N))
count if ckd == 0 & gender ==1 & sglt2 == 1
putexcel `nockd_col_per'20 = (r(N))

count if ckd == 1 & gender ==2
putexcel `ckd_col_n'21 = (r(N))
count if ckd == 1 & gender ==2 & sglt2 == 1
putexcel `ckd_col_per'21 = (r(N))

count if ckd == 0 & gender ==2
putexcel `nockd_col_n'21 = (r(N))
count if ckd == 0 & gender ==2 & sglt2 == 1
putexcel `nockd_col_per'21 = (r(N))

local counter = 23
foreach dep of numlist 5 4 3 2 1 {

count if ckd == 1 & imd5 == `dep'
putexcel `ckd_col_n'`counter' = (r(N))
count if ckd == 1 & imd5 == `dep' & sglt2 == 1
putexcel `ckd_col_per'`counter' = (r(N))

count if ckd == 0 & imd5 == `dep'
putexcel `nockd_col_n'`counter' = (r(N))
count if ckd == 0 & imd5 == `dep' & sglt2 == 1
putexcel `nockd_col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

local counter = 29
foreach eth of numlist 1 2 3 4 5 6 {

count if ckd == 1 & eth_6 == `eth'
putexcel `ckd_col_n'`counter' = (r(N))
count if ckd == 1 & eth_6 == `eth' & sglt2 == 1
putexcel `ckd_col_per'`counter' = (r(N))

count if ckd == 0 & eth_6 == `eth'
putexcel `nockd_col_n'`counter' = (r(N))
count if ckd == 0 & eth_6 == `eth' & sglt2 == 1
putexcel `nockd_col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

restore 

}


*************************************************************************
/* Table X appendix - egf/albumin */

putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vJul25.xlsx", sheet("Table X - raw") modify

local counter 1

ta egfr_cat album_cat, matcell(X) m

matrix list X

foreach R in 1 2 3 4 5 6 7 {

local RE = `R' + 3

foreach C in C D E F {
  
putexcel `C'`RE' = X[`R',`counter']

local counter = `counter' + 1

}

local counter 1

}


*****************************************************************************
/* Table Y - appendix high and low risk uptake */

putexcel set "\\tsclient\K\1-Methods_Economics team\RETAIN - METHODOLOGY\Data science\diabetes medicines 2023\g. results\uptake paper\Results vSep25.xlsx", sheet("Table Y - raw") modify

foreach group in high_risk low_risk {

preserve
	
if "`group'" == "high_risk" {	
keep if cvd_group == "high_risk" & hf == 0
local ckd_col_n = "C"
local ckd_col_per = "D"
local nockd_col_n = "E"
local nockd_col_per = "F"
}

if "`group'" == "low_risk" {	
keep if cvd_group == "low_risk" & hf == 0
local ckd_col_n = "G"
local ckd_col_per = "H"
local nockd_col_n = "I"
local nockd_col_per = "J"
}

count if ckd == 1
putexcel `ckd_col_n'7 = (r(N))
count if ckd == 1 & sglt2 == 1
putexcel `ckd_col_per'7 = (r(N))

count if ckd == 0
putexcel `nockd_col_n'7 = (r(N))
count if ckd == 0 & sglt2 == 1
putexcel `nockd_col_per'7 = (r(N))

count if ckd == 1 & diagnosis_recency == 1 | diagnosis_recency == 2
putexcel `ckd_col_n'9 = (r(N))
count if ckd == 1 & diagnosis_recency == 1 | diagnosis_recency == 2 & sglt2 == 1
putexcel `ckd_col_per'9 = (r(N))

count if ckd == 0 & diagnosis_recency == 1 | diagnosis_recency == 2
putexcel `nockd_col_n'9 = (r(N))
count if ckd == 0 & diagnosis_recency == 1 | diagnosis_recency == 2 & sglt2 == 1
putexcel `nockd_col_per'9 = (r(N))

count if ckd == 1 & diagnosis_recency > 2
putexcel `ckd_col_n'10 = (r(N))
count if ckd == 1 & diagnosis_recency > 2 & sglt2 == 1
putexcel `ckd_col_per'10 = (r(N))

count if ckd == 0 & diagnosis_recency > 2
putexcel `nockd_col_n'10 = (r(N))
count if ckd == 0 & diagnosis_recency > 2 & sglt2 == 1
putexcel `nockd_col_per'10 = (r(N))



local counter = 12
foreach age of numlist 0 40 50 60 70 80 90 {

count if ckd == 1 & agegroup == `age'
putexcel `ckd_col_n'`counter' = (r(N))
count if ckd == 1 & agegroup == `age' & sglt2 == 1
putexcel `ckd_col_per'`counter' = (r(N))

count if ckd == 0 & agegroup == `age'
putexcel `nockd_col_n'`counter' = (r(N))
count if ckd == 0 & agegroup == `age' & sglt2 == 1
putexcel `nockd_col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

count if ckd == 1 & gender ==1
putexcel `ckd_col_n'20 = (r(N))
count if ckd == 1 & gender ==1 & sglt2 == 1
putexcel `ckd_col_per'20 = (r(N))

count if ckd == 0 & gender ==1
putexcel `nockd_col_n'20 = (r(N))
count if ckd == 0 & gender ==1 & sglt2 == 1
putexcel `nockd_col_per'20 = (r(N))

count if ckd == 1 & gender ==2
putexcel `ckd_col_n'21 = (r(N))
count if ckd == 1 & gender ==2 & sglt2 == 1
putexcel `ckd_col_per'21 = (r(N))

count if ckd == 0 & gender ==2
putexcel `nockd_col_n'21 = (r(N))
count if ckd == 0 & gender ==2 & sglt2 == 1
putexcel `nockd_col_per'21 = (r(N))

local counter = 23
foreach dep of numlist 5 4 3 2 1 {

count if ckd == 1 & imd5 == `dep'
putexcel `ckd_col_n'`counter' = (r(N))
count if ckd == 1 & imd5 == `dep' & sglt2 == 1
putexcel `ckd_col_per'`counter' = (r(N))

count if ckd == 0 & imd5 == `dep'
putexcel `nockd_col_n'`counter' = (r(N))
count if ckd == 0 & imd5 == `dep' & sglt2 == 1
putexcel `nockd_col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

local counter = 29
foreach eth of numlist 1 2 3 4 5 6 {

count if ckd == 1 & eth_6 == `eth'
putexcel `ckd_col_n'`counter' = (r(N))
count if ckd == 1 & eth_6 == `eth' & sglt2 == 1
putexcel `ckd_col_per'`counter' = (r(N))

count if ckd == 0 & eth_6 == `eth'
putexcel `nockd_col_n'`counter' = (r(N))
count if ckd == 0 & eth_6 == `eth' & sglt2 == 1
putexcel `nockd_col_per'`counter' = (r(N))

local counter = `counter' + 1 
}

restore 

}





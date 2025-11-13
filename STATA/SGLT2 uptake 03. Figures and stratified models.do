
cap log close

log using "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\log\graphing_jul25", append

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\sglt2i_investigation_read_Jul25.dta", clear

******************************************************************************************
* Table 3 - CVD without CHF

logistic sglt2 i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency i.ckd_cat if ascvd == 1 & hf == 0
est store ModelA

mat list r(table)
mat define X = r(table)
mat list X

svmat float X, names(T3_)

rename T3_1 F3_agegroup_0
rename T3_2 F3_agegroup_40
rename T3_3 F3_agegroup_50
rename T3_4 F3_agegroup_60
rename T3_5 F3_agegroup_70
rename T3_6 F3_agegroup_80
rename T3_7 F3_agegroup_90
rename T3_8 F3_gender1
rename T3_9 F3_gender2
rename T3_10 F3_imd1
rename T3_11 F3_imd2
rename T3_12 F3_imd3
rename T3_13 F3_imd4
rename T3_14 F3_imd5
rename T3_15 F3_eth1
rename T3_16 F3_eth2
rename T3_17 F3_eth3
rename T3_18 F3_eth4
rename T3_19 F3_eth5
rename T3_20 F3_eth6

* Table 4 HF only not CVD

logistic sglt2 i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency i.ckd_cat if ascvd == 0 & hf == 1
est store ModelA

mat list r(table)
mat define Y = r(table)
mat list Y

svmat float Y, names(T4_)

rename T4_1 F4_agegroup_0
rename T4_2 F4_agegroup_40
rename T4_3 F4_agegroup_50
rename T4_4 F4_agegroup_60
rename T4_5 F4_agegroup_70
rename T4_6 F4_agegroup_80
rename T4_7 F4_agegroup_90
rename T4_8 F4_gender1
rename T4_9 F4_gender2
rename T4_10 F4_imd1
rename T4_11 F4_imd2
rename T4_12 F4_imd3
rename T4_13 F4_imd4
rename T4_14 F4_imd5
rename T4_15 F4_eth1
rename T4_16 F4_eth2
rename T4_17 F4_eth3
rename T4_18 F4_eth4
rename T4_19 F4_eth5
rename T4_20 F4_eth6

* Table 5 HF and aCVD

logistic sglt2 i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency i.ckd_cat if ascvd == 1 & hf == 1
est store ModelA

mat list r(table)
mat define Y = r(table)
mat list Y

svmat float Y, names(T5_)

rename T5_1 F5_agegroup_0
rename T5_2 F5_agegroup_40
rename T5_3 F5_agegroup_50
rename T5_4 F5_agegroup_60
rename T5_5 F5_agegroup_70
rename T5_6 F5_agegroup_80
rename T5_7 F5_agegroup_90
rename T5_8 F5_gender1
rename T5_9 F5_gender2
rename T5_10 F5_imd1
rename T5_11 F5_imd2
rename T5_12 F5_imd3
rename T5_13 F5_imd4
rename T5_14 F5_imd5
rename T5_15 F5_eth1
rename T5_16 F5_eth2
rename T5_17 F5_eth3
rename T5_18 F5_eth4
rename T5_19 F5_eth5
rename T5_20 F5_eth6


* Table 6 High CVD risk

logistic sglt2 i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency i.ckd_cat if ascvd == 0 & hf == 0 & high_risk == 1
est store ModelA

mat list r(table)
mat define Y = r(table)
mat list Y

svmat float Y, names(T6_)

rename T6_1 F6_agegroup_0
rename T6_2 F6_agegroup_40
rename T6_3 F6_agegroup_50
rename T6_4 F6_agegroup_60
rename T6_5 F6_agegroup_70
rename T6_6 F6_agegroup_80
rename T6_7 F6_agegroup_90
rename T6_8 F6_gender1
rename T6_9 F6_gender2
rename T6_10 F6_imd1
rename T6_11 F6_imd2
rename T6_12 F6_imd3
rename T6_13 F6_imd4
rename T6_14 F6_imd5
rename T6_15 F6_eth1
rename T6_16 F6_eth2
rename T6_17 F6_eth3
rename T6_18 F6_eth4
rename T6_19 F6_eth5
rename T6_20 F6_eth6


* Table 7 Low CVD risk

logistic sglt2 i.agegroup i.gender i.imd5 i.eth_6 i.diagnosis_recency i.ckd_cat if ascvd == 0 & hf == 0 & low_risk == 1
est store ModelA

mat list r(table)
mat define Y = r(table)
mat list Y

svmat float Y, names(T7_)

rename T7_1 F7_agegroup_0
rename T7_2 F7_agegroup_40
rename T7_3 F7_agegroup_50
rename T7_4 F7_agegroup_60
rename T7_5 F7_agegroup_70 

gen F7_agegroup_80 = 1
gen F7_agegroup_90 = 1

rename T7_6 F7_gender1
rename T7_7 F7_gender2
rename T7_8 F7_imd1
rename T7_9 F7_imd2
rename T7_10 F7_imd3
rename T7_11 F7_imd4
rename T7_12 F7_imd5
rename T7_13 F7_eth1
rename T7_14 F7_eth2
rename T7_15 F7_eth3
rename T7_16 F7_eth4
rename T7_17 F7_eth5
rename T7_18 F7_eth6

keep F3_* F4_* F5_* F6_* F7_*

keep if _n == 1 | _n == 5 | _n ==6

save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Figures_raw_data.dta", replace

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Figures_raw_data.dta", clear

***** going to do table 3 estimates first

keep F3_*

gen name = ""
replace name = "point" if _n == 1
replace name = "lower" if _n == 2
replace name = "upper" if _n == 3
order name

reshape long F3_, i(name) j(type) string

sort type name
rename F3_ estimate

reshape wide estimate, i(type) j(name) string

gen index = 10 if type == "agegroup_0"
replace index = 17 if type == "agegroup_40"
replace index = 24 if type == "agegroup_50"
replace index = 31 if type == "agegroup_60"
replace index = 38 if type == "agegroup_70"
replace index = 45 if type == "agegroup_80"
replace index = 52 if type == "agegroup_90"

replace index = 67 if type == "gender1"
replace index = 74 if type == "gender2"

replace index = 89 if type == "eth1"
replace index = 96 if type == "eth2"
replace index = 103 if type == "eth3"
replace index = 110 if type == "eth4"
replace index = 117 if type == "eth5"
*replace index = 124 if type == "eth6"

replace index = 132 if type == "imd1"
replace index = 139 if type == "imd2"
replace index = 146 if type == "imd3"
replace index = 153 if type == "imd4"
replace index = 160 if type == "imd5"

gen dum1 = .
gen dum2 = .
replace dum1 = 0 if _n == 1
replace dum1 = 175 if _n == 2

replace dum2 = 1 if _n == 1
replace dum2 = 1 if _n == 2

gen dum2_log = ln(dum2)

gen log_estimatepoint = ln(estimatepoint)
gen log_estimateupper = ln(estimateupper)
gen log_estimatelower = ln(estimatelower)

graph twoway line dum2 dum1, color(blue) || ///
scatter estimatepoint index, color(gs0) msymbol(d) || ///
rcap estimateupper estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel(0.5 1 1.5 2, labsize(small) valuelabel) yscale(range(0 2) titlegap(3)) ytitle("aCVD without HF", size(medsmall)) xscale(range(0 170)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" /*124 "Missing"*/ 132 "IMD 5" 139 "4" 146 "3" 153 "2" 160 "IMD 1", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off) 

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab3_fig.gph", replace

* now with log y axis
/*
graph twoway line dum2_log dum1, color(blue) || ///
scatter log_estimatepoint index, color(gs0) msymbol(d) || ///
rcap log_estimateupper log_estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel(-3.47 "0.03" -2.77 "0.06" -2.07 "0.13" -1.38 "0.3" -0.693 "0.5" 0 "1"  0.69 "2" 1.386 "4", labsize(tiny) valuelabel) yscale(range(-3.5 1.5) titlegap(3)) ytitle("aCVD without HF", size(medsmall)) xscale(range(0 175)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" 124 "Missing" 139 "IMD 1" 146 "2" 153 "3" 160 "4" 167 "IMD 5", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off)

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab3_fig_log.gph", replace

*/
***** now table 4 estimates

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Figures_raw_data.dta", clear

keep F4_*

gen name = ""
replace name = "point" if _n == 1
replace name = "lower" if _n == 2
replace name = "upper" if _n == 3
order name

reshape long F4_, i(name) j(type) string

sort type name
rename F4_ estimate

reshape wide estimate, i(type) j(name) string

gen index = 10 if type == "agegroup_0"
replace index = 17 if type == "agegroup_40"
replace index = 24 if type == "agegroup_50"
replace index = 31 if type == "agegroup_60"
replace index = 38 if type == "agegroup_70"
replace index = 45 if type == "agegroup_80"
replace index = 52 if type == "agegroup_90"

replace index = 67 if type == "gender1"
replace index = 74 if type == "gender2"

replace index = 89 if type == "eth1"
replace index = 96 if type == "eth2"
replace index = 103 if type == "eth3"
replace index = 110 if type == "eth4"
replace index = 117 if type == "eth5"
*replace index = 124 if type == "eth6"

replace estimatepoint =. if type == "eth6"
replace estimateupper =. if type == "eth6"
replace estimatelower =. if type == "eth6"

replace index = 132 if type == "imd1"
replace index = 139 if type == "imd2"
replace index = 146 if type == "imd3"
replace index = 153 if type == "imd4"
replace index = 160 if type == "imd5"


gen dum1 = .
gen dum2 = .
replace dum1 = 0 if _n == 1
replace dum1 = 175 if _n == 2

replace dum2 = 1 if _n == 1
replace dum2 = 1 if _n == 2

gen dum2_log = ln(dum2)

gen log_estimatepoint = ln(estimatepoint)
gen log_estimateupper = ln(estimateupper)
gen log_estimatelower = ln(estimatelower)

graph twoway line dum2 dum1, color(blue) || ///
scatter estimatepoint index, color(gs0) msymbol(d) || ///
rcap estimateupper estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel( 0.5 1 1.5 2, labsize(small) valuelabel) yscale(range(0 2) titlegap(3)) ytitle("HF without aCVD", size(medsmall)) xscale(range(0 170)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" /*124 "Missing"*/ 132 "IMD 5" 139 "4" 146 "3" 153 "2" 160 "IMD 1", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off) 

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab4_fig.gph", replace

* now with log y axis
/*
graph twoway line dum2_log dum1, color(blue) || ///
scatter log_estimatepoint index, color(gs0) msymbol(d) || ///
rcap log_estimateupper log_estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel(-3.47 "0.03" -2.77 "0.06" -2.07 "0.13" -1.38 "0.3" -0.693 "0.5" 0 "1"  0.69 "2" 1.386 "4", labsize(tiny) valuelabel) yscale(range(-3.5 1.5) titlegap(3)) ytitle("aCVD and HF", size(medsmall)) xscale(range(0 175)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" 124 "Missing" 139 "IMD 1" 146 "2" 153 "3" 160 "4" 167 "IMD 5", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off)

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab4_fig_log.gph", replace
*/

***** now table 5 estimates

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Figures_raw_data.dta", clear

keep F5_*

gen name = ""
replace name = "point" if _n == 1
replace name = "lower" if _n == 2
replace name = "upper" if _n == 3
order name

reshape long F5_, i(name) j(type) string

sort type name
rename F5_ estimate

reshape wide estimate, i(type) j(name) string

gen index = 10 if type == "agegroup_0"
replace index = 17 if type == "agegroup_40"
replace index = 24 if type == "agegroup_50"
replace index = 31 if type == "agegroup_60"
replace index = 38 if type == "agegroup_70"
replace index = 45 if type == "agegroup_80"
replace index = 52 if type == "agegroup_90"

replace index = 67 if type == "gender1"
replace index = 74 if type == "gender2"

replace index = 89 if type == "eth1"
replace index = 96 if type == "eth2"
replace index = 103 if type == "eth3"
replace index = 110 if type == "eth4"
replace index = 117 if type == "eth5"
*replace index = 124 if type == "eth6"

replace index = 132 if type == "imd1"
replace index = 139 if type == "imd2"
replace index = 146 if type == "imd3"
replace index = 153 if type == "imd4"
replace index = 160 if type == "imd5"


gen dum1 = .
gen dum2 = .
replace dum1 = 0 if _n == 1
replace dum1 = 175 if _n == 2

replace dum2 = 1 if _n == 1
replace dum2 = 1 if _n == 2

gen dum2_log = ln(dum2)

gen log_estimatepoint = ln(estimatepoint)
gen log_estimateupper = ln(estimateupper)
gen log_estimatelower = ln(estimatelower)

graph twoway line dum2 dum1, color(blue) || ///
scatter estimatepoint index, color(gs0) msymbol(d) || ///
rcap estimateupper estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel( 0.5 1 1.5 2, labsize(small) valuelabel) yscale(range(0 2) titlegap(3)) ytitle("HF and aCVD", size(medsmall)) xscale(range(0 170)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" /*124 "Missing"*/ 132 "IMD 5" 139 "4" 146 "3" 153 "2" 160 "IMD 1", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off) 

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab5_fig.gph", replace



***** now table 6 estimates

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Figures_raw_data.dta", clear

keep F6_*

gen name = ""
replace name = "point" if _n == 1
replace name = "lower" if _n == 2
replace name = "upper" if _n == 3
order name

reshape long F6_, i(name) j(type) string

sort type name
rename F6_ estimate

reshape wide estimate, i(type) j(name) string

gen index = 10 if type == "agegroup_0"
replace index = 17 if type == "agegroup_40"
replace index = 24 if type == "agegroup_50"
replace index = 31 if type == "agegroup_60"
replace index = 38 if type == "agegroup_70"
replace index = 45 if type == "agegroup_80"
replace index = 52 if type == "agegroup_90"

replace index = 67 if type == "gender1"
replace index = 74 if type == "gender2"

replace index = 89 if type == "eth1"
replace index = 96 if type == "eth2"
replace index = 103 if type == "eth3"
replace index = 110 if type == "eth4"
replace index = 117 if type == "eth5"
*replace index = 124 if type == "eth6"

replace index = 132 if type == "imd1"
replace index = 139 if type == "imd2"
replace index = 146 if type == "imd3"
replace index = 153 if type == "imd4"
replace index = 160 if type == "imd5"


gen dum1 = .
gen dum2 = .
replace dum1 = 0 if _n == 1
replace dum1 = 175 if _n == 2

replace dum2 = 1 if _n == 1
replace dum2 = 1 if _n == 2

gen dum2_log = ln(dum2)

gen log_estimatepoint = ln(estimatepoint)
gen log_estimateupper = ln(estimateupper)
gen log_estimatelower = ln(estimatelower)

graph twoway line dum2 dum1, color(blue) || ///
scatter estimatepoint index, color(gs0) msymbol(d) || ///
rcap estimateupper estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel( 0.5 1 1.5 2, labsize(small) valuelabel) yscale(range(0 2) titlegap(3)) ytitle("High CVD risk", size(small)) xscale(range(0 170)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" /*124 "Missing"*/ 132 "IMD 5" 139 "4" 146 "3" 153 "2" 160 "IMD 1", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off) 

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab6_fig.gph", replace



***** now table 7 estimates

use "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\data\Figures_raw_data.dta", clear

keep F7_*

gen name = ""
replace name = "point" if _n == 1
replace name = "lower" if _n == 2
replace name = "upper" if _n == 3
order name

reshape long F7_, i(name) j(type) string

sort type name
rename F7_ estimate

reshape wide estimate, i(type) j(name) string

replace estimatepoint = . if type == "agegroup_70"
replace estimateupper = . if type == "agegroup_70"
replace estimatelower = . if type == "agegroup_70"
replace estimatepoint = . if type == "agegroup_80"
replace estimateupper = . if type == "agegroup_80"
replace estimatelower = . if type == "agegroup_80"
replace estimatepoint = . if type == "agegroup_90"
replace estimateupper = . if type == "agegroup_90"
replace estimatelower = . if type == "agegroup_90"

gen index = 10 if type == "agegroup_0"
replace index = 17 if type == "agegroup_40"
replace index = 24 if type == "agegroup_50"
replace index = 31 if type == "agegroup_60"
replace index = 38 if type == "agegroup_70"
replace index = 45 if type == "agegroup_80"
replace index = 52 if type == "agegroup_90"

replace index = 67 if type == "gender1"
replace index = 74 if type == "gender2"

replace index = 89 if type == "eth1"
replace index = 96 if type == "eth2"
replace index = 103 if type == "eth3"
replace index = 110 if type == "eth4"
replace index = 117 if type == "eth5"
*replace index = 124 if type == "eth6"

replace index = 132 if type == "imd1"
replace index = 139 if type == "imd2"
replace index = 146 if type == "imd3"
replace index = 153 if type == "imd4"
replace index = 160 if type == "imd5"


gen dum1 = .
gen dum2 = .
replace dum1 = 0 if _n == 1
replace dum1 = 175 if _n == 2

replace dum2 = 1 if _n == 1
replace dum2 = 1 if _n == 2

gen dum2_log = ln(dum2)

gen log_estimatepoint = ln(estimatepoint)
gen log_estimateupper = ln(estimateupper)
gen log_estimatelower = ln(estimatelower)

graph twoway line dum2 dum1, color(blue) || ///
scatter estimatepoint index, color(gs0) msymbol(d) || ///
rcap estimateupper estimatelower index, color(gs0) ///
graphregion(color(white)) bgcolor(white) ///
ylabel( 0.5 1 1.5 2, labsize(small) valuelabel) yscale(range(0 2) titlegap(3)) ytitle("Low CVD risk", size(small)) xscale(range(0 170)) ///
xlabel(10 "18-39" 17 "40-49" 24 "50-59" 31 "60-69" 38 "70-79" 45 "80-89" 52 "90-99" 67 "Men" 74 "Women" 89 "White" 96 "Mixed" 103 "Asian" 110 "Black" 117 "Other" /*124 "Missing"*/ 132 "IMD 5" 139 "4" 146 "3" 153 "2" 160 "IMD 1", angle(90) labsize(*0.8) valuelabel) xtitle("") legend(off) 

graph save "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab7_fig.gph", replace



*** combining graphs


graph combine "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab3_fig.gph" "C:\Users\Public\Documents\065_CfG_diabetes\STATA\sglt2i_inequalities\results\tab4_fig.gph", rows(2) ycommon





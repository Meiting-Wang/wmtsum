* Description: output summary statistics to Stata interface, Word and LaTeX
* Author: Meiting Wang, Master, School of Economics, South-Central University for Nationalities
* Email: wangmeiting92@gmail.com
* Created on May 4, 2020


program define wmtsum
version 15.1

syntax [varlist(numeric default=none)] [if] [in] [aw fw/] [using/] [, ///
	replace append Statistics(string) TItle(string) Alignment(string) PAGE(string)]


*--------设置默认格式------------
*Stata界面显示和Word输出默认格式
local N_default_fmt "%11.0f"
local others_default_fmt "%11.3f"

*LaTeX默认输出格式
local N_default_la_fmt "%11.0fc"
local others_default_la_fmt "%11.3fc"

*默认下会输出的统计量(界面、Word、LaTeX)
if "`statistics'" == "" {
	local statistics "N mean sd min max"
}


*--------输入选项不合规的报错信息-------
if ("`replace'`append'"!="")&("`using'"=="") {
	dis "{error:replace or append can't appear when you don't need to output result to a file.}"
	exit
}

if ("`replace'"!="")&("`append'"!="") {
	dis "{error:replace and append can't appear at the same time.}"
	exit
}

if (~ustrregexm("`using'",".tex"))&("`alignment'`page'"!="") { 
	dis "{error:alignment and page can only be used in the LaTeX output.}"
	exit
}


*---------前期语句处理----------
*普通选项语句的处理
if "`varlist'" == "" {
	cap drop _est_* //删除变量_est_*
	qui ds, has(type numeric)
	local varlist "`r(varlist)'"
} //如果没有设定变量，则自动导入所有的数值变量。

if "`weight'" != "" {
	local weight "[`weight'=`exp']"
}

if "`using'" != "" {
	local us_ing "using `using'"
}

if "`title'" == "" {
	local title "Summary statistics"
} //设置默认表格标题

*构建esttab中cells("")内部的语句
//对`statistics'进行预处理
tokenize "`statistics'", parse("()")
local statistics ""
local i = 1
while "``i''" != "" {
	if (mod(`i'+1,4)==0) {
		local `i' = ustrregexra("``i''"," ","-")
	}
	if (mod(`i',4)==0) {
		local `i' "``i'' "
	}
	local statistics "`statistics'``i''"
	local `i' "" //置空`i'
	local i = `i' + 1
}
local statistics = ustrtrim("`statistics'")

//对`statistics'进行正式处理
tokenize "`statistics'"
local i = 1
while "``i''" != "" {
	local inp_`i' "``i''"
	local inp_pure_`i' = ustrregexrf("``i''","\(.*","")
	local `i' "" //将`i'置空
	local i = `i' + 1
} //分解"`statistics'"
local stat_num = `i' - 1 //记录要输出的统计量的总数

local N "count"   //以下几条local下面循环要用；这些也是该命令可以输出的全部统计量
local mean "mean"
local sd "sd"
local min "min"
local median "p50"
local max "max"
local p1 "p1"
local p5 "p5"
local p10 "p10"
local p25 "p25"
local p75 "p75"
local p90 "p90"
local p95 "p95"
local p99 "p99"

local i = 1
local st ""         //界面显示和Word输出中cells("")内部的语句
local stl ""        //LaTeX输出中cells("")内部的语句
local N_pos = -1    //N所在位置的指标

while "`inp_pure_`i''" != "" {
	if ustrregexm("`inp_pure_`i''", "\bN\b") {  
		local N_pos = `i' //记录N统计量所在的位置
	}
	if ustrregexm("`inp_`i''", "\("){
		local fmt = ustrregexrf("`inp_`i''",".*\(","") //将左括号及之前的内容移除
		local fmt = ustrregexrf("`fmt'","\)","") //将右括号移除
		local fmt = ustrregexra("`fmt'","-+"," ") //将"-"号替换成空格
		local st "`st'``inp_pure_`i'''(fmt(`fmt') label(`inp_pure_`i'')) "
		local stl "`stl'``inp_pure_`i'''(fmt(`fmt') label(\multicolumn{1}{c}{`inp_pure_`i''})) "
	}
	else {
		if ustrregexm("`inp_pure_`i''", "\bN\b") {
			local default_fmt "`N_default_fmt'"
			local default_la_fmt "`N_default_la_fmt'"
		}
		else {
			local default_fmt "`others_default_fmt'"
			local default_la_fmt "`others_default_la_fmt'"
		}
		local st "`st'``inp_pure_`i'''(fmt(`default_fmt') label(`inp_pure_`i'')) "
		local stl "`stl'``inp_pure_`i'''(fmt(`default_la_fmt') label(\multicolumn{1}{c}{`inp_pure_`i''})) "
	}
	local i = `i' + 1
}
local st = ustrtrim("`st'")
local stl = ustrtrim("`stl'")

*构建esttab中alignment()和page()内部的语句(LaTeX输出专属)
if "`alignment'" == "" {
	local alignment "math"
} //默认下LaTeX输出的列格式

if "`page'" != "" {
	local page ",`page'"
}

if "`alignment'" == "math" {
	local page "array`page'"
	local alignment "*{`stat_num'}{>{$}c<{$}}"
}
else {
	local page "array,dcolumn`page'"
	if "`N_pos'" == "-1" {
		local alignment "*{`stat_num'}{D{.}{.}{-1}}"
	}
	else if "`N_pos'" == "1" {
		if "`stat_num'" == "1" {
			local alignment ">{$}c<{$}"
		}
		else {
			local alignment ">{$}c<{$}*{`=`stat_num'-1'}{D{.}{.}{-1}}"
		}
	}
	else if "`N_pos'" == "`stat_num'" {
		local alignment "*{`=`stat_num'-1'}{D{.}{.}{-1}}>{$}c<{$}"
	}
	else {
		local alignment "*{`=`N_pos'-1'}{D{.}{.}{-1}}>{$}c<{$}*{`=`stat_num'-`N_pos''}{D{.}{.}{-1}}"
	}
}
//加上array宏包可使得表格线之间的衔接没有空缺


*-------------------------------主程序------------------------------------
eststo clear
qui estpost summarize `varlist' `if' `in' `weight', detail
esttab, cells("`st'") compress ///
	noobs nomti nonum title(`title') //Stata 界面显示 
if ustrregexm("`us_ing'",".rtf") {
	esttab `us_ing', cells("`st'") compress `replace'`append' ///
		noobs nomti nonum title(`title')
} //Word 显示
if ustrregexm("`us_ing'",".tex") { 
	esttab `us_ing', cells("`stl'") compress `replace'`append' ///
		noobs nomti nonum title(`title') ///
		booktabs width(\hsize) page(`page') alignment(`alignment')	 
} //LaTeX 显示
end

{smcl}

{* -----------------------------title------------------------------------ *}{...}
{p 0 16 2}
{bf:[W-1] wmtsum} {hline 2} output summary statistics to Stata interface, Word as well as LaTeX. The source code can be gained in {browse "https://github.com/Meiting-Wang/wmtsum":github}.


{* -----------------------------Syntax------------------------------------ *}{...}
{title:Syntax}

{p 8 8 2}
{bf:wmtsum} [{it:varlist}] [{it:if}] [{it:in}] [{it:weight}] [using {it:filename}] [, {it:options}]

{p 4 4 2}
where the subcommands can be :

{p2colset 5 20 24 2}{...}
{p2col :{it:subcommand}}Description{p_end}
{p2line}
{p2col :{opt {help varlist}}}a list of numeric variables, all numeric variables as the defaut{p_end}
{p2col :{opt {help weight}}}can choose one of {bf:fweight} and {bf:aweight}, empty as the default{p_end}
{p2col :{opt {help using}}}output the result to Word with .rtf file or LaTeX with .tex file{p_end}
{p2line}
{p2colreset}{...}


{* -----------------------------Contents------------------------------------ *}{...}
{title:Contents}

{p 4 4 2}
{help wmtsum##Description:Description}{break}
{help wmtsum##Options:Options}{break}
{help wmtsum##Examples:Examples}{break}
{help wmtsum##Author:Author}{break}
{help wmtsum##Also_see:Also see}{break}


{* -----------------------------Description------------------------------------ *}{...}
{marker Description}{title:Description}

{p 4 4 2}
{bf:wmtsum}, based on esttab, can output summary statistics to Stata interface, Word as well as LaTeX. User can use this command easily due to its simple syntax. It is worth noting that this command can only be used in version 15.1 or later.

{p 4 4 2}
Users can also append the output from {bf:wmtsum} to other word or LaTeX document,
which is more likely to be generated by {help wmttest}, {help wmtcorr}, {help wmtreg} and {help wmtmat}.


{* -----------------------------Options------------------------------------ *}{...}
{marker Options}{title:Options}

{p2colset 5 28 32 2}{...}
{p2col :{it:option}}Description{p_end}
{p2line}
{p2col :For all}{p_end}
{p2col :{space 2}{opth s:tatistics(strings:string)}}{bf:N}, {bf:mean}, {bf:sd}, {bf:min}, {bf:median}, {bf:max}, {bf:p1}, {bf:p5}, {bf:p10}, {bf:p25}, {bf:p75}, {bf:p90}, {bf:p95} and {bf:p99} can be included, and you can set the format of every statistics, such as mean(%9.3f){p_end}
{p2col :{space 2}{opth ti:tle(strings:string)}}Set the title for the table, {bf:summary statistics} as the default{p_end}
{p2col :{space 2}{opt replace}}Replace a file if it already exists{p_end}
{p2col :{space 2}{opt append}}Append the result to a already existed file{p_end}

{p2col :For LaTeX only}{p_end}
{p2col :{space 2}{opth a:lignment(strings:string)}}Format the table columns in LaTeX, but it will not have influence on the Stata interface. {bf:math} or {bf:dot} can be included, {bf:math} as the default{p_end}
{p2col :{space 2}{bf:page(}{it:{help strings:string}}{bf:)}}Set the extra package for the LaTeX. Don't need to care about the package of booktabs, array and dcolumn, because option {bf:alignment} will deal with it automatically{p_end}
{p2line}
{p2colreset}{...}


{* -----------------------------Examples------------------------------------ *}{...}
{marker Examples}{title:Examples}

{p 4 4 2}Setup{p_end}
{p 8 8 2}. {stata sysuse auto.dta, clear}{p_end}

{p 4 4 2}Output summary statistics of all numeric variables{p_end}
{p 8 8 2}. {stata wmtsum}{p_end}

{p 4 4 2}Output summary statistics of specified variables{p_end}
{p 8 8 2}. {stata wmtsum price rep78 foreign weight}{p_end}

{p 4 4 2}Output summary statistics of specified statistics and numeric format{p_end}
{p 8 8 2}. {stata wmtsum price rep78 foreign weight, s(N sd(%9.3f) min(%9.2f) max(%9.2f))}{p_end}

{p 4 4 2}Add a custom title to the table{p_end}
{p 8 8 2}. {stata wmtsum price rep78 foreign weight, ti(This is a custom title)}{p_end}

{p 4 4 2}Output the result to a .rtf file{p_end}
{p 8 8 2}. {stata wmtsum price rep78 foreign weight using Myfile.rtf, replace}{p_end}

{p 4 4 2}Output the result to a .tex file{p_end}
{p 8 8 2}. {stata wmtsum price rep78 foreign weight using Myfile.tex, replace}{p_end}

{p 4 4 2}Format table column in LaTeX to decimal point alignment{p_end}
{p 8 8 2}. {stata wmtsum price rep78 foreign weight using Myfile.tex, replace a(dot)}{p_end}


{* -----------------------------Author------------------------------------ *}{...}
{marker Author}{title:Author}

{p 4 4 2}
Meiting Wang{break}
School of Economics, South-Central University for Nationalities{break}
Wuhan, China{break}
wangmeiting92@gmail.com


{* -----------------------------Also see------------------------------------ *}{...}
{marker Also_see}{title:Also see}

{space 4}{help wmttest}(already installed) {col 40}{stata github install Meiting-Wang/wmttest:install wmttest}(to install)
{space 4}{help wmtcorr}(already installed) {col 40}{stata github install Meiting-Wang/wmtcorr:install wmtcorr}(to install)
{space 4}{help wmtreg}(already installed)  {col 40}{stata github install Meiting-Wang/wmtreg:install wmtreg}(to install)
{space 4}{help wmtmat}(already installed)  {col 40}{stata github install Meiting-Wang/wmtmat:install wmtmat}(to install)

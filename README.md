# Stata新命令：wmtsum——描述性统计表格的输出

> 作者：王美庭  
> Email: wangmeiting92@gmail.com

## 摘要
本文主要介绍了个人编写的可将描述性统计结果输出至Stata界面、Word以及LaTeX的`wmtsum`命令。


## 目录

&emsp;&emsp;**摘要**  
&emsp;&emsp;**一、引言**  
&emsp;&emsp;**二、为何要使用`wmtxxx`命令**  
&emsp;&emsp;**三、命令的安装**  
&emsp;&emsp;**四、语法与选项**  
&emsp;&emsp;**五、实例**  
&emsp;&emsp;**六、输出效果展示**  

## 一、引言

自从我的推文[Stata：毕业论文大礼包 C——新版 esttab](https://mp.weixin.qq.com/s/wX4_v6HjAoh6l42W4Yn3tA)在连享会发布之后，不少同学发邮件给我说是无法下载命令，以及没有帮助文件。基于此，本人花了很多心血，解决了以上问题（书写了对应命令的帮助文件；将代码托管于GitHub中，简化了命令安装流程（参见下文））。

在此需要说明的是，这些命令之后将由我本人全程托管。本文以及后续文章命令的名称将会有所变化，分别为：`wmtsum`对应`lxhsum`；`wmttest`对应`lxhttest`；`wmtcorr`对应`lxhcorr`；`wmtreg`对应`lxhreg`；`wmtmat`对应`lxhmat`。在此感谢中山大学连玉君老师对于这些命令的认可。

为了文章的简洁性，我将按照**一个命令一篇文章**的形式进行阐述，这篇文章所涉及到的命令为`wmtsum`，后续命令`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`也会逐渐推出。在这之后，`matmh`命令也会被正式推出。目前计划大体是这样。

> 后文的`wmtxxx`代指命令`wmtsum`、`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`集合。


## 二、为何要使用`wmtxxx`命令

现有很多相关的输出命令，但或许多多少少不让我们满意，有些只能输出到Word而无法输出到Stata界面和LaTeX，而有些甚至在格式上还需自己后续手动调整（如多出的额外的空行，表格内容的错位）。而**`esttab`由于其功能的完整性，支持描述性统计、分组T均值检验、相关系数矩阵、回归结果以及矩阵在Stata界面、Word和LaTeX的输出**，堪称完美，但是由于其语句的复杂性让很多同学望而却步。基于此，个人根据`esttab`内核，编写了语法更加简洁的`wmtxxx`系列命令，以尽量使得大家能在更短的语句中，实现`esttab`全面的功能。

本文主要阐述的`wmtsum`命令，和后期将推出`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`命令，都可以通过`append`选项将结果输出到一个Word或LaTeX文件（无需手动修改，可直接编译）中，将大幅度节省工作量。

事实上，`esttab`输出命令默认也会夹带多余的空行，而修正后的`wmtxxx`无此问题。

`esttab`输出命令将结果导出到Word或LaTeX时，Stata界面将不会显示结果。此时如果我们要去查看结果，还要额外打开对应的文件（或运行额外的命令），这明显降低了效率。而本文的`wmtsum`（以及`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`）在将结果导入到Word或LaTeX后，本身Stata界面也会呈现对应的结果（也就是说，无论有无结果导出，Stata界面都会呈现相应的结果）。


## 三、命令的安装

`wmtsum`命令以及后续其他命令的代码都将托管于GitHub上，以使得同学们可以随时下载安装这些命令。

首先你需要有`github`命令，如果没有，你可以运行以下命令安装最新的`github`命令。
```stata
net install github, from("https://haghish.github.io/github/")
```

然后你就可以运行以下命令安装最新的`wmtsum`命令以及对应的帮助文件了。
```stata
github install Meiting-Wang/wmtsum
```

当然，你也可以`github search`一下，也能找到`wmtsum`命令安装的入口：
```stata
github search wmtsum
```


## 四、语法与选项

**命令语法**：
```stata
wmtsum [varlist] [if] [in] [weight] [using filename] [, options]
```

> - varlist: 仅可输出数值型变量，若为空，则自动导入所有数值型变量。
> - weight: 可以选择fweight或aweight，默认为空。
> - using: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）中。

**选项（options）**：
- 一般选项
	- `statistics()`：括号中可输入：`N mean sd min median max p1 p5 p10 p25 p75 p90 p95 p99`。默认为：`N mean sd min max`。当然，我们还可以为每一个统计量设定不同的数值格式，如：`N(%11.0f) mean(%11.3f) sd(%11.3f) min(%11.3f) max(%11.3f)`。
	- `title()`：设置表格标题，默认为：`Summary statistics`。
	- `replace`：将结果输出至Word或LaTeX时，替换现有的文件（若文件已存在）
	- `append`：将结果输出至Word或LaTeX时，附加在现在的文件中（若文件已存在）
- LaTeX专有选项
	- `alignment()`：设置LaTeX表格的列对齐格式，可输入`math`或`dot`，`math`设置列格式为居中对齐的数学格式（自动添加宏包`booktabs`和`array`），`dot`表示小数点对齐的数学格式（自动添加宏包`booktabs`、`array`和`dcolumn`）。默认为`math`。
	- `page()`：可添加额外用户需要的宏包。

> 以上选项大部分都可以缩写，如`statistics()`可以缩写为`s()`，详情可以`help wmtsum`。


## 五、实例

```stata
* 描述性统计结果输出的实例
sysuse auto.dta, clear
wmtsum //自动导入所有的数值型变量
wmtsum price rep78 foreign weight //导入特定的数值型变量
wmtsum price rep78 foreign weight, s(N sd(%9.3f) min(%9.2f) max(%9.2f)) //指定要报告的统计量及其对应的数值格式
wmtsum price rep78 foreign weight, ti(This is a custom title) //设置自定义表格标题
wmtsum price rep78 foreign weight using Myfile.rtf, replace //将描述性统计结果导出到Word中
wmtsum price rep78 foreign weight using Myfile.tex, replace //将描述性统计结果导出到LaTeX中
wmtsum price rep78 foreign weight using Myfile.tex, replace a(dot) //设置LaTeX表格列格式为小数点对齐
```

> 以上所有实例都可以在`help wmtsum`中直接运行。
> ![image](https://user-images.githubusercontent.com/42256486/81039260-1c2e4d80-8edb-11ea-83bd-61d304f58b53.png)


## 六、输出效果展示

- **Stata**

```stata
wmtsum price rep78 foreign weight
```

```stata
Summary statistics
------------------------------------------------------------
                   N      mean        sd       min       max
------------------------------------------------------------
price             74  6165.257  2949.496  3291.000 15906.000
rep78             69     3.406     0.990     1.000     5.000
foreign           74     0.297     0.460     0.000     1.000
weight            74  3019.459   777.194  1760.000  4840.000
------------------------------------------------------------
```

- **Word**

```stata
wmtsum price rep78 foreign weight using Myfile.rtf, replace
```

![image](https://user-images.githubusercontent.com/42256486/81039394-7a5b3080-8edb-11ea-9af4-a92b940f4c33.png)

- **LaTeX**

```stata
wmtsum price rep78 foreign weight using Myfile.tex, replace
```

![image](https://user-images.githubusercontent.com/42256486/81039467-ae365600-8edb-11ea-9667-12b4bb08abcb.png)

```stata
wmtsum price rep78 foreign weight using Myfile.tex, replace a(dot)
```

![image](https://user-images.githubusercontent.com/42256486/81039862-ac20c700-8edc-11ea-8d7d-561b328b6479.png)

> 如前文所述，在将结果输出Word或LaTeX时，Stata界面上也会呈现对应的结果，以方便查看。
# Stata新命令：wmtsum——描述性统计表格的输出

> 作者：王美庭  
> Email: wangmeiting92@gmail.com


## 引言

自从我的推文[Stata：毕业论文大礼包 C——新版 esttab](https://mp.weixin.qq.com/s/wX4_v6HjAoh6l42W4Yn3tA)在连享会发布之后，不少同学发邮件给我说是无法下载命令，以及没有帮助文件，在此感谢各位同学们的关注和建议。基于此，这篇文章以及后续的文章将解决以上问题。

在此需要说明的是，这些命令之后将全程由我本人托管。本文以及后续的文章命令的名称将会有所变化，分别为：`lxhsum`对应`wmtsum`；`lxhttest`对应`wmttest`；`lxhcorr`对应`wmtcorr`；`lxhreg`对应`wmtreg`；`lxhmat`对应`wmtmat`。在此感谢中山大学连玉君老师对于我书写的这些命令的认可。

为了文章的简洁性，我将按照一个命令一篇文章的形式进行阐述，这篇文章所涉及到的命令为`wmtsum`，后续命令`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`也会逐渐推出。在这之后，`matmh`命令也会被正式推出。目前计划大体是这样。


## 为何要使用`wmtsum`命令

现有很多相关的输出命令，但或许多多少少不让我们满意，有些只能输出到Word而无法输出到Stata界面和LaTeX，而有些甚至在格式上还需自己后续手动调整（如多出的额外的空行，表格内容的错位）。**`esttab`由于其完整性，支持描述性统计、分组T均值检验、相关系数矩阵、回归结果以及矩阵在Stata界面、Word和LaTeX的输出**，但是由于其语句的复杂性让很多同学望而却步。本文的`wmtsum`正是基于`esttab`对于描述性统计输出的语法，目的在于简化原本`esttab`复杂的语法的同时，兼具`esttab`本身的优势。

本身`wmtsum`命令，和后期将推出的基于`esttab`编写的其他输出命令（`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`），都可以通过`append`选项将结果输出到一个Word文件或LaTeX文件（无需手动修改，可直接编译）中，将大幅度节省工作量。

`esttab`输出命令默认也会夹带多余的空行，而修正后的`wmtsum`（以及`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`）没有这个问题。

`esttab`输出命令将结果导出到Word或LaTeX时，Stata界面将不会显示结果。此时如果我们要去查看结果，还要额外打开对应的文件。这明显降低了效率，而本文的`wmtsum`（以及`wmttest`、`wmtcorr`、`wmtreg`和`wmtmat`）在将结果导入到Word或LaTeX后，本身Stata界面也会呈现对应的结果（也就是说，无论有无结果导出，Stata界面都会呈现相应的结果）。


## 命令的安装

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


## 语法与选项

**命令语法**：
```stata
wmtsum [varlist] [if] [in] [weight] [using filename] [, options]
```

> - varlist: 仅可输出数值型变量，若为空，则自动导入所有数值型变量。
> - weight: 可以选择fweight或aweight，默认为空。
> - using: 可以将结果输出至 Word（ .rtf 文件）和 LaTeX（ .tex 文件）中。

**选项（options）**：
- 一般选项
	- `statistics()`：可以输入的全部统计量有：`N mean sd min median max p1 p5 p10 p25 p75 p90 p95 p99`。若为空，则默认输入`N mean sd min median max`。Stata 界面和 Word 输出格式默认为`%11.0f`（`N`）和`%11.3f`（除`N`以外的统计量），LaTeX 输出格式默认为`%11.0fc`（`N`）和`%11.3fc`（除`N`以外的统计量）。当然，我们也可以自行设置，如输入`N sd(3) min(%9.2f) p99(%9.3fc)`。
	- `title()`：设置表格标题，若为空，则默认为`Summary statistics`。
	- `replace`：若已存在相同文件名，则替换之。
	- `append`：若已存在相同文件名，则附加之。
- LaTeX专有选项
	- `alignment()`：LaTeX 输出专属选项，用于设置列格式，可输入`math`或`dot`。`math`表示设置列格式为传统的数学格式（`>{$}c<{$}`），并自动添加宏包`booktabs`和`array`。`dot`表示设置列格式为小数点对齐的数学模式（`D{.}{.}{-1}`），并自动添加添加宏包`booktabs`、`array`和`dcolumn`。若为空，则默认为`math`。
	- `page()`：LaTeX 输出专属选项，除了`alignment()`选项自动添加的宏包，该选项还可以添加额外的宏包。

> 以上选项大部分都可以缩写，如`statistics()`可以缩写为`s()`，详情可以`help wmtsum`。


## 实例

```stata
sysuse nlsw88.dta, clear
wmtsum //输出所有数值型变量的描述性统计
wmtsum wage age race hours //报告所输入变量的描述性统计
wmtsum wage age race hours, s(N sd(3) min(%9.2f) p99(%9.3fc)) //报告指定统计量和指定数值格式的描述性统计
wmtsum wage age race hours, s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) //为表格添加自定义标题
wmtsum wage age race hours using Myfile.rtf, replace s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) //将结果导入到Word文件中
wmtsum wage age race hours using Myfile.tex, replace s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) //将结果导入到LaTeX中
wmtsum wage age race hours using Myfile.tex, replace s(N sd(3) min(%9.2f) p99(%9.3fc)) ti(this is a title) a(dot) //将结果导入到LaTeX中，并将LaTeX表格的列格式调为dot
```

> 以上所有实例都可以在`help wmtsum`中直接运行。
> ![image](https://user-images.githubusercontent.com/42256486/80948546-ea5aaf80-8e24-11ea-840f-4f14f9c74b42.png)


## 默认效果图

**所用代码**：
```stata
wmtsum wage age race hours
wmtsum wage age race hours using Myfile.rtf, replace
wmtsum wage age race hours using Myfile.tex, replace
```

**效果展示**：
- Stata
```stata
Summary statistics
------------------------------------------------------------
                   N      mean        sd       min       max
------------------------------------------------------------
wage            2246     7.767     5.756     1.005    40.747
age             2246    39.153     3.060    34.000    46.000
race            2246     1.283     0.475     1.000     3.000
hours           2242    37.218    10.509     1.000    80.000
------------------------------------------------------------
```

- Word

![image](https://user-images.githubusercontent.com/42256486/80947075-fb55f180-8e21-11ea-9f7b-a71d45ee5509.png)

- LaTeX

![image](https://user-images.githubusercontent.com/42256486/80947947-c2b71780-8e23-11ea-920a-975314d55a82.png)

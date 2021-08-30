
### ffmpeg filter
#### filter 符号
```text
ffmpeg -i INPUT -vf "filter text" OUTPUT
ffmpeg -i INPUT -af "filter text" OUTPUT
```
一个filterChain由一队连接的过滤器组合而成，每一个过滤器链接前面的过滤器，<br>
通过“，”分割开来。一个filterGraph由一系列的filterChain组成，通过“；”分<br>
号分割开来。<br>
<br>
一个过滤器是如下形式的字符串：[in_link_1]...[in_link_N]filter_name@id<br>
=arguments[out_link_1]...[out_link_M]。其中使用“：”分割arguments，<br>
分割的可以是键值对key=value,单独的value,或者二者的混合。<br>
<br>
如果某个选项的值是多个可以使用“|”分割。<br>
<br>
可以使用“'”单引号作为开始和结束的标志。可以使用“\”来转义引号中的内容。<br>
<br>
filterGraph中同一个名字的链接标志，相应的输入和输出之间的链接被创建。如果输<br>
出没有被打标签，下一个过滤器的第一个无标签化的输入将链接到该未标签化输出。在一<br>
个完整filterChain中，所有未标签化的输入和输出必须是连通的。一个filterGraph<br>
被认为是有效的前提是，所有的过滤器的输入和输出是连通的。<br>

在过滤器的描述中，首个过滤器没有指定input标签的，假定是Input.最后一个过滤器没<br>
有指定out标签的，假定是Output.<br>
<br>

```text
NAME 由字母 数字和下划线组成。
FILTER_NAME 是 NAME["@"NAME]
LINKLABEL是[NAME]
LINKLABELS是LINKLABEL[LINKLABELS]
FILTER_ARGUMENTS是字符串
FILTER是[LINKLABELS]FILTER_NAME[“=”FILTER_ARGUMENTS][LINKLABELS]
FILTERCHAIN是FILTER[,FILTERCHAIN]
FILTERGRAPH是[sws_flags=flags]FILTERCHAIN[;FILTERGRAPH]
```

#### filtergrah中的转义
需要转义的字符包括逗号，分号，冒号，斜杠，方括号，引号，这些要特别注意。

```text
this is a 'string':may contain one,or more,special charaters
text=this is a \'string\'\:may contain one,special characters
drawtext=text=this is a \\\'string\\\'\\\:may contain one\,special characters
-vf "drawtext=text=this is a \\\\\\\'string\\\\\\\'\\\\\\\:may contain one\\\,special characters"
```

#### 时间基线编辑
一些过滤器支持通用的可开启选项，对于支持时间基线编辑的过滤器，在帧数据发给过滤器之前<br>
该选项（时间基线）可以设置到表达式中。如果表达式执行结果为非零值，过滤器生效该选项。<br>
否则不生效。表达式接受一下值：
<br>
t 时间戳，单位是秒。<br>
n 输入帧数据的序号。<br>
pos 帧数据在文件中的位置。<br>
w h 输入帧数据的宽和高（视频的情况）<br>

#### 若干输入的过滤输入选项
主要包括一下选项
eof_action 如果次级的输入遇到EOF的时候，eof_action选项的值可以由一下三种：<br>
    1. repeat 重复最后的一帧<br>
    2. end all 结束所有的流<br>
    3. pass 传入主要的输入 <br>
shortest 默认值是0；当设置为1的时候，当最短的输入结束的时候，强制结束输出。<br>
repeatlast 默认值是1；当值为1的情况下，强制复制次级输入的最后一帧直到主要输<br>
入流结束。设置为0会禁掉以上行为。
#### filter 实例分析
```text
ffmpeg -i INPUT -vf "split [main][tmp];[tmp]crop=iw:ih/2:0:0,vflip
    [flip];[main][flip]overlay=0:H/2" OUTPUT
```
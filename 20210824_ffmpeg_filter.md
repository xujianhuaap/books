
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
有指定out标签的，假定是Output.


#### filer 实例分析
```text
ffmpeg -i INPUT -vf "split [main][tmp];[tmp]crop=iw:ih/2:0:0,vflip
    [flip];[main][flip]overlay=0:H/2" OUTPUT
```
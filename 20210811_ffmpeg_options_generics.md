### ffmpeg选项
####选项简介
<li>视频选项

|选项|选项简称|描述|
|:---:|:---:|:---:|
|-vframes number|-|输出视频的帧数到output|
|-r number |-|帧率，单位是赫兹,帧率越大越流畅|
|-s size|-|每帧的大小|
|-aspect value|-|高宽比例16:9;4:3;1.333;1.777|
|-b rate|-b:v|视频比特率，值越大视频质量越高，越清晰|
|-ab rate|-b:a|音频比特率|
|-vn |-|禁止视频|
|-dn|-|禁止data|
|-vf filter_graph|-|视频过滤|
|-vcodec codec|-|强制使用codec 复制视频流|
|-bits_per_sample number|-|设置每个采样的位数|
<li> 音频选项

|选项|选项简称|描述|
|:---:|:---:|:---:|
|-aframes number|-|输出到output的音频帧数|
|-ar number|-|设置音频采样率|
|-aq quality|-|设置音频质量|
|-ac number|-|设置音频信道数量|
|-an|-|禁止音频|
|-acodec codec|-|强制使用codec复制音频流|
|-vol volume|-|音量大小|
|-af filter_graph|-|过滤音频|
<li>字幕选项

|选项|描述|
|:---:|:---:|
|-s size|字幕的帧大小|
|-sn |禁止字幕|
|-scodec codec|强制使用codec复制字幕流|
|-canvas_size size|设置字幕字体的大小|
|-fix_sub_duration|修改字幕的时长|
|-spre preset|设置字幕选项为指定的预设|


#### 一般配置选项
|选项|描述|
|:---:|:---:|
|-formats|详解如下,列出所有的可用的muxers和demuxers|
|-demuxers|可用的拆包器|
|-muxers|可用的分包器|
|-devices|可用的设备|
|-filters|可用的过滤|
|-codecs|可用的codecs，媒体字节流格式的缩写|
|-decoders|可用的解码器|
|-coders|可用的编码器|
|-bsfs|可用的字节流过滤器|
|-pix_fmts|展示可用像素格式|
|-layouts|可用的信道|
|-sample_fmts|音频可用的采样格式|
|-hwaccels|支持的硬件加速方法|
|-sources deveice|列出输入设备的资源|
|-sinks device|列出输出设备的sinks|


```text
ffmpeg -codecs 
 D..... = Decoding supported
 .E.... = Encoding supported
 ..V... = Video codec
 ..A... = Audio codec
 ..S... = Subtitle codec
 ...I.. = Intra frame-only codec（帧内编码）
 ....L. = Lossy compression(有损压缩)
 .....S = Lossless compression(无损压缩)

```
|支持情况|codec|描述|
|:---:|:---:|:---:|
|D.V.L|4xm|4x电影|
|DEVIL|amv|amv视频|


```text
ffmpeg -formats
列出所有可用的组装器(muxer)和分包器(demuxer)
下面的表格只是列出常用的
```
|demuxer|muxer|demuxer/muxer|
|:---:|:---:|:---:|
|aa|adts|ac3|
|aac|dvd|amr|
|acm|ipod|amrnb|
|act|-|amrwb|
|asf_o|asf_stream|asf|
|-|-|ass|
|-|-|ast|
|-|-|avi|
|-|-|dts|
|-|-|dsf|
|-|-|flac|
|-|-|gif|
|-|-|h264|
|-|-|lrc|
|-|mp4|mp3|
|-|-|mpeg|
|-|-|wav|

```text
ffmpeg -sample_fmts
每一个像素在计算机中所使用的这种位数就是“位深度”

```
|name|depth|
|:---:|:---:|
|u8|8|
|s16|16|
|s32|32|
|flt|32|
|dbl|64|
|u8p|8|
|s16p|16|
|s32p|32|
fltp|32|
dblp|64|
|s32|32|
s64|64|
#### AVOPtions
这些选项由libavformat libavdevice libavcodec三个库提供。
<li>一般选项
这些选项可以设置到任何的container，device,codec上。在AVFormatContext中的选项<br>
用于设置到container,device；在AVCodecContext中的选项用于设置到codec；
<li>私有选项
这些私有选项设置到特定的container/device/codec上

```text
ffmpeg -i input.flac -id3v2_version 3 output.mp3
mp3（container）使用id3v2.3来代替默认的id3v2.4.id3v2_version是MP3的私有选项。
```
```text
ffmpeg -i multichannel.mxf -map 0:v:0 -map 0:a:0 -map 0:a:0 -c:a:0 
    ac3 -b:a:0 640k -ac:a:1 2 -c:a:1 aac -b:2 128k out.mp4

out.mp4这个文件（容器）中将会出现两个音频流，第一个是acc3编码的，比特率为640k。
第二个音频流为aac编码的，音频信道数量为2个，比特率为128k.值得注意的是-b:2这个2
是指output.mp4文件中第三个流。
-map 0:v:0 表示第一个输入文件的第一个视频流
-c:a:0 ac3 表示输出到output的第一个音频流使用ac3这种编码方式
-b:a:0 640K 表示输出到output的第一个音频流比特率为640k


-b:2 表示输出到output的第三个流比特率为128k
```
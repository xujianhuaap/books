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






#### 一般配置选项
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

```
### ffmpeg basic concept
#### demuxer/muxer
本章节主要描述libavformat库所支持的muxers和demuxers。<br>
libavformat这个库提供了一些可以设置在muxers和demuxers全局的选项。每一个对应的<br>
muxer/demuexer都有自己的私有选项。<br>
<br>
Demuxers可以读取特定类型文件中的对媒体流。根据文件类型选择特定的demuxers；例如aa<br>
对应的demuxer，是专门针对.aa这种音频文件的。
#### codec　选项
libavcodec这个库主要提供了一些设置在coder和decoder上的全局选项。对于每一个特定<br>
选项的值设置可以通过ffmpeg这个工具，也可以通过AVCodecContext中的选项进行设置。
#### device选项
libavdevice库提供和libavaformat一样的接口。从字义上讲一个输出设备类似一个muxer，<br>
一个输入设备类似一个demuxer。<br>
<br>
ALSA(Advanced Linux Sound Architecture) input device<br>
为了使用这个设备，你需要你的系统安装了libasound这个库。<br>
<br>
android_camera
该输入设备使用android Camera2 NDK(sdk 24之后才有)。该输入设备允许你捕获图片从<br>
android设备上的所有摄像头。
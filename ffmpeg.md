####　ffmpeg学习
#### 纲要
    ffmpeg [gloabl options] {[input_file_options] -i input_url} {[output_file_options] output_url}
#### 描述
    ffmpeg 是一款非常快捷的视频音频转换器，也可以从播放的音视频资源抓取．
    ffmpeg,可以读取任意数量的输入文件（常规媒体文件，管道流，网络流，收集设备），通过　-i选项指定.并且写到任意数量的
    输出文件，由output_url指定．原则上来讲，每一个input_url或者output_url可以包含任意数量的不同类型的流．例如video
    ,audio,subtitle,attachment,data.允许的数量和流的类型由容器格式决定．那个输入的流进入到那个输出，要么自动完成，
    要么通过-map 选项设置．
    
    不要混淆输入和输出文件，先指定输入文件，在指定所有的输出文件．不要混淆属于不同文件的选项，所有的选项只针对紧挨着的输入
    或者输出文件．其他文件选项是被重置的．
    
    使用用例
    ffmepg -i input.avi -b:v 64k -bufsize 64k output.avi
    
    ffmepg -i inputavi -r 24 output.avi //每秒２４帧
    
    ffmeng -r 1 -i input.m2v -r 24 output.avi
#### 详细描述
    ffmepg转码的过程具体如下：
    ffmepg调用libavformat库（包含demuxers)读取input_fles,拿到压缩后的数据（packet).当读取多个input_file的时候，
    在激活的输入流中，ffmepg试图通过记录最早的时间戳来保持输入多个文件的同步．压缩后的数据（packet)交给解码器，解码器产
    出原始的数据Frames（raw video/PCM audio),这些原始数据frames,可以被过滤器处理，处理之后可以传递给编码器，生成
    压缩后的数据packet,编码后的数据交给muxers,输出到output_file.
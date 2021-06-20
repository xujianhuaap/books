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
#### filering(过滤)
    在编码之前，通过libavfilter库的filters的使用，ffmpeg可以处理原始的音频和视频数据（Frames)．若干个链式的filters
    组成一个过滤图．ffmpeg区分两种顾虑图，复杂的和简单的．简单的是有明确的输入输出，并且类型一致．简单的过滤图以每个流的
    -filter选项的形式配置．-vf表示是视频过滤，-af表示是音频过滤．值得注意的是，一些过滤只是改变流的属性，而非内容．例如
    fps 过滤器只是改变帧的数量．setpts过滤器只是设置时间戳．
    
    复杂的过滤图．使用-filter_complex 选项来配置复杂的过滤．-lavfi 等同-filter_complex.复杂过滤选项是全局的，不能
    适用单个输出流或者时候输出文件．复杂过滤的例子是overlay（覆盖）过滤选项,两个视频输入和一个视频输出．一个视频会覆盖在
    另一个视频上．音频部分是amix过滤选项．
    
    对于不携带lable的复杂过滤的输出流,会添加到第一个输出文件中.在没有设置map选项的时候,由于输出文件的格式限制,不支持复杂
    过滤产生的输出流类型,会导致致命错误.在使用-map选项的时候,map指定的流和复杂过滤的输出流都会包含在输出的文件中.
    
    对于携带lable的复杂过滤输出流,必须设置map,而且只能设置map一次.

    

#### stream copy(流的复制)
    Stream复制通过-codec这个选项配置为copy, 这样ffmepg会忽略解码和编码的步骤，只是把数据读取出来，再输出到
    out_put_file.该模式下不能使用filters,因为filters只针对原始数据有效．
#### stream selection(流的选择)
    ffmpeg提供了 -map选项,以便人为控制在每个输出文件内的流的选择.用户可以省略-map选项,这种情况下,ffmpeg自动进行流的
    选择.-vn/ -an/-sn/-dn/用于分别表示忽略视频流,音频流,字幕流,数据流.但不能忽略复杂过滤图中的输出流.
    
    流自动选择,对于一个输出文件没有任何-map的设置,ffmpeg检视输出的格式,来核查用哪种流的类型,例如video,audio,subtitles.
    对于可接受的类型,ffmpeg会从所有输入当中选择一个可用的流.基于一下规则:
    1> 对于video ,选择高分辨率的流
    2> 对于audio, 选择声道最多的流
    3> 对于subtitles(字幕),选择第一个发现的字幕流.输出格式的默认字幕编码器可以是基于文本的,也可是基于图像的,只有和字幕流
    类型一致的,才可以被选择.
    少数情况下同一种类型的流被选择机会相等,就选择索引值比较小的.
    对于data这种数据流不能自动选择,只能使用-map人为控制.
    
    人为控制选择.当-map选项使用的时候,只有用户配置的流才可能包含在输出文件中.复杂的过滤可能是一个意外.对于带标签的复杂的过
    滤输出流,必须使用人为控制,并且要一次精确控制.对于没有标签的复杂过滤输出流,会被添加到第一个输出文件.如果流的类型和输出的
    格式不支持可能会导致致命的错误.在没有设置-map选项的时候,自动选择流会失败.在设置-map选项的时候,map选项选择的流和复杂过
    滤输出流,都会被包含在输出文件中.
####　stream handling(流的处理)
    流的处理是独立于流的选择的,但是一下关于字幕的描述是个例外.流的处理通过设置-coodec选项设置特定输出文件中的流.尤其是,
    -codec选项在流选择之后被ffmpeg使用,并且不影响后面.在没有-codec设置的情况下,ffmpeg会选择默认的注册在输出文件中muxer
    的编码器.
    
    字幕的异常.对于一个输出文件指定了字幕编码器,任何类型,文本或者图像的首个发现的字幕流会被包含.如果指定的字幕编码器能不能转换
    选择的流或者转换的流是否为输出格式所支持,ffmepg,不会验证.按照这个表现,当用户人为设置编码器,流选择过程中是不会检查编码的流
    是否可以并入到输出文件的,如果不可以,ffmpeg就会舍弃并且所有的输出文件都会失败.
    
#### 案例
    input file 'A.avi'
          stream 0: video 640x360
          stream 1: audio 2 channels
    
    input file 'B.mp4'
          stream 0: video 1920x1080
          stream 1: audio 2 channels
          stream 2: subtitles (text)
          stream 3: audio 5.1 channels
          stream 4: subtitles (text)
    
    input file 'C.mkv'
          stream 0: video 1280x720
          stream 1: audio 2 channels
          stream 2: subtitles (image)
    
    1. ffmpeg -i A.avi -i B.mp4 out1.mkv out2.wav -map 1:a -c:a copy out3.mov
    -map 1:a 表示从第二输入文件(B.mp4)中的选取所有的音频流,输入文件中不会有其他流
    -c:a copy 表示从输入流中选择合适的音频流进行复制,不再进行解码-过滤-编码的步骤
    
    2. ffmpeg -i C.mkv out1.mkv -c:s dvdsub -an out2.mkv
    对于out1.mkv只能包含 C.mkv的音频和视频流,不能包含字幕流,这是因为.mkv文件默认的字幕格式是基于文本的,而这里C.mkv的字幕
    流是基于图像的.
    对于out2.mkv只能包含视频和字幕流,-c:s dvdsub,指定了字幕流的编码器,-an 排除了音频流.
    
    3. ffmpeg -i A.avi -i C.mkv -i B.mp4 -filter_complex "overlay out1.mp4 out2.srt
    对于out1.mp4文件,由于mp4没有默认的字幕编码器,因此不包含字幕流.音频选择最高声道的即B.mp4中stream3.-filer_complex "overlay"
    表示基于前两个输入视频文件中的视频流,覆盖为一个视频流.因此不包含B.mp4中的视频流.
    对于out2.srt文件只包含B.mp4输入文件中的字幕流,C.mkv文件中只包含基于图像的字幕流,所以无法使用.
    
    4. ffmpeg -i A.avi -i B.mp4 -i C.mkv -filter_complex "[1:v]hue=s=0,split=2[outv1][outv2];overlay;aresample" \
        -map '[outv1]' -an out1.mp4 \
        out2.mkv\
        -map '[outv2]' -map 1:a:0 out3.mkv
        
     B.mp4的视频流传递给hue这个过滤器,输出流复制两份[outv1],[outv2],分别传递给出文件out1.mp4,out3.mkv.
     
     由于overlay这个过滤器不携带标签,要使用输入文件中未使用的前两个文件(A.avi和C.mkv),对于这两个文件中的视频流进行覆盖合成,
     输出到第一个输出文件out1.mp4;(对于不携带标签复杂的过滤,生成的输出流只包含在第一个输出文件中);
     
     对于aresample这个不携带标签的过滤器,音频的采样输出流也只是输出到第一个输出文件out1.mp4,但是由于-an,排除了音频流,因此
     out1.mp4中不包含音频流.
     
     对于out2.mkv,完全是自动化选择.
     对于out2.mkv,来自于hue过滤器的输出流和B.mp4文件中的第一个音频流.
    
#### ps
    1. mkv文件(MatroSka Video File) 是一款标准开放的自由容器和文件格式,目的是为了取代AVI,其最大特点就是可以容纳不同编
    码类型的视频,16种格式以上的音频,以及不同语言的字幕.单一的纯音频文件是.mka,纯字幕的文件是.mks.包含了音频视频的是.mkv.
    
    2. wav(WaveForm)文件是多媒体音频文件,可以直接存储声音波形,还原相当逼真.
    
    3. mov文件是苹果公司开发的,用于音频与是视频的封装,采用有损压缩.无论是在本地播放还是作为视频流格式在网上传播都可以.
    
    4. .srt文件只支持基于文本编码

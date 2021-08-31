### Audio  Filter
#### acompressor
acompressor 主要功能是减少信号的动态范围。尤其是现代音乐高比率压缩，以提高整体的响度。<br>
这样做是为了获得听众最高的关注，充实的声音，和给音乐赋予更多的力量感。如果信号被压缩的太<br>
过分，声音听起来就会沉闷的，或者毫无生机的。正确压缩的关键是达到一个专业的声音标准，并且<br>
是混合和掌控的高超艺术。由于是很复杂的设置，需要花费很长时间达到正确的感觉。<br>
<br>
压缩是通过超过threshold水平的值和ratio值的商值例如如果threshold(阈值)设置为-12db<br>
并且你的信号达到-6db,一个2：1的ratio会产生一个-9db的信号。对信号精确的人为控制，会使<br>
引起信号曲线失真。随着时间推移，这种控制会使减弱变得平滑，主要通过attack和release<br>
来完成的。attack决定了信号在减弱之前，要保持多久在阈值(threshold)之上。release<br>
设置了信号可以保持阈值之上的时间，超过这个时间必须要减弱到阈值一下。信号的整体减弱<br>
可以使用makeup来设置。因此压缩信号的峰值到6分贝，并且提高整体的音量到该水平，会导<br>
致信号的音量是音源处的两倍。在压缩中为了获得一个舒服的入口，knee选项熨平threshold<br>
(阈值)的硬边界。<br>
<br>
该filter接受一下选项<br>
```text
level_in 设置输入增益，默认值是1，范围是[0.015625,64]

mode 设置压缩的模式，值可以是upward或者downward，默认是downward

threshold 如果信号超过阈值水平，会影响增益减弱。默认值是0.125，范围是[0.00097563,1]

ratio 设置信号减弱的比率。1：2表示如果信号超过阈值4db,在减弱以后，信号只能超过阈值2db
    默认值是2，范围是[1,20]。减弱后的信号的值=阈值的值+超过阈值的值/ratio

attack 设置信号减弱之前，必须保持阈值之上的最小时长。默认值是20毫秒，范围是[0.01,
    2000]

release 设置信号保持在阈值之上的最大时长，之后必须降到阈值之下。默认值是250毫秒，范
    围是[0.01,9000]

makeup 设置信号放大多少，默认值是1，范围是[1,64]

knee 弯曲尖锐的阈值曲线，使减弱更平滑。默认值是2.82843，范围是[1,8]

link 如果是average 所有信道的输入流会影响减弱的效果，如果选择maxium声音较大的信道输入
    流影响减弱。默认值是average.

detection 若值为peak,准确的信号则在峰值的时候采集，若为平方根（rms）准确信号采集时机
    为平方根的时候采集。默认是rms,更为顺滑。

mix 输入中使用多少压缩信号，范围是[0,1]。
```    
#### afade
为输入音频设置淡入或者淡出效果，可以接受如下参数
```text
type,t 默认值是 in.表示淡入，out表示淡出
start_sample,ss 运用淡入淡出效果的样品数量从哪里开始，默认值是0;
nb_samples,ns 指定淡入淡出效果必须持续的样品数量
duration,d 设置淡入淡出效果的时长，默认情况下是使用nb_samples选项，使用该选项可以
    替代nb_samples选项。输出音频的淡入效果的结尾和输入音频拥有同样的声音强度。输出
    音频的淡出效果的结尾会保持沉默。
start_time,st 指定开始淡入和淡出的开始时间。默认值是0，用来替代start_sample选项
curve 设置淡出淡入过渡曲线接受一下的值
    1.tri 三角形和直线斜率
    2.qsin 四分之一正玄波
    3. hsin 二分之一正玄波
    4. log对数曲线
    5. cub立方曲线
    6. qua平方曲线
    ...
```
使用用例
```text
afade=t=in:ss=0:d=15
afade=t=out:st=875:d=25
```
#### acrossfade
运用交叉淡出从一个输入音频流到另一个输入音频流。临近第一个输入音频流结束的时候，交叉淡出<br>
指定持续时长。该过滤器接受一下选项:<br>
```text
nb_samples,ns 指定交叉淡出持续的样本数量，在交叉淡出的结束的时候，第一个输入音频完全沉默。
    默认值是44100。
duration,d 指定交叉淡出持续的时长，默认情况下由nb_samples选项确定，可以使用该选项替代
    nb_samples选项。
overlap,o 第二个音频流的开头是否可以覆盖第一个音频结尾，默认是可以的。
curve1,c1 为第一个输入音频流设置曲线
curve2,c2 为第二个输入音频流设置曲线(参照afade选项)
```
使用用例
```text
ffmpeg -i first.flac -i second.flac -filter_complex 
    acrossfade=d=10:c1=exp:c2=exp output.flac

ffmpeg -i first.flac -i second.flac -filter_complex
     acrossfade=d=10:o=0:c1=exp:c2=exp output.flac
```
#### ps
分贝是可以为负数的
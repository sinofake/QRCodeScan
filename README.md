QRCodeScan
==========
iOS7.0之前版本使用zbar，7.0以上本片使用系统自带二维码扫描


导入框架：
AVFoundation.framework
CoreMedia.framework
CoreVideo.framework
QuartzCore.framework
libiconv.dylib




本工程zbar静态包已经解决了这具问题：duplicate symbol _base64_encode
duplicate symbol _base64_encode解决办法:
http://www.cocoachina.com/bbs/read.php?tid=177828
http://blog.sina.com.cn/s/blog_a45145650101j4t3.html

二维码生成：
https://github.com/fukuchi/libqrencode
https://github.com/MartinLi841538513/ProduceQRCodeDemo
https://github.com/smallMas/FMTQRCode
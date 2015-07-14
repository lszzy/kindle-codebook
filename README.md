# kindle-codebook
将源代码目录转为kindle支持的电子书，让kindle支持阅读github源代码

## 工具说明
将目录下所有的文件转换为单一的html文件，支持索引，支持代码缩进，php语法高亮；生成的文件可以浏览器直接查看，也可以通过kindle推送服务发送到kindle设备阅读

## 使用说明
1. 安装php环境
2. 命令行执行  
    ./kindle-codebook.sh input output.html [skips]  
  示例：  
    ./kindle-codebook.sh input/ output.html "phpinfo.php"  
3. 将生成的html文件邮件推送给kindle邮箱，邮件标题convert，即可自动转换为azw3格式并发送给kindle设备 
4. kindle设备下载转换后的文档即可阅读

## 其它
1. 浏览器查看：直接打开html文件即可查看生成的电子书
2. php源代码：如果源代码为php文件，html还会语法高亮着色（highlight_file函数）

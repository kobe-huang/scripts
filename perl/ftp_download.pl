=pod 
在Perl中，使用模块Net::FTP来使用FTP服务，一般的使用步骤如下：
 
1. 使用Net::FTP的new方法来创建一个新的FTP对象。
2. 使用login方法登录到FTP服务器。
3. 使用cwd方法来切换目录。
4. 使用get方法来获取文件。
5. 使用put方法来上传文件。
6. 使用quit方法退出。

下面是linux下perl编写的ftp程序连接非21端口的例子：

[root@localhost aa]# more connect_ftp.pl 
=cut 
#!/usr/bin/perl -w
use Net::FTP;
$server = '120.76.166.20';
$port = '21';
$user = 'ftp';
$pw = 'H11111111h';

$ftp = Net::FTP->new($server, Port=>$port, Debug => 0, Timeout => 600) or die "Cannot connect.\n";
$ftp->login($user, $pw) or die "Could not login.\n";
$ftp->cwd('') or die "Cannot change working directory.\n";

#$remotefile = '/ZenTaoPMS.8.2.4.zip';
$remotefile = '/WeEngine-Laster-Offline.zip';
#$localpath = './test/WeEngine-Laster-Offline.zip';
$localpath = 'D:/test/WeEngine-Laster-Offline.zip';
$localfile = $localpath;  #. '/ZenTaoPMS.8.2.4.zip';

$ftp->get($remotefile, $localfile) or die "Could not get remotefile:$remotefile.\n"	;
print "get file sucessful.\n";

$ftp->quit;


#执行一下看看：
#[root@localhost aa]# ./connect_ftp.pl 
#get file sucessful.
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


    use net::ftp;  
    my $username = "liuweichuanusrname";  
    my $password = "liuweichuanpassword";  
    my $remotefile = "test.txt";  
    my $localfile = "a.txt";  
    my $remotefilename = "111";  
    my $filename = "C:/Users/liuweic/Documents/FFOutput/Animals United 动物总动员 00_54_00-00_55_11.avi";  
      
    $ftp = Net::FTP->new("16.173.246.xx",Timeout => 30)    or die "Can't connect: $@\n";  
    $ftp->login($username, $password)    or die "Could not log in.\n";  
      
    $ftp->cwd('/var');  
    print "I'm in the directory ", $ftp->pwd( ), "\n";  
      
    @lines = $ftp->ls("/UXMON")  or die "Can't get a list of files in /pub/gnat/perl: $!";  
    print @lines;  
      
    $ftp->get($remotefile, $localfile)   or die "Can't fetch $remotefile : $!\n";  
    $ftp->put($filename, $remotefilename)    or die "Couldn't put $filename\n";  
      
    $ftp->quit( )    or warn "Couldn't quit.  Oh well.\n";  
    print "\nquit";  


=cut 
#!/usr/bin/perl -w
use Net::FTP;
$server = '120.76.166.20';
$port = '21';
$user = 'ftp';
$pw = 'H11111111h';
$local_ftp_path = 'D:\ftp_path';

$ftp = Net::FTP->new($server, Port=>$port, Debug => 0, Timeout => 120) or die "Cannot connect.\n";
$ftp->login($user, $pw) or die "Could not login.\n";

if(-d $local_ftp_path){
	print("directory $local_ftp_path exist! \r\n");
}
else{
	system("md $local_ftp_path");
	print("create directory $local_ftp_path \r\n");
}

#$ftp->cwd("") or die "Cannot change working directory.\n";

#exit;

@lines = $ftp->ls("/backup/")  or die "Can't get a list of files in /pub/gnat/perl: $!";  
#print @lines; 
#print join "\n", @lines; 
#local $,="\n"; print @lines;
foreach $each (@lines){
		print("+++ $each\r\n");
	} 





#$remotefile = '/ZenTaoPMS.8.2.4.zip';
$remotefile = '/WeEngine-Laster-Offline.zip';
#$localpath = './test/WeEngine-Laster-Offline.zip';
$localpath = "$local_ftp_path";
$localfile = "$localpath\\WeEngine-Laster-Offline.zip";  #. '/ZenTaoPMS.8.2.4.zip';

$ftp->get($remotefile, $localfile) or die "Could not get remotefile:$remotefile.\n"	;
print "\r\n get file sucessful.\n";

$ftp->quit;


#执行一下看看：
#[root@localhost aa]# ./connect_ftp.pl 
#get file sucessful.
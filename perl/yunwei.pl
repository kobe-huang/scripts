#!/usr/bin/perl  
use strict;
use warnings;
use diagnostics;  
use Net::FTP;

#参数部分
my $server_ip = "120.76.166.20";
my $server_port = "21";
my $server_path = "/backup/";
my $server_user_account = "ftp";
my $server_user_pwd = "H11111111h";

my $local_log_file = "e:\\backup\\log.txt";
my $local_backup_path = "e:\\backup";
my $local_os_type = "linux";

my $expired_days = 5;
my $total_timer = 0;
my $win32_mkdir_cmd = "md ";
my $win32_mkfile_cmd = "echo InitFile> ";
my $win32_flashfxp_cmd = 'D:\setup\FlashFXP.lh\FlashFXP.exe -c4 -min';

my $timeout_seconds =  10000;  #超时时间为10000s
my $data_now = "20160101";

#函数接口
#
sub re_define_stdout{
	if($_[0]){
		open (STDOUT, ">>$local_log_file") || die ("open STDOUT failed");
		open (STDERR, ">>&STDOUT") || die ("open STDERR failed");
	}else{
		close (STDOUT);
		close (STDERR);
	}
}


sub mkdir_by_date{
    #print local time
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    my $mytime = sprintf("%04d%02d%02d_%02d%02d%02d", $year+1900,$mon+1,$mday,$hour,$min,$sec);
    
    $data_now = sprintf("%04d%02d%02d", $year+1900,$mon+1,$mday);
    printf("DateTime: %s\r\n", $mytime);

    if($local_os_type  eq  "win32"){
    	!system("$win32_mkdir_cmd$local_backup_path\\$mytime") or die "Error 创建文件失败;\r\n"; 
    	$local_backup_path = "$local_backup_path\\$mytime";
    	print("\r\n++++++create backup date &local_backup_path directory sucessful!++++++\r\n");
    	}   
}


sub set_os_type {
	my  $Sys_name = $^O;
	if ($Sys_name =~ /MSWin32/){
	   $local_os_type = "win32";
	   print("system is win32\r\n");
	   #print $ENV{'USERNAME'},"\n";
	}
	else 
	{
	     if($Sys_name =~ /linux/){
	     	 print("system is linux\r\n");
	     	 $local_os_type = "linux";
	    }
	    else
	    {
	    	$local_os_type = "unknow";
	        print "Unknow\n";
	    }
	}
}


sub set_env {
	&set_os_type;
	if($local_os_type  eq  "win32"){
		if(-e $local_log_file){
		   print "log file exist\n";
		}
		else
		{
		   print "log file $local_log_file no exist\n";
		   if(-d $local_backup_path){
		   		print("$local_backup_path 存在 \n");
			}
		   else{
		   	!system("$win32_mkdir_cmd$local_backup_path") or die "Error 创建文件夹$local_backup_path 出错 \n";
		   	print(" 创建文件夹$local_backup_path \n");
		   }

		   !system("$win32_mkfile_cmd $local_log_file") or die "Error 出错，不能建立$local_log_file \n";  
		   print("init log file \n");
		   #close(LOGFILE);
		   #print("+++init log file\r\n");
		}
		&re_define_stdout(1);
		&mkdir_by_date;
	}
}


sub connect_download_remote_ftp {	
	my $ftp = Net::FTP->new($server_ip, Port=>$server_port, Debug => 0, Timeout => 600) or die "Cannot connect.\n";
	$ftp->login($server_user_account, $server_user_pwd) or die "Error Could not login.\n";
	#$ftp->cwd($local_backup_path) or die "Cannot change working directory.\n";
	my @lines = $ftp->ls("/backup/")  or die "Error Can't get a list of files in /backup: $!";  
	my $each = "";
	#print @lines; 
	print join "\n", @lines; 
	#local $,="\n"; print @lines;
	$ftp->quit;

	foreach $each (@lines){
		#print("+++ $each\r\n");
		if ($each =~ /$data_now/){
		#开始下载
		print("++begin to download $each++ \n");
		my $cmd = "$win32_flashfxp_cmd -local=$local_backup_path -download ";
		my $cmd1= "$server_user_account:$server_user_pwd\@$server_ip:$server_port ";
		my $cmd2= "-remotepath=$server_path/$each -localpath=$local_backup_path\\$each" ;
		!system("$cmd$cmd1$cmd2") or die "Error download error----\r\n" ;	
		#print("the result = $result\r\n");
		sleep(5);	
		}
	} 
	print("+++++ downloda over ++++++\r\n\r\n\r\n\r\n");	
}


sub check_download_files {
}

sub download_backup {
}


local $SIG{ALRM} = sub{print "sorry,time out.please try again\n"; exit} ;

alarm $timeout_seconds ; #启动定时器 
&set_env;
&connect_download_remote_ftp;
&re_define_stdout(0);
alarm 0 ;

exit;
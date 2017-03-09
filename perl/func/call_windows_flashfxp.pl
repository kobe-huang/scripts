#C:\Users\abc-pc\Downloads\FlashFXP0SC\FlashFXP\FlashFXP.exe
print "...start...\n";
my $cmd = 'C:\Users\abc-pc\Downloads\FlashFXP0SC\FlashFXP\FlashFXP.exe -c4 -local="D:\TDDownload" -download ftp:H11111111h@120.76.166.20:21 -remotepath="/WeEngine-Laster-Offline.zip" -localpath="D:\TDDownload\huang.zip"' ;
#$para = "-c4 -local='D:\TDDownload' -download ftp://ftp:H11111111h@120.76.166.20:21 -remotepath='/WeEngine-Laster-Offline.zip' -localpath='D:\TDDownload\' ";
#system('C:\Users\abc-pc\Downloads\FlashFXP0SC\FlashFXP\FlashFXP.exe' , $para);
#system("C:\Users\abc-pc\Downloads\FlashFXP0SC\FlashFXP\FlashFXP.exe");
#system('C:\Users\abc-pc\Downloads\FlashFXP0SC\FlashFXP\FlashFXP.exe -c4 -local="D:\TDDownload" -download ftp:H11111111h@120.76.166.20:21 -remotepath="/WeEngine-Laster-Offline.zip" -localpath="D:\TDDownload\WeEngine-Laster-Offline.zip"' );
#$result = system('C:\Users\abc-pc\Downloads\FlashFXP0SC\FlashFXP\FlashFXP.exe -c4 -local="D:\TDDownload" -download ftp:H111111h@120.76.166.20:21 -remotepath="/WeEngine-Laster-Offline.zip" -localpath="D:\TDDownload\huang.zip"' );
$result = system($cmd);
print "$result\n";
print "...end...\n";
=pod 
 use IO::Tee;
 use IO::File;

 my $tee = new IO::Tee(\*STDOUT,
     new IO::File(">tt1.out"), ">tt2.out");

 print join(' ', $tee->handles), "\n";
 for (1..10) { print $tee $_, "\n" }
 for (1..10) { $tee->print($_, "\n") }
 $tee->flush;
 $tee = new IO::Tee('</etc/passwd', \*STDOUT);
 my @lines = <$tee>;
 print scalar(@lines); 
=cut

#http://blog.csdn.net/xyp84/article/details/8051252
#!/usr/local/bin/perl

open (STDOUT, ">>d:\\backup\\log.txt") || die ("open STDOUT failed");
open (STDERR, ">>&STDOUT") || die ("open STDERR failed");
$| = 1;
select (STDERR);
$| = 1;
print ("line huangyinke 1\n");
print STDERR ("line huangyinke error 2\n");
close (STDOUT);
close (STDERR);


#这个不全，还是看安装目录来的清晰
use strict;
use ExtUtils::Installed;
my $inst = ExtUtils::Installed->new();
my @modules = $inst->modules();

foreach  (@modules) {
        my  $ver = $inst->version($_) || "???";
        printf("%-22s -Version- %-22s\n", $_, $ver);
}
exit;
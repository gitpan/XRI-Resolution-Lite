use Test::More tests => 2;

use XRI::Resolution::Lite;

my $r = XRI::Resolution::Lite->new;
ok($r);
my $xrds = $r->resolve('=zigorou');
is($xrds->documentElement->nodeName, 'XRDS');


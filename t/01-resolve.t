use Test::More tests => 10;

use XRI::Resolution::Lite;

{
    my $r = XRI::Resolution::Lite->new;
    ok($r, 'Create instance using http://xri.net/');
    my $xrds = $r->resolve('=zigorou');
    is($xrds->documentElement->nodeName, 'XRDS', 'Root node is XRDS element');
}

{
    my $r = XRI::Resolution::Lite->new({
        resolver => 'http://beta.xri.net/'
    });
    ok($r, 'Create instance using http://beta.xri.net/');
    my $xrds = $r->resolve('=zigorou');
    is($xrds->documentElement->nodeName, 'XRDS', 'Root node is XRDS element');
}


{
    my $r = XRI::Resolution::Lite->new({
        resolver => 'http://xri.freexri.com/'
    });
    ok($r, 'Create instance using http://xri.freexri.com/');
    my $xrds = $r->resolve('=zigorou');
    is($xrds->documentElement->nodeName, 'XRDS', 'Root node is XRDS element');
}

{
    my $r = XRI::Resolution::Lite->new({
        resolver => 'http://xri.testxri.com/'
    });
    ok($r, 'Create instance using http://xri.testxri.com/');
    my $xrds = $r->resolve('=zigorou');
    is($xrds->documentElement->nodeName, 'XRDS', 'Root node is XRDS element');
}

{
    my $r = XRI::Resolution::Lite->new({
        resolver => 'http://xri.fullxri.com/'
    });
    ok($r, 'Create instance using http://xri.fullxri.com/');
    my $xrds = $r->resolve('=zigorou');
    is($xrds->documentElement->nodeName, 'XRDS', 'Root node is XRDS element');
}

diag('Testing result format application/xrds+xml');

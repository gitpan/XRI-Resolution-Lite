package XRI::Resolution::Lite;

use strict;
use warnings;

use base qw(Class::Accessor::Fast);

__PACKAGE__->mk_accessors(qw/resolver ua parser/);

use HTTP::Request;
use LWP::UserAgent;
use URI;
use XML::LibXML;

=head1 NAME

XRI::Resolution::Lite - The LightWeight client module for XRI Resolution

=head1 VERSION

version 0.01

=cut

our $VERSION = '0.01';

my %param_map = (
    format => '_xrd_r',
    type => '_xrd_t',
    media => '_xrd_m',
);

=head1 SYNOPSIS

  use XML::LibXML::XPathContext;
  use XRI::Resolution::Lite;

  my $r = XRI::Resolution::Lite->new;
  my $xrds = $r->resolve('=zigorou'); ### XML::LibXML::Document
  my $ctx = XML::LibXML::XPathContext->new($xrds);
  my @services = $ctx->findnodes('//Service');

=head1 METHODS

=head2 new

=over 2

=item $args

This param must be HASH reference. Available 2 fields.

=over 2

=item ua

(Optional) L<LWP::UserAgent> object or its inheritance.

=item resolver

(Optional) URI string of XRI Proxy Resolver.
If this param is omitted, using XRI Global Proxy Resolver, "http://xri.net/", as resover.

=back 

=back

=cut

sub new {
    my ($class, $args) = @_;

    $args = {
        ua => $args->{ua} || LWP::UserAgent->new,
        resolver => ($args->{resolver}) ? 
            ((UNIVERSAL::isa($args->{resolver}, 'URI')) ? $args->{resolver} : URI->new($args->{resolver})) :
            URI->new('http://xri.net/'),
        parser => XML::LibXML->new,
    };

    my $self = $class->SUPER::new($args);
    return $self;
}

=head2 resolve($qxri, $args)

If a resolution is succeed, return <XML::LibXML::Document> object. if not succeed then return undef.

=over 2

=item $qxri

Query XRI string. For example :

  =zigorou
  @perlmongers

=item $args

This param must be HASH reference. Available 3 fields.

=over 2

=item format

Resolution Output Format. This param would be '_xrd_r' query parameter.

=item type

Service Type. This param would be '_xrd_t' query parameter.

=item media

Service Media Type. This param would be '_xrd_m' query parameter.

=back

=back

=cut

sub resolve {
    my ($self, $qxri, $args) = @_;

    $qxri =~ s|^xri://||; ### normalize

    my %query = ();
    %query = (
        _xrd_r => 'application/xrds+xml',
        map { ( $param_map{$_}, $args->{$_} ) } keys %$args
    );

    my $hxri = $self->resolver->clone;
    $hxri->path($qxri);
    $hxri->query_form(%query);

    my $req = HTTP::Request->new(GET => $hxri);
    $req->header(Accept => $args->{type} || 'application/xrds+xml');

    my $res = $self->ua->request($req);

    return unless ($res->is_success);

    my $doc = $self->parser->parse_string($res->content);
    return $doc;
}

=head1 SEE ALSO

=over 2

=item http://docs.oasis-open.org/xri/xri-resolution/2.0/specs/cd03/xri-resolution-V2.0-cd-03.html

There are XRI Resolution spec in OASIS.

=back

=head1 AUTHOR

Toru Yamaguchi, C<< <zigorou@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-xri-resolution-lite@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically be
notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2008 Toru Yamaguchi, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of XRI::Resolution::Lite

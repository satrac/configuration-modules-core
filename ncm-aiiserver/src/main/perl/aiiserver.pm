# ${license-info}
# ${developer-info}
# ${author-info}

# Note: all methods in this component are called in a
# $self->$method ($config) way, unless explicitly stated.

package NCM::Component::aiiserver;

use strict;
use warnings;
use NCM::Component;
use CAF::FileWriter;
use File::Path qw(mkpath);

use constant PATH	=> "/software/components/aiiserver";
use constant AIIDIR	=> "/etc/aii";
use constant AIISHELLFE	=> AIIDIR . "/aii-shellfe.conf";
use constant AIIDHCP	=> AIIDIR . "/aii-dhcp.conf";

our @ISA = qw (NCM::Component);
our $EC = LC::Exception::Context->new->will_store_all;

sub Configure
{
    my ($self, $config) = @_;

    my $t = $config->getElement (PATH)->getTree;
    mkpath (AIIDIR);
    my $fh = CAF::FileWriter->new(AIISHELLFE, log => $self);
    print $fh <<EOF;
# File generated by ncm-aiiserver
# Do not edit
EOF


    while (my ($k, $v) = each (%{$t->{"aii-shellfe"}})) {
	print $fh "$k = $v\n";
    }
    $fh->close();

    $fh = CAF::FileWriter->new(AIIDHCP, log => $self);

    print $fh <<EOF;
# File generated by ncm-aiiserver
# Do not edit
EOF

    while (my ($k, $v) = each (%{$t->{"aii-dhcp"}})) {
	print $fh "$k = $v\n";
    }
    $fh->close();

    return 1;
}

1;

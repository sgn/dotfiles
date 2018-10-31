#!/usr/bin/env perl

use strict;
use warnings;
use AnyEvent;
use AnyEvent::I3 qw(:all);
use Data::Dumper;
use Getopt::Long qw(:config no_ignore_case auto_help);

sub format_ipc_command {
    my ($msg) = @_;
    my $len;
    # Get the real byte count (vs. amount of characters)
    { use bytes; $len = length($msg); }
    return "i3-ipc" . pack("LL", $len, 0) . $msg;
}

my $shift_mask=0;
my $key;

GetOptions(
    "shift!" => \$shift_mask, # if shift is pressed
    "key|k=s" => \$key
    ) or die "error: failed to parse options";

defined($key) or die "key is required";

if ($key ne 'h' && $key ne 'l' && $key ne 'j' && $key ne 'k') {
    die "error: key $key not supported"
}

my $i3 = i3();
$i3->connect->recv or die 'error: not connect';

# Get current workspace index
my $current_ws_idx = 0;

for my $ws_ (@{i3->get_workspaces->recv}) {
    my %ws = %{$ws_};
    $current_ws_idx = $ws{'num'} if ($ws{'focused'});
}

# * hl
# ** traverse the tree,
# ** meet no tabbed layout
# ** window width == workspace width
#
# * jk
# ** traverse the tree
# ** meet no stack layout
# ** ref_height = ws.h
# ** On tabbed layout (tab in split in tab),
# *** check rect.h + deco_rect.h == ref_height
# *** ref_height = rect.h

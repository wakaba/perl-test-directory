package Test::Directory::Diff;
use strict;
use warnings;
our $VERSION = '1.0';
use Test::More;
use Exporter::Lite;

our @EXPORT = qw(eq_or_diff_dir);

our $DIFF_COMMAND ||= 'diff';
our @DIFF_OPTION = qw(-ur --text --new-file);

our $DEBUG ||= $ENV{TEST_DIRECTORY_DEBUG};

sub eq_or_diff_dir ($$;$) {
    my ($dir1, $dir2, $name) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    $name = caller(0) unless defined $name;
    
    unless ($dir1 and -d $dir1) {
        ok 0,  "$name - /actual/ is a directory";
        return;
    }

    unless ($dir2 and -d $dir2) {
        ok 0,  "$name - /expected/ is a directory";
        return;
    }

    my $command = join ' ', map { quotemeta } $DIFF_COMMAND, @DIFF_OPTION, $dir1, $dir2;
    warn "$command\n" if $DEBUG;
    my $diff = `$command`;
    is $diff, '', $name;
}

1;

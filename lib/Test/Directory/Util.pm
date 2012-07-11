package Test::Directory::Util;
use strict;
use warnings;
our $VERSION = '1.0';
use File::Temp qw(tempdir);
use Exporter::Lite;
use Encode;
use Path::Class;
require utf8;

our @EXPORT = qw(
    create_directory_for_test
);

our $DEBUG ||= $ENV{TEST_DIRECTORY_DEBUG};

sub create_directory_for_test ($) {
    my $files = shift;
    my $d = dir(tempdir);
    warn "Test::Directory: Test directory \"$d\"\n" if $DEBUG;
    for my $file_name (keys %$files) {
        my $f = $d->file($file_name);
        $f->dir->mkpath;
        my $file = $f->openw;
        warn "Test::Directory: Test file \"$f\"\n" if $DEBUG;
        if (utf8::is_utf8($files->{$file_name})) {
            print $file encode 'utf8', $files->{$file_name};
        } else {
            print $file $files->{$file_name};
        }
    }
    return $d;
}

1;

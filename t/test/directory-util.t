package test::Test::Directory::Util;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->parent->subdir('lib')->stringify;
use base qw(Test::Class);
use Test::More;
use Test::Directory::Util;
use Encode;

sub _create_directory_for_test : Test(3) {
    my $d = create_directory_for_test({
        abc => "\x{4000}\x{5000}",
        'xyz/abc' => "abc def \x80\x40\x90",
    });
    isa_ok $d, 'Path::Class::Dir';
    
    is scalar $d->file('abc')->slurp, encode 'utf8', "\x{4000}\x{5000}";
    is scalar $d->subdir('xyz')->file('abc')->slurp, "abc def \x80\x40\x90";
}

__PACKAGE__->runtests;

1;

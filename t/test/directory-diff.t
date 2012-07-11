package test::Test::Directory::Diff;
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->parent->subdir('lib')->stringify;
use base qw(Test::Class);
use Test::Test::More;
use Test::Directory::Diff;
use Test::Directory::Util;
use Encode;

sub _eq_or_diff_dir_no_arg : Test(4) {
    my $d1 = file(__PACKAGE__)->dir;
    test_ng_ok { eq_or_diff_dir $d1, undef };
    test_ng_ok { eq_or_diff_dir undef, $d1 };
    test_ng_ok { eq_or_diff_dir $d1, rand() . 'notfound' };
    test_ng_ok { eq_or_diff_dir rand() . 'notfound', $d1 };
}

sub _eq_or_diff_dir_same : Test(2) {
    my $d1 = create_directory_for_test({
        abc => "\x{4000}\x{5000}",
        'xyz/abc' => "abc def \x80\x40\x90",
    });
    test_ok_ok { eq_or_diff_dir $d1, $d1 };
    test_ok_ok { eq_or_diff_dir $d1->stringify, $d1->stringify };
}

sub _eq_or_diff_dir_equal : Test(2) {
    my $d1 = create_directory_for_test({
        abc => "\x{4000}\x{5000}",
        'xyz/abc' => "abc def \x80\x40\x90",
    });
    my $d2 = create_directory_for_test({
        abc => "\x{4000}\x{5000}",
        'xyz/abc' => "abc def \x80\x40\x90",
    });
    test_ok_ok { eq_or_diff_dir $d1, $d2 };
    test_ok_ok { eq_or_diff_dir $d2->stringify, $d1->stringify };
}

sub _eq_or_diff_dir_not_equal : Test(2) {
    my $d1 = create_directory_for_test({
        abc => "\x{4000}\x{5000}",
        'xyz/abc' => "abc def \x80\x40\x90",
    });
    my $d2 = create_directory_for_test({
        abc => "\x{4000}\x{5000}\x{6000}",
        'xyz/abcd/def' => "abc def \x80\x40\x90",
    });
    test_ng_ok { eq_or_diff_dir $d1, $d2 };
    test_ng_ok { eq_or_diff_dir $d2->stringify, $d1->stringify };
}

__PACKAGE__->runtests;

1;

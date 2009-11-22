# $Id$

=begin comments

Reason::Grammar::Actions - ast transformations for Reason

This file contains the methods that are used by the parse grammar
to build the PAST representation of an Reason program.
Each method below corresponds to a rule in F<src/parser/grammar.pg>,
and is invoked at the point where C<{*}> appears in the rule,
with the current match object as the first argument.  If the
line containing C<{*}> also has a C<#= key> comment, then the
value of the comment is passed as the second argument to the method.

=end comments

class Reason::Grammar::Actions;

method TOP($/) {
    make $/{'expr'}.ast;
}

method expr($/) {
    my $items;
    $items := parse_list($<term>);
    make $items;
}

##  term:
##    Like 'expr' above, the $key has been set to let us know
##    which term subrule was matched.
method term($/, $key) {
    make $/{$key}.ast;
}


method value($/, $key) {
    make $/{$key}.ast;
}

method symbol($/) {
    our @?BLOCK;
    my $scope := 'package';
    my $name := ~$<symbol>;
    for @?BLOCK {
        if $_.symbol($name) && $scope eq 'package' {
            $scope := $_.symbol($name)<scope>;
        }
    }
    make PAST::Var.new(
        :name( $name ),
        :scope( $scope ),
        :node( $/ ),
    );
}


method integer($/) {
    make PAST::Val.new(
        :value( ~$/ ),
        :returns('Integer'),
##        :node($/),
    );
}


method quote($/) {
    make PAST::Val.new(
        :value( $<string_literal>.ast ),
        :returns('String'),
        :node($/),
    );
}


# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4:


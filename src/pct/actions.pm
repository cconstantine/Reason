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
    my $past;
 
    my @empty;
    $past:= PAST::Block.new(
       :blocktype('declaration'),
       :node( $/ ),
        :hll('reason'),
        :namespace(@empty),
     );

     $past.push(to_past(self, $<expr>.ast));
     make $past;
}

method compile_func($/, $node) {
    my $past := PAST::Op.new(
        :pasttype('call'),
        :node( $/ )
    );
   $past.name(first($node));
   $node := rest($node);
   while ($node) {
     $past.push(to_past(self, first($node)));
     $node := rest($node);
   }
   return $past;
}


method expr($/) {
    my $items;
    my @item_array;
    my $i;
    $i := 0;
    for $<term> {
        @item_array[$i] := $_.ast;
        $i := $i + 1;
    }
    $items := parse_list($/, @item_array);
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
    my $name := ~$<symbol>;
    make $name;
}


method integer($/) {
    make PAST::Val.new(
        :value( ~$/ ),
        :returns('Integer'),
        :node($/),
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


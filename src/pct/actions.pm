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
    our @?BLOCK;
    our @?LIBRARY;
    my $past;
   _dumper($/, "Starting parsing");
    my @empty;
    $past:= PAST::Block.new(
       :blocktype('declaration'),
       :node( $/ ),
       :hll('reason'),
       :namespace(@empty),
    );
    for $<term> {
      $past.push(to_past(self, $_.ast));
    }
## To Finish compiling a PAST and execute it
#   my $compiler := Q:PIR { %r = compreg 'PAST' };
#   my $code := $compiler.compile($past);
#   $code[0]();
#    _dumper($past, "AST");
    make $past;
}

method compile_fn($/, $node) {

    # Strip off leading 'fn'
    $node := rest($node);

    my $args := first($node); $node := rest($node);
    my $impl := $node;
#say("Compile_fn");
#say("args");
#    say($args);
#say("impl");
#    say($impl);
    my $block := PAST::Block.new( :blocktype('declaration'), :node($/) );
    my $init := PAST::Stmts.new();
    while ($args) {
        my $var := first($args);
        $var.scope('parameter');
        $var.isdecl(1);
        $block.symbol($var.name(), :scope('lexical'));
        $init.push($var);
        $args := rest($args);
    }
    $block.unshift($init);
    my $stmts := PAST::Stmts.new();

    while ($impl) {
        $stmts.push(to_past(self, first($impl)));
        $impl := rest($impl);
    }

    $block.push($stmts);
    return $block;
}

method compile_call($/, $node) {
    my $past := PAST::Op.new(
        :pasttype('call'),
        :node( $/ )
    );

   while ($node) {
     $past.push(to_past(self, first($node)));
     $node := rest($node);
   }

   return $past;
}

method decorate_node($node, $name, $scope) {
    for $node.iterator {
        decorate(self, $_, $name, $scope);
    }
}

method decorate_symbol($var, $name, $scope) {
    if ($var.name() eq $name) {
      $var.scope($scope);
    }
}

method compile_let($/, $node) {
#say("Compiling let: ");say($node);

    # Strip off leading 'let'
    $node := rest($node);
    my $vars := first($node); $node := rest($node);

    my $block;

#say("Vars: ");say($vars);
#say("body: ");say($node);

    my $stmts := PAST::Stmts.new();
    while ($node) {
        $stmts.push( to_past(self, first($node)) );
        $node := rest($node);
    }
    $block := PAST::Block.new( :blocktype('immediate'), :node($/) );
    $block.push($stmts);

    my $init := PAST::Stmts.new();
    while ($vars) {
        my $var := first($vars);
        $vars := rest($vars);
        my $val  := to_past(self, first($vars));
        $vars := rest($vars);

#        say("Var: ");say($var);
#        say("Val: ");say($val);
        decorate(self, $stmts, $var.name(), 'lexical');
        $var.scope('lexical');
        $var.isdecl(1);
        $block.symbol($var.name(), :scope('lexical'));
        $init.push( PAST::Op.new( $var, $val, :pasttype('bind')));
    }
    $block.unshift($init);

    return $block;
}

method compile_node($/, $node) {
    my $first := first($node);
#say("Compiling: ");say($node);

    if ($first.name eq "fn")
    {
#say("Compiling to fn");
	compile_fn(self, $/, $node);
    }
    elsif ($first.name eq "let")
    {
#say("Compiling to let");
        compile_let(self, $/, $node);
    }
    else
    {
#say("Compiling to call");
       compile_call(self, $/, $node);
    }

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
    my $name := ~$/;

    make PAST::Var.new(
        :name( $name ),
        :scope( 'package' ),
        :node( $/ ),
    );
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


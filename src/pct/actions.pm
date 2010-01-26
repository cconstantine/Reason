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
#   _dumper($/, "Starting parsing");
    my @empty;
    $past:= PAST::Block.new(
       :blocktype('declaration'),
       :node( $/ ),
       :hll('reason'),
       :namespace(@empty),
    );
    @?LIBRARY.unshift($past);

    for $<term> {
      my $n := to_past(self, $_.ast);
      if ($n) {
          $past.push(to_past(self, $_.ast));
      }
    }
#    _dumper($past, "AST");

    our %?CONS := NULL;
    make $past;
}

method compile_fn($/, $node, $name, $type) {
    # Strip off leading 'fn'
    $node := rest($node);

    my $args := first($node); $node := rest($node);
    my $impl := $node;
 
    my $block;
    if ($name) {
        $block := PAST::Block.new( :blocktype($type),
                                   :name($name),
                                   :node($/) );
    } else {
        $block := PAST::Block.new( :blocktype($type),
                                   :node($/) );
    }
    my $stmts := PAST::Stmts.new();
    while ($impl) {
        $stmts.push(to_past(self, first($impl)));
        $impl := rest($impl);
    }
    $block.push($stmts);

    my $init := PAST::Stmts.new();
    while ($args) {
        my $var := first($args);
        $var.scope('parameter');
        $var.isdecl(1);
        decorate(self, $stmts, $var.name(), 'lexical');
        $block.symbol($var.name(), :scope('lexical'));
        $init.push($var);
        $args := rest($args);
    }
    $block.unshift($init);

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

    my $block := PAST::Block.new( :blocktype('immediate'), :node($/) );
    my $stmts := PAST::Stmts.new();
    while ($node) {
        $stmts.push( to_past(self, first($node)) );
        $node := rest($node);
    }
    $block.push($stmts);

    my $init := PAST::Stmts.new();
    while ($vars) {
        my $var := first($vars);
        $vars := rest($vars);
        my $val  := to_past(self, first($vars));
        $vars := rest($vars);

        decorate(self, $stmts, $var.name(), 'lexical');
        $var.scope('lexical');
        $var.isdecl(1);
        $block.symbol($var.name(), :scope('lexical'));
        $init.push( PAST::Op.new( $var, $val, :pasttype('bind')));
    }
    $block.unshift($init);

    return $block;
}

method compile_if($/, $node) {
    # Strip off leading 'if'
    $node := rest($node);

    my $cond_node := to_past(self, first($node));$node := rest($node);
    my $then_node := NULL;
    my $else_node := NULL;

    if ($node) {
     $then_node := to_past(self, first($node));$node := rest($node);
    }
    if ($node) {
     $else_node := to_past(self, first($node));$node := rest($node);
    }

    return PAST::Op.new(
        $cond_node,
        $then_node,
        $else_node,
        :pasttype('if'),
        :node($/),
    );
}

method compile_def($/, $node) {
    our @?LIBRARY;

    # Strip off leading 'def'
    $node := rest($node);

    my $var := to_past(self, first($node));$node := rest($node);
    my $val := to_past(self, first($node));

    my $lib := @?LIBRARY[0];
    my @ns := $lib.namespace();

    $var.scope('package');
    $var.namespace(@ns);
    #$var.isdecl(1);

    $lib.symbol( $var.name, :scope('package') );
    return PAST::Op.new( $var, $val, :pasttype('bind'), :node($/) );
}

method compile_defn($/, $node) {
    # Strip off leading 'defn'
    $node := rest($node);
    my $name := first($node).name();

    return compile_fn(self, $/, $node, $name, 'declaration');
}

method compile_quote($/, $node) {
    our @?QUOTES;
    # Strip off leading 'quote'
    $node := rest($node);
#    return first($node);
    my $var := PAST::Var.new(
        :scope( 'register' ),
        :node( $/ )
    );
    @?QUOTES.push(first($node));
    return PAST::Var.new(:scope('keyed'),
                  PAST::Var.new(:scope('package'),
                                :namespace( ('Reason', 'Grammar', 'Actions') ), :name('@?QUOTES'),
                                ),
                  PAST::Val.new(:value(+@?QUOTES - 1)));

#    my $stmts := PAST::Stmts.new();
#    $stmts.push( first($node) );
#
#    return $stmts;
#    return PAST::Val.new(
#        :value( first($node) ),
#        :node($/),
#     );
}

method compile_defmacro($/, $node) {
    our %?MACROS;
    # Strip off leading 'defn'
    $node := rest($node);
    my $name := first($node).name();

    my $macro := compile_fn(self, $/, $node, $name, 'declaration');
    $macro.hll('reason');
#_dumper($macro, "macro");

    ## Finish compiling a PAST
    my $compiler := Q:PIR { %r = compreg 'PAST' };
    my $code := $compiler.compile($macro);#, :target('PIR'));
    %?MACROS{$name} := $code;

    return NULL;
}

method compile_macro($/, $node) {
    our %?CONS;
    our %?MACROS;
    my $mac := %?MACROS{first($node).name};
    $node := rest($node);
    my @args;
    my $i := 0;
    while ($node) {
       @args[$i] := first($node);
        $node := rest($node);
    }
#say(exec_macro($/, $mac, @args));
    my $macro_result := exec_macro($mac, @args);
    %?CONS{$macro_result} := $/;
    return to_past(self, $macro_result);
}

method compile_node($/, $node) {
    our %?MACROS;
    my $first := first($node);
#say("Compiling: ");say($node);
#say("first: ");say($first);

    if ($first.name eq "fn")
    {
	return compile_fn(self, $/, $node, NULL, 'declaration');
    }
    elsif ($first.name eq "let")
    {
        return compile_let(self, $/, $node);
    }
    elsif ($first.name eq "if")
    {
        return compile_if(self, $/, $node);
    }
    elsif ($first.name eq "def")
    {
        return compile_def(self, $/, $node);
    }
    elsif ($first.name eq "defn")
    {
        return compile_defn(self, $/, $node);
    }
    elsif ($first.name eq "quote")
    {
       return compile_quote(self, $/, $node);
    }
    elsif ($first.name eq "defmacro")
    {
       return compile_defmacro(self, $/, $node);
    }
#_dumper($first, "first");
    if (%?MACROS{$first.name}) {
        return compile_macro(self, $/, $node);
    }
    return compile_call(self, $/, $node);
}


method expr($/) {
    our %?CONS;
    my $items;
    my @item_array;
    my $i;
    $i := 0;
    for $<term> {
        @item_array[$i] := $_.ast;
        $i := $i + 1;
    }
    $items := parse_list(@item_array);
    %?CONS{$items} := $/;
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


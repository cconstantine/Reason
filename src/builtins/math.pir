# $Id$

=head1

math.pir -- simple implementation of math functions

=cut

.namespace []

.sub '+'
    .param pmc a
    .param pmc b
    $P0 = add a, b
    .return ($P0)
.end

.sub '-'
    .param pmc a
    .param pmc b
    $P0 = sub a, b
    .return ($P0)
.end

.sub '*'
    .param pmc a
    .param pmc b
    $P0 = mul a, b
    .return ($P0)
.end

.sub '/'
    .param pmc a
    .param pmc b
    $P0 = div a, b
    .return ($P0)
.end

.sub '='
     .param pmc a
     .param pmc b
     if a == b goto true
     .return (0)
    true:
     .return (1)
.end

.sub '>'
     .param pmc a
     .param pmc b
     if a > b goto true
     .return (0)
    true:
     .return (1)
.end

.sub 'exists'
     .param pmc val

     unless null val goto true
     .return (0)
    true:
     .return (1)
.end

.sub 'init_class' :load :init
     $P0 = newclass 'range'
     addattribute $P0, "n"
     addattribute $P0, "max"
     addattribute $P0, "inc"
.end

.sub 'range'
     .param pmc start
     .param pmc max
     .param pmc inc

     $P0 = new 'range'
     setattribute $P0, 'n', start
     setattribute $P0, 'max', max
     setattribute $P0, 'inc', inc

     .return ($P0)
.end

.sub 'first' :multi('range')
     .param pmc val
     $P0 = getattribute val, 'n'
     .return ($P0)
.end

.sub 'rest' :multi('range')
     .param pmc val
     $P0 = getattribute val, 'n'
     $P1 = getattribute val, 'max'
     $P2 = getattribute val, 'inc'

     $P0 = $P0 + $P2
     if $P0 > $P1 goto done
     $P4 = new 'range'
     setattribute $P4, 'n',   $P0
     setattribute $P4, 'max', $P1
     setattribute $P4, 'inc', $P2
     .return ($P4)
    done:
     .return ()
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:


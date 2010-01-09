# $Id$

=head1

list.pir -- simple implementation list functions

=cut
     .include "iterator.pasm"

.namespace []

.sub 'init_class' :load :init
     $P0 = newclass 'cons'
     addattribute $P0, "first"
     addattribute $P0, "rest"
     addattribute $P0, "node"
.end


.sub first :multi('cons')
     .param pmc val

     $P0 = getattribute val, 'first'
     .return ($P0)
.end

.sub first :multi(_)
     .return (0)
.end

.sub rest :multi('cons')
     .param pmc val

     $P0 = getattribute val, "rest"
     .return ($P0)
.end

.sub 'parse_list'
     .param pmc node
     .param pmc args
     $P0 = 'list'(args :flat)
     setattribute $P0, 'node', node

     .return ($P0)
.end

.sub 'list'
     .param pmc args	:slurpy

     null $P1
     null $P2

     $P3 = iter args
     $P3 = .ITERATE_FROM_END
    it_loop:
     unless $P3 goto it_end

     $P1 = pop $P3

     $P0 = new 'cons'
     setattribute $P0, 'first', $P1
     setattribute $P0, 'rest', $P2

     $P2 = $P0
     goto it_loop
    it_end:
     .return ($P0)
.end

.namespace ['cons']

.sub get_bool :vtable
     .return (1)
.end

.sub get_string :vtable
     .local pmc first
     .local pmc rest
     .local pmc this

     this = self
     null $P0

     $S0 = "("
     goto print
print:
     first = getattribute this, 'first'
     $S1 = first
     $S0 = $S0 . " "
     $S0 = $S0 . $S1

     this = getattribute this, 'rest'
     $I0 = isnull this
     unless $I0 goto print

     $S0 = $S0 . " )"
     .return ($S0)
.end

#.sub 'map'
#     .param pmc func
#     .param pmc l
#     
#     .local pmc c
#     .local pmc n
#
#     c = 'first'(l)
#    start:
#     func(c)

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

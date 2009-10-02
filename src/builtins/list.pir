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

.sub 'safoo'
     'say'("foo")
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

     print $P1

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

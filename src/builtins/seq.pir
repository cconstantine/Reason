# $Id$

=head1

list.pir -- simple implementation list functions

=cut
     .include "iterator.pasm"

.sub 'init_class' :load :init
     $P0 = newclass 'seq'
     addattribute $P0, "val"
     addattribute $P0, "next"
     addattribute $P0, "last"
.end

.namespace []

.sub first :multi('seq')
     .param pmc val 

     $P0 = getattribute val, 'val'
     .return ($P0)
.end

.sub rest :multi('seq')
     .param pmc val

     $P1 = getattribute val, 'val'
     $P2 = getattribute val, 'last'
     null $P0

     if $P1 == $P2 goto end
     $P3 = getattribute val, 'next'

     $P1 = $P3($P1)

     $P0 = new 'seq'
     setattribute $P0, 'val', $P1
     setattribute $P0, 'last', $P2
     setattribute $P0, 'next', $P3 
    end:
     .return ($P0)
.end

.sub seq
     .param pmc first
     .param pmc last
     .param pmc next

     $P0 = new 'seq'
     setattribute $P0, 'val', first
     setattribute $P0, 'last', last
     setattribute $P0, 'next', next
     .return ($P0)
.end


.namespace ['seq']

.sub get_bool :vtable
     .return (1)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

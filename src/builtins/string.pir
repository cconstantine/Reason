# $Id$

=head1

string.pir -- extra string functions

=cut

.namespace []

.sub sprintf
     .param pmc format
     .param pmc args :slurpy

     $P0 = format
     $S0 = $P0

     $P0 = args
     $S0 = sprintf $S0, $P0
     $P0 = box $S0
     .return ($P0)
.end

.namespace ['String']

.sub invoke :vtable
     .param pmc args	:slurpy
     
     $P0 = shift args
     $S0 = self
     $S0 = sprintf $S0, $P0
     $P0 = box $S0
     .return ($P0)
.end
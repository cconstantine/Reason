.HLL 'reason'

.namespace [ 'Reason';'Grammar';'Actions' ]

.sub 'to_past' :multi(_, _)
     .param pmc arg
     .param pmc ast

     .return (ast)
.end

.sub 'to_past' :multi(_,'cons')
     .param pmc arg
     .param pmc ast

     .local pmc node
     node = getattribute ast, 'node'

     $P1 = arg.'compile_node'(node, ast)
     .return ($P1)
.end
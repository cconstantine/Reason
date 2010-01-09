.HLL 'reason'

.namespace [ 'Reason';'Grammar';'Actions' ]

.sub 'to_past' :multi(_, _)
     .param pmc arg
     .param pmc ast
     print "generic\n"
     .return (ast)
.end

.sub 'to_past' :multi(_,'cons')
     .param pmc arg
     .param pmc ast

     .local pmc node
     node = getattribute ast, 'node'
     'say'(node)
#     .return ("")
      $P1 = arg.'compile_func'(node)
     .return ($P1)
.end
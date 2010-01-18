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

.sub 'decorate' :multi(_, _,     _, _)
     .param pmc arg
     .param pmc node
     .param pmc name
     .param pmc scope
#     'say'("Decorating default")
#     _dumper(node, "Node")
#     $S0 = node['type']
#     print $S0
     arg.'decorate_node'(node, name, scope)
     .return()
.end

.sub 'decorate' :multi(_, ['PAST';'Var'], _, _)
     .param pmc arg
     .param pmc node
     .param pmc name
     .param pmc scope
#     'say'("Decorating var\n")
#     _dumper(node, "Node")
     arg.'decorate_symbol'(node, name, scope)
     .return ()
.end
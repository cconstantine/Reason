.HLL 'reason'

.namespace [ 'Reason';'Grammar';'Actions' ]

.sub 'parse_list'
     .param pmc args
     $P0 = 'list'(args :flat)

     .return ($P0)
.end

.sub 'to_past' :multi(_, _)
     .param pmc arg
     .param pmc ast

     .return (ast)
.end

.sub 'to_past' :multi(_,'cons')
     .param pmc arg
     .param pmc ast

     .local pmc cons_hash
     cons_hash = get_global '%?CONS'
     
     .local pmc node
     node = cons_hash[ast]

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

.sub 'name' :multi(_)
     .param pmc arg
     .return ("")
.end

.sub 'name' :multi(['PAST';'Var'])
     .param pmc arg
     $S0 = arg.'name'()
     .return ($S0)
.end

.sub 'exec_macro'
     .param pmc macro
     .param pmc args

     $P0 = macro(args :flat)
      .return ($P0)
.end
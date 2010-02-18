(say '1..2')
(defmacro foo (x) (list (quote say) (quote 'ok ') x))
(foo 1)
(foo 2)
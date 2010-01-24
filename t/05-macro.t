(say '1')
(defmacro foo (x) (list (quote say) (quote 'OK ') x))
(foo 1)
(say '1..4')
(let (ok (fn (msg) (say 'ok ' msg))
      sum (fn (a b) (+ a b))
      double (fn (a) (* a 2)))
    (ok 1)
    (ok (double 1))
    (ok (sum 1 (double 1)))
    (ok (double (sum 1 1)))
)

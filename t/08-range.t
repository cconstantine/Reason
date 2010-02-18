(say '1..100')
(defn map (func seq) 
 (if (exists seq) (let (val (func (first seq))) (tcall map func (rest seq))) 
     seq ))

(defn visit (x)
  (say 'ok ' x))

(map visit (range 1 100 1))

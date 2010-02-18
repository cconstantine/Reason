(say '1..3')
(defn map (func seq) 
 (if (exists seq) (let (val (func (first seq))) (tcall map func (rest seq))) 
     seq ))

(map say (list 'ok 1' 'ok 2' 'ok 3'))

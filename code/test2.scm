(define x 5)
(define identity (lambda (x) x))
(display (identity 5))

(display ((lambda (x) (+ x 1)) 2))
(display "x")
(newline)
(display x)
(newline)

(define a
  (lambda (n) (+ n 5)))
(define b
  (lambda (x y) (+ x y)))

(display "(+ 5 (* 3 1))")
(newline)
(display (+ 5 (* 3 1)))
(newline)

(display "(a 1)")
(newline)
(display (a 1))
(newline)

(display "(b 1 2)")
(newline)
(display (b 1 2))
(newline)

(display "(b (a 3) (b 2 2))")
(newline)
(display (b (a 3) (b 2 2)))
(newline)

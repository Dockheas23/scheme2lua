(define IsInteger
  (lambda (x)
    (integer? x)))

(define Last
  (lambda (l)
    (cond
      ((null? (cdr l)) (car l))
      (else (Last (cdr l))))))

(define Range
  (lambda (lo hi)
    (cond
      ((> lo hi) '())
      (else (cons lo (Range (+ lo 1) hi))))))

(display (Range 1 5))
(display (Last '(9 8 7 6 5 4)))

(define Range
  (lambda (lo hi)
    (cond
      ((> lo hi) '())
      (else (cons lo (Range (+ lo 1) hi))))))

(define Filter
  (lambda (p l)
    (cond
      ((null? l) '())
      ((p (car l)) (cons (car l) (Filter p (cdr l))))
      (else (Filter p (cdr l))))))

(define isPrime
  (lambda (n)
    (if (< n 2) #f
      (let prime ((k 2))
        (cond
          ((= n k) #t)
          ((integer? (/ n k)) #f)
          (else (prime (+ k 1))))))))

(display (Filter isPrime (Range 2 20000)))
(newline)
(exit)

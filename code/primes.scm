(define primes
  (lambda (n)
    (let nextprime ((primecount 1) (current 2))
      (cond
        ((> primecount n) (newline))
        ((isprime? current)
         (display current) (display " ")
         (nextprime (+ primecount 1) (+ current 1)))
        (else (nextprime primecount (+ current 1)))))))

(define isprime?
  (lambda (n)
    (if (< n 2) #f
      (let prime ((k 2))
        (cond
          ((= n k) #t)
          ((integer? (/ n k)) #f)
          (else (prime (+ k 1))))))))

(primes 1000)
(exit)

(define primes
  (lambda (n)
    (let nextprime ((primecount 1) (current 2))
      (cond
        ((> primecount n) (newline))
        ((isPrime current)
         (display primecount) (display ": ") (display current) (newline)
         (nextprime (+ primecount 1) (+ current 1)))
        (else (nextprime primecount (+ current 1)))))))

(define isPrime
  (lambda (n)
    (if (< n 2) #f
      (let prime ((k 2))
        (cond
          ((= n k) #t)
          ((integer? (/ n k)) #f)
          (else (prime (+ k 1))))))))

(primes 5000)
(exit)

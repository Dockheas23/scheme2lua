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

(define Count
  (lambda (x l)
    (cond
      ((null? l) 0)
      ((eqv? x (car l)) (+ 1 (Count x (cdr l))))
      (else (Count x (cdr l))))))

(define Evens
  (lambda (l)
    (cond
      ((null? l) '())
      ((integer? (/ (car l) 2)) (cons (car l) (Evens (cdr l))))
      (else (Evens (cdr l))))))

(define Take
  (lambda (n l)
    (cond
      ((or (null? l) (<= n 0)) '())
      (else (cons (car l) (Take (- n 1) (cdr l)))))))

(define Drop
  (lambda (n l)
    (cond
      ((or (null? l) (<= n 0)) l)
      (else (Drop (- n 1) (cdr l))))))

(define AppendLists
  (lambda (l1 l2)
    (cond
      ((null? l2) l1)
      ((null? l1) l2)
      (else (cons (car l1) (AppendLists (cdr l1) l2))))))

(define Any
  (lambda (p l)
    (and (not (null? l))
	 (or (p (car l)) (Any p (cdr l))))))

(define All
  (lambda (p l)
    (or (null? l)
	(and (p (car l)) (All p (cdr l))))))

(define Filter
  (lambda (p l)
    (cond
      ((null? l) '())
      ((p (car l)) (cons (car l) (Filter p (cdr l))))
      (else (Filter p (cdr l))))))

(define Frequencies
  (lambda (l)
    (cond
      ((null? l) '())
      (else (cons
	      (cons (car l) (list (Count (car l) l)))
	      (Frequencies
		(Filter (lambda (x) (not (eqv? x (car l)))) l))))))) 

(define Compose
  (lambda (l)
    (cond
      ((null? l) (lambda (x) x))
      ((null? (cdr l)) (car l))
      (else (lambda (x) ((car l) ((Compose (cdr l)) x)))))))

(define Merge
  (lambda (l1 l2)
    (cond
      ((null? l2) l1)
      ((null? l1) l2)
      ((< (car l1) (car l2)) (cons (car l1) (Merge (cdr l1) l2)))
      (else (cons (car l2) (Merge l1 (cdr l2)))))))

(define MergeSort
  (lambda (l)
    (cond
      ((or (null? l) (null? (cdr l))) l)
      (else (Merge
	      (MergeSort (Take (/ (length l) 2) l))
	      (MergeSort (Drop (/ (length l) 2) l)))))))

(define QuickSort
  (lambda (l)
    (cond
      ((or (null? l) (null? (cdr l))) l)
      (else (AppendLists
	      (QuickSort (filter (lambda (n) (< n (car l))) l))
	      (AppendLists
		(filter (lambda (n) (= n (car l))) l)
		(QuickSort (filter (lambda (n) (> n (car l))) l))))))))

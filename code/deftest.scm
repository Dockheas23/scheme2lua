(display "(Last '(4 3 5 3 5 5 2)): ")
(display (Last '(4 3 5 3 5 5 2)))
(newline)
(display "(Count 5 '(4 3 5 3 5 5 2)): ")
(display (Count 5 '(4 3 5 3 5 5 2)))
(newline)
(display "(Evens (Range 1 10)): ")
(display (Evens (Range 1 10)))
(newline)
(display "(Take 3 (Range 1 10)): ")
(display (Take 3 (Range 1 10)))
(newline)
(display "(Drop 3 (Range 1 10)): ")
(display (Drop 3 (Range 1 10)))
(newline)
(display "(AppendLists (Range 4 9) '(2 2 1 2)): ")
(display (AppendLists (Range 4 9) '(2 2 1 2)))
(newline)
(display "(Any (lambda (x) (> x 5)) '(2 2 1 2)): ")
(display (Any (lambda (x) (> x 5)) '(2 2 1 2)))
(newline)
(display "(Any (lambda (x) (> x 1)) '(2 2 1 2)): ")
(display (Any (lambda (x) (> x 1)) '(2 2 1 2)))
(newline)
(display "(All (lambda (x) (> x 5)) '(2 2 1 2)): ")
(display (All (lambda (x) (> x 5)) '(2 2 1 2)))
(newline)
(display "(All (lambda (x) (> x 0)) '(2 2 1 2)): ")
(display (All (lambda (x) (> x 0)) '(2 2 1 2)))
(newline)
(display "(Filter (lambda (x) (>= x 2)) '(2 2 1 2)): ")
(display (Filter (lambda (x) (>= x 2)) '(2 2 1 2)))
(newline)
(display "(Frequencies '(1 4 3 5 3 5 5 2)): ")
(display (Frequencies '(1 4 3 5 3 5 5 2)))
(newline)
(display "(MergeSort '(1 4 3 5 3 5 5 2)): ")
(display (MergeSort '(1 4 3 5 3 5 5 2)))
(newline)
(display "(MergeSort '(1 4 3 5 5 5 2)): ")
(display (MergeSort '(1 4 3 5 5 5 2)))
(newline)
(display "(QuickSort '(1 4 3 5 3 5 5 2)): ")
(display (QuickSort '(1 4 3 5 3 5 5 2)))
(newline)
(exit)

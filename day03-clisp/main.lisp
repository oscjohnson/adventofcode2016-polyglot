(defun delimiterp (c) (or (char= c #\Space) (char= c #\,)))

(defun split-string (string &key (delimiterp #'delimiterp))
  (loop :for beg = (position-if-not delimiterp string)
    :then (position-if-not delimiterp string :start (1+ end))
    :for end = (and beg (position-if delimiterp string :start beg))
    :when beg :collect (subseq string beg end)
    :while end))


(defun valid-triangle (a b c) 
	(setq valid 'T)
	
	(if (<= (+ a b) c) (setq valid Nil))
	(if (<= (+ b c) a) (setq valid Nil))
	(if (<= (+ a c) b) (setq valid Nil))

	valid
)

(defun tests () 
	(assert (not (valid-triangle 5 10 25)))
	(assert (valid-triangle 3 4 5))

	; input from advent of code
	(assert (not (valid-triangle 810 679 10))) ; false
  	(assert (valid-triangle 783 255 616)) ; true 
  	(assert (valid-triangle 545 626 626)) ; true
   	(assert (not (valid-triangle 84 910 149))) ; false
)
(tests)


(defun part1 ()
	(setq counter 0)
	(with-open-file (stream "./input.txt")
	    (do ((line (read-line stream nil)
			(read-line stream nil)))
				((null line))
					(let ((values (split-string line)))
						(setq a (parse-integer (pop values)))
						(setq b (parse-integer (pop values)))
						(setq c (parse-integer (pop values)))
						
						(if (valid-triangle a b c) (setq counter (+ counter 1))))))
	counter
)

(defun part2 ()
	(setq counter 0)
	(with-open-file (stream "./input.txt")
	    (do ((line (read-line stream nil)
			(read-line stream nil)))
				((null line))
					(setq line2 (read-line stream))
					(setq line3 (read-line stream))

					(setq line-split1 (split-string line))
					(setq line-split2 (split-string line2))
					(setq line-split3 (split-string line3))

					(setq values1 (list (nth 0 line-split1) (nth 0 line-split2) (nth 0 line-split3)))
					(setq values2 (list (nth 1 line-split1) (nth 1 line-split2) (nth 1 line-split3)))
					(setq values3 (list (nth 2 line-split1) (nth 2 line-split2) (nth 2 line-split3)))

				
					(if (parse-and-check values1) (setq counter (+ counter 1)))
					(if (parse-and-check values2) (setq counter (+ counter 1)))
					(if (parse-and-check values3) (setq counter (+ counter 1)))))
	counter
)

(defun parse-and-check (values) 
	(setq a (parse-integer (pop values)))
	(setq b (parse-integer (pop values)))
	(setq c (parse-integer (pop values)))
	
	(valid-triangle a b c)
)


(print (concatenate 'string (write-to-string (part1)) ", " (write-to-string (part2)) ))











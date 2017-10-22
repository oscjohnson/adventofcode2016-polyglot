(require '[clojure.string :as string])

(def optimization-possible? (fn[sub-instructions]
	(def ins [
   "cpy b c",
   "inc a",
   "dec c",
   "jnz c -2",
   "dec d",
   "jnz d -5"])
		(= ins sub-instructions)
	))

(def cast-op (fn[op1 r]
	(if (re-find #"\d+" op1)
		(read-string op1)
		(get r (keyword op1)))))
	
(def run (fn[instructions ip r toggle-map part2]
	(if (>= ip (count instructions))
		r
		(let [ins (nth instructions ip)]
			(let [[cmd-before-toggle op1 op2] (string/split ins #" ")]
				(if (and (> (count instructions) (+ ip 5)) (optimization-possible? (subvec instructions ip (+ ip 6))))
					(do
						(def n-r (assoc (assoc r :a (+ (get r :a) (* (get r :b) (get r :d)))) :d 0))
						(recur instructions (+ ip 6) n-r toggle-map part2)
						)
					(do
						; toggle adaption
						(def cmd-pre (if (nth toggle-map ip)
							(case cmd-before-toggle
							"inc" "dec"
							"dec" "inc"
							"tgl" "inc"
							"jnz" "cpy"
							"cpy" "jnz"
							cmd-before-toggle
							)
							cmd-before-toggle))
						(def cmd (if (and (= cmd-pre "inc") part2)
							cmd-pre
							cmd-pre))
						(def n-toggle-map
							(if (= cmd "tgl")
								(do
									(def index (+ ip (get r (keyword op1))))
									(if (>= index (count instructions))
										toggle-map
										(assoc toggle-map index (not (nth toggle-map index)))))
								toggle-map))
						(def n-ip (case cmd
								"jnz" (if (= (cast-op op1 r) 0)
												(+ ip 1)
												(+ ip (cast-op op2 r))
											)
								(+ ip 1)
							))
						(def n-r (case cmd
								"cpy" (if (re-find #"\d+" op2)
									r
									(update r (keyword op2) (fn[a] (cast-op op1 r)))
								)
								"dec" (update r (keyword op1) dec)
								"inc" (update r (keyword op1) inc)
								r))
						(recur instructions n-ip n-r n-toggle-map part2) )))))))


(def input (slurp "./input.txt"))
(def instructions (string/split input #"\n"))
(def toggle-map (into [] (replicate (count instructions) false)))

(defn part1[]
	(def r {:a 7, :b 0, :c 0, :d 0})
	(get (run instructions 0 r toggle-map false) :a ))

(defn part2[]
	(def r {:a 12, :b 0, :c 0, :d 0})
	(get (run instructions 0 r toggle-map true) :a ))

(print (part1) (part2))



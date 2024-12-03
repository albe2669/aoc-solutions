(ns aoc.day03
  (:gen-class))

(defn multiply [mul]
  (let [a (Integer/parseInt (second mul)) ;; First is the entire expression
        b (Integer/parseInt (last mul))]
    (* a b)))

(defn part-1 [input]
  (->> input
       (re-seq #"mul\((\d{1,3}),(\d{1,3})\)")
       (map multiply)
       (reduce +)))

(defn multiply-if [matches]
  (loop [[statement & rest] matches, enabled true, acc 0]
    (if (nil? statement)
      acc
      (cond
        (= "do()" (first statement)) (recur rest true acc)
        (= "don't()" (first statement)) (recur rest false acc)
        :else (if enabled
                (recur rest true (+ acc (multiply statement)))
                (recur rest false acc))))))

(defn part-2 [input]
  (->> input
       (re-seq #"do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)")
       multiply-if))

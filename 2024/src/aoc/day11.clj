(ns aoc.day11
  (:require [aoc.utils :as u]))

(defn split-stone [digits]
  (->> digits
       (split-at (/ (count digits) 2))
       (map (comp parse-long (partial apply str)))))

(defn apply-rules [[stone num]]
  (let [digits (str stone)]
    (cond (zero? stone) {1 num}
          (even? (count digits)) (apply merge-with + (map #(hash-map % num) (split-stone digits)))
          :else {(* 2024 stone) num})))

(defn blink-once [stones]
  (apply merge-with + (map apply-rules stones)))

(defn blink [times stones]
  (nth (iterate blink-once (frequencies stones)) times))

(defn part-1 [input]
  (->> input
       u/parse-longs
       (blink 25)
       vals
       (reduce +)))

(defn part-2 [input]
  (->> input
       u/parse-longs
       (blink 75)
       vals
       (reduce +)))

(ns aoc.day02
  (:require [aoc.utils :as utils])
  (:gen-class))

(defn is-ordered [input]
  (or (apply < input) (apply > input)))

(defn diffs [pairs]
  (map #(Math/abs (- (first %) (last %))) pairs))

(defn is-gaps-safe [input]
  (let [parts (partition 2 1 input)]
    (every? #(and (>= % 1) (<= % 3)) (diffs parts))))

(defn part-1 [input]
  (->> input
       utils/to-lines
       (map utils/parse-longs)
       (map vec) ;; Convert the entire tuple to a vector
       (filter is-ordered)
       (filter is-gaps-safe)
       count)) ;; Sum the distances

(defn drop-nth [n ls]
  (concat (take n ls) (drop (inc n) ls)))

(defn gen-variations [input] ;; hehe bruteforce
  (loop [[n & therest] (range (count input))
         acc (list input)]
    (if (nil? n)
      acc
      (recur therest (conj acc (drop-nth n input))))))

(defn any-variation-valid [variations]
  (some #(and (is-ordered %) (is-gaps-safe %)) variations))

(defn part-2 [input]
  (->> input
       utils/to-lines
       (map utils/parse-longs)
       (map gen-variations)
       (filter any-variation-valid)
       count)) ;; Sum the distances

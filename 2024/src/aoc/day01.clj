(ns aoc.day01
  (:require [aoc.utils :as utils])
  (:gen-class))

(defn get-dists [[list1 list2]]
  (let [l1sorted (sort list1)
        l2sorted (sort list2)]
    (map #(Math/abs (- %1 %2)) l1sorted l2sorted)))

(defn part-1 [input]
  (->> input
       utils/to-lines
       (map utils/parse-longs)
       (mapv vec) ;; Convert the entire tuple to a vector
       (apply mapv vector) ;; Transpose the vectors
       get-dists ;; Get the distances
       (reduce +))) ;; Sum the distances

(defn get-similarity [[list1 list2]]
  (let [ft (frequencies list2)]
    (map #(* %1 (get ft % 0)) list1)))

(defn part-2 [input]
  (->> input
       utils/to-lines
       (map utils/parse-longs)
       (mapv vec) ;; Convert the entire tuple to a vector
       (apply mapv vector) ;; Transpose the vectors
       get-similarity ;; Get the similarities
       (reduce +))) ;; Sum the distances

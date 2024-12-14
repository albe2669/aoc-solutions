(ns aoc.day06
  (:require [aoc.utils :as u]))

(def directions {:u [-1 0],
                 :d [1 0],
                 :l [0 -1],
                 :r [0 1]})

(def turn {:u :r,
           :r :d,
           :d :l,
           :l :u})

(defn move [guard direction]
  (mapv + guard (directions direction)))

(defn locate-guard [grid]
  (first (for [y (range (count grid))
               x (range (count (first grid)))
               :when (= (get-in grid [y x]) \^)]
           [y x])))

(defn get-positions [guard grid]
  (loop [guard guard, dir :u, seen #{guard}]
    (let [next (move guard dir)
          space (get-in grid next nil)]
      (cond
        (nil? space) seen
        (= space \#) (recur guard (turn dir) seen)
        :else (recur next dir (conj seen next))))))

(defn solve [grid]
  (get-positions (locate-guard grid) grid))

(defn part-1 [input]
  (->> input
       u/to-lines
       u/to-grid
       solve
       count))

(defn detect-cycle [guard grid]
  (loop [guard guard, dir :u, seen #{}]
    (if (seen [guard dir])
      true
      (let [next (move guard dir)
            space (get-in grid next nil)]
        (cond
          (nil? space) false
          (= space \#) (recur guard (turn dir) (conj seen [guard dir]))
          :else (recur next dir (conj seen [guard dir])))))))

(defn get-cycles [guard grid]
  (reduce (fn [obstacles obstacle]
            (if (detect-cycle guard (assoc-in grid obstacle \#))
              (cons obstacle obstacles)
              obstacles)) () (get-positions guard grid)))

(defn solve2 [grid]
  (get-cycles (locate-guard grid) grid))

(defn part-2 [input]
  (->> input
       u/to-lines
       u/to-grid
       solve2
       count))


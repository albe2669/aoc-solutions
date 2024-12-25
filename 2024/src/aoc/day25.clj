(ns aoc.day25
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(defn parse [input]
  (reduce (fn [parsed block]
            (let [schematic (u/matrix-transpose (u/in-to-matrix block))
                  type (if (= (get-in schematic [0 0]) \#) :locks :keys)]
              (update parsed type conj (mapv #(dec (% \#)) (map frequencies schematic)))))
          {:locks #{}, :keys #{}} (u/to-blocks input)))

(defn key-fits [lock key]
  (every? #(<= % 5) (map + lock key)))

(defn get-matches [{:keys [locks keys]}]
  (for [lock locks, key keys
        :when (key-fits lock key)]
    [lock key]))

(defn part-1 [input]
  (->> input
       parse
       get-matches
       count))

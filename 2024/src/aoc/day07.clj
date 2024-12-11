(ns aoc.day07
  (:require [aoc.utils :as u]
            [clojure.math.combinatorics :as comb]))

(def ^:private operators [[0 1] [* +]])

(defn calculate [available-ops [lead & numbers] combo]
  (reduce (fn [acc [n operator]]
            ((available-ops operator) acc n))
          lead (map vector numbers combo)))

(defn evaluate [[combospots available-ops] [calibration & values]]
  (let [number (dec (count values))
        combos (comb/selections combospots number)]
    (loop [[combo & rest] combos]
      (if (nil? combo)
        0
        (let [value (calculate available-ops values combo)]
          (if (= value calibration)
            calibration
            (recur rest)))))))

(defn part-1 [input]
  (->> input
       u/to-lines
       (map u/parse-longs)
       (map (partial evaluate operators))
       (reduce +)))

(defn elecat [a b]
  (parse-long (apply str [a b])))

(def ^:private operators2 [[0 1 2] [* + elecat]])

(defn part-2 [input]
  (->> input
       u/to-lines
       (map u/parse-longs)
       (map (partial evaluate operators2))
       (reduce +)))

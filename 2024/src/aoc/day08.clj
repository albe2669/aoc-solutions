(ns aoc.day08
  (:require [aoc.utils :as u]
            [clojure.core.reducers :as r]
            [clojure.math.combinatorics :as c]))

(defn get-freqs [row-num line]
  (let [freqs (u/regex-pos #"[a-zA-Z0-9]" line)]
    (map #(vector [row-num (first %)] (last %)) freqs)))

(defn group-freqs [freqs [pos freq]]
  (update freqs freq (partial cons pos)))

(defn gen-next [op dx dy [row col]]
  [(op row dy) (op col dx)])

(defn get-antinodes [[[row-a col-a] [row-b col-b]]]
  (let [dx (- col-b col-a)
        dy (- row-b row-a)]
    [(gen-next - dx dy [row-a col-a])
     (gen-next + dx dy [row-b col-b])]))

(defn part-1 [input]
  (let [lines (u/to-lines input)
        bound-fn (u/out-of-bounds-fn (count lines) (count (first lines)))]
    (->> lines
         (map-indexed get-freqs)
         (mapcat identity)
         (reduce group-freqs {})
         vals
         (mapcat #(c/combinations % 2))
         (mapcat get-antinodes)
         (remove bound-fn)
         distinct
         count)))

(defn get-all-antinodes [bound-fn [[row-a col-a] [row-b col-b]]]
  (let [dx (- col-b col-a)
        dy (- row-b row-a)]
    (concat (take-while (complement bound-fn) (iterate (partial gen-next - dx dy) [row-a col-a]))
            (take-while (complement bound-fn) (iterate (partial gen-next + dx dy) [row-b col-b])))))

(defn part-2 [input]
  (let [lines (u/to-lines input)
        bound-fn (u/out-of-bounds-fn (count lines) (count (first lines)))]
    (->> lines
         (map-indexed get-freqs)
         (mapcat identity)
         (reduce group-freqs {})
         vals
         (mapcat #(c/combinations % 2))
         (mapcat (partial get-all-antinodes bound-fn))
         distinct
         count)))

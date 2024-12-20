#_{:clj-kondo/ignore [:namespace-name-mismatch]}
(ns aoc.utils
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

(defn to-lines [input]
  (str/split-lines input))

(defn to-grid [input]
  (->> input
       (mapv str/trim)
       (mapv #(vec (mapv char %)))))

(defn to-chars [input]
  (map char input))

(defn to-strs [input]
  (map str input))

(defn out-of-bounds-fn [row-bound col-bound]
  (fn [[row col]]
    (or (>= row row-bound) (>= col col-bound)
        (< row 0) (< col 0))))

(defn to-blocks [input]
  (str/split input #"\n\n"))

(defn parse-longs [line]
  (mapv parse-long (re-seq #"\d+" line)))

(defn parse-longs-seq [input]
  (map parse-long input))

;; Stolen from: https://github.com/rjray/advent-2024-clojure/blob/master/src/advent_of_code/utils.clj
(defn read-input
  "Read in the content of the given day-file and return as a blob"
  [day]
  (slurp (if (str/starts-with? day "/") day (io/resource day))))

;; Like the core time macro, but rather than printing the elapsed time it
;; returns a list of (result, time). Returned value is in milliseconds.
(defmacro time-it [expr]
  `(let [start# (. System (nanoTime))
         ret#   ~expr
         end#   (/ (double (- (. System (nanoTime)) start#)) 1000000.0)]
     (list ret# end#)))

(defn regex-pos
  "Return a list of pairs of (index, string) for all matches of `re` in `s`"
  [regex str]
  (loop [m (re-matcher regex str), res ()]
    (if (.find m)
      (recur m (cons (list (.start m) (.group m)) res))
      (reverse res))))

(defn matrix-to-map [matrix]
  (into {}
        (for [row (range (count matrix))
              col (range (count (first matrix)))
              :let [coord [row col]]]
          [coord (get-in matrix coord)])))

(defn neighbors [[row col]]
  [{:coord [(dec row) (dec col)] :dir :up-left}
   {:coord [(dec row) col] :dir :up}
   {:coord [(dec row) (inc col)] :dir :up-right}
   {:coord [row (dec col)] :dir :left}
   {:coord [row (inc col)] :dir :right}
   {:coord [(inc row) (dec col)] :dir :down-left}
   {:coord [(inc row) col] :dir :down}
   {:coord [(inc row) (inc col)] :dir :down-right}])

(defn direct-neighbors [coord]
  (filter #(#{:up :down :left :right} (:dir %)) (neighbors coord)))

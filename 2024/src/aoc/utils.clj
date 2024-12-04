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

(defn parse-longs [line]
  (mapv parse-long (re-seq #"\d+" line)))

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

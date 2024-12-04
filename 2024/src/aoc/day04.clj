(ns aoc.day04
  (:require [aoc.utils :as u])
  (:gen-class))

(defn get-cell
  [grid x y]
  (when (and (>= x 0) (>= y 0)
             (< x (count grid))
             (< y (count (first grid))))
    (get-in grid [x y])))

(defn check-word
  [grid x y dx dy word]
  (let [word-length (count word)]
    (loop [i 0
           cur-x x
           cur-y y]
      (cond
        (= i word-length) true
        (nil? (get-cell grid cur-x cur-y)) false
        (not= (get-cell grid cur-x cur-y) (nth word i)) false
        :else (recur (inc i)
                     (+ cur-x dx)
                     (+ cur-y dy))))))

(defn count-word-occurrences
  [word grid]
  (let [rows (count grid)
        cols (count (first grid))
        directions [[0 1]   ; horizontal
                    [1 0]   ; vertical
                    [1 1]   ; diagonal down-right
                    [-1 1]  ; diagonal up-right
                    [0 -1]  ; horizontal backwards
                    [-1 0]  ; vertical backwards
                    [-1 -1] ; diagonal up-left
                    [1 -1]  ; diagonal down-left
                    ]]
    (filter true?
            (for [x (range rows)
                  y (range cols)
                  [dx dy] directions]
              (check-word grid x y dx dy word)))))

(defn part-1 [input]
  (->> input
       u/to-lines
       u/to-grid
       (count-word-occurrences "XMAS")
       count))

(defn match-char
  [grid-char pattern-char]
  (or (= pattern-char \.)
      (= grid-char pattern-char)))

(defn is-valid-mas
  [grid x1 y1 x2 y2 x3 y3]
  (or
   (and
    (match-char (get-cell grid x1 y1) \M)
    (match-char (get-cell grid x2 y2)  \A)
    (match-char (get-cell grid x3 y3)  \S))
   (and
    (match-char (get-cell grid x1 y1) \S)
    (match-char (get-cell grid x2 y2)  \A)
    (match-char (get-cell grid x3 y3)  \M))))

(defn get-mas
  [grid]
  (let [rows (count grid)
        cols (count (first grid))]
    (filter true?
            (for [x (range (- rows 2))
                  y (range (- cols 2))]
              (and (is-valid-mas grid x y
                                 (+ x 1) (+ y 1)
                                 (+ x 2) (+ y 2))
                   (is-valid-mas grid x (+ y 2)
                                 (+ x 1) (+ y 1)
                                 (+ x 2) y))))))

(defn part-2 [input]
  (->> input
       u/to-lines
       u/to-grid
       get-mas
       count))

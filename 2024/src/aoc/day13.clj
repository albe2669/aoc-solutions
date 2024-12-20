(ns aoc.day13
  (:require
   [aoc.utils :as u]))

(defn solve [[ax ay bx by px py]]
  (let [solutions (for [a (range 101), b (range 101) :when
                        (and (= px (+ (* a ax) (* b bx)))
                             (= py (+ (* a ay) (* b by))))]
                    (+ (* 3 a) b))]
    (if (seq solutions)
      (apply min solutions)
      0)))

(defn part-1 [input]
  (->> input
       u/to-blocks
       (map u/parse-longs)
       (map solve)
       (reduce +)))

(defn aug [[ax ay bx by px py]]
  (list ax ay bx by (+ 10000000000000 px) (+ 10000000000000 py)))

(defn get-determinant [a b]
  (- (* (first a) (last b)) (* (first b) (last a))))

(defn find-solution [[ax ay bx by px py]]
  (let [det-ab (get-determinant [ax ay] [bx by])
        det-ap (get-determinant [ax ay] [px py])
        det-pb (get-determinant [px py] [bx by])]
    (if (= 0 (mod det-pb det-ab) (mod det-ap det-ab))
      (+ (* 3 (/ det-pb det-ab)) (/ det-ap det-ab))
      0)))

(defn part-2 [input]
  (->> input
       u/to-blocks
       (map u/parse-longs)
       (map aug)
       (map find-solution)
       (reduce +)))

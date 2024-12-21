(ns aoc.day14
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(def grid-size [101 103])
;(def grid-size [11 7])

(defn create-robots [[x y vx vy]]
  {:position [x y]
   :velocity [vx vy]})

(defn move-robot [n robot]
  (let [loc (:position robot)
        vel (:velocity robot)
        new (map + loc (mapv * vel [n n]))]
    {:position [(mod (first new) (first grid-size)) (mod (last new) (last grid-size))], :velocity vel}))

(defn move-robots [n robots]
  (map #(move-robot n %) robots))

(defn get-quad [[x y]]
  (let [width-mid (quot (first grid-size) 2)
        height-mid (quot (last grid-size) 2)]
    (cond
      (and (< x width-mid) (< y height-mid)) 1
      (and (< x width-mid) (> y height-mid)) 2
      (and (> x width-mid) (< y height-mid)) 3
      (and (> x width-mid) (> y height-mid)) 4
      :else 0)))

(defn part-1 [input]
  (->> input
       u/to-lines
       (map u/parse-longs)
       (map create-robots)
       (move-robots 100)
       (map :pos)
       (map get-quad)
       (frequencies)
       (sort-by first)
       rest
       (map second)
       (reduce *)))

(defn is-line [grid y]
  (let [line (apply str (for [x (range (first grid-size))
                              :let [val (if (grid [x y]) "x" ".")]] val))]
    (str/includes? line "xxxxxxxxxxxxxxxxxx")))

(defn find-line [positions]
  (let [height (last grid-size)]
    (loop [[y & ys] (range height)]
      (if (nil? y)
        false
        (if (is-line (set positions) y)
          true
          (recur ys))))))

(defn find-tree [robots]
  (loop [robots (move-robots 1 robots), seconds 1]
    (println seconds)
    (if (find-line (map :position robots))
      seconds
      (recur (move-robots 1 robots) (inc seconds)))))

(defn part-2 [input]
  (->> input
       u/to-lines
       (map u/parse-longs)
       (map create-robots)
       find-tree))

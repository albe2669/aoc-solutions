(ns aoc.day16
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(def valid-directions {:up #{:up :left :right}
                       :down #{:down :left :right}
                       :left #{:left :up :down}
                       :right #{:right :up :down}})

(defn neighbours [walls [coord direction]]
  (apply merge
         (map (fn [neighbour]
                (if-not (= direction (:dir neighbour))
                  (assoc {} [coord (:dir neighbour)] 1000)
                  (assoc {} [(:coord neighbour) direction] 1)))
              (->> (u/direct-neighbors coord)
                   (filter (comp (valid-directions direction) :dir))
                   (remove (comp walls :coord))))))

(defn part-1 [input]
  (let [maze (->> input
                  u/to-lines
                  u/matrix-to-map)
        walls (set (keep #(when (= \# (last %)) (first %)) maze))
        start (some #(when (= \S (last %)) (first %)) maze)
        end (some #(when (= \E (last %)) (first %)) maze)]
    (->> (u/dijkstra [start :right] end (partial neighbours walls))
         (keep #(when (= end (ffirst %)) (last %)))
         ffirst)))

(defn find-all-nodes [start end graph]
  (loop [[position & tail] (map first (filter #(= end (ffirst %)) graph))
         seen #{}]
    (cond (not (seq position)) []
          (= (first position) start) (conj seen position)
          (seen position) (recur tail seen)
          :else (recur (concat tail (seq (last (graph position)))) (conj seen position)))))

(defn part-2 [input]
  (let [maze (->> input
                  u/to-lines
                  u/matrix-to-map)
        walls (set (keep #(when (= \# (last %)) (first %)) maze))
        start (some #(when (= \S (last %)) (first %)) maze)
        end (some #(when (= \E (last %)) (first %)) maze)]
    (->> (u/dijkstra [start :right] [end :right] (partial neighbours walls) :alt-targets #{[end :left] [end :up] [end :down]})
         (find-all-nodes start end)
         (map first)
         set
         count)))

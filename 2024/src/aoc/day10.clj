(ns aoc.day10
  (:require [aoc.utils :as u]))

(defn get-trailheads [map]
  (->> map
       seq
       (keep #(when (zero? (last %)) (first %)))))

(defn get-next-positions [[row col]]
  [[row (inc col)]
   [row (dec col)]
   [(inc row) col]
   [(dec row) col]])

(defn get-trailhead-scores [input is-part-2 trailhead]
  (count
   (reduce (fn [trails position]
             (if-not (seq trails)
               (reduced nil)
               (->> trails
                    (mapcat get-next-positions)
                    (#(if-not is-part-2 (distinct %) %))
                    (filter #(= position (input %))))))
           [trailhead]
           (range 1 10))))

(defn solve [part-2 input]
  (->> (get-trailheads input)
       (map (partial get-trailhead-scores input part-2))
       (reduce +)))

(defn part-1 [input]
  (->> input
       u/to-lines
       (map #(re-seq #"\d" %))
       (mapv #(mapv parse-long %))
       u/matrix-to-map
       (solve false)))

(defn part-2 [input]
  (->> input
       u/to-lines
       (map #(re-seq #"\d" %))
       (mapv #(mapv parse-long %))
       u/matrix-to-map
       (solve true)))

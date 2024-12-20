(ns aoc.day12
  (:require
   [aoc.utils :as u]
   [clojure.set :as set]))

(defn get-region [matrix start visited]
  (loop [[plot & plots] [start]
         result #{}]
    (cond (empty? plot) result
          (or (visited plot) (result plot) (not= (matrix start) (matrix plot))) (recur plots result)
          :else (recur (concat plots (map :coord (u/direct-neighbors plot))) (conj result plot)))))

(defn get-regions [matrix]
  (loop [[plot & plots] (mapv first matrix)
         regions []
         visited #{}]
    (cond (empty? plot) regions
          (visited plot) (recur plots regions visited)
          :else (let [region (get-region matrix plot visited)]
                  (recur plots (conj regions region) (set/union region visited))))))

(defn get-perimiter [region]
  (->> region
       (map #(- 4 (count (filter region (map :coord (u/direct-neighbors %))))))
       (reduce +)))

(defn get-price [region]
  (* (count region) (get-perimiter region)))

(defn part-1 [input]
  (->> input
       u/to-lines
       u/to-grid
       u/matrix-to-map
       get-regions
       (map get-price)
       (reduce +)))

(defn count-vertical-neighbors [region [row col]]
  (let [nbrs (filter (comp region first)
                     [[[(dec row) col] :up] [[(inc row) col] :down]])]
    (condp = (count nbrs)
      0 :none
      1 (last (first nbrs))
      2 nil)))

(defn find-horizontal-sides [row]
  (reduce (fn [res [[p-row p-col :as pos] nbrs]]
            (let [prev-pos [p-row (dec p-col)]
                  sides (if (= :none nbrs) 2 1)]
              (cond (nil? (row prev-pos)) (+ res sides)
                    (= :none (row prev-pos)) res
                    (not= (row prev-pos) nbrs) (inc res)
                    (= (row prev-pos) (row pos)) res)))
          0
          row))

(defn count-horizontal-sides [region]
  (let [rows (vals (group-by first region))]
    (reduce +
            (map (partial find-horizontal-sides)
                 (map (comp (partial into (sorted-map))
                            (partial keep #(when (last %) %))
                            (partial map #(vector % (count-vertical-neighbors region %))))
                      rows)))))

(defn transpose-region [region]
  (set (map #(vector (last %) (first %)) region)))

(defn- count-sides [region]
  (+ (count-horizontal-sides region) (count-horizontal-sides (transpose-region region))))

(defn get-bulk-price [region]
  (* (count region) (count-sides region)))

(defn part-2 [input]
  (->> input
       u/to-lines
       u/to-grid
       u/matrix-to-map
       get-regions
       (map get-bulk-price)
       (reduce +)))



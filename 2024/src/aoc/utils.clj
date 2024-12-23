#_{:clj-kondo/ignore [:namespace-name-mismatch]}
(ns aoc.utils
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [clojure.data.priority-map :refer [priority-map-keyfn]]))

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
  (mapv parse-long (re-seq #"[-+]?\d+" line)))

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

(defn dissoc-by [pred m]
  (apply dissoc m (filter pred (keys m))))

(defn- merge-costs [[curr-cost curr-prevs :as curr] [new-cost new-prevs :as new]]
  (cond (= curr-cost new-cost) [curr-cost (set/union curr-prevs new-prevs)]
        (< new-cost curr-cost) new
        :else curr))

(defn dijkstra
  "Dijkstra's algorithm for finding the minimum path between two positions in
  a matrix. Positions consist of a coordinate and a direction.
  
  - start: the start position [coordinate, direction]
  - target: the target coordinate. This does not include the direction.
  - neighbour-fn: a function that takes a position and returns a map of positions and
  the cost of travelling to that position.
  - alt-targets: specifies alternate nodes that are also targets. This is
  useful when node have an associated state that don't matter for the target.
  For example, if you're doing this search on a matrix where the direction
  you're travelling in is important."
  [start target neighbour-fn & {:keys [alt-targets] :or {alt-targets #{}}}]
  (loop [q (priority-map-keyfn first start [0 #{}])
         res {}]
    (let [[node [cost :as cost-and-prevs]] (peek q)]
      (cond (not (seq q)) res
            (or (= node target) (alt-targets node))
            (assoc res node cost-and-prevs)
            :else
            (let [new-costs (->> (neighbour-fn node)
                                 ;; skip nodes we've visited
                                 (dissoc-by #(res %))
                                 (#(update-vals % (partial + cost))))]
              (recur (merge-with merge-costs
                                 (pop q)
                                 (update-vals new-costs #(vector % (set [node]))))
                     (assoc res node cost-and-prevs)))))))

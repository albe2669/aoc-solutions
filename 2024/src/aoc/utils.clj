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

(defn in-to-matrix [input]
  (->> input
       to-lines
       (mapv vec)))

(defn matrix-transpose [matrix] (apply mapv vector matrix))

(defn to-blocks [input]
  (str/split input #"\n\n"))

(defn out-of-bounds-fn [row-bound col-bound]
  (fn [[row col]]
    (or (>= row row-bound) (>= col col-bound)
        (< row 0) (< col 0))))

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

(def directions
  [{:dir :up-left :delta [-1 -1]}
   {:dir :up :delta [-1 0]}
   {:dir :up-right :delta [-1 1]}
   {:dir :left :delta [0 -1]}
   {:dir :right :delta [0 1]}
   {:dir :down-left :delta [1 -1]}
   {:dir :down :delta [1 0]}
   {:dir :down-right :delta [1 1]}])

(defn neighbors [[row col]]
  (for [{:keys [dir delta]} directions
        :let [row' (+ row (first delta))
              col' (+ col (second delta))]]
    {:coord [row' col'] :dir dir :delta delta}))

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

(defn dijkstra-matrix
  "Dijkstra's algorithm for finding the minimum path between two positions in
  a matrix. Positions consist of a coordinate and a direction.
  
  - start: the start position [coordinate, direction]
  - target: the target coordinate. This does not include the direction.
  - nbrs-fn: a function that takes a position and returns a map of positions and
  the cost of travelling to that position.
  - transform-fn: transform a position to another unique identifer. For example,
  using first as the transform-fn will ignore direction."
  [start target nbrs-fn & {:keys [transform-fn] :or {transform-fn identity}}]
  (loop [q (priority-map-keyfn first start [0 #{}])
         res {}]
    (let [[[coord :as pos] [cost :as cost-and-prevs]] (peek q)]
      (cond (not (seq q)) res
            (= coord target)
            (assoc res (transform-fn pos) cost-and-prevs)
            :else
            (let [new-costs (->> (nbrs-fn pos)
                                 ;; skip nodes we've visited
                                 (dissoc-by #(res (transform-fn %)))
                                 (#(update-vals % (partial + cost))))]
              (recur (merge-with merge-costs
                                 (pop q)
                                 (update-vals new-costs #(vector % (set [(transform-fn pos)]))))
                     (assoc res (transform-fn pos) cost-and-prevs)))))))

(defn dfs
  "Depth First Search Algorithm
  - start: the start node
  - target: the target node
  - nbrs-fn: a functions that takes a node and returns a list of its neighboring
  nodes."
  [start target nbrs-fn]
  (loop [q [[start []]]
         res {}]
    (let [[curr path] (peek q)]
      (cond (nil? curr) res
            (= curr target) (assoc res target (conj path target))
            (res curr) (recur (pop q) res)
            :else (recur (vec (concat (pop q)
                                      (map #(vector % (conj path curr))
                                           (nbrs-fn curr))))
                         (assoc res curr (conj path curr)))))))

(defn manhattan-distance [[r1 c1] [r2 c2]]
  (+ (Math/abs (- r1 r2))
     (Math/abs (- c1 c2))))

(defn create-field
  "Create a NxM field as a matrix (vector of vectors). Fill with `with` or nil"
  [N M & [with]]
  (if (or (seq? with) (vector? with))
    ;; Ignore N/M and treat each element of `with` as a row in the field
    (mapv vec with)
    ;; Otherwise, use the value of `with` itself (which may be nil)
    (vec (repeat M (vec (repeat N with))))))

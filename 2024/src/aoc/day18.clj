(ns aoc.day18
  (:require
   [aoc.utils :as u]))

(def end [70 70])
(def NUM_BYTES 1024)

(defn get-bytes [input]
  (->> input
       u/to-lines
       (take 1024)
       (map (comp vec reverse u/parse-longs))
       set))
(def out-of-bounds (u/out-of-bounds-fn (inc (first end)) (inc (last end))))

(defn neighbors [bytes coord]
  (apply merge (map #(assoc {} % 1)
                    (keep #(when-not (or (out-of-bounds (:coord %))
                                         (bytes (:coord %)))
                             (:coord %))
                          (u/direct-neighbors coord)))))

(defn part-1 [input]
  (let [bytes (get-bytes input)
        graph (u/dijkstra [0 0] end (partial neighbors bytes))]
    (first (graph end))))

(defn get-neighbors2 [bytes coord]
  (keep #(when-not (or (out-of-bounds (:coord %))
                       (bytes (:coord %)))
           (:coord %))
        (u/direct-neighbors coord)))

(defn dfs [bytes start target]
  ((u/dfs start target #(get-neighbors2 bytes %)) target))

(defn get-first-failing-byte [bytes]
  (loop [[byte & rem] (drop NUM_BYTES bytes)
         seen-bytes (set (take NUM_BYTES bytes))
         last-path (set nil)]
    (let [new-bytes (conj seen-bytes byte)]
      (cond (nil? rem) nil
            (and (seq last-path) (not (last-path byte))) (recur rem new-bytes last-path)
            :else (if-let [path (dfs new-bytes [0 0] end)]
                    (recur rem new-bytes path)
                    byte)))))

(defn part-2 [input]
  (let [bytes (->> input
                   u/to-lines
                   (map (comp vec reverse u/parse-longs)))]
    (reverse (get-first-failing-byte bytes))))

(ns aoc.day09
  (:require [aoc.utils :as u]))

(defn create-memory [input]
  (loop [file true, id 0, memory (transient []) [head & tail] input]
    (if (nil? head)
      (persistent! memory)
      (if file
        (recur false (inc id) (reduce conj! memory (repeat head id)) tail)
        (recur true id (reduce conj! memory (repeat head nil)) tail)))))

(defn defrag [memory]
  (loop [i (dec (count memory)), j 0, res (transient [])]
    (if (< i j)
      (persistent! res)
      (if-let [v (get memory j)]
        (recur i (inc j) (conj! res v))
        (recur (loop [i (dec i)]
                 (if (get memory i)
                   i
                   (recur (dec i))))
               (inc j) (conj! res (get memory i)))))))

(defn part-1 [input]
  (->> input
       u/to-lines
       first
       (re-seq #"\d")
       (map parse-long)
       create-memory
       defrag
       (reduce-kv #(+ %1 (* %2 %3)) 0)))

(defn fragment-map
  "Returns a tuple of empty blocks and blocks, empty is [index size] and blocks is [index [value size]]"
  [fragments]
  (reduce (fn [[empty blocks i] h]
            (let [v (first h), size (count h)]
              (if v
                [empty (assoc blocks i [v size]) (+ i size)]
                [(assoc empty i size) blocks (+ i size)]))) [(sorted-map) (sorted-map) 0] fragments))

(defn get-free-location [free-blocks index size]
  (first (into [] (comp (take-while (fn [[i]] (< i index)))
                        (filter (fn [[_ bs]] (>= bs size)))
                        (take 1))
               free-blocks)))

(defn consolidate [empty-memory value size]
  (cond-> (assoc empty-memory value size)
    (get empty-memory (+ value size)) (-> (dissoc empty-memory (+ value size))
                                          (update value + (get empty-memory (+ value size))))))

(defn file-defrag [memory]
  (let [fragments (vec (partition-by identity memory))
        [empty blocks] (fragment-map fragments)]
    (loop [[[index [value size]] & tail] (reverse blocks)
           empty empty
           blocks blocks]
      (if (nil? index)
        blocks
        (if-let [[free-idx free-size] (get-free-location empty index size)]
          (recur tail
                 (cond-> (dissoc empty free-idx)
                   (not= free-size size) (consolidate (+ free-idx size) (- free-size size))
                   :always (assoc value size))
                 (-> (dissoc blocks index)
                     (assoc free-idx [value size])))
          (recur tail empty blocks))))))

(defn part-2 [input]
  (->> input
       u/to-lines
       first
       (re-seq #"\d")
       (map parse-long)
       create-memory
       file-defrag
       (reduce-kv (fn [acc i [v s]] (reduce (fn [acc idx] (+ acc (* idx v))) acc (range i (+ i s)))) 0)))


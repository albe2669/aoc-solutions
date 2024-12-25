(ns aoc.day22
  (:require
   [aoc.utils :as u]))

(defn mix-and-prune [new-num secret]
  (mod (bit-xor new-num secret) 16777216))

(defn next-num [num]
  (as-> num $
    (mix-and-prune (bit-shift-left $ 6) $)
    (mix-and-prune (bit-shift-right $ 5) $)
    (mix-and-prune (bit-shift-left $ 11) $)))

(defn get-nth [n num]
  (second (take-nth n (iterate next-num num))))

(defn part-1 [input]
  (->> input
       u/to-lines
       (map parse-long)
       (map (partial get-nth 2000))
       (reduce +)))

(defn get-prices [num]
  (map #(mod % 10) (take 2001 (iterate next-num num))))

(defn get-diffs [prices]
  (let [diffs (map vec (partition 4 1 (map #(apply - (reverse %)) (partition 2 1 prices))))]
    (map list diffs (drop 4 prices))))

(defn map-diffs [memo pairs]
  (loop [[[diff price] & tail] pairs, memo memo, seen #{}]
    (if (nil? diff)
      memo
      (if (seen diff)
        (recur tail memo seen)
        (recur tail (update memo diff (fnil + 0) price) (conj seen diff))))))

(defn part-2 [input]
  (->> input
       u/to-lines
       (map parse-long)
       (map get-prices)
       (map get-diffs)
       (reduce (fn [memo mapping]
                 (map-diffs memo mapping)) {})
       vals
       (apply max)))



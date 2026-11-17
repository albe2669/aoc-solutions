(ns aoc.day21
  (:require [clojure.math.combinatorics :as mc]
            [clojure.string :as str]))

(def numeric-keypad
  {\7 [0 0] \8 [0 1] \9 [0 2]
   \4 [1 0] \5 [1 1] \6 [1 2]
   \1 [2 0] \2 [2 1] \3 [2 2]
   \0 [3 1] \A [3 2]})

(def directional-keypad
  {\^ [0 1] \A [0 2]
   \< [1 0] \v [1 1] \> [1 2]})

(def move-deltas
  {\^ [-1 0] \v [1 0] \< [0 -1] \> [0 1]})

(defn- moves-between
  "All key sequences that move from `from` to `to` on `keypad`
  without crossing the missing key."
  [keypad from to]
  (let [[r1 c1] (keypad from)
        [r2 c2] (keypad to)
        dr (- r2 r1)
        dc (- c2 c1)
        vs (repeat (Math/abs dr) (if (pos? dr) \v \^))
        hs (repeat (Math/abs dc) (if (pos? dc) \> \<))
        path-valid? (fn [s]
                      (loop [pos [r1 c1] [m & ms] s]
                        (if (nil? m)
                          true
                          (let [pos' (mapv + pos (move-deltas m))]
                            (when (some #(= pos' %) (vals keypad))
                              (recur pos' ms))))))
        seqs (distinct (mc/permutations (concat vs hs)))]
    (filter path-valid? seqs)))

(defn- cost
  "Fewest presses needed for the robot chain to type the move from
  `from` to `to` (including the final A press) with `depth` robots
  below the keypad the keys live on."
  [cache keypad from to depth]
  (let [k [keypad from to depth]]
    (or (get @cache k)
        (let [v (if (zero? depth)
                  (inc (count (first (moves-between keypad from to))))
                  (let [presses (fn [seq']
                                  (let [steps (concat seq' [\A])]
                                    (->> (map (fn [prev cur]
                                                (cost cache directional-keypad prev cur (dec depth)))
                                              (cons \A steps)
                                              steps)
                                         (reduce +))))]
                    (->> (moves-between keypad from to)
                         (map presses)
                         (apply min))))]
          (swap! cache assoc k v)
          v))))

(defn- solve
  [input robots]
  (let [cache (atom {})]
    (->> (str/split-lines input)
         (map (fn [code]
                (* (parse-long (apply str (butlast code)))
                   (reduce +
                           (map (fn [prev cur]
                                  (cost cache numeric-keypad prev cur robots))
                                (cons \A code) code)))))
         (reduce +))))

(defn part-1 [input]
  (solve input 2))

(defn part-2 [input]
  (solve input 25))

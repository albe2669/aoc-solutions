(ns aoc.day24
  (:require [aoc.utils :as u]
            [clojure.string :as str]))

(def op-codes {"AND" 0, "OR" 1, "XOR" 2})

(defn- parse-gate [line]
  (let [[_ a op b out] (re-matches #"(\w+) (AND|OR|XOR) (\w+) -> (\w+)" line)]
    {:in [a b] :op-name op :out out}))

(defn parse-input [input]
  (let [[wire-block gate-block] (u/to-blocks input)]
    {:wires (->> (u/to-lines wire-block)
                 (map #(str/split % #": "))
                 (into {}))
     :gates (mapv parse-gate (u/to-lines gate-block))}))

(defn- input-wire? [w]
  (boolean (re-matches #"[xy]\d\d" w)))

(defn- topo-gates
  "Order the gates so that every input of a gate is computed first."
  [gates]
  (loop [pending gates
         ordered []
         known #{}]
    (if (empty? pending)
      ordered
      (let [ready (filter (fn [{:keys [in]}]
                            (every? #(or (input-wire? %) (known %)) in))
                          pending)]
        (if (empty? ready)
          (throw (ex-info "Circuit contains a cycle" {}))
          (recur (remove (set ready) pending)
                 (into ordered ready)
                 (into known (map :out ready))))))))

(defn- compile-circuit
  "Turn the gates into int arrays. Wire names are indexes,
  ops are codes: 0 AND, 1 OR, 2 XOR."
  [ordered n-bits]
  (let [xy (vec (mapcat (fn [p] (map #(format "%s%02d" p %) (range n-bits)))
                        ["x" "y"]))
        wires (into xy (map :out ordered))
        idx (into {} (map-indexed (fn [i w] [w i]) wires))
        rows (mapv (fn [{:keys [in op-name out]}]
                     [(idx (first in)) (idx (second in)) (op-codes op-name) (idx out)])
                   ordered)
        produced (set (range (count xy) (count wires)))
        waits (int-array
               (mapv (fn [row]
                       (count (filter produced (take 2 row))))
                     rows))
        consumers (->> (map-indexed (fn [g row] g) rows)
                       (mapcat (fn [g]
                                 (keep (fn [w] (when (produced w) [w g]))
                                       (take 2 (rows g)))))
                       (group-by first)
                       (#(into {} (map (fn [[w gs]]
                                         [w (int-array (sort (map second gs)))])
                                       %))))]
    {:wire-count (count wires)
     :xy-count (count xy)
     :wires wires
     :idx idx
     :waits waits
     :consumers consumers
     :in1 (int-array (mapv first rows))
     :in2 (int-array (mapv second rows))
     :op (int-array (mapv #(nth % 2) rows))
     :out (int-array (mapv #(nth % 3) rows))}))

(defn- eval-circuit
  [c ^longs vals]
  (let [{:keys [^ints in1 ^ints in2 ^ints op ^ints out ^ints waits consumers]} c
        n (alength in1)
        ready (java.util.ArrayDeque.)]
    (dotimes [g n]
      (when (zero? (aget waits g))
        (.add ready g)))
    (loop [waits (aclone waits)]
      (when-let [g (.poll ready)]
        (let [a (aget vals (aget in1 g))
              b (aget vals (aget in2 g))
              r (case (int (aget op g))
                  0 (bit-and a b)
                  1 (bit-or a b)
                  2 (bit-xor a b))]
          (aset vals (aget out g) r)
          (doseq [g' (get consumers (aget out g) [])]
            (let [w (dec (aget waits g'))]
              (aset waits g' w)
              (when (zero? w)
                (.add ready g')))))
        (recur waits))))
  vals)

(defn- swapped
  [c i j]
  (let [swap-arr (fn [^ints arr]
                   (let [arr (aclone arr)]
                     (dotimes [k (alength arr)]
                       (let [v (aget arr k)]
                         (cond (= v i) (aset arr k j)
                               (= v j) (aset arr k i))))
                     arr))]
    (assoc c :out (swap-arr (:out c)))))

(defn- read-z
  "Read the z wires out of `vals` as one number, bit 0 first."
  [z-idx ^longs vals]
  (let [^ints z z-idx]
    (loop [k 0, acc 0]
      (if (= k (alength z))
        acc
        (recur (inc k)
               (if (pos? (aget vals (aget z k)))
                 (+ acc (bit-shift-left 1 k))
                 acc))))))

(defn- z-indexes [c n-bits]
  (int-array (keep #((:idx c) %)
                   (map #(format "z%02d" %) (range (inc n-bits))))))

(defn- test-vectors
  [n-bits k]
  (let [rand-mask (fn [tag]
                    (reduce (fn [m t]
                              (if (zero? (bit-and (hash (str tag t)) 1))
                                m
                                (bit-or m (bit-shift-left 1 t))))
                            0 (range k)))]
    {:x (vec (map #(rand-mask (str "x" %)) (range n-bits)))
     :y (vec (map #(rand-mask (str "y" %)) (range n-bits)))}))

(defn- add-masks
  [{:keys [x y]} n-bits]
  (loop [b 0, carry 0, sums []]
    (if (= b n-bits)
      (conj sums carry)
      (let [xb (x b), yb (y b)
            s (bit-xor (bit-xor xb yb) carry)
            c' (bit-or (bit-and xb yb)
                       (bit-and carry (bit-or xb yb)))]
        (recur (inc b) c' (conj sums s))))))

(defn- score
  [c z-idx tv sums]
  (let [{:keys [wire-count]} c
        {:keys [x y]} tv
        ^longs vals (long-array wire-count)
        ^ints z z-idx]
    (dotimes [b (count x)]
      (aset vals b (x b))
      (aset vals (+ b (count x)) (y b)))
    (eval-circuit c vals)
    (mapv (fn [b]
            (Long/bitCount (bit-xor (aget vals (aget z b)) (sums b))))
          (range (alength z)))))

(defn part-1
  [input]
  (let [{:keys [wires gates]} (parse-input input)
        n-bits (count (filter #(re-matches #"x\d\d" %) (keys wires)))
        c (compile-circuit (topo-gates gates) n-bits)
        z-idx (z-indexes c n-bits)
        vals (long-array (:wire-count c))]
    (dotimes [b n-bits]
      (aset vals b (parse-long (get wires (format "x%02d" b))))
      (aset vals (+ b n-bits) (parse-long (get wires (format "y%02d" b)))))
    (read-z z-idx (eval-circuit c vals))))

(defn part-2
  [input]
  (let [{:keys [wires gates]} (parse-input input)
        n-bits (count (filter #(re-matches #"x\d\d" %) (keys wires)))
        ordered (topo-gates gates)
        c (compile-circuit ordered n-bits)
        idx (:idx c)
        z-idx (z-indexes c n-bits)
        candidates (mapv idx (map :out ordered))
        pairs (for [i candidates, j candidates :when (< i j)] [i j])
        tv (test-vectors n-bits 63)
        sums (add-masks tv n-bits)]
    (loop [c c, used #{}, swaps []]
      (let [s (score c z-idx tv sums)]
        (if (every? zero? s)
          (->> swaps
               (apply concat)
               (map (:wires c))
               sort
               (str/join ","))
        (let [total (fn [v] (reduce + v))
              better (for [[i j] pairs
                           :when (not (or (used i) (used j)))
                           :let [s' (score (swapped c i j) z-idx tv sums)]
                           :when (pos? (compare (total s) (total s')))]
                       [(total s') s' i j])]
          (if (seq better)
            (let [[_ _ i j] (first (sort better))]
              (recur (swapped c i j)
                     (conj used i j)
                     (conj swaps [i j])))
            (throw (ex-info "No improving swap found"
                            {:score s :swaps swaps})))))))))

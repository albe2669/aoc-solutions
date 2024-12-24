(ns aoc.day17
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(defn combo [operand a b c]
  (get [0 1 2 3 a b c nil] operand))

(defn run [[a b c & tail]]
  (let [program (vec tail), end (count program)]
    (loop [pc 0, a a, b b, c c, output []]
      (if (>= pc end)
        output
        (let [opcode (program pc), operand (program (inc pc))]
          (case opcode
            0 (let [d (long (Math/pow 2 (combo operand a b c)))]
                (recur (+ 2 pc) (quot a d) b c output))
            1 (recur (+ 2 pc) a (bit-xor b operand) c output)
            2 (recur (+ 2 pc) a (mod (combo operand a b c) 8) c output)
            3 (recur (if (zero? a) (+ 2 pc) operand) a b c output)
            4 (recur (+ 2 pc) a (bit-xor b c) c output)
            5 (recur (+ 2 pc) a b c (conj output (mod (combo operand a b c) 8)))
            6 (let [d (long (Math/pow 2 (combo operand a b c)))]
                (recur (+ 2 pc) a (quot a d) c output))
            7 (let [d (long (Math/pow 2 (combo operand a b c)))]
                (recur (+ 2 pc) a b (quot a d) output))))))))

(defn part-1 [input]
  (->> input
       u/parse-longs
       run
       (str/join ",")))

(defn find-program [[a b c & program]]
  (apply min Long/MAX_VALUE
         (for [i (range 8)
               :let [a' (+ i (* 8 a)), output (run (concat [a' b c] program))]
               :when (= (reverse output) (take (count output) (reverse program)))]
           (if (= output program)
             a'
             (find-program  (concat [a' b c] program))))))

(defn part-2 [input]
  (->> input
       u/parse-longs
       (drop 1)
       (cons 0)
       find-program))

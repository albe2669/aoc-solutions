(ns aoc.day19
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(defn parse [input]
  (let [[patterns designs] (u/to-blocks input)]
    (list (str/split patterns #", ") (u/to-lines designs))))

(def get-matches
  (memoize (fn [design patterns]
             (if-not (seq design)
               1
               (some (fn [pattern]
                       (when
                        (str/starts-with? design pattern)
                         (get-matches (subs design (count pattern)) patterns))) patterns)))))

(defn get-match-count [[patterns designs]]
  (count (filter #(get-matches % patterns) designs)))

(defn part-1 [input]
  (->> input
       parse
       get-match-count))

(def get-matches2
  (memoize (fn [design patterns]
             (if-not (seq design)
               1
               (reduce +
                       (mapv (fn [pattern]
                               (if-not (str/starts-with? design pattern)
                                 0
                                 (get-matches2 (subs design (count pattern)) patterns))) patterns))))))

(defn get-match-count2 [[patterns designs]]
  (transduce (map #(get-matches2 % patterns)) + designs))

(defn part-2 [input]
  (->> input
       parse
       get-match-count2))

(ns aoc.day05
  (:require [aoc.utils :as u])
  (:gen-class))

(defn create-rules [rules]
  (reduce (fn [crules [n1 n2]]
            (assoc crules n1 (conj (get crules n1 #{}) n2)))
          {} rules))

(defn parse-input-1 [[b1 b2]]
  (let [rules (->> b1
                   u/to-lines
                   (map u/parse-longs))
        updates (->> b2
                     u/to-lines
                     (map u/parse-longs))]
    (list (create-rules rules) updates)))

(defn update-correct [rules update]
  (loop [pages update, seen #{}]
    (if-let [[p & ps] pages]
      (let [deps (rules p)]
        (if (some seen deps)
          false
          (recur ps (conj seen p))))
      true)))

(defn get-correct [[rules updates]]
  (let [func (partial update-correct rules)]
    (filter func updates)))

(defn get-middle [page]
  (nth page (/ (count page) 2)))

(defn part-1 [input]
  (->> input
       u/to-blocks
       parse-input-1
       get-correct
       (map get-middle)
       (reduce +)))

(defn get-incorrect-updates [rules updates]
  (filter (complement (partial update-correct rules)) updates))

(defn fix-pages [rules update]
  (letfn [(insert-page [pages page]
            (let [rules' (get rules page #{})
                  place  (first (for [n (range (count pages))
                                      :when (rules' (nth pages n))]
                                  n))]
              (if place
                (into [] (concat (take place pages)
                                 (list page)
                                 (drop place pages)))
                (conj pages page))))]
    (reduce insert-page [] update)))

(defn get-correct-incorrect [[rules updates]]
  (let [incorrect (get-incorrect-updates rules updates)]
    (map #(fix-pages rules %) incorrect)))

(defn part-2 [input]
  (->> input
       u/to-blocks
       parse-input-1
       get-correct-incorrect
       (map get-middle)
       (reduce +)))

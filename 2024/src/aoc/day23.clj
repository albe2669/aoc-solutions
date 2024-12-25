(ns aoc.day23
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]
   [clojure.set :as set]))

(defn parse [graph [a b]]
  (-> graph
      (update a (fnil conj #{}) b)
      (update b (fnil conj #{}) a)))

(defn get-connections-of-3 [graph node]
  (let [connections (graph node)]
    (for [a connections
          :let [b (set/intersection connections (graph a))]
          :when (and (not (nil? a))
                     (not (zero? (count b))))]
      (map #(into #{} [node a %]) b))))

(defn get-triples [graph]
  (->> (filter #(str/starts-with? % "t") (keys graph))
       (map (partial get-connections-of-3 graph))
       flatten
       distinct))

(defn part-1
  [input]
  (->> input
       u/to-lines
       (map #(str/split % #"-"))
       (reduce parse {})
       get-triples
       count))

(defn find-networks [graph]
  (distinct
   (reduce-kv (fn [acc node connections]
                (reduce (fn [acc node']
                          (let [connections' (set/intersection connections (graph node'))]
                            (if (<= 1 (count connections'))
                              (conj acc (conj connections' node node'))
                              acc)))
                        acc connections))
              [] graph)))

(defn get-fully-connected [graph]
  (->> (find-networks graph)
       (filter #(every? (fn [node]
                          (every? (fn [node'] ((graph node') node)) (disj % node))) %))

       (sort-by count >)))

(defn part-2
  [input]
  (->> input
       u/to-lines
       (map #(str/split % #"-"))
       (reduce parse {})
       get-fully-connected
       first
       sort
       (str/join ",")))

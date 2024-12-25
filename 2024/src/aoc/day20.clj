(ns aoc.day20
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(defn parse [input]
  (let [matrix-map (u/matrix-to-map (u/in-to-matrix input))
        start (some #(when (= \S (last %)) (first %)) matrix-map)
        end (some #(when (= \E (last %)) (first %)) matrix-map)]
    {:start start
     :end end
     :walls (set (keep #(when (= \# (last %)) (first %)) matrix-map))
     :map (-> matrix-map
              (assoc start \.)
              (assoc end \.))}))

(defn get-next-move [node map cost]
  (first (for [dir (u/direct-neighbors node)
               :let [node' (:coord dir)]
               :when (= \. (map node'))
               :when (nil? (get cost node'))]
           node')))

(defn get-full-cost [state]
  (let [{:keys [map start end]} state]
    (loop [node end, cur 0, cost {}]
      (if (= node start)
        (-> state
            (assoc :costs (assoc cost node cur))
            (assoc :cost cur))
        (recur (get-next-move node map cost)
               (inc cur)
               (assoc cost node cur))))))

(defn get-jumps [node cost map costs visited total]
  (for [dir (u/direct-neighbors node)
        :let [node'  (:coord dir)
              node'' (mapv + (:coord dir) (:delta dir))]
        :when (= \# (map node'))
        :when (= \. (map node''))
        :when (not (visited node''))]
    (hash-map [node' node''] (- total (+ 2 cost (costs node''))))))

(defn get-cheats [state]
  (let [{:keys [map start end costs cost]} state]
    (loop [node start, cur 0, known {}, visited #{}]
      (if (= node end)
        (assoc state :shortcuts known)
        (let [move (get-next-move node map visited)
              jumps (get-jumps node cur map costs visited cost)]
          (recur move (inc cur) (into known jumps) (conj visited node)))))))

(defn part-1 [input]
  (->> input
       parse
       get-full-cost
       println
       get-cheats
       :shortcuts
       vals
       (filter #(>= % 100))
       count))

(defn get-jumps-20 [node rempath limit]
  (for [node' (drop limit rempath)
        :let [dist (u/manhattan-distance node node')]
        :when (<= 2 dist limit)]
    [node' dist]))

(defn- get-cheats-20 [state]
  (let [{:keys [costs]} state
        path            (reverse (map first (sort-by last costs)))
        pathlen         (dec (count path))]
    (loop [cnt 0, picos 0, path path]
      (println cnt picos (count path))
      (if (seq (drop 20 path))
        (let [[node & rempath] path
              jumps            (get-jumps-20 node rempath 20)
              newcnt           (reduce (fn [acc [pt dist]]
                                         (if (<= (+ picos dist (costs pt))
                                                 (- pathlen 100))
                                           (inc acc)
                                           acc))
                                       cnt jumps)]
          (recur newcnt (inc picos) rempath))
        cnt))))

(defn part-2
  [input]
  (->> input
       parse
       get-full-cost
       get-cheats-20))

(ns aoc.day15
  (:require
   [aoc.utils :as u]
   [clojure.string :as str]))

(defn parse-warehouse [block]
  (let [matrix (u/to-lines block)
        warehouse-map (u/matrix-to-map matrix)]
    {:width (count (first matrix))
     :height (count matrix)
     :position (some #(when (= \@ (last %)) (first %)) warehouse-map)
     :walls (set (keep #(when (= \# (last %)) (first %)) warehouse-map))
     :blocks (set (keep #(when (= \O (last %)) (first %)) warehouse-map))}))

(defn parse-moves [input]
  (->> input
       u/to-lines
       (map str/trim)
       (apply str)))

(defn take-step [move]
  (fn [[row col]]
    (condp = move
      \> [row (inc col)]
      \v [(inc row) col]
      \< [row (dec col)]
      \^ [(dec row) col])))

(defn push-block [{:keys [blocks walls] :as warehouse} next-pos step-fn]
  (let [blocks-to-push (take-while blocks (iterate step-fn next-pos))
        after-blocks (step-fn (last blocks-to-push))]
    (if (walls after-blocks)
      warehouse
      (assoc warehouse
             :position next-pos
             :blocks (disj (conj blocks after-blocks) next-pos)))))

(defn move-robot-once [{:keys [blocks walls position] :as warehouse} push-block-fn move]
  (let [next-pos ((take-step move) position)]
    (cond (walls next-pos) warehouse
          (blocks next-pos) (push-block-fn warehouse next-pos (take-step move))
          :else (assoc warehouse :position next-pos))))

(defn move-robot [{:keys [blocks] :as warehouse} push-block-fn [move & tail]]
  (if (nil? move)
    blocks
    (recur (move-robot-once warehouse push-block-fn move) push-block-fn tail)))

(defn part-1 [input]
  (let [blocks (u/to-blocks input)
        warehouse (parse-warehouse (first blocks))]
    (->> (parse-moves (last blocks))
         (move-robot warehouse push-block)
         (map #(+ (* 100 (first %)) (last %)))
         (reduce +))))

(defn find-blocks-to-push [blocks start-pos step-fn]
  (loop [[q & rem] [start-pos]
         seen #{}
         res []]
    (cond (not (seq q)) res
          (or (seen q) (not (seq (blocks q)))) (recur rem seen res)
          :else (recur (concat rem [(step-fn q) (step-fn (blocks q))])
                       (-> seen (conj q) (conj (blocks q)))
                       (conj res [q (blocks q)])))))

(defn push-all-big-blocks [blocks blocks-to-push step-fn]
  (reduce (fn [res [block-a block-b]]
            (let [new-a (step-fn block-a)
                  new-b (step-fn block-b)]
              (assoc res new-a new-b new-b new-a)))
          (apply dissoc blocks (mapcat identity blocks-to-push))
          blocks-to-push))

(defn push-big-block [{:keys [blocks walls] :as warehouse} next-pos step-fn]
  (let [blocks-to-push (find-blocks-to-push blocks next-pos step-fn)]
    (if (every? (complement walls) (map step-fn (mapcat identity blocks-to-push)))
      (assoc warehouse
             :position next-pos
             :blocks (push-all-big-blocks blocks blocks-to-push step-fn))
      warehouse)))

(defn expand-block [[row col]]
  (assoc {}
         [row (* 2 col)] [row (inc (* 2 col))]
         [row (inc (* 2 col))] [row (* 2 col)]))

(defn- expand-warehouse [{[row col] :position :keys [blocks walls width height]}]
  {:height height
   :width (* width 2)
   :position [row (* 2 col)]
   :blocks (apply merge (map expand-block blocks))
   :walls (->> walls
               (mapcat #(vector [(first %) (* 2 (last %))]
                                [(first %) (inc (* 2 (last %)))]))
               set)})

(defn part-2 [input]
  (let [blocks (u/to-blocks input)
        warehouse (parse-warehouse (first blocks))]
    (->> (parse-moves (last blocks))
         (move-robot (expand-warehouse warehouse) push-big-block)
         (map (partial sort-by last))
         (distinct)
         (map first)
         (map #(+ (* 100 (first %)) (last %)))
         (reduce +))))

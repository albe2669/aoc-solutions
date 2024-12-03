(defproject aoc "0.0.0"
  :description "Advent of Code 2024 solutions"
  :url "https://github.com/albe2669/aoc-solutions"
  :dependencies [[org.clojure/clojure "1.12.0"]
                 [org.clojure/tools.cli "1.0.194"]]
  :plugins [[lein-kibit "0.1.6"]]
  :main aoc.main
  :repl-options {:init-ns aoc.main})

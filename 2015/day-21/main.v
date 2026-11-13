module main

import common
import math

struct Day {
	name string = 'Day 21'
}

struct Entity {
	hp int
	damage int
	armor int
}

struct Item {
	cost   int
	damage int
	armor int
}

const weapons = [
	Item{cost: 8, damage: 4, armor: 0},
	Item{cost: 10, damage: 5, armor: 0},
	Item{cost: 25, damage: 6, armor: 0},
	Item{cost: 40, damage: 7, armor: 0},
	Item{cost: 74, damage: 8, armor: 0},
]

const armors = [
	Item{cost: 0, damage: 0, armor: 0},
	Item{cost: 13, damage: 0, armor: 1},
	Item{cost: 31, damage: 0, armor: 2},
	Item{cost: 53, damage: 0, armor: 3},
	Item{cost: 75, damage: 0, armor: 4},
	Item{cost: 102, damage: 0, armor: 5},
]

const rings = [
	Item{cost: 0, damage: 0, armor: 0},
	Item{cost: 25, damage: 1, armor: 0},
	Item{cost: 50, damage: 2, armor: 0},
	Item{cost: 100, damage: 3, armor: 0},
	Item{cost: 20, damage: 0, armor: 1},
	Item{cost: 40, damage: 0, armor: 2},
	Item{cost: 80, damage: 0, armor: 3},
]

fn player_wins(player Entity, boss Entity) bool {
	mut boss_hp := boss.hp
	player_turns := (boss_hp + math.max(1, player.damage - boss.armor) - 1) / math.max(1, player.damage
		- boss.armor)
	boss_turns := (player.hp + math.max(1, boss.damage - player.armor) - 1) / math.max(1, boss.damage
		- player.armor)
	return player_turns <= boss_turns
}

struct Loadout {
	cost   int
	damage int
	armor  int
}

fn ring_combos() [][]Item {
	mut result := [][]Item{}
	result << []Item{}
	for r in rings {
		result << [r]
	}

	for i in 0 .. rings.len {
		for j in i + 1 .. rings.len {
			result << [rings[i], rings[j]]
		}
	}

	return result
}

fn loadouts() []Loadout {
	mut result := []Loadout{}

	for w in weapons {
		for a in armors {
			for rc in ring_combos() {
				mut ring_cost := 0
				mut ring_damage := 0
				mut ring_armor := 0

				for r in rc {
					ring_cost += r.cost
					ring_damage += r.damage
					ring_armor += r.armor
				}
				result << Loadout{
					cost: w.cost + a.cost + ring_cost
					damage: w.damage + a.damage + ring_damage
					armor: w.armor + a.armor + ring_armor
				}
			}
		}
	}
	return result
}

fn read_boss(mut reader common.Reader) !Entity {
	return Entity{
		hp: reader.next_line()!.split(': ')[1].int()
		damage: reader.next_line()!.split(': ')[1].int()
		armor: reader.next_line()!.split(': ')[1].int()
	}
}

fn (d Day) part_1(mut reader common.Reader) string {
	boss := read_boss(mut reader) or { panic(err) }

	mut min_cost := 1000000
	for l in loadouts() {
		player := Entity{hp: 100, damage: l.damage, armor: l.armor}
		if player_wins(player, boss) {
			min_cost = math.min(min_cost, l.cost)
		}
	}
	return min_cost.str()
}

fn (d Day) part_2(mut reader common.Reader) string {
	boss := read_boss(mut reader) or { panic(err) }

	mut max_cost := 0
	for l in loadouts() {
		player := Entity{hp: 100, damage: l.damage, armor: l.armor}
		if !player_wins(player, boss) {
			max_cost = math.max(max_cost, l.cost)
		}
	}
	return max_cost.str()
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}

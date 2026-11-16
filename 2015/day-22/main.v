module main

import common
import math

struct Day {
	name string = 'Day '
}

struct Boss {
pub mut:
	hp     int
	damage int
}

struct Player {
pub mut:
	hp  int
	mana int
	active_spells []Spell
}

struct Spell {
pub mut:
	name   string
	cost   int
	damage int
	heal   int
	armor  int
	mana   int
	turns  int
}


const spells = [
	Spell{name: 'Magic Missile', cost: 53, damage: 4, heal: 0, armor: 0, mana: 0, turns: 1},
	Spell{name: 'Drain', cost: 73, damage: 2, heal: 2, armor: 0, mana: 0, turns: 1},
	Spell{name: 'Shield', cost: 113, damage: 0, heal: 0, armor: 7, mana: 0, turns: 6},
	Spell{name: 'Poison', cost: 173, damage: 3, heal: 0, armor: 0, mana: 0, turns: 6},
	Spell{name: 'Recharge', cost: 229, damage: 0, heal: 0, armor: 0, mana: 101, turns: 5},
]


fn read_boss(mut reader common.Reader) !Boss {
	return Boss{
		hp: reader.next_line()!.split(': ')[1].int()
		damage: reader.next_line()!.split(': ')[1].int()
	}
}

fn apply(mut player Player, mut boss Boss) {
	mut spells_left := []Spell{}
	for spell in player.active_spells {
		boss.hp -= spell.damage
		player.mana += spell.mana

		if spell.turns > 1 {
			spells_left << Spell{
				name: spell.name
				cost: spell.cost
				damage: spell.damage
				armor: spell.armor
				mana: spell.mana
				turns: spell.turns - 1
			}
		}
	}
	player.active_spells = spells_left
}

fn win_check(player Player, boss Boss) int {
	if boss.hp <= 0 {
		return 1
	}
	if player.hp <= 0 {
		return 0
	}
	return -1
}

// Turn order:
//   1. Player turn starts: hard-mode hp loss, active spells apply
//   2. Player casts a spell
//   3. Boss turn starts: active spells apply
//   4. Boss attacks
//   5. Repeat until one side is defeated
struct Bound {
mut:
	cost i64
}

fn recurse(player Player, boss Boss, mana_spent int, is_p2 bool, mut best_cost Bound) ?i64 {
	mut turn_player := player
	mut turn_boss := boss

	turn_player.hp -= if is_p2 { 1 } else { 0 }
	if win_check(turn_player, turn_boss) == 0 {
		return none
	}
	// Prune branches that already cost more than the cheapest win found so far
	if mana_spent >= best_cost.cost {
		return none
	}

	apply(mut turn_player, mut turn_boss)
	if win_check(turn_player, turn_boss) == 1 {
		best_cost.cost = mana_spent
		return mana_spent
	}


	mut min_mana_spent := i64(1 << 60)
	for spell in spells {
		// Can i cast this spell? Check if I have enough mana and if the spell is not already active
		if spell.cost <= turn_player.mana && !turn_player.active_spells.any(it.name == spell.name) {
			// Local copies of player and boss to pass to the next recursion
			mut next_player := turn_player
			mut next_boss := turn_boss

			next_player.mana -= spell.cost
			next_player.hp += spell.heal
			next_player.active_spells << spell

			// Boss turn
			apply(mut next_player, mut next_boss)
			if win_check(next_player, next_boss) == 1 {
				best_cost.cost = math.min(best_cost.cost, mana_spent + spell.cost)
				min_mana_spent = math.min(min_mana_spent, mana_spent + spell.cost)
				continue
			}

			mut player_armor := 0
			for active in next_player.active_spells {
				player_armor += active.armor
			}
			damage := math.max(1, next_boss.damage - player_armor)
			next_player.hp -= damage
			if win_check(next_player, next_boss) == 0 {
				continue
			}

			// Recurse to the next turn
			result := recurse(next_player, next_boss, mana_spent + spell.cost, is_p2, mut best_cost)
			if result != none {
				min_mana_spent = math.min(min_mana_spent, result)
			}
		}
	}

	if min_mana_spent == i64(1 << 60) {
		return none
	} else {
		return min_mana_spent
	}
}


fn simulate(mut reader common.Reader, is_p2 bool) string {
	boss := read_boss(mut reader) or { panic(err) }
	mut bound := Bound{cost: 1 << 60}
	return (recurse(Player{hp: 50, mana: 500, active_spells: []}, boss, 0, is_p2, mut bound) or { -1 }).str()
}

fn (d Day) part_1(mut reader common.Reader) string {
	return simulate(mut reader, false)
}

fn (d Day) part_2(mut reader common.Reader) string {
	return simulate(mut reader, true)
}

fn main() {
	day := Day{}
	common.define_and_run_app(day)
}


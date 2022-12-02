use helper::*;
use once_cell::sync::Lazy;

static INPUT: Lazy<String> = Lazy::new(|| helper::easy_aoc_input());

fn main() {
    println!("Day 2 Part 1: {}", day2_p1());
    println!("Day 2 Part 2: {}", day2_p2());
}

#[derive(PartialEq, Eq)]
enum Rps {
    Rock = 1,
    Paper = 2,
    Scissors = 3,
}

enum EndState {
    Lose = 0,
    Draw = 3,
    Win = 6,
}

pub fn day2_p1() -> u64 {
    use Rps::*;

    INPUT
        .lines()
        .map(|line| {
            let opponent = match line.as_bytes() {
                &[b'A', ..] => Rock,
                &[b'B', ..] => Paper,
                &[b'C', ..] => Scissors,
                _ => unreachable!(),
            };
            let me = match line.as_bytes() {
                &[.., b'X'] => Rock,
                &[.., b'Y'] => Paper,
                &[.., b'Z'] => Scissors,
                _ => unreachable!(),
            };

            match (opponent, me) {
                (opp @ _, m @ _) if opp == m => m as u64 + EndState::Draw as u64,
                (Rock, m @ Scissors) | (Paper, m @ Rock) | (Scissors, m @ Paper) => {
                    m as u64 + EndState::Lose as u64
                }
                (_, m @ _) => m as u64 + EndState::Win as u64,
            }
        })
        .sum()
}

pub fn day2_p2() -> u64 {
    use EndState::*;
    use Rps::*;

    INPUT
        .lines()
        .map(|line| {
            let opponent = match line.as_bytes() {
                &[b'A', ..] => Rock,
                &[b'B', ..] => Paper,
                &[b'C', ..] => Scissors,
                _ => unreachable!(),
            };
            let end = match line.as_bytes() {
                &[.., b'X'] => Lose,
                &[.., b'Y'] => Draw,
                &[.., b'Z'] => Win,
                _ => unreachable!(),
            };

            match (opponent, end) {
                (Rock, Lose) => Scissors as u64 + Lose as u64,
                (Rock, Win) => Paper as u64 + Win as u64,
                (Paper, Lose) => Rock as u64 + Lose as u64,
                (Paper, Win) => Scissors as u64 + Win as u64,
                (Scissors, Lose) => Paper as u64 + Lose as u64,
                (Scissors, Win) => Rock as u64 + Win as u64,
                (opp @ _, Draw) => opp as u64 + Draw as u64,
            }
        })
        .sum()
}

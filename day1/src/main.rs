use helper::*;
use once_cell::sync::Lazy;

static INPUT: Lazy<String> = Lazy::new(|| helper::easy_aoc_input());

fn main() {
    println!("Solved Day 1 Part 1: {:?}", day1_p1());
    println!("Solved Day 1 Part 2: {:?}", day1_p2().unwrap());
}

pub fn day1_p1() -> u64 {
    INPUT.split("\n\n")
        .map(|x| x.lines()
            .map(str::parse::<u64>)
            .map(Result::unwrap).sum()
        ).max().unwrap()
}

pub fn day1_p2() -> Option<u64> {
    let mut elf_calories: Vec<u64> = INPUT.split("\n\n")
        .map(|x| x.lines()
            .map(str::parse::<u64>)
            .map(Result::unwrap).sum()
        ).collect();

    let max_cal_1 = *elf_calories.iter().max()?;

    elf_calories.remove(elf_calories
        .iter().enumerate().find(|(_i, &x)| x == max_cal_1)?.0
    );

    let max_cal_2 = *elf_calories.iter().max()?;

    elf_calories.remove(elf_calories
        .iter().enumerate().find(|(_i, &x)| x == max_cal_2)?.0
    );

    let max_cal_3 = elf_calories.iter().max()?;

    Some(max_cal_1 + max_cal_2 + max_cal_3)
}

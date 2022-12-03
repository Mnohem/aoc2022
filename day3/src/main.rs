use helper::*;
use once_cell::sync::Lazy;

static INPUT: Lazy<String> = Lazy::new(|| helper::easy_aoc_input());

fn main() {
    println!("Day 3 Part 1: {}", day3_p1());

    println!("Day 3 Part 2: {}", day3_p2());
}

pub fn day3_p1() -> u64 {
    INPUT.lines()
        .filter_map(|line| {
            let (comp_1, comp_2) = line.split_at((line.len()) / 2);
            comp_1
                .chars()
                .filter(|x| comp_2.contains(*x))
                .map(|x| match x as u8 {
                    x @ b'a'..=b'z' => x - b'a' + 1,
                    x @ b'A'..=b'Z' => x - b'A' + 27,
                    _ => unreachable!(),
                })
                .next().map(|x| x as u64)
        })
        .sum()
}

pub fn day3_p2() -> u64 {
    INPUT.lines()
        .fold(("".to_owned(), 0u64, 1), |(items, total_priority, counter), line| {
            let mut priority = total_priority;

            if counter == 1 {
                return (line.to_owned(), priority, 2);
            } else if counter == 2 {
                let new_items = line
                    .chars()
                    .filter(|x| items.contains(*x))
                    .collect::<String>();

                return (new_items, priority, 3);
            } else if counter == 3 {
                let badge_item = line
                    .chars()
                    .filter(|x| items.contains(*x))
                    .collect::<String>();

                priority += match badge_item.as_bytes() {
                    [x @ b'a'..=b'z', ..] => x - b'a' + 1,
                    [x @ b'A'..=b'Z', ..] => x - b'A' + 27,
                    _ => unreachable!(),
                } as u64;
                return ("".to_owned(), priority, 1);
            }
            ("".to_owned(), 0, 0)
        }).1
}

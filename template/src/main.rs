use helper::{resolve, when};

fn main() {
    let input = {
        let run_arg = std::env::args().next().unwrap();
        let day = run_arg.split('/').last().unwrap();
        helper::easy_input(day)
    };

    println!("{}", input);
}

pub fn day#_p1(input: &str) -> Result<(), Box<dyn std::error::Error>> {
    todo!()
}

pub fn day#_p2(input: &str) -> Result<(), Box<dyn std::error::Error>> {
    todo!()
}

#[cfg(test)]
mod solve {
    #[test]
    fn solved_p1() {
        assert!(false);
    }

    #[test]
    fn solved_p2() {
        assert!(false);
    }
}

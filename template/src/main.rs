use helper::{resolve, when};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = {
        let run_arg = std::env::args().next().unwrap();
        let day = run_arg.split('/').last().unwrap();
        helper::easy_input(day)
    };

    println!("{}", input);

    Ok(())
}

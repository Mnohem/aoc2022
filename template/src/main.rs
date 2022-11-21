fn main() {
    let input = {
        use helper::easy_input;
        use std::env::args;

        let run_arg = args().next().unwrap();
        let day = run_arg.split('/').last().unwrap();
        easy_input(day)
    };

    println!("{}", input);
}

#[macro_export]
/// creates a closure that returns Some($body) if $cond evaluates to true,
/// otherwise returns None
macro_rules! when {
    ($cond:expr => $body:expr) => {
        || {
            ($cond).then(|| $body)
        }
    }
}

#[macro_export]
/// Short circuits || -> Option<T>, as in returns the first Some(T) and does not execute the rest, lazy execution
macro_rules! resolve {
    ( $first:expr, $( $x:expr ),* ) => {
        $first()
            $(.or_else($x))*
    }
}

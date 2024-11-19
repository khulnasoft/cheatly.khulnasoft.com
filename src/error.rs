use hyper::{http, http::uri};
use std::error;
use std::fmt;
use std::io;

#[derive(Debug)]
pub enum CheatlyError {
    InvalidCheatLyUri(uri::InvalidUri),
    UnknownCheatSheet,
    InvalidChtRequest(http::Error),
    Error(hyper::Error),
    ResponseInterrupted(io::Error),
}

impl error::Error for CheatlyError {
    fn source(&self) -> Option<&(dyn error::Error + 'static)> {
        match *self {
            CheatlyError::InvalidCheatLyUri(ref err) => Some(err),
            CheatlyError::UnknownCheatSheet => None,
            CheatlyError::InvalidChtRequest(ref err) => Some(err),
            CheatlyError::Error(ref err) => Some(err),
            CheatlyError::ResponseInterrupted(ref err) => Some(err),
        }
    }
}

impl fmt::Display for CheatlyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match *self {
            CheatlyError::InvalidCheatLyUri(ref _err) => {
                f.write_str("invalid cheatly.khulnasoft.com URL provided")
            }
            CheatlyError::UnknownCheatSheet => f.write_str("unknown cheat sheet provided"),
            CheatlyError::InvalidChtRequest(ref err) => err.fmt(f),
            CheatlyError::Error(ref err) => err.fmt(f),
            CheatlyError::ResponseInterrupted(ref _err) => {
                f.write_str("response stream from cheatly.khulnasoft.com interrupted")
            }
        }
    }
}

impl From<uri::InvalidUri> for CheatlyError {
    fn from(error: uri::InvalidUri) -> Self {
        CheatlyError::InvalidCheatLyUri(error)
    }
}

impl From<http::Error> for CheatlyError {
    fn from(error: http::Error) -> Self {
        CheatlyError::InvalidChtRequest(error)
    }
}

impl From<hyper::Error> for CheatlyError {
    fn from(error: hyper::Error) -> Self {
        CheatlyError::Error(error)
    }
}

impl From<io::Error> for CheatlyError {
    fn from(value: io::Error) -> Self {
        use io::ErrorKind::Interrupted;

        match value.kind() {
            Interrupted => CheatlyError::ResponseInterrupted(value),
            _ => todo!(),
        }
    }
}

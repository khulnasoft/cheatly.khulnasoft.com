pub use crate::error::CheatlyError;

pub type Result<TSuccess> = core::result::Result<TSuccess, CheatlyError>;

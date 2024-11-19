#![warn(clippy::all)]

mod client;
mod error;
mod prelude;

use std::fmt;
use std::io::{self, Write};

use clap::Parser;
use hyper::{body, Body, Response};

use client::config::CheatlyClientConfig;
use client::CheatlyClient;

use crate::prelude::*;

// type Result<T> = std::result::Result<T, Box<dyn std::error::Error + Send + Sync>>;

#[tokio::main]
async fn main() -> Result<()> {
    let input = CheatlyOptions::parse();
    let writer = io::stdout();
    let client = CheatlyClient::new(CheatlyClientConfig::default());
    let cheatly = Cheatly {
        input,
        writer,
        client,
    };

    cheatly.run().await?;

    Ok(())
}

/// Main program state.
#[derive(Debug)]
pub struct Cheatly<TWrite>
where
    TWrite: Write,
{
    /// Parsed command-line options and arguments.
    pub input: CheatlyOptions,
    /// Output handle to write to.
    pub writer: TWrite,
    /// Client used for making requests to `cheatly.khulnasoft.com`.
    pub client: CheatlyClient,
}

impl<TWrite> Cheatly<TWrite>
where
    TWrite: Write,
{
    pub async fn run(mut self) -> Result<()> {
        let res: Response<Body> = self
            .client
            .cheat(
                &self.input.language,
                &self
                    .input
                    .query_parts
                    .iter()
                    .map(String::as_str)
                    .collect::<Vec<_>>(),
            )
            .await?;

        let bytes = body::to_bytes(res).await?;
        self.writer.write_all(&bytes)?;

        // Stream the body, writing each chunk to stdout as we get it
        // (instead of buffering and printing at the end).
        //         while let Some(next) = res.data().await {
        //             let chunk = next?;
        //             self.writer.write_all(&chunk)?;
        //         }

        Ok(())
    }
}

/// Cheatly command-line options/arguments.
#[derive(Parser, Debug, PartialEq)]
#[clap(name = "cheatly.khulnasoft.com Rust CLI", author, version, about, long_about = None)]
pub struct CheatlyOptions {
    /// Language value required by `cheatly.khulnasoft.com`.
    #[clap(required = true)]
    language: String,
    /// Query regarding the provided `language` value.
    #[clap(default_value = ":list")]
    query_parts: Vec<String>,
}

impl fmt::Display for CheatlyOptions {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_fmt(format_args!(
            "{}/{}",
            self.language,
            self.query_parts.join("+")
        ))
    }
}

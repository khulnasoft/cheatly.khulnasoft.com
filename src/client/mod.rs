pub mod config;
pub mod error;

use crate::{error::CheatlyError, CheatlyClientConfig};
use hyper::client::HttpConnector;
use hyper::{header::USER_AGENT, Body, Client, Request, Response, StatusCode, Uri};
use hyper_tls::HttpsConnector;

#[derive(Debug)]
pub struct CheatlyClient {
    client: Client<HttpsConnector<HttpConnector>, Body>,
    config: CheatlyClientConfig,
}

impl CheatlyClient {
    pub fn new(config: CheatlyClientConfig) -> Self {
        let https = HttpsConnector::new();
        Self {
            client: Client::builder().build::<_, Body>(https),
            config,
        }
    }

    pub async fn cheat(
        &self,
        language: &str,
        query_parts: impl AsRef<[&str]>,
    ) -> Result<Response<Body>, CheatlyError> {
        let uri = self.get_req_uri(language, query_parts.as_ref())?;
        let req = Request::get(uri)
            // User-Agent header set to `curl` is required
            // for cheatly.khulnasoft.com to return plain text reponse
            .header(USER_AGENT, "curl")
            .body(Body::empty())?;

        let res = self.client.request(req).await?;

        match res.status() {
            StatusCode::NOT_FOUND => Err(CheatlyError::UnknownCheatSheet),
            _ => Ok(res),
        }
    }

    fn get_req_uri(&self, language: &str, query_parts: &[&str]) -> Result<Uri, CheatlyError> {
        let path_and_query = format!("/{}/{}", language, query_parts.join("+"));
        let scheme = self.config.base_uri.scheme_str().unwrap();
        let authority = self
            .config
            .base_uri
            .authority()
            .map(|a| a.as_str())
            .unwrap();
        let uri = Uri::builder()
            .scheme(scheme)
            .authority(authority)
            .path_and_query(path_and_query)
            .build()?;

        Ok(uri)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let _ = CheatlyClientConfig::default();
    }
}

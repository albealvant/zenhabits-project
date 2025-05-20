use axum::response::{IntoResponse, Response};
use reqwest::StatusCode;

pub async fn check() -> Response {
    (StatusCode::OK, "Ok").into_response()
}
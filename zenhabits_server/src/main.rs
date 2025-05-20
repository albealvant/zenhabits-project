use axum::{
    routing::{get, post},
    Router,
};
use dotenv::dotenv;

#[tokio::main]
async fn main() {
    dotenv().ok();
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();

    let app = Router::new().route("/hello", get(hello));

    println!("Servidor en ejecucion: http://0.0.0.0:3000/");

    axum::serve(listener, app).await.unwrap();
}

async fn hello() -> &'static str {
    "bye\n"
}
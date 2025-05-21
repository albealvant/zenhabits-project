use axum::{
    response::Response, routing::{get, post}, Json, Router
};
use dotenv::dotenv;
use models::user::User;

pub mod routes;
pub mod models;
pub mod db;
use crate::db::get_db_connection;
use crate::routes::check_handler::check;
use crate::routes::save_data_handler::save_data;

#[tokio::main]
async fn main() {
    dotenv().ok();
    let pool = get_db_connection().await.unwrap();

    let app = Router::new()
        .route("/", get(check))
        .route("/save", post(save_data))
        .route("/load", get(load_data))
        .with_state(pool);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Servidor en ejecucion: http://0.0.0.0:3000/");

    axum::serve(listener, app).await.unwrap();
}

async fn load_data(Json(payload): Json<User>) -> Response {

    todo!()
}
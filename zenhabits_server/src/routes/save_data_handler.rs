use axum::{
    body::Body,
    extract::{Json, State},
    http::HeaderMap,
    response::{IntoResponse, Response},
};
use reqwest::StatusCode;
use sqlx::MySqlPool;

use crate::models::{habit::{self, Habit}, user::{self, User}};
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
pub struct Data {
    user: User,
    habits: Vec<Habit>
}

pub async fn save_data(State(pool): State<MySqlPool>, Json(payload): Json<Data>) -> Response {
    let user = payload.user;

    match upsert_user(State(pool.clone()), user).await {
        Ok(_) => (),
        Err(_) => return (axum::http::StatusCode::INTERNAL_SERVER_ERROR, "[Database error]").into_response()
    }

    for habit in payload.habits {
        
    }


    (axum::http::StatusCode::OK, "[INFO: Updated]").into_response()
}

async fn upsert_user(State(pool): State<MySqlPool>, user: User) -> Result<(), sqlx::Error> {
    let user_exist = sqlx::query("SELECT 1 FROM Users WHERE user_id = ?")
        .bind(user.get_id())
        .fetch_one(&pool)
        .await;

    //TO DO: If user differs from db update it
    if user_exist.is_err() { 
        match sqlx::query("INSERT INTO Users VALUES (?, ?, ?, ?)")
            .bind(user.get_id())
            .bind(user.get_name())
            .bind(user.get_email())
            .bind(user.get_password())
            .execute(&pool)
            .await {
                Ok(_) => return Ok(()),
                Err(e) => return Err(e),
            }
    }

    Ok(())
}

//TO DO: upsert habit
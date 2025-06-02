use axum::{
    body::Body,
    extract::{Json, State},
    http::StatusCode,
    response::Response,
};
use sqlx::{MySqlPool, Row};
use crate::models::{user::User, habit::Habit};
use crate::routes::save_data_handler::Data;

pub async fn load_data(State(pool): State<MySqlPool>, Json(payload): Json<User>) -> Response {
    let user_id = payload.get_id();

    let user_row = match sqlx::query("SELECT * FROM Users WHERE user_id = ?")
        .bind(user_id)
        .fetch_one(&pool)
        .await
    {
        Ok(row) => {
            User::new(
                row.get("user_id"),
                row.get("name"),
                row.get("email"),
                row.get("password_hash"),
            )
        }
        Err(_) => {
            return Response::builder()
                .status(StatusCode::NOT_FOUND)
                .body(Body::from("[ERROR: User not found]"))
                .unwrap();
        }
    };

    let habit_rows = match sqlx::query("SELECT * FROM Habits WHERE user_id = ?")
        .bind(user_id)
        .fetch_all(&pool)
        .await
    {
        Ok(rows) => {
            rows
        }
        Err(_) => {
            return Response::builder()
                .status(StatusCode::INTERNAL_SERVER_ERROR)
                .body(Body::from("[ERROR: Failed to load habits]"))
                .unwrap();
        }
    };

    let habits: Vec<Habit> = habit_rows
        .into_iter()
        .map(|row| {
            Habit::new(
                row.get("habit_id"),
                row.get("name"),
                row.try_get("description").ok(),
                row.get("frequency"),
                row.get("completed"),
                row.get("start_date"),
                row.get("end_date"),
                row.get("user_id"),
            )
        })
        .collect();

    let data = Data {
        user: user_row,
        habits,
    };

    let json_string = match serde_json::to_string(&data) {
        Ok(json) => {
            json
        }
        Err(_) => {
            return Response::builder()
                .status(StatusCode::INTERNAL_SERVER_ERROR)
                .body(Body::from("Error serializing data"))
                .unwrap();
        }
    };

    let axum_body = Body::from(json_string);

    Response::builder().status(200).body(axum_body).unwrap()
}
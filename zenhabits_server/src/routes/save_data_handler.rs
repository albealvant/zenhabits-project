use axum::{
    extract::{Json, State},
    response::{IntoResponse, Response},
};

use sqlx::{MySqlPool, Row};

use crate::models::{habit::Habit, user::User};
use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Clone)]
pub struct Data {
    pub user: User,
    pub habits: Vec<Habit>
}

pub async fn save_data(State(pool): State<MySqlPool>, Json(payload): Json<Data>) -> Response {
    let user = payload.user;
    let habits = payload.habits;
    let user_id = user.get_id();

    match upsert_user(State(pool.clone()), user.clone()).await {
        Ok(_) => (),
        Err(e) => {
            eprintln!("Error in upsert_user: {}", e);
            return (axum::http::StatusCode::INTERNAL_SERVER_ERROR, format!("[Database error: {}]", e)).into_response();
        }
    }

    match upsert_habit(State(pool.clone()), habits, user_id).await {
        Ok(_) => (),
        Err(e) => {
            eprintln!("Error in upsert_user: {}", e);
            return (axum::http::StatusCode::INTERNAL_SERVER_ERROR, format!("[Database error: {}]", e)).into_response();
        }
    }

    (axum::http::StatusCode::OK, "[INFO: Updated]").into_response()
}

async fn upsert_user(State(pool): State<MySqlPool>, user: User) -> Result<(), sqlx::Error> {
    let user_exist = sqlx::query("SELECT 1 FROM Users WHERE user_id = ?")
        .bind(user.get_id())
        .fetch_one(&pool)
        .await;

    //TO DO: If user differs from db update it in the future
    if user_exist.is_err() {
        sqlx::query("INSERT INTO Users VALUES (?, ?, ?, ?)")
            .bind(user.get_id())
            .bind(user.get_name())
            .bind(user.get_email())
            .bind(user.get_password())
            .execute(&pool)
            .await?;
    }

    Ok(())
}

async fn upsert_habit(State(pool): State<MySqlPool>, habits: Vec<Habit>, user_id: &i32) -> Result<(), sqlx::Error> {
    let current_rows = sqlx::query("SELECT habit_id FROM Habits WHERE user_id = ?")
        .bind(user_id)
        .fetch_all(&pool)
        .await?;

    let current_db_ids = current_rows
        .iter()
        .map(|row| row.try_get("habit_id").unwrap())
        .collect::<Vec<i32>>();

    let new_ids: Vec<i32> = habits.iter().map(|row| *row.get_habit_id()).collect::<Vec<i32>>();

    for id in current_db_ids.clone() {
        if !new_ids.contains(&id) {
            sqlx::query("DELETE FROM Habits WHERE habit_id = ? AND user_id = ?")
                .bind(id)
                .bind(user_id)
                .execute(&pool)
                .await?;
        }
    }

    for habit in habits {
        let habit_id = habit.get_habit_id();
        let name = habit.get_name();
        let description = habit.get_description();
        let frequency = habit.get_frequency();

        let habit_exists = current_db_ids.contains(habit_id);

        if habit_exists {
            sqlx::query("UPDATE Habits SET name = ?, description = ?, frequency = ?, completed = ?, start_date = ?, end_date = ? WHERE habit_id = ? AND user_id = ?")
                .bind(name)
                .bind(description)
                .bind(frequency)
                .bind(habit.get_completed())
                .bind(habit.get_start_date())
                .bind(habit.get_end_date())
                .bind(habit_id)
                .bind(user_id)
                .execute(&pool)
                .await?;
        } else {
            sqlx::query("INSERT INTO Habits (habit_id, name, description, frequency, completed, start_date, end_date, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")
                .bind(habit_id)
                .bind(name)
                .bind(description)
                .bind(frequency)
                .bind(habit.get_completed())
                .bind(habit.get_start_date())
                .bind(habit.get_end_date())
                .bind(user_id)
                .execute(&pool)
                .await?;
        }
    }

    Ok(())
}
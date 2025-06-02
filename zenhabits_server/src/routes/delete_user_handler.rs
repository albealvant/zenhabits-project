use axum::{
    body::Body,
    extract::{Path, State},
    http::Response,
};
use sqlx::MySqlPool;

pub async fn delete_user(
    Path(user_id): Path<i32>,
    State(pool): State<MySqlPool>,
) -> Response<Body> {
    let result = sqlx::query("DELETE FROM Users WHERE user_id = ?")
        .bind(user_id)
        .execute(&pool)
        .await;

    match result {
        Ok(res) => {
            if res.rows_affected() == 0 {
                Response::builder()
                    .status(404)
                    .body(Body::from("[ERROR: User not found]"))
                    .unwrap()
            } else {
                Response::builder()
                    .status(200)
                    .body(Body::from(format!("[INFO: User {} deleted]", user_id)))
                    .unwrap()
            }
        }
        Err(e) => match e {
            sqlx::Error::Database(err) => match err.code() {
                Some(code) => Response::builder()
                    .status(409)
                    .body(Body::from(format!("[ERROR: Database constraint error: {}]", code)))
                    .unwrap(),
                None => Response::builder()
                    .status(409)
                    .body(Body::from("[ERROR: Undefined Database Error]"))
                    .unwrap(),
            },
            _ => Response::builder()
                .status(409)
                .body(Body::from("[ERROR: Unexpected error]"))
                .unwrap(),
        },
    }
}

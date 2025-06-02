use sqlx::{mysql::MySqlPoolOptions, MySqlPool};

pub async fn get_db_connection() -> Result<MySqlPool, sqlx::error::Error> {
    let db_url = std::env::var("DATABASE_URL").unwrap();
    let pool = MySqlPoolOptions::new()
        .max_connections(5)
        .connect(&db_url)
        .await
        .unwrap();

    Ok(pool)
}

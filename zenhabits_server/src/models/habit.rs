use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Clone)]
pub struct Habit {
    habit_id: i32,
    name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    description: Option<String>,
    frequency: String,
    completed: bool,
    start_date: i64, // timestamp en milisegundos
    end_date: i64,
    user_id: i32,
}

impl Habit {
    pub fn new(
        habit_id: i32,
        name: String,
        description: Option<String>,
        frequency: String,
        completed: bool,
        start_date: i64,
        end_date: i64,
        user_id: i32,
    ) -> Self {
        Habit {
            habit_id,
            name,
            description,
            frequency,
            completed,
            start_date,
            end_date,
            user_id,
        }
    }

    pub fn validate(&self) -> bool {
        !self.name.trim().is_empty() && !self.frequency.trim().is_empty()
    }

    pub fn get_habit_id(&self) -> &i32 {
        &self.habit_id
    }

    pub fn get_name(&self) -> &String {
        &self.name
    }

    pub fn get_description(&self) -> Option<&String> {
        self.description.as_ref()
    }

    pub fn get_frequency(&self) -> &String {
        &self.frequency
    }

    pub fn get_completed(&self) -> bool {
        self.completed
    }

    pub fn get_start_date(&self) -> i64 {
        self.start_date
    }

    pub fn get_end_date(&self) -> i64 {
        self.end_date
    }

    pub fn get_user_id(&self) -> &i32 {
        &self.user_id
    }
}

use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
pub struct Habit {
    habit_id: usize,
    name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    description: Option<String>,
    frecuency: String,
    user_id: usize
}

impl Habit {
    pub fn new(habit_id: usize, name: String, description: Option<String>, frecuency: String, user_id: usize) -> Self {
        Habit {
            habit_id,
            name,
            description,
            frecuency,
            user_id,
        }
    }

    pub fn validate(&self) -> bool {
        !self.name.trim().is_empty()
            && !self.frecuency.trim().is_empty()
    }

    pub fn get_habit_id(&self) -> &usize {
        &self.habit_id
    }

    pub fn get_name(&self) -> &String {
        &self.name
    }

    pub fn get_description(&self) -> Option<&String> {
        self.description.as_ref()
    }

    pub fn get_frecuency(&self) -> &String {
        &self.frecuency
    }

    pub fn get_user_id(&self) -> &usize {
        &self.user_id
    }
}
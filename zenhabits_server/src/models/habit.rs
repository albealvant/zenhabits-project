use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Clone)]
pub struct Habit {
    habit_id: u32,
    name: String,
    #[serde(skip_serializing_if = "Option::is_none")]
    description: Option<String>,
    frequency: String,
    user_id: u32
}

impl Habit {
    pub fn new(habit_id: u32, name: String, description: Option<String>, frequency: String, user_id: u32) -> Self {
        Habit {
            habit_id,
            name,
            description,
            frequency,
            user_id,
        }
    }

    pub fn validate(&self) -> bool {
        !self.name.trim().is_empty()
            && !self.frequency.trim().is_empty()
    }

    pub fn get_habit_id(&self) -> &u32 {
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

    pub fn get_user_id(&self) -> &u32 {
        &self.user_id
    }
}
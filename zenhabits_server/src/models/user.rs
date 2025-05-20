use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize)]
pub struct User {
    user_id: u32,
    name: String,
    email: String,
    password: String
}

impl User {
    pub fn new(user_id: u32, name: String, email: String, password: String) -> Self {
        User {
            user_id,
            name,
            email,
            password,
        }
    }

    pub fn validate(&self) -> bool {
        !self.name.trim().is_empty()
            && !self.email.trim().is_empty()
            && !self.password.trim().is_empty()
    }

    pub fn get_id(&self) -> &u32 {
        &self.user_id
    }

    pub fn get_name(&self) -> &String {
        &self.name
    }

    pub fn get_password(&self) -> &String {
        &self.password
    }

    pub fn get_email(&self) -> &String {
        &self.email
    }
}
###### ALBA ALMORIL BENITO.
# ZENHABITS
> **NOTA**
> Todos los diagramas se encuentran en `docs/img`

## Requisitos
* **Funcionales:**
  - Crear, consultar, modificar y eliminar hábitos y metas.
  - Gestionar y recibir notificaciones.
  - Desbloquear logros.
* **No funcionales:**
  - Compatibilidad Android/iOS.
  - Funcionamiento offline con SQLite.
  - Interfaz intuitiva y minimalista.
  - Seguridad en la API con autenticación JWT.
  - Pruebas de usabilidad.
  - Personalizar personaje.
<br>

## Diagrama de casos de uso
```plantuml
@startuml
left to right direction
actor User as u

rectangle Zenhabits {
  u -- (Crear y/o consultar hábitos y metas)
  u -- (Modificar y/o eliminar hábitos y metas) 
  u -- (Desbloquear logros)
  u -- (Gestionar o recibir notificaciones)
}
@enduml
```

<br>

## Diagrama de despliegue
```plantuml
@startuml
left to right direction

node "<<Device>>" {
  component "ZENHABITS App" {
    database "local SQLite"
  }
}

node "<<Servidor>>" {
  node "<<API Docker container>>" {
    component "Remote service" as api
  }
  node "<<Mysql Docker container>>" {
    database "remote MySQL" as mysql
  }
}

"ZENHABITS App" -- api : HTTPS:8000/JSON
api -- mysql : TCP:3306/SQL
@enduml
```

La API RESTful desarrollada en Rust utiliza el crate sqlx como gestor de conexiones y ORM asíncrono para comunicarse con la base de datos MySQL alojada en un contenedor Docker. La comunicación se realiza a través de TCP sobre el puerto expuesto por Docker (3306), utilizando el protocolo SQL.
Por su parte, la app móvil establece la conexión con la API mediante HTTPS (puerto 8000), usando JSON (JavaScript Object Notation) como formato de datos.

<br>

## Diagrama de componentes
```plantuml

```
<br>

## Diagrama de clases (ongoing)
```plantuml
@startuml
top to bottom direction

package "data" {
  package "database"{
    package converter {
      class DatetimeConverter
    }
    package dao {
      abstract class HabitDao
      abstract class UserDao
    }
    package entities {
      class HabitEntity {
        + habitId: int
        + name: String
        + description: String
        + completed: bool
        + startDate: DateTime
        + endDate: DateTime
        + userId: int
      }

      class UserEntity {
        + userId: int
        + name: String
        + email: String
        + passwordHash: String
      }
    }
  }
  package model {
    class HabitModel
    class UserModel
  }
  package repository {
    class HabitsRepository {
      + getHabits(): List<HabitModel>
      + insertHabit(HabitModel habit)
      + deleteHabit(HabitModel habit)
      + getHabitsByUser(int userId): List<HabitModel>
    }

    class UsersRepository {
      + createUser(UserModel user)
      + getUserById()
    }
  }

  HabitDao --> HabitEntity
  UserDao --> UserEntity

  HabitModel --> HabitEntity
  UserModel --> UserEntity

  HabitsRepository --> HabitDao
  HabitsRepository --> HabitModel
  UsersRepository --> UserDao
  UsersRepository --> UserModel
}

package "domain" {
  package model {
    class Habit {
      - name: String
      - description: String
      - completed: bool
      - startDate: DateTime
      - endDate: DateTime
      - userId: int
    }

    class User {
      - userId: int
      - name: String
      - email: String
      - passwordHash: String
    }
  }
  package usecases {
    class GetHabitsUseCase
    class InsertHabitUseCase
    class DeleteHabitUseCase
    class InsertUserUseCase
  }

  GetHabitsUseCase --> Habit
  InsertHabitUseCase --> Habit
  DeleteHabitUseCase --> Habit
  InsertUserUseCase --> User
}

package "presentation" {
  package screens {
    class LoginScreen
    class CreateUserScreen
    class HomeScreen
    class CreateHabitScreen
    class GoalsScreen
    class SettingsScreen
  }
  package viewmodels {
    class HabitViewModel
    class UserViewModel
  }

  HabitViewModel --> GetHabitsUseCase
  HabitViewModel --> InsertHabitUseCase
  HabitViewModel --> DeleteHabitUseCase
}
@enduml
```

<br>

## Diagrama de navegación
```plantuml
@startuml
left to right direction

frame "Login/Registro" as Login {
}

frame "Pantalla Principal" as Principal {
}

frame "Crear Hábito" as CrearHabito {
}

frame "Metas" as Metas {
}

frame "Perfil Usuario" as Perfil {
}

Login --> Principal : iniciar sesión
Principal --> CrearHabito : crear nuevo hábito
Principal --> Metas : gestionar metas
Principal --> Perfil : ver perfil
@enduml
```
> **INFO**
> Versión más detallada en `docs/img`

## Modelo entidad-relación (ERD)
Hecho en ERDPlus: https://erdplus.com/
> (ubicado en `docs/img/MER.png`)
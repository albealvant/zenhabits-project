###### ALBA ALMORIL BENITO.
# ZENHABITS
## Diagrama de despliegue
```plantuml
@startuml
node "Dispositivo del usuario" {
  component "ZENHABITS App" {
    database "SQLite local"
  }
}

node "Servidor Cloud" {
  component "API Rust" as api {
    [sqlx crate]
  }
  node "Docker Host" {
    database "MySQL (contenedor Docker)\nPuerto: 3306" as mysql
  }
}

"ZENHABITS App" -- api : HTTPS (puerto 8000)\nFormato: JSON
api -- mysql : TCP (3306)\nProtocolo: SQL

@enduml
```

La API RESTful desarrollada en Rust utiliza el crate sqlx como gestor de conexiones y ORM asíncrono para comunicarse con la base de datos MySQL alojada en un contenedor Docker. La comunicación se realiza a través de TCP sobre el puerto expuesto por Docker (3306), utilizando el protocolo SQL.
Por su parte, la app móvil establece la conexión con la API mediante HTTPS (puerto 8000), usando JSON (JavaScript Object Notation) como formato de datos.

<br>

## Requisitos
* **Funcionales:**
  - Crear, modificar y eliminar hábitos, tareas y metas.
  - Asignar notificaciones.
  - Desbloquear logros.
  - Personalizar personaje.
* **No funcionales:**
  - Compatibilidad Android/iOS.
  - Funcionamiento offline con SQLite.
  - Interfaz intuitiva y minimalista.
  - Seguridad en la API con autenticación JWT.
  - Pruebas de usabilidad.
<br>

## Diagrama de casos de uso (en proceso)
```plantuml
@startuml
left to right direction
actor User as u

rectangle Zenhabits {
  u --> (Iniciar sesión) 
  u --> (Crear hábito/tarea/meta)
  u --> (Editar o eliminar hábito/tarea/metas) 
  u --> (Desbloquear logros)
  u --> (Personalizar al personaje)
  u --> (Gestionar o recibir notificaciones)
}
@enduml
```

<br>

## Modelo entidad-relación (ERD)
Hecho en ERDPlus: https://erdplus.com/
![erd]() Está en proceso...
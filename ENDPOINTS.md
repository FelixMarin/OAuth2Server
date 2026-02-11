# 📚 Documentación de Endpoints – OAuth2Server

OAuth2Server expone endpoints para autenticación OAuth2, emisión de tokens JWT y gestión básica de usuarios.  
Todos los endpoints siguen el estándar OAuth2 y devuelven respuestas en formato **JSON**.

---

# 🔐 1. Endpoints OAuth2

## 1.1. `/oauth/token` – Obtener token

Endpoint principal para obtener tokens JWT mediante los flujos:

- **Password Grant**
- **Client Credentials**

### 🔸 Método
```
POST /oauth/token
```

### 🔸 Headers
```
Authorization: Basic base64(client_id:client_secret)
Content-Type: application/x-www-form-urlencoded
```

---

## 🔹 A) Password Grant

Autentica a un usuario real (username/password).

### Request
```bash
curl -X POST \
  -u "cine-platform:supersecreto" \
  -d "grant_type=password" \
  -d "username=admin" \
  -d "password=PASSWORD" \
  http://localhost:8080/oauth/token
```

### Response
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expires_in": 86399,
  "scope": "read write"
}
```

---

## 🔹 B) Client Credentials

Autenticación entre servicios (sin usuario humano).

### Request
```bash
curl -X POST \
  -u "client_id:client_secret" \
  -d "grant_type=client_credentials" \
  http://localhost:8080/oauth/token
```

### Response
Igual que en password grant, pero sin refresh token.

---

## 🔹 C) Refresh Token

Renueva un access token caducado.

### Request
```bash
curl -X POST \
  -u "client_id:client_secret" \
  -d "grant_type=refresh_token" \
  -d "refresh_token=<REFRESH_TOKEN>" \
  http://localhost:8080/oauth/token
```

---

# 🧪 2. Endpoints de Usuario

Los endpoints de usuario están protegidos por **Bearer Token**.  
Requieren incluir:

```
Authorization: Bearer <ACCESS_TOKEN>
```

---

## 2.1. `GET /api/users` – Listar usuarios

### Request
```bash
curl -H "Authorization: Bearer <TOKEN>" \
  http://localhost:8080/api/users
```

### Response
```json
[
  {
    "id": 1,
    "username": "admin",
    "role": "ADMIN"
  },
  {
    "id": 2,
    "username": "juanaco",
    "role": "USER"
  }
]
```

---

## 2.2. `GET /api/users/{id}` – Obtener usuario por ID

### Request
```bash
curl -H "Authorization: Bearer <TOKEN>" \
  http://localhost:8080/api/users/1
```

### Response
```json
{
  "id": 1,
  "username": "admin",
  "role": "ADMIN"
}
```

---

## 2.3. `POST /api/users` – Crear usuario

### Request
```bash
curl -X POST \
  -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{
        "username": "nuevo",
        "password": "1234",
        "role": "USER"
      }' \
  http://localhost:8080/api/users
```

### Response
```json
{
  "id": 3,
  "username": "nuevo",
  "role": "USER"
}
```

---

# 🔒 3. Seguridad y Roles

El sistema define dos roles:

- `ADMIN`
- `USER`

### Permisos por defecto:

| Endpoint | USER | ADMIN |
|---------|------|--------|
| `/oauth/token` | ✔️ | ✔️ |
| `GET /api/users` | ❌ | ✔️ |
| `POST /api/users` | ❌ | ✔️ |
| `GET /api/users/{id}` | ✔️ (solo su propio usuario) | ✔️ |

---

# 🧾 4. Errores comunes

### Token inválido
```json
{
  "error": "invalid_token",
  "error_description": "JWT expired"
}
```

### Credenciales incorrectas
```json
{
  "error": "invalid_grant",
  "error_description": "Bad credentials"
}
```

### Sin permisos
```json
{
  "error": "access_denied"
}
```

---

# 🧭 5. Swagger UI

El proyecto incluye documentación interactiva:

```
http://localhost:8080/swagger-ui.html
```

---

# 🎯 6. Resumen

OAuth2Server proporciona:

- Autenticación OAuth2 estándar  
- Emisión de JWT  
- Gestión de usuarios  
- Seguridad basada en roles  
- Integración lista para microservicios  
- Despliegue completo en Kubernetes  

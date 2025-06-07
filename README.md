# Mail Pilot – Rails API

This Rails API serves as the backend for the **Mail Pilot** system, created for the [Postmark Challenge](https://dev.to/challenges/postmark).
It receives commands via email (webhook) and delivers them to a connected device (ESP8266).

## 📦 Overview

- Parses incoming email bodies and extracts valid commands.
- Stores each command in the database with a status (`pending`, `running`, `completed`, `failed`).
- Exposes endpoints for the ESP8266 to fetch and report command statuses.

## 🛠 Tech Stack

- Ruby on Rails 7
- PostgreSQL
- Docker + Docker Compose

## 🧪 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/your-username/mail_pilot.git
cd mail_pilot
```

### 2. Set up environment

Create a .env file:

```env
API_PORT=3006
DB_PORT_EXPOSE=5441
```

### 3. Build and run DB with Docker

```bash
docker-compose up --build
```

### 4. Create the database

```bash
bin/rails db:create db:migrate
```

### 5. Run the server

```bash
bin/rails server
```

## 📬 Email Webhook Endpoint

POST /inbound

- Receives emails via Postmark Inbound webhook.

- Parses the TextBody and saves it as a command.

```json
{
  "TextBody": "ROOM_1_ON"
}
```

## 📡 Device Endpoints

GET /device/commands/latest
Returns the oldest pending command and marks it as running.
Response:
```json
{
  "id": 42,
  "command": "ROOM_1_ON"
}
```
If no command is found:
```json
{
  "command": null
}
```

PATCH /device/commands/:id/complete
Marks the command as completed.

PATCH /device/commands/:id/failed
Marks the command as failed.

## ✅ Valid Commands
The following commands are supported:

- ROOM_1_ON, ROOM_1_OFF

- ROOM_2_ON, ROOM_2_OFF

- ROOM_3_ON, ROOM_3_OFF

- ROOM_4_ON, ROOM_4_OFF

- DOOR_OPEN, DOOR_CLOSE

## 🧭 System Diagram

![Mail Pilot System Diagram](https://raw.githubusercontent.com/davidmrtz-dev/mail_pilot/main/diagram_mail_pilot.png)

### 🧠 How it works

1. A user sends an email with a valid command to Postmark.
2. Postmark triggers a webhook (`/inbound`) in the Rails API with the `TextBody` of the email.
3. The Rails API validates and stores the command in the database.
4. The ESP8266 polls `/device/commands/latest` every 3 seconds.
5. If a command is pending:
   - It executes the action.
   - Reports completion or failure via PATCH endpoints.

## 🙏 Acknowledgments
Mail Pilot is proudly built for the Postmark Challenge.
Powered by email, Ruby, and a little Wi-Fi magic.

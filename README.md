
# Twitter-like App with Additional Features (Invite Friends & Chat)

This project is a Twitter-like application with added functionality such as inviting friends and chatting. It uses a Ruby on Rails backend, PostgreSQL as the primary database, Redis for caching, and Redoc for API documentation.

- Services
  - Postgres
  - Redis
  - App
  - API Documentation (Redoc)


## Project Setup

To get started with the project, follow these steps:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/twitter-like-app.git
   cd twitter-like-app
   ```

2. **Build and Start the Containers:**
   Run the following command to start the services defined in `docker-compose.yml`:

   ```bash
   docker-compose up --build
   ```

   This command will:
   - Build the application image.
   - Spin up the `Postgres`, `Redis`, and `App` services.
   - Run the Rails app on `http://localhost:3000`.

# Event Booking System Backend

It supports two user roles—**Event Organizers** and **Customers**—and features role-based authentication using JWT. The application also uses Sidekiq for background jobs.

## Features

- **Role-based API:**  
  - Event Organizers can create, read, update, and delete events.
  - Customers can view events and make bookings.
- **Authentication:**  
  - JWT-based authentication with separate login endpoints for organizers and customers.
- **Database Models:**  
  - Event Organizers, Customers, Events, Tickets, and Bookings with proper associations.
- **Background Jobs:**  
  - Sidekiq jobs to simulate sending email confirmations and notifications on event updates.
- **Logging:**  
  - Use of Rails logger to track background job activity.

## Requirements

- **Ruby:** 3.3.7
- **Rails:** 8.0.2
- **PostgreSQL**
- **Redis** (for Sidekiq)

## Installation

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd event_booking_system
   ```

2. **Install dependencies:**

   Make sure you have Bundler installed, then run:

   ```bash
   bundle install
   ```

3. **Configure Environment Variables:**

    Ensure your `config/database.yml` is configured with your PostgreSQL credentials.

## Database Setup

1. **Create and Migrate the Database:**

   Run the following commands:

   ```bash
   rails db:create
   rails db:migrate
   ```

## Creating Sample Data

Since there are no dedicated signup endpoints in this so i am creating sample Event Organizer and Customer via the Rails console:

1. **Open the Rails console:**

   ```bash
   rails console
   ```

2. **Create a sample Event Organizer:**

   ```ruby
   EventOrganizer.create(name: "Organizer One", email: "organizer@example.com", password: "password")
   ```

3. **Create a sample Customer:**

   ```ruby
   Customer.create(name: "Customer One", email: "customer@example.com", password: "password")
   ```

4. **Create an Event and Ticket:**

   ```ruby
   organizer = EventOrganizer.first
   event = organizer.events.create(title: "Ruby Conference", description: "A conference for Ruby enthusiasts", date: "2025-06-15T09:00:00Z", venue: "Convention Center")
   event.tickets.create(ticket_type: "General Admission", price: 50.00, availability: 100)
   ```

## Running the Application

1. **Start the Rails Server:**

   ```bash
   rails server
   ```

   The application will be available at [http://localhost:3000](http://localhost:3000).

2. **Start Redis:**

   Ensure Redis is running on your system. For example, if you have it installed locally, run:

   ```bash
   redis-server
   ```

3. **Run Sidekiq:**

   Start Sidekiq from the project root:

   ```bash
   bundle exec sidekiq
   ```

   > **Note for Windows users(In my case):** If you have issues running the Sidekiq executable, consider generating a binstub with `bundle binstubs sidekiq` and then run `bin\sidekiq`.




## Testing the API with Postman

### 1. Obtain a JWT Token

- **Event Organizer Login:**
  - **Method:** POST
  - **URL:** `http://localhost:3000/api/v1/login/event_organizer`
  - **Headers:** `Content-Type: application/json`
  - **Body:**
    ```json
    {
      "email": "organizer@example.com",
      "password": "password"
    }
    ```
  - **Response:** A JSON containing a token (e.g., `{ "token": "eyJhbGciOiJIUzI1NiJ9..." }`).

- **Customer Login:**
  - **Method:** POST
  - **URL:** `http://localhost:3000/api/v1/login/customer`
  - **Body:** Use the customer's credentials similarly.

### 2. Use the Token for Protected Endpoints

For subsequent requests, include the following header:

```
Authorization: Bearer <your_token_here>
```

### 3. Example Endpoints

- **Get All Events:**

  ```http
  GET http://localhost:3000/api/v1/events
  ```

- **Create an Event (Organizer Only):**

  ```http
  POST http://localhost:3000/api/v1/events
  ```

  **Body:**
  ```json
  {
    "event": {
      "title": "Ruby Conference",
      "description": "A conference for Ruby enthusiasts",
      "date": "2025-06-15T09:00:00Z",
      "venue": "Convention Center"
    }
  }
  ```

- **Create a Booking (Customer Only):**

  ```http
  POST http://localhost:3000/api/v1/bookings
  ```

  **Body:**
  ```json
  {
    "booking": {
      "event_id": 1,
      "ticket_id": 1,
      "quantity": 2
    }
  }
  ```

- **Get Bookings (Restricted to Logged-In Customer):**

  ```http
  GET http://localhost:3000/api/v1/bookings
  ```

## Background Jobs and Sidekiq

### Logging Job Messages

Instead of using `puts`, I'm using `Rails.logger.info` to log messages because puts was not working for me in sidekiq console.

```ruby
Rails.logger.info "Email confirmation: Booking ##{booking.id} confirmed for customer #{booking.customer.email}"
```

### Viewing Logs on Windows

I am using Windows, you can view your development logs using PowerShell:

```powershell
Get-Content .\log\development.log -Wait
```

This command works similarly to `tail -f` on Unix systems.

## Troubleshooting

- **Sidekiq Executable Issues on Windows:**  
  If `bundle exec sidekiq` doesn’t work(it doesnt worked for me), generate a binstub with:
  
  ```bash
  bundle binstubs sidekiq
  ```
  
  Then run Sidekiq using:
  
  ```bash
  bin\sidekiq
  ```

- **Log Monitoring on Windows:**  
  Use PowerShell command: `Get-Content .\log\development.log -Wait`

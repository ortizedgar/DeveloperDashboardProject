# Real-time News and GitHub Events Dashboard

## Table of Contents

1. [Introduction](#introduction)
2. [Technologies](#technologies)
3. [Features](#features)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Contributing](#contributing)
7. [License](#license)

## Introduction

This project aims to provide a real-time dashboard that displays news and GitHub events. The backend is built using Ruby on Rails, while the frontend employs Next.js with TypeScript.

## Technologies

- **Backend**: Ruby on Rails
  - Webhooks for GitHub Events
  - REST API for News
- **Frontend**: Next.js with TypeScript
  - Axios for API requests
  - ActionCable for WebSockets
- **Styling**: Tailwind CSS
- **Real-time**: Action Cable (WebSockets)

## Features

- View the latest news
- Receive GitHub events in real-time
- Responsive and mobile-first design
- Button for manually fetching news

## Environment Variables
To run this project, you'll need to add the following environment variables:

### Backend
Create a .env file in the backend/ directory and add:

```env
NEWS_API_KEY=... # Your News API Key
NEWS_API_URL=https://newsapi.org/v2/ # News API URL

GITHUB_WEBHOOK_SECRET=... # GitHub Webhook Secret

PUBLIC_URL=... # Public URL (if using Ngrok or a similar service)
```

### Frontend
Create a .env file in the frontend/ directory and add:

```env
NEXT_PUBLIC_BACKEND_HOST=localhost:3001 # Address where the backend is listening
```

### Additional Setup
To make the GitHub events feature work:

- **Configure a GitHub Webhook**: You'll need to set up a webhook in your GitHub repository to point to your backend server's GitHub events endpoint.

- **Expose Local Server**: If you are running the backend server on your local machine, you'll need to expose it to the internet. You can use services like Ngrok to get a public URL that forwards to your local server.

## Installation

### Prerequisites

- Node.js
- Ruby
- Rails
- PostgreSQL
- Yarn
- NGrok or similar

### Backend

```bash
# Navigate to the backend directory
cd backend/

# Install dependencies
bundle install

# Create and migrate the database
rails db:create db:migrate

# Start the Rails server
rails s
```

### Frontend

```bash
# Navigate to the frontend directory
cd frontend/

# Install dependencies
yarn install

# Start the development server
yarn dev
```

## Usage
Once the frontend and backend servers are up and running:

> Open http://localhost:3000 to view the dashboard.
Use the "Fetch News" button to load the latest news.
GitHub events will automatically update in real-time.

## Contributing
If you would like to contribute to the project, create a fork, make your changes, and submit a Pull Request. Ensure that your changes are well-documented.

## License
This project is under the MIT License. See the LICENSE.md file for more details.

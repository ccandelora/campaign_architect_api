# Campaign Architect API

A comprehensive Rails 8.0.2 API for managing marketing campaigns with AI-powered features for Everclear and Phrendly brands.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [API Documentation](#api-documentation)
- [AI Features](#ai-features)
- [Background Jobs](#background-jobs)
- [Testing](#testing)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)

## Overview

Campaign Architect API is a sophisticated marketing campaign management system that provides:

- **Campaign Management**: Create, edit, and manage multi-channel marketing campaigns
- **AI-Powered Features**: Copy grading, funnel analysis, and intelligent suggestions
- **Multi-Brand Support**: Dedicated features for Everclear (spiritual guidance) and Phrendly (social connection) brands
- **Background Processing**: Asynchronous AI analysis and processing
- **Template System**: Reusable campaign templates and playbooks
- **Performance Tracking**: Campaign analytics and post-mortem analysis

## Features

### Core Features
- ✅ **Campaign CRUD Operations**: Full campaign lifecycle management
- ✅ **Multi-Channel Support**: Email, Push, Social Media, Ads, Delays, Conditionals
- ✅ **Node-Based Campaign Builder**: Visual campaign flow construction
- ✅ **UTM Parameter Management**: Automatic UTM generation and tracking
- ✅ **Campaign Templates**: Pre-built templates for common use cases

### AI Features
- ✅ **AI Copy Grading**: Intelligent analysis of email and marketing copy
- ✅ **Funnel Analysis**: AI-powered campaign flow optimization
- ✅ **Smart Suggestions**: Context-aware campaign improvement recommendations
- ✅ **AI Chat Assistant**: Conversational AI for campaign strategy
- ✅ **Copy Enhancement**: AI-powered copy rewriting and optimization

### Advanced Features
- ✅ **Background Job Processing**: Asynchronous AI analysis
- ✅ **Pre-flight Checks**: Campaign readiness validation
- ✅ **Performance Logging**: Post-campaign analytics
- ✅ **Brand-Specific Intelligence**: Tailored AI responses for each brand
- ✅ **Template Management**: Create and manage reusable templates

## Tech Stack

- **Framework**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL
- **Background Jobs**: Active Job with async adapter
- **AI Integration**: OpenAI GPT-3.5-turbo/GPT-4
- **Authentication**: JWT tokens
- **HTTP Client**: HTTParty for external API calls
- **Testing**: RSpec (ready for implementation)

## Prerequisites

- **Ruby**: 3.3.5 or higher
- **Rails**: 8.0.2
- **PostgreSQL**: 12 or higher
- **Node.js**: 18+ (for asset compilation)
- **OpenAI API Key**: For AI features (optional, falls back to mock responses)

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd campaign_architect_api
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install Node.js dependencies (if any)
npm install
```

### 3. Environment Setup

Create environment files:

```bash
# Copy environment template
cp .env.example .env

# Edit environment variables
nano .env
```

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
# Database Configuration
DATABASE_URL=postgresql://username:password@localhost:5432/campaign_architect_development

# JWT Secret for Authentication
JWT_SECRET=your-super-secret-jwt-key-here

# OpenAI API Configuration
OPENAI_API_KEY=sk-your-openai-api-key-here

# Rails Configuration
RAILS_ENV=development
RAILS_SERVE_STATIC_FILES=true

# CORS Configuration
FRONTEND_URL=http://localhost:3000
```

### Rails Credentials

For production, use Rails encrypted credentials:

```bash
# Edit credentials
EDITOR=nano rails credentials:edit

# Add the following structure:
jwt_secret: your-jwt-secret
openai_api_key: your-openai-api-key
```

### Database Configuration

Edit `config/database.yml`:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: campaign_architect_development
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['DB_USERNAME'] || 'postgres' %>
  password: <%= ENV['DB_PASSWORD'] || '' %>
  host: <%= ENV['DB_HOST'] || 'localhost' %>
  port: <%= ENV['DB_PORT'] || 5432 %>

test:
  adapter: postgresql
  encoding: unicode
  database: campaign_architect_test
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['DB_USERNAME'] || 'postgres' %>
  password: <%= ENV['DB_PASSWORD'] || '' %>
  host: <%= ENV['DB_HOST'] || 'localhost' %>
  port: <%= ENV['DB_PORT'] || 5432 %>

production:
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>
```

## Database Setup

### 1. Create and Setup Database

```bash
# Create databases
rails db:create

# Run migrations
rails db:migrate

# Seed initial data
rails db:seed
```

### 2. Verify Database Setup

```bash
# Check database status
rails db:version

# Open Rails console to verify
rails console
> User.count
> Campaign.count
```

## Running the Application

### Development Mode

```bash
# Start the Rails server
rails server -p 3001

# Or with specific binding
rails server -b 0.0.0.0 -p 3001
```

The API will be available at `http://localhost:3001`

### Background Jobs

The application uses Active Job for background processing:

```bash
# Jobs run automatically in development
# For production, use a job processor like Sidekiq
```

### Console Access

```bash
# Open Rails console
rails console

# Test API functionality
user = User.first
campaign = Campaign.first
service = OpenaiService.new
```

## API Documentation

### Base URL
```
http://localhost:3001/api/v1
```

### Authentication

All API endpoints require JWT authentication:

```bash
# Get JWT token (implement login endpoint)
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'

# Use token in subsequent requests
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  http://localhost:3001/api/v1/campaigns
```

### Core Endpoints

#### Campaigns

```bash
# Get all campaigns
GET /api/v1/campaigns

# Get specific campaign
GET /api/v1/campaigns/:id

# Create campaign
POST /api/v1/campaigns
{
  "campaign": {
    "name": "Q4 Holiday Campaign",
    "brand": "everclear",
    "goal": "Increase user acquisition",
    "structure": {
      "nodes": [],
      "edges": []
    }
  }
}

# Update campaign
PATCH /api/v1/campaigns/:id

# Delete campaign
DELETE /api/v1/campaigns/:id
```

#### AI Features

```bash
# Grade copy
POST /api/v1/campaigns/:id/grade_copy
{
  "node_id": "node-1"
}

# Analyze funnel
POST /api/v1/campaigns/:id/analyze

# AI chat
POST /api/v1/ai/chat
{
  "message": "How can I improve my email open rates?",
  "current_brand": "everclear",
  "current_campaign_id": 1
}
```

#### Background Jobs

```bash
# Check job status
GET /api/v1/jobs/:job_id
```

#### Templates

```bash
# Get templates
GET /api/v1/campaign_templates

# Create template
POST /api/v1/campaign_templates

# Create campaign from template
POST /api/v1/campaigns/from_template
```

### Response Formats

#### Success Response
```json
{
  "campaign": {
    "id": 1,
    "name": "Q4 Holiday Campaign",
    "brand": "everclear",
    "goal": "Increase user acquisition",
    "status": "draft",
    "structure": {
      "nodes": [...],
      "edges": [...]
    },
    "created_at": "2025-01-01T00:00:00Z",
    "updated_at": "2025-01-01T00:00:00Z"
  }
}
```

#### Error Response
```json
{
  "error": "Campaign not found",
  "details": "The requested campaign does not exist"
}
```

## AI Features

### OpenAI Integration

The application integrates with OpenAI for intelligent features:

#### Copy Grading
- Analyzes email subject lines, body content, and CTAs
- Provides scores (1-10) and detailed feedback
- Brand-specific recommendations for Everclear and Phrendly

#### Funnel Analysis
- Evaluates campaign flow and structure
- Identifies optimization opportunities
- Suggests improvements for conversion rates

#### AI Chat Assistant
- Conversational AI for campaign strategy
- Context-aware responses based on current campaign
- Brand-specific expertise and recommendations

### Fallback System

When OpenAI API is unavailable:
- Intelligent mock responses based on content analysis
- Maintains functionality without external dependencies
- Graceful degradation with helpful feedback

### Configuration

```ruby
# config/application.rb
config.openai_timeout = 30.seconds
config.ai_fallback_enabled = true
```

## Background Jobs

### Job Types

1. **Copy Grading Jobs**
   - Analyzes campaign copy using AI
   - Returns detailed feedback and scores
   - Typical processing time: 2-5 seconds

2. **Funnel Analysis Jobs**
   - Evaluates campaign structure
   - Provides optimization recommendations
   - Typical processing time: 3-8 seconds

3. **AI Rewrite Jobs**
   - Enhances copy using AI
   - Multiple variation generation
   - Typical processing time: 5-10 seconds

### Job Monitoring

```bash
# Check job status in console
rails console
> BackgroundJob.recent.limit(10)
> job = BackgroundJob.find_by(job_id: "your-job-id")
> job.status
> job.result
```

### Job Configuration

```ruby
# config/application.rb
config.active_job.queue_adapter = :async
config.active_job.default_queue_name = :default
```

## Testing

### Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/models/campaign_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Test Database Setup

```bash
# Prepare test database
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate
```

### API Testing

```bash
# Test with curl
curl -X GET http://localhost:3001/api/v1/campaigns \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Test AI features
curl -X POST http://localhost:3001/api/v1/campaigns/1/grade_copy \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"node_id": "node-1"}'
```

## Deployment

### Production Setup

1. **Environment Configuration**
```bash
# Set production environment variables
export RAILS_ENV=production
export DATABASE_URL=postgresql://...
export JWT_SECRET=...
export OPENAI_API_KEY=...
```

2. **Database Migration**
```bash
rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production
rails db:seed RAILS_ENV=production
```

3. **Asset Compilation**
```bash
rails assets:precompile RAILS_ENV=production
```

4. **Server Start**
```bash
rails server -e production -p 3001
```

### Docker Deployment

```dockerfile
# Dockerfile
FROM ruby:3.3.5

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3001
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  api:
    build: .
    ports:
      - "3001:3001"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/campaign_architect_production
      - JWT_SECRET=your-jwt-secret
      - OPENAI_API_KEY=your-openai-key
    depends_on:
      - db
  
  db:
    image: postgres:14
    environment:
      - POSTGRES_DB=campaign_architect_production
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Troubleshooting

### Common Issues

#### 1. Database Connection Issues
```bash
# Check PostgreSQL status
brew services list | grep postgresql

# Start PostgreSQL
brew services start postgresql

# Check database exists
psql -l | grep campaign_architect
```

#### 2. OpenAI API Issues
```bash
# Test API key
curl -H "Authorization: Bearer YOUR_API_KEY" \
  https://api.openai.com/v1/models

# Check logs
tail -f log/development.log | grep -i openai
```

#### 3. Background Job Issues
```bash
# Check job status
rails console
> BackgroundJob.where(status: 'failed')

# Retry failed jobs
> failed_job = BackgroundJob.find_by(status: 'failed')
> CopyGradingJob.perform_now(failed_job.campaign_id, node_id, failed_job.job_id)
```

#### 4. CORS Issues
```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000'
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
```

#### 5. JWT Token Issues
```bash
# Generate new token in console
rails console
> require 'jwt'
> user = User.first
> secret = Rails.application.credentials.jwt_secret || ENV['JWT_SECRET']
> payload = { user_id: user.id, exp: 1.hour.from_now.to_i }
> token = JWT.encode(payload, secret, 'HS256')
> puts token
```

### Logging

```bash
# View logs
tail -f log/development.log

# Filter specific logs
tail -f log/development.log | grep -i "ai\|openai\|job"

# Check error logs
grep -i error log/development.log
```

### Performance Monitoring

```bash
# Monitor memory usage
ps aux | grep rails

# Monitor database connections
rails console
> ActiveRecord::Base.connection_pool.stat

# Monitor background jobs
> BackgroundJob.group(:status).count
```

### Health Checks

```bash
# API health check
curl http://localhost:3001/api/v1/health

# Database health check
rails runner "puts ActiveRecord::Base.connection.active? ? 'DB OK' : 'DB Error'"

# AI service health check
rails runner "puts OpenaiService.new.grade_copy(brand: 'everclear', node_data: {'data' => {'subject' => 'test'}}, node_type: 'email')[:score] ? 'AI OK' : 'AI Error'"
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is proprietary software. All rights reserved.

## Support

For technical support or questions:
- Check the troubleshooting section above
- Review the API documentation
- Contact the development team

---

**Campaign Architect API** - Empowering marketing teams with AI-driven campaign intelligence.

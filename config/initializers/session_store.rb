# Configure session store for OAuth support
# This is needed because Rails API mode disables sessions by default
Rails.application.config.session_store :cookie_store, key: '_campaign_architect_session'

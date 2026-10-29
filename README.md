# Redmine API Key Manager (target: Redmine 5.0.1)

Administrator-only list of users and their REST API key presence, first 3 characters, creation date, and revoke/rotate operations. Uses Redmine's built-in `Token` model; no database migrations and no secrets exported.

## Installation

1. Back up Redmine's database and test in a staging environment.
2. Copy the folder `redmine_api_key_manager` into `<redmine>/plugins/` (keep the folder name).
3. Restart Redmine (Passenger/Puma/systemd depending on your installation).
4. Sign in as a Redmine administrator, go to **Amministrazione → API Key utenti**, or `/admin/api_keys`.

No `bundle install` and no plugin migrations are normally required.

## Behavior and important caveats

- **Revoca** deletes the user's existing API token, if any.
- **Rigenera** creates a new API token via `Token.create!` which replaces the prior token through Redmine's built-in `before_create` callback. This creates a token even for an account that did not previously have one.
- The newly generated secret is **not displayed** to the administrator; the user retrieves it from their account page if REST API is enabled.
- An account can generate its own key again if REST API remains enabled. Revocation is not a durable per-user API deny policy.
- Redmine API keys act with the user's privileges, so revocation may break external integrations.
- Actions use POST and Redmine's built-in CSRF protection and administrator authorization; they are logged without secrets in Rails logs.
- The key prefix is only for visual identification and **not** a unique identifier; use the `token.id` and creation timestamp for inventory comparisons.
- The user status is shown as Redmine's numeric status code. The listing may include disabled/locked user accounts.
- No scheduled SIEM export is included in this version.

## Validation checklist

- Verify with an admin and non-admin account (non-admin must receive denial).
- Verify list, pagination and three filters.
- Verify revocation invalidates the original key and user can subsequently generate a new one.
- Verify rotation invalidates the old key, while the user's account shows the replacement.
- Check logs for actor/user/token IDs and absence of raw keys.

This package has been syntax checked but not integration-tested on your live Redmine installation.

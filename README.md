# Redmine API Key Manager (target: Redmine 5.0.1)

Administrator-only list of users and their REST API key presence, first 3 characters, creation date, and revoke/rotate operations. Uses Redmine's built-in `Token` model; no database migrations and no secrets exported.

## Installation

1. Back up Redmine's database and test in a staging environment.
2. Copy the folder `redmine_api_key_manager` into `<redmine>/plugins/` (keep the folder name).
3. Restart Redmine (Passenger/Puma/systemd depending on your installation).
4. Sign in as a Redmine administrator, go to **Amministrazione → API Key utenti**, or `/admin/api_keys`.

No `bundle install` and no plugin migrations are normally required.

## Standard installation

cd /var/www/redmine/plugins
git clone https://github.com/bubibubi/redmine_api_key_manager.git
sudo systemctl restart apache2

## Update

cd /var/www/redmine/plugins/redmine_api_key_manager
git pull --ff-only origin main
sudo systemctl restart apache2


get 'admin/api_keys', to: 'redmine_api_keys#index', as: :redmine_api_keys
post 'admin/api_keys/:id/revoke', to: 'redmine_api_keys#revoke', as: :revoke_redmine_api_key
post 'admin/api_keys/:id/rotate', to: 'redmine_api_keys#rotate', as: :rotate_redmine_api_key

# frozen_string_literal: true
Redmine::Plugin.register :redmine_api_key_manager do
  name 'Gestione API Key utenti'
  author 'Custom'
  description 'Inventario e revoca/rotazione delle API Key REST per amministratori.'
  version '0.1.0'
  requires_redmine version_or_higher: '5.0.0'
  menu :admin_menu, :redmine_api_keys,
       { controller: 'redmine_api_keys', action: 'index' },
       caption: 'API Key utenti', html: { class: 'icon icon-key' }
end

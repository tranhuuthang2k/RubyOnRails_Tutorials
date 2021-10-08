RailsAdmin.config do |config|
  # https://github.com/sferik/rails_admin/wiki/Fields

  config.model 'User' do
    edit do
      configure :reset_password_token do
        hide
      end
      configure :remember_created_at do
        hide
      end
      configure :remember_created_at do
        hide
      end
      configure :current_sign_in_ip do
        hide
      end
      configure :last_sign_in_ip do
        hide
      end
      configure :current_sign_in_at do
        hide
      end
      configure :sign_in_count do
        hide
      end
      configure :reset_password_sent_at do
        hide
      end
      configure :last_sign_in_at do
        hide
      end
    end
    navigation_label 'Manage User'
  end

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  config.parent_controller = 'ApplicationController'
  RailsAdmin.config do |config|
    config.authorize_with :cancancan
  end

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

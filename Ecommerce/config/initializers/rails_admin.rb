# frozen_string_literal: true

require Rails.root.join('lib', 'rails_admin', 'show_order_item.rb')
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ShowOrderItem)
RailsAdmin.config do |config|
  # https://github.com/sferik/rails_admin/wiki/Fields
  require Rails.root.join('lib', 'rails_admin.rb')

  config.model 'ActiveStorage::Blob' do
    visible false
  end

  config.model 'ActiveStorage::Attachment' do
    visible false
  end

  config.model 'ActiveStorage::VariantRecord' do
    visible false
  end
  config.model 'ActionText::RichText' do
    visible false
  end
  config.model 'Cart' do
    visible false
  end
  config.model 'CartItem' do
    visible false
  end

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
      configure :provider do
        hide
      end
      configure :comment do
        hide
      end
      configure :uid do
        hide
      end
      configure :post do
        hide
      end
      configure :api_token_digest do
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
  config.main_app_name = %w[Shopee Admin]

  config.actions do
    dashboard
    index
    new do
      except ['OrderItem']
    end
    export
    bulk_delete

    # phan show cua OrderItem se duoc custom nhung khong anh huong den show cua cac thanh phan khac

    show do
      except ['OrderItem']
    end

    edit
    delete
    show_order_item do
      only ['OrderItem']
    end
    show_in_app
  end
end

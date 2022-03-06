# frozen_string_literal: true

require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
module RailsAdmin
  module Config
    module Actions
      class ShowOrderItem < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)
        # hien action
        register_instance_option :visible? do
          true
        end

        register_instance_option :member do
          true
        end

        register_instance_option :pjax? do
          false
        end

        # icon cua action
        register_instance_option :link_icon do
          'icon-info-sign'
        end

        register_instance_option :http_methods do
          %i[get post]
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :custom_key do
          key
        end

        register_instance_option :controller do
          proc do
            @order = OrderItem.find params[:id] if request.get?
          end
        end

        def key
          self.class.key
        end
      end
    end
  end
end

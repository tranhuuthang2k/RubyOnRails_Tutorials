module RailsAdmin
    module Config
      module Actions
        class Dashboard < RailsAdmin::Config::Actions::Base
          RailsAdmin::Config::Actions.register(self)
  
          register_instance_option :root? do
            true
          end
  
          register_instance_option :breadcrumb_parent do
            nil
          end
  
          register_instance_option :controller do
            proc do
              #You can specify instance variables
              @custom_stats = "grab your stats here."
  
              #You can access submitted params (just submit your form to the dashboard).
              if params[:xyz]
                @do_something = "here"
              end
  
              #You can specify flash messages
              flash.now[:success] = "Welcome to dashboard"
  
              #After you're done processing everything, render the new dashboard
              render @action.template_name, status: 200
            end
          end
  
          register_instance_option :route_fragment do
            ''
          end
  
          register_instance_option :link_icon do
            'icon-home'
          end
  
          register_instance_option :statistics? do
            true
          end
        end
      end
    end
  end
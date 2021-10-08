class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :switch_locale
    before_action :sign_in,:redirect_to_users

    def switch_locale
        I18n.locale = params[:locale] || I18n.default_locale
    end

    def default_url_options
        { locale: I18n.locale }
    end
end

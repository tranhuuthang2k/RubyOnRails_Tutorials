# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '790662589513-al11bjemuihk02d29b645oqqb8vha5g4.apps.googleusercontent.com',
           'en3c5ju62pd-QHfrGhd8FxR8', skip_jwt: true
end

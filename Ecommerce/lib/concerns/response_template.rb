# frozen_string_literal: true

module ResponseTemplate
  def self.template(code, message, content = {}, messages = [])
    response = { code: code, message: message, data: content }
    response[:messages] = messages if messages.present?
    Rails.logger.info Time.zone
    Rails.logger.info response

    response
  end

  def self.success(message, content = {})
    template(200, message, content)
  end

  def self.error(message, content = {})
    template(500, message, content)
  end

  def self.errors(messages, content = {})
    template(500, messages.first, content, messages)
  end

  def self.unauthorized(message, content = {})
    template(401, message, content)
  end
end

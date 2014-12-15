class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include TicketsHelper

  private

  def client
    MyClient.instance
  end
end

class MyClient < ZendeskAPI::Client
  def self.instance
    @instance ||= new do |config|
      config.url = ENV["ZENDESK_URL"]
      config.username = ENV["ZENDESK_USERNAME"]
      config.token = ENV["ZENDESK_TOKEN"]
      config.password = ENV["ZENDESK_PASSWORD"]


      config.retry = true

      config.logger = Rails.logger
    end
  end
end

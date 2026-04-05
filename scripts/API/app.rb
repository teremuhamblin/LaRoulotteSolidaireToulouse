# scripts/API/app.rb
# frozen_string_literal: true

require "sinatra/base"
require "sinatra/json"
require "sinatra/namespace"
require "rack/protection"
require "rack/cors"
require "logger"
require_relative "lib/json_helpers"
require_relative "lib/auth"
require_relative "api_v1"

module RoulotteAPI
  class App < Sinatra::Base
    helpers Sinatra::JSON
    helpers JsonHelpers
    helpers AuthHelpers

    configure do
      set :environment, ENV.fetch("RLT_ENV", "development")
      set :logging, true
      set :show_exceptions, false
      set :raise_errors, false
      set :protection, except: :http_origin

      logger = Logger.new($stdout)
      logger.level = Logger::INFO
      set :logger, logger
    end

    use Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: %i[get post put patch delete options]
      end
    end

    use Rack::Protection

    before do
      content_type :json
    end

    error do
      e = env["sinatra.error"]
      settings.logger.error("[ERROR] #{e.class}: #{e.message}")
      json_error("internal_error", 500, details: e.message)
    end

    not_found do
      json_error("not_found", 404, details: "Route inconnue")
    end

    get "/health" do
      json_ok(
        status: "ok",
        service: "RoulotteAPI",
        env: settings.environment,
        time: Time.now.utc.iso8601
      )
    end

    # API v1 montée ici
    register RoulotteAPI::V1
  end
end

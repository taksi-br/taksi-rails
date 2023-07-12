# frozen_string_literal: true

module Taksi
  class DataController < ::Taksi::ApplicationController
    def index
      return head(404) unless params[:interface_id].match?(::Taksi::Registry::NAME_REGEX)

      interface = ::Taksi::Interface.find(params[:interface_id].to_sym,
                                          request.env['X_TAKSI_VERSION']).new

      render json: {interface_data: interface.data.as_json}
    rescue Taksi::Registry::InterfaceNotFoundError
      head(404)
    end
  end
end

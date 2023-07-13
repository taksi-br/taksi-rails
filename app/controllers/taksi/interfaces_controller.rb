# frozen_string_literal: true

module Taksi
  class InterfacesController < ::Taksi::ApplicationController
    def show
      return head(404) unless params[:id].match?(::Taksi::Registry::NAME_REGEX)

      interface = ::Taksi::Interface.find(params[:id].to_sym,
                                          request.env['X_TAKSI_VERSION']).new(params: parameters)

      render json: interface.skeleton.to_json
    rescue Taksi::Registry::InterfaceNotFoundError
      head(404)
    end

    protected

    def parameters
      params
    end
  end
end

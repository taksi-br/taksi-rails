# frozen_string_literal: true

module Taksi
  class InterfacesController < ::Taksi::ApplicationController
    def show
      interface = ::Taksi::Interface.find(params[:id].to_sym, request.env['X_TAKSI_VERSION']).new

      # response.headers['Link'] = "<#{}>; rel=preload; as=fetch, crossorigin=use-credentials"

      render json: interface.skeleton.to_json
    rescue Taksi::Registry::InterfaceNotFoundError
      head(404)
    end
  end
end

# frozen_string_literal: true

module Taksi
  class SkeletonsController < ::Taksi::ApplicationController
    def show
      screen = ::Taksi::Screen.find(params[:id].to_sym, request.env['X_Taksi_VERSION']).new

      # response.headers['Link'] = "<#{}>; rel=preload; as=fetch, crossorigin=use-credentials"

      render json: screen.skeleton.to_json
    rescue Taksi::Registry::ScreenNotFoundError
      head(404)
    end
  end
end

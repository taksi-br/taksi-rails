# frozen_string_literal: true

module Taksi
  class DataController < ::Taksi::ApplicationController
    def show
      screen = ::Taksi::Screen.find(params[:id].to_sym, request.env['X_Taksi_VERSION']).new

      render json: screen.data.as_json
    rescue Taksi::Registry::ScreenNotFoundError
      head(404)
    end
  end
end

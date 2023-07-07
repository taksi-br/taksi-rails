# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Taksi::DataController, type: :controller do
  render_views

  before do
    self.routes = Taksi::Engine.routes

    request.set_header('X_Taksi_VERSION', '2.1')

    class DummyScreen
      include ::Taksi::Screen.new('dummy-screen', '> 1.0')
    end
  end

  after do
    Object.send(:remove_const, :DummyScreen)
  end

  describe 'GET /data/:id' do
    context 'when screen exists with components' do
      before do
        class DummyWidget
          include ::Taksi::Widget.new('dummy/widget')

          content do
            title Taksi::Dynamic
          end
        end

        class DummyScreen
          add DummyWidget, with: :dummy_data

          def dummy_data
            {title: 'dummy_value'}
          end
        end
      end

      after do
        Object.send(:remove_const, :DummyWidget)
      end

      it 'returns the skeleton json' do
        get :show, params: {id: 'dummy-screen'}

        parsed_json_response = JSON.parse(response.body)

        expect(parsed_json_response).to have_key('widget$0')
        expect(parsed_json_response['widget$0']).to eq({
                                                         'title' => 'dummy_value'
                                                       })
      end
    end

    xcontext 'when screen exists with no components'

    context 'when a page cannot be found' do
      it 'returns the skeleton json' do
        get :show, params: {id: 'unknown-screen'}

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when page version do not exists' do
      before do
        request.set_header('X_Taksi_VERSION', '0.5')
      end

      it 'returns the skeleton json' do
        get :show, params: {id: 'dummy-screen'}

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

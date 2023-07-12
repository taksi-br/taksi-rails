# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Taksi::InterfacesController, type: :controller do
  render_views

  before do
    self.routes = Taksi::Engine.routes

    request.set_header('X_TAKSI_VERSION', '2.1')

    class DummyInterface
      include ::Taksi::Interface.new('dummy-interface', '> 1.0')
    end
  end

  after do
    Object.send(:remove_const, :DummyInterface)
  end

  describe 'GET /interfaces/:id' do
    context 'when interface exists with components' do
      before do
        class DummyComponent
          include ::Taksi::Component.new('dummy/component')

          content do
            field :title, Taksi::Static, 'Static Key Title'
          end
        end

        class DummyInterface
          add DummyComponent
        end
      end

      after do
        Object.send(:remove_const, :DummyComponent)
      end

      it 'returns the skeleton json' do
        get :show, params: {id: 'dummy-interface'}

        parsed_json_response = JSON.parse(response.body)

        expect(parsed_json_response).to have_key('components')
        expect(parsed_json_response['components']).to be_kind_of(Array)
        expect(parsed_json_response['components'].size).to eq(1)
        expect(parsed_json_response['components'].first).to eq({
                                                                 'name' => 'dummy/component',
                                                                 'identifier' => 'component$0',
                                                                 'requires_data' => false,
                                                                 'content' => {
                                                                   'title' => 'Static Key Title'
                                                                 }
                                                               })
      end
    end

    xcontext 'when interface exists with no components'

    context 'when interface name is invalid' do
      it 'fails with HTTP 404' do
        get :show, params: {id: 'invalid.interface%name'}

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when a interface cannot be found' do
      it 'returns the skeleton json' do
        get :show, params: {id: 'unknown-interface'}

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when interface version do not exists' do
      before do
        request.set_header('X_TAKSI_VERSION', '0.5')
      end

      it 'returns the skeleton json' do
        get :show, params: {id: 'dummy-interface'}

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

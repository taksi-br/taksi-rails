# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Taksi::DataController, type: :controller do
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

  describe 'GET /interface/:id/data' do
    context 'when interface exists with components' do
      before do
        class DummyComponent
          include ::Taksi::Component.new('dummy/component')

          content do
            field :title, Taksi::Static, 'dummy_value'
          end
        end

        class DummyInterface
          add DummyComponent, with: :nothing

          def nothing
            nil
          end
        end
      end

      after do
        Object.send(:remove_const, :DummyComponent)
      end

      it 'returns the skeleton json' do
        get :index, params: {interface_id: 'dummy-interface'}

        parsed_json_response = JSON.parse(response.body)

        expect(parsed_json_response).to have_key('interface_data')
        expect(parsed_json_response['interface_data']).to include({
                                                                    'identifier' => 'component$0',
                                                                    'content' => {
                                                                      'title' => 'dummy_value'
                                                                    }
                                                                  })
      end
    end

    context 'when interface has dynamic components' do
      before do
        class DummyComponent
          include ::Taksi::Component.new('dummy/component')

          content do
            field :title, Taksi::Dynamic
            field :custom_content, Taksi::Dynamic
          end
        end

        class DummyInterface
          add DummyComponent, with: :dummy_data

          def dummy_data
            {
              title: 'dummy_value',
              custom_content: options[:params].require(:custom_content)
            }
          end
        end
      end

      after do
        Object.send(:remove_const, :DummyComponent)
      end

      it 'returns the skeleton json' do
        get :index, params: {interface_id: 'dummy-interface', custom_content: 'custom_content_from_query_param'}

        parsed_json_response = JSON.parse(response.body)

        expect(parsed_json_response).to have_key('interface_data')
        expect(parsed_json_response['interface_data']).to include({
                                                                    'identifier' => 'component$0',
                                                                    'content' => {
                                                                      'title' => 'dummy_value',
                                                                      'custom_content' => 'custom_content_from_query_param'
                                                                    }
                                                                  })
      end
    end

    xcontext 'when interface exists with no components'

    context 'when interface name is invalid' do
      it 'fails with HTTP 404' do
        get :index, params: {interface_id: 'invalid.interface%name'}

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when a interface cannot be found' do
      it 'returns the skeleton json' do
        get :index, params: {interface_id: 'unknown-interface'}

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when interface version do not exists' do
      before do
        request.set_header('X_TAKSI_VERSION', '0.5')
      end

      it 'returns the skeleton json' do
        get :index, params: {interface_id: 'dummy-interface'}

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

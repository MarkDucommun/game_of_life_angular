require 'spec_helper'

describe AngularController do
  context 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template :index
    end
  end
end

require 'rails_helper'

describe TagsController do
  before :each do
    user = create(:user)
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'populate an array of all tags' do
      tag1 = create(:tag, name: 'Pedas')
      tag2 = create(:tag, name: 'Lokal')
      get :index
      expect(assigns(:tags)).to match_array([tag1, tag2])
    end

    it 'renders the :index tempalate' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested tag to @tag' do
      tag = create(:tag)
      get :show, params: { id: tag }
      expect(assigns(:tag)).to eq tag
    end

    it 'renders the :show template' do
      tag = create(:tag)
      get :show, params: { id: tag }
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
		it 'assign the new tag to @tag' do
			get :new
			expect(assigns(:tag)).to be_a_new(Tag)
		end

		it 'renders the :new template' do
			get :new
			expect(response).to render_template :new
		end
	end

  describe 'GET #edit' do
		it 'assign the requested tag to @tag' do
			tag = create(:tag)
			get :edit, params: { id: tag }
			expect(assigns(:tag)).to eq tag
		end
		it 'renders the :edit template' do
			tag = create(:tag)
			get :edit, params: { id: tag }
			expect(response).to render_template :edit
		end
	end

  describe 'POST #create' do
		context 'with valid attributes' do
			it 'saves the new tags in the database' do
				expect{
					post :create, params: { tag: attributes_for(:tag) }
				}.to change(Tag, :count).by(1)
			end

			it 'redirects to tag#show' do
				post :create, params: { tag: attributes_for(:tag) }
				expect(response).to redirect_to(tag_path(assigns(:tag)))
			end
		end

		context 'with invalid attributes' do
			it 'does not save the new tag in the database' do
				expect{
					post :create, params: { tag: attributes_for(:invalid_tag) }
				}.not_to change(Tag, :count)
			end

			it 're-renders the :new template' do
				post :create, params: { tag: attributes_for(:invalid_tag) }
				expect(response).to render_template :new
			end
		end
	end

  describe 'PATCH #update' do
    before :each do
			@tag = create(:tag)
		end

		context 'with valid attributes' do
			it 'locates the requested @food' do
				patch :update, params: {id:@tag, tag: attributes_for(:tag) }
				expect(assigns(:tag)).to eq @tag
			end

			it "changes @tag's attributes" do
				patch :update, params: { id: @tag, tag: attributes_for(:tag, name: 'Pedas') }
				@tag.reload
				expect(@tag.name).to eq('Pedas')
			end

			it 'redirect to the tag#index' do
				patch :update, params: { id: @tag, tag: attributes_for(:tag) }
				expect(response).to redirect_to @tag
			end
		end

    context 'with invalid' do
			it "does not update the food in the database" do
        patch :update, params: { id: @tag, tag: attributes_for(:tag, name: 'Pedass') }
        @tag.reload
        expect(@tag.name).not_to eq('Pedas')
      end

			it 're-renders the :edit template' do
				patch :update, params: { id: @tag, tag: attributes_for(:invalid_tag) }
				expect(response).to render_template :edit
			end
		end
  end

  describe 'DELETE #destroy' do
		before :each do
      @tag = create(:tag)
    end

		it "deletes the tag from the database" do
      expect{
        delete :destroy, params: { id: @tag }
      }.to change(Tag, :count).by(-1)
    end

		it 'redirects to tag#show' do
			delete :destroy, params: { id: @tag }
			expect(response).to redirect_to tags_path
		end
	end
end

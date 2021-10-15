require 'rails_helper'
require 'monkey_patch'
# require 'movies'

describe MoviesController do 
    fixtures :movies
    describe 'Looking for movies with same director' do
        it 'should not find movies - sad path' do 
            expect(Movie).to receive(:same_director_movies).with("1").and_return([])
            get :same_director, id: 1
            response.response_code.should == 302
            expect(response).to redirect_to movies_path
        end
        it 'should find movies - happy path' do 
            expect(Movie).to receive(:same_director_movies).with("3").and_return([movies(:jannat_3), movies(:jannat_4)])
            get :same_director, id: 3
            response.response_code.should == 200
        end
    end
    
    describe 'Testing create method' do
        it 'should create movie' do
            expect(Movie).to receive(:create!).with({'title':'jannat_4', 'director':'test'}).and_return(movies(:jannat_4))
            post :create, {:movie => {'title':'jannat_4', 'director':'test'}}
            expect(flash[:notice]).to match (/was successfully created./)
        end
    end
    
    describe 'Testing update method' do
        it 'should update movie' do
            expect(Movie).to receive(:find).with(movies(:jannat_4).id.to_s).and_return(movies(:jannat_4))
            expect(movies(:jannat_4)).to receive(:update_attributes!).with({'title':'jannat_4', 'director':'test'}).and_return(movies(:jannat_4))
            put :update, {:id => movies(:jannat_4).id, :movie => {'title':'jannat_4', 'director':'test'}}
            expect(flash[:notice]).to match (/was successfully updated./)
        end
    end
    
    describe 'Testing edit method' do
        it 'should edit movie' do
            expect(Movie).to receive(:find).with(movies(:jannat_4).id.to_s).and_return(movies(:jannat_4))
            get :edit, id: movies(:jannat_4).id
            response.response_code.should == 200
        end
    end
    
    describe 'Testing show method' do
        it 'should show movie' do
            expect(Movie).to receive(:find).with(movies(:jannat_4).id.to_s).and_return(movies(:jannat_4))
            get :show, id: movies(:jannat_4).id
            response.response_code.should == 200
            expect(response).to render_template("movies/show")
        end
    end
    
    describe 'Testing destroy method' do
        it 'should destroy movie' do
            expect(Movie).to receive(:find).with(movies(:jannat_4).id.to_s).and_return(movies(:jannat_4))
            expect(movies(:jannat_4)).to receive(:destroy)
            delete :destroy, id: movies(:jannat_4).id
            expect(flash[:notice]).to match (/Movie 'jannat_4' deleted/)
            response.response_code.should == 302
        end
    end
    
    describe 'Testing new method' do
        it 'should open page for new movie' do
            get :new
            response.response_code.should == 200
        end
    end
    
    describe 'Testing index method' do
        it 'should get movies' do
            expect(Movie).to receive(:all).and_return([movies(:jannat_3), movies(:jannat_4)])
            get :index
            response.response_code.should == 200
        end
    end
    
end
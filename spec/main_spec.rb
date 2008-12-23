require 'sinatra'
require 'sinatra/test/rspec'
require '6-month-me'


describe 'Main' do
  
  it 'should show a default page' do
    get_it '/'
    @response.should be_ok
    @response.body.should == 'My Default Page!'
  end



end

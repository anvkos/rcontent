require './spec/feature_spec_helper'
require './app/services/update_page_service'
require 'faker'

RSpec.describe UpdatePageService do
  describe '#call' do
    it 'updated page with update_at date' do
      page = FactoryGirl.build(:page, id: rand(1..1000))
      DB.connection[:pages].insert(id: page.id, title: page.title, created_at: Time.now)
      service = UpdatePageService.new
      page = service.call(id: page.id, title: 'update title')
      updated_page = DB.connection[:pages].where(id: page.id).first
      expect(updated_page[:title]).to eq page.title
      expect(updated_page[:updated_at].to_i).to eq page.updated_at.to_i
    end
  end
end

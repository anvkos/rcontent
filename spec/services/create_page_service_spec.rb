require './spec/feature_spec_helper'
require './app/services/create_page_service'
require 'faker'

RSpec.describe CreatePageService do
  describe '#call' do
    it 'create page with created_at date' do
      page = FactoryGirl.build(:page)
      count = DB.connection[:pages].count
      service = CreatePageService.new
      page = service.call(title: page.title)
      new_count = DB.connection[:pages].count
      created_page = DB.connection[:pages].where(id: page.id).first
      expect(new_count).to eq count + 1
      expect(created_page[:title]).to eq page.title
      expect(created_page[:created_at].to_i).to eq page.created_at.to_i
    end
  end
end

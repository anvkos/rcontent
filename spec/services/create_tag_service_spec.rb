require './spec/feature_spec_helper'
require './app/services/create_tag_service'
require 'faker'

RSpec.describe CreateTagService do
  describe '#call' do
    it 'create tag with created_at date' do
      tag = FactoryGirl.build(:tag)
      count = DB.connection[:tags].count
      service = CreateTagService.new
      tag = service.call(name: tag.name)
      new_count = DB.connection[:tags].count
      created_tag = DB.connection[:tags].where(id: tag.id).first
      expect(new_count).to eq count + 1
      expect(created_tag[:name]).to eq tag.name
      expect(created_tag[:created_at].to_i).to eq tag.created_at.to_i
    end
  end
end

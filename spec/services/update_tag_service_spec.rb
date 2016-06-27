require './spec/feature_spec_helper'
require './app/services/update_tag_service'
require 'faker'

RSpec.describe UpdateTagService do
  describe '#call' do
    it 'updated tag' do
      tag = FactoryGirl.build(:tag, id: rand(1..1000))
      DB.connection[:tags].insert(id: tag.id, name: tag.name, created_at: Time.now)
      service = UpdateTagService.new
      tag = service.call(id: tag.id, name: 'update name tag')
      updated_tag = DB.connection[:tags].where(id: tag.id).first
      expect(updated_tag[:name]).to eq tag.name
      expect(updated_tag[:updated_at].to_i).to eq tag.updated_at.to_i
    end
  end
end

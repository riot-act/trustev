require_relative 'test_helper'

describe Trustev::Item do
  before do
    trustev_case = build_case
    @case_id = trustev_case.create[:Id]
    @item = build_item case_id: @case_id
  end

  describe 'when creating an item' do
    it 'must return a valid response' do
      create_case_attribute @item
    end
  end

  describe 'when updating an item' do
    it 'must return a valid response' do
      update_case_attribute @item, self.method(:build_item), @case_id, { name: Faker::Commerce.product_name }
    end
  end

  describe 'when retrieving an item' do
    it 'must return a valid response' do
      retrieve_case_attribute @item, Trustev::Item, @case_id
    end
  end

  describe 'when retrieving all items' do
    it 'must return a valid response' do
      retrieve_all_case_attribute Trustev::Item, @case_id
    end
  end
end

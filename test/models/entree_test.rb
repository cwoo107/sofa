require_relative '../test_helper'

class EntreeTest < ActiveSupport::TestCase

  def test_fixtures_validity
    Entree.all.each do |entree|
      assert entree.valid?, entree.errors.inspect
    end
  end

  def test_validation
    entree = Entree.new
    assert entree.invalid?
    assert_equal [:name, :category, :price, :description, :available], entree.errors.keys
  end

  def test_creation
    assert_difference 'Entree.count' do
      Entree.create(
        name: 'test name',
        category: 'test category',
        price: 'test price',
        description: 'test description',
        available: 'test available',
      )
    end
  end
end

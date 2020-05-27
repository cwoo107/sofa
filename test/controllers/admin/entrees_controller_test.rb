require_relative '../../test_helper'

class Admin::EntreesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @entree = entrees(:default)
  end

  # Vanilla CMS has BasicAuth, so we need to send that with each request.
  # Change this to fit your app's authentication strategy.
  # Move this to test_helper.rb
  def r(verb, path, options = {})
    headers = options[:headers] || {}
    headers['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials(
        ComfortableMexicanSofa::AccessControl::AdminAuthentication.username,
        ComfortableMexicanSofa::AccessControl::AdminAuthentication.password
      )
    options.merge!(headers: headers)
    send(verb, path, options)
  end

  def test_get_index
    r :get, admin_entrees_path
    assert_response :success
    assert assigns(:entrees)
    assert_template :index
  end

  def test_get_show
    r :get, admin_entree_path(@entree)
    assert_response :success
    assert assigns(:entree)
    assert_template :show
  end

  def test_get_show_failure
    r :get, admin_entree_path('invalid')
    assert_response :redirect
    assert_redirected_to action: :index
    assert_equal 'Entree not found', flash[:danger]
  end

  def test_get_new
    r :get, new_admin_entree_path
    assert_response :success
    assert assigns(:entree)
    assert_template :new
    assert_select "form[action='/admin/entrees']"
  end

  def test_get_edit
    r :get, edit_admin_entree_path(@entree)
    assert_response :success
    assert assigns(:entree)
    assert_template :edit
    assert_select "form[action='/admin/entrees/#{@entree.id}']"
  end

  def test_creation
    assert_difference 'Entree.count' do
      r :post, admin_entrees_path, params: {entree: {
        name: 'test name',
        category: 'test category',
        price: 'test price',
        description: 'test description',
        available: 'test available',
      }}
      entree = Entree.last
      assert_response :redirect
      assert_redirected_to action: :show, id: entree
      assert_equal 'Entree created', flash[:success]
    end
  end

  def test_creation_failure
    assert_no_difference 'Entree.count' do
      r :post, admin_entrees_path, params: {entree: { }}
      assert_response :success
      assert_template :new
      assert_equal 'Failed to create Entree', flash[:danger]
    end
  end

  def test_update
    r :put, admin_entree_path(@entree), params: {entree: {
      name: 'Updated'
    }}
    assert_response :redirect
    assert_redirected_to action: :show, id: @entree
    assert_equal 'Entree updated', flash[:success]
    @entree.reload
    assert_equal 'Updated', @entree.name
  end

  def test_update_failure
    r :put, admin_entree_path(@entree), params: {entree: {
      name: ''
    }}
    assert_response :success
    assert_template :edit
    assert_equal 'Failed to update Entree', flash[:danger]
    @entree.reload
    refute_equal '', @entree.name
  end

  def test_destroy
    assert_difference 'Entree.count', -1 do
      r :delete, admin_entree_path(@entree)
      assert_response :redirect
      assert_redirected_to action: :index
      assert_equal 'Entree deleted', flash[:success]
    end
  end
end

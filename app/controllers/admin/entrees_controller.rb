class Admin::EntreesController < Comfy::Admin::BaseController

  before_action :build_entree,  only: [:new, :create]
  before_action :load_entree,   only: [:show, :edit, :update, :destroy]

  def index
    @entrees = Entree.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @entree.save!
    flash[:success] = 'Entree created'
    redirect_to action: :show, id: @entree
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to create Entree'
    render action: :new
  end

  def update
    @entree.update!(entree_params)
    flash[:success] = 'Entree updated'
    redirect_to action: :show, id: @entree
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = 'Failed to update Entree'
    render action: :edit
  end

  def destroy
    @entree.destroy
    flash[:success] = 'Entree deleted'
    redirect_to action: :index
  end

protected

  def build_entree
    @entree = Entree.new(entree_params)
  end

  def load_entree
    @entree = Entree.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Entree not found'
    redirect_to action: :index
  end

  def entree_params
    params.fetch(:entree, {}).permit(:name, :category, :price, :description, :available)
  end
end

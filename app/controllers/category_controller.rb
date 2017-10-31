class CategoryController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def show
  end

  def edit
  end

  def create
  end

  def upadet
  end

  def destroy
  end

  private
    # use callcacks to share common setup or cintraints between actions
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end

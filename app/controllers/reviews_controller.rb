class ReviewsController < ApplicationController
  before_action :load_reviewable
  skip_before_action :authorize

  def index
    @reviews = Review.all
    # @reviews = Review.where(reviewable_id: @reviewable.id)
  end

  def new
    @review = Review.new
  end

  def create
    # @review = Review.new(review_params)
    @review = @reviewable.reviews.new(review_params) # equivalent what's written on new

    respond_to do |format|
      if @review.save
        format.html { redirect_to @reviewable, notice: "Review was successfully created" }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /reviews/1
  # # DELETE /reviews/1.json
  # def destroy
  #   @review.destroy
  #   respond_to do |format|
  #     if @review.destroy
  #       format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to reviews_path, notice: 'Review is in use. Cannot be destroyed.' }
  #       format.json { head :no_content }
  #     end
  #   end
  # end

  private
    def load_reviewable
      if params[:food_id]
        @reviewable = Food.find_by(id: params[:food_id])
      elsif params[:restaurant_id]
        @reviewable = Restaurant.find_by(id: params[:restaurant_id])
      end
    end

    def review_params
      params.require(:review).permit(:name, :title, :description, :reviewable_id, :reviewable_type)
    end
end

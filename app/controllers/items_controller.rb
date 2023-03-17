class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
rescue_from ActiveRecord::RecordInvalid, with: :invalid

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
    items = Item.all
    end
    render json: items, include: :user, status: :ok
  end

  def show
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      item = items.find(params[:id])
    else 
      item = Item.find(params[:id])
    end
    render json: item, status: :ok
  end



  def create
    
      user = User.find(params[:user_id])
    
     item = user.items.create!(review_params)
     render json: item, status: :created
  end

  private 
  
  def review_params
    params.permit(:name, :description, :price)
  end

  def render_not_found_response
    render json: {error: "User not found"}, status: :not_found
  end

  def invalid
    render json: {error: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end
 

end

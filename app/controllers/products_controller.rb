class ProductsController < ApplicationController
  before_action :authenticate!

  def listing
    if !current_user.admin?
      flash[:minha_mensagem] = "No permission for you! 🤪"
      redirect_to root_path
    end

    @products = Product.includes(:store)
  end
end

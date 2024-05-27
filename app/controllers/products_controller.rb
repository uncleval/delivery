class ProductsController < ApplicationController
  before_action :authenticate!
  before_action :set_locale!

  def listing
    if !current_user.admin?
      flash[:minha_mensagem] = "No permission for you! 🤪"
      redirect_to root_path
    end

    @products = Product.includes(:store)
  end

  def index
    respond_to do |format|
      format.json do
        paginated_products if buyer?
      end
    end
  end

  private

  def paginated_products
    # @has_pagination = params.fetch(:page, false)
    # page = @has_pagination ? @has_pagination : 1
    page = params.fetch(:page, 1)

    @products = Product.
      where(store_id: params[:store_id]).
      order(:title).
      page(page)
  end
end

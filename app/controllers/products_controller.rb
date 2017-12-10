# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.categorizations.build
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(create_product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(update_product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def public_view
    # @cats = []
    # Category.where(parent_id: nil).where(product_exists: true).each do |cat|
    #   @cats << cat
    #   cat.sub_categories.where(product_exists: true).each do |sub_cat|
    #     @cats << sub_cat
    #     sub_cat.sub_categories.where(product_exists: true).each do |sub_sub_cat|
    #       @cats << sub_sub_cat
    #     end
    #   end
    # end

    if params[:category_id].present? && params[:category_id].match(/\A\d+\z/)
      @categorizations = Categorization.where(search_params)
      @products = @categorizations.map{|c| c.product}.uniq
    else
      @products = Product.all
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_product_params
      params.require(:product).permit(:name, :description, :price, :image, categorizations_attributes: [:sub_sub_category_id, :_destroy])
    end

    def update_product_params
      params.require(:product).permit(:name, :description, :price, :image, categorizations_attributes: [:id, :sub_sub_category_id, :_destroy])
    end

    def search_params
      params.permit(:category_id, :sub_category_id, :sub_sub_category_id).delete_if {|key, value| value.blank?}
    end
end

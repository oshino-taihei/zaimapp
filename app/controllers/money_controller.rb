class MoneyController < ApplicationController
  before_action :set_money, only: [:show, :edit, :update, :destroy]

  def index
    @q = Money.ransack(params[:q])
    @money = @q.result.includes(:category, :genre, :from_account)
  end

  def show
  end

  def new
    @money = Money.new
  end

  def edit
  end

  def create
    @money = Money.new(money_params)

    respond_to do |format|
      if @money.save
        format.html { redirect_to @money, notice: 'Money was successfully created.' }
        format.json { render :show, status: :created, location: @money }
      else
        format.html { render :new }
        format.json { render json: @money.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @money.update(money_params)
        format.html { redirect_to @money, notice: 'Money was successfully updated.' }
        format.json { render :show, status: :ok, location: @money }
      else
        format.html { render :edit }
        format.json { render json: @money.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @money.destroy
    respond_to do |format|
      format.html { redirect_to money_index_url, notice: 'Money was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_money
      @money = Money.find(params[:id])
    end

    def money_params
      params[:money]
    end
end

class DataViewController < ApplicationController
  def viz
    @categories = Category.payments.order(:sort)
  end

  def month
    money = Money.payments
    money = money.from_date(params[:from_date])
    money = money.to_date(params[:to_date])
    money = money.categories(params[:zaim_category_ids])

    months = money.months
    months = months.map { |e| e.month }
    @label = months.map.with_index { |month,i| [i, month] }

    category_money = money.includes(:category).group('categories.name').group('substr(date, 1, 7)').order(:zaim_category_id, 'substr_date_1_7').sum(:amount)
    @data = Hash.new
    category_money.each do |k,v|
      category = k[0]
      month = k[1]
      amount = v
      @data[category] ||= []
      @data[category] << [month_to_label(month), amount]
    end
  end

  def month_genre
    money = Money.payments
    money = money.from_date(params[:from_date])
    money = money.to_date(params[:to_date])
    money = money.where(zaim_category_id: params[:zaim_category_id]) if params[:zaim_category_id]

    months = money.months
    months = months.map { |e| e.month }
    @label = months.map.with_index { |month,i| [i, month] }

    genre_money = money.includes(:genre).group('genres.name').group('substr(date, 1, 7)').order(:zaim_genre_id, 'substr_date_1_7').sum(:amount)
    @data = Hash.new
    genre_money.each do |k,v|
      genre = k[0]
      month = k[1]
      amount = v
      @data[genre] ||= []
      @data[genre] << [month_to_label(month), amount]
    end
    render :month
  end

  private

  def month_to_label(month)
    @label.each do |label|
      return label[0] if label[1] == month
    end
  end
end

class DataViewController < ApplicationController
  def viz
    @q = Money.ransack(params[:q])
    @money = @q.result.includes(:category, :genre, :from_account)
  end

  def month
    money = Money.where('zaim_from_account_id <> "0"') # 支出のみ
    if params[:from_date]
      begin
        from_date = Date.civil(params[:from_date]['date(1i)'].to_i, params[:from_date]['date(2i)'].to_i, params[:from_date]['date(3i)'].to_i)
        money.where!('? <= date', from_date)
      rescue
      end
    end
    if params[:to_date]
      begin
        to_date = Date.civil(params[:to_date]['date(1i)'].to_i, params[:to_date]['date(2i)'].to_i, params[:to_date]['date(3i)'].to_i)
        money.where!('date <= ?', to_date)
      rescue
      end
    end

    months = money.select('substr(date, 1, 7) as month').distinct.order(1)
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

    total_amount_money = Money.where('zaim_from_account_id <> "0" and date < "2016-01-01"').group('substr(date, 1, 7)').order('substr_date_1_7').sum(:amount)
    total = Hash.new
    total_amount_money.each do |k,v|
      label = month_to_label(k)
      amount = v
      if total[label]
        total[label] += amount
      else
        total[label] = amount
      end
    end
    @total = total.map { |k| k }
  end

  private

  def month_to_label(month)
    @label.each do |label|
      return label[0] if label[1] == month
    end
  end
end

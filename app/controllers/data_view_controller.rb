class DataViewController < ApplicationController
  def month
    months = Money.where('zaim_from_account_id <> "0" and date < "2016-01-01"').select('substr(date, 1, 7) as month').distinct.order(1)
    months = months.map { |e| e.month }
    @label = months.map.with_index { |month,i| [i, month] }

    category_money = Money.includes(:category).where('zaim_from_account_id <> "0" and date < "2016-01-01"').group('categories.name').group('substr(date, 1, 7)').order(:zaim_category_id, 'substr_date_1_7').sum(:amount)
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

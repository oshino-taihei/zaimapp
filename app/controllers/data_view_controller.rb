class DataViewController < ApplicationController
  def month
    money = Money.group('substr(date, 1, 7)').group(:zaim_category_id).group(:zaim_genre_id).having('substr(date, 1, 7) = "2015-09"').order(amount: :desc).sum(:amount)
    @data = money.map do |k,v|
      {month: k[0], category: k[1], genre: k[2], amount: v}
    end
  end
end

class Money < ActiveRecord::Base
  validates :zaim_id,
    uniqueness: true

  belongs_to :category, foreign_key: :zaim_category_id, primary_key: :zaim_id
  belongs_to :genre, foreign_key: :zaim_genre_id, primary_key: :zaim_id
  belongs_to :from_account, class_name: :Account, foreign_key: :zaim_from_account_id, primary_key: :zaim_id
  belongs_to :to_account, class_name: :Account, foreign_key: :zaim_to_account_id, primary_key: :zaim_id

  scope :payments, -> {
    where('zaim_from_account_id <> "0"')
  }
  scope :incomes, -> {
    where('zaim_to_account_id <> "0"')
  }
  scope :from_date, ->(from_date) {
    where('? <= date', from_date) if from_date && !from_date.empty?
  }
  scope :to_date, ->(to_date) {
    where('date <= ?', to_date) if to_date && !to_date.empty?
  }
  scope :categories, ->(params_zaim_category_ids) {
    where(zaim_category_id: params_zaim_category_ids.keys.to_a) if params_zaim_category_ids
  }
  scope :months, -> {
    select('substr(date, 1, 7) as month').distinct.order(1)
  }

  NO_DATA = "-"

  def category_name
    category ? category.name : NO_DATA
  end

  def genre_name
    genre ? genre.name : NO_DATA
  end

  def from_account_name
    from_account ? from_account.name : NO_DATA
  end

  # Zaim APIが返すJSONをMoneyモデルのHashに変換する
  def self.fix_zaim_param(zaim_param)
    {
      zaim_id: zaim_param["id"],
      zaim_user_id: zaim_param["user_id"],
      date: Date.parse(zaim_param["date"]),
      mode: zaim_param["mode"],
      zaim_genre_id: zaim_param["genre_id"],
      zaim_category_id: zaim_param["category_id"],
      zaim_from_account_id: zaim_param["from_account_id"],
      zaim_to_account_id: zaim_param["to_account_id"],
      amount: zaim_param["amount"],
      comment: zaim_param["comment"],
      active: zaim_param["active"],
      created: Date.parse(zaim_param["created"]),
      currency_code: zaim_param["currency_code"],
      name: zaim_param["name"],
      zaim_receipt_id: zaim_param["receipt_id"],
      zaim_place_uid: zaim_param["place_uid"],
      place: zaim_param["place"]
    }
  end

  private

  def self.convert_date(params_date)
    begin
      year = params_date['date(1i)'] ? params_date['date(1i)'].to_i : Date.today.year
      month = params_date['date(2i)'] ? params_date['date(2i)'].to_i : 1
      day = params_date['date(3i)'] ? params_date['date(3i)'].to_i : 1
      Date.civil(year, month, day)
    rescue
      nil
    end
  end
end

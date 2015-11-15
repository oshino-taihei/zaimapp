class Money < ActiveRecord::Base
  validates :zaim_id,
    uniqueness: true

  belongs_to :category, foreign_key: :zaim_category_id, primary_key: :zaim_id
  belongs_to :genre, foreign_key: :zaim_genre_id, primary_key: :zaim_id
  belongs_to :from_account, class_name: :Account, foreign_key: :zaim_from_account_id, primary_key: :zaim_id
  belongs_to :to_account, class_name: :Account, foreign_key: :zaim_to_account_id, primary_key: :zaim_id

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
end

class Category < ActiveRecord::Base
  validates :zaim_id,
    uniqueness: true

  has_many :money, foreign_key: :zaim_genre_id, primary_key: :zaim_id

  scope :payments, -> {
    where(mode: 'payment')
  }
  scope :incomes, -> {
    where(mode: 'income')
  }


  # Zaim APIが返すJSONをCategoryモデルのHashに変換する
  def self.fix_zaim_param(zaim_param)
    {
      zaim_id: zaim_param["id"],
      name: zaim_param["name"],
      sort: zaim_param["sort"],
      active: zaim_param["active"],
      modified: Date.parse(zaim_param["modified"]),
      zaim_parent_category_id: zaim_param["parent_category_id"],
      zaim_local_id: zaim_param["local_id"]
    }
  end
end

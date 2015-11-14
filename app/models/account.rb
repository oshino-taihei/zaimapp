class Account < ActiveRecord::Base
  validates :zaim_id,
    uniqueness: true

  has_many :from_account_money, class_name: :Money, foreign_key: :zaim_from_account_id, primary_key: :zaim_id
  has_many :to_account_money, class_name: :Money, foreign_key: :zaim_to_account_id, primary_key: :zaim_id

  # Zaim APIが返すJSONをAccountモデルのHashに変換する
  def self.fix_zaim_param(zaim_param)
    {
      zaim_id: zaim_param["id"],
      name: zaim_param["name"],
      sort: zaim_param["sort"],
      active: zaim_param["active"],
      modified: Date.parse(zaim_param["modified"]),
      zaim_parent_account_id: zaim_param["parent_account_id"],
      zaim_local_id: zaim_param["local_id"]
    }
  end
end

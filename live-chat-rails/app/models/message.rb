class Message < ApplicationRecord
  # 1つのレコードに所属させる
  belongs_to :user
  has_many :likes
  validates :content, presence: true
end

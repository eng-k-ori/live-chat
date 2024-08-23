class Message < ApplicationRecord
  # 1つのレコードに所属させる
  belongs_to :user
  validates :content, presence: true
end

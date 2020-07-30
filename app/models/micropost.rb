class Micropost < ApplicationRecord
  MICROPOSTS_PARAMS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {
    maximum: Settings.microposts.maximum
  }
  validates :image,
    content_type: {in: Settings.microposts.type,
      message: I18n.t("microposts.valid_image"),
        size: {less_than: Settings.microposts.less.megabytes,
          message: I18n.t("microposts.less_than")}}

  delegate :name, to: :user, prefix: :user
  scope :recent_posts, ->{order created_at: :desc}

  def display_image
    image.variant(resize_to_limit: [Settings.micropost.width,
      Settings.micropost.height])
  end
end

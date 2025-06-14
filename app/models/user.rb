class User < ApplicationRecord
  has_many :campaigns, dependent: :destroy
  has_many :swipe_files, dependent: :destroy
  has_many :background_jobs, through: :campaigns

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid
    end
  end

  def full_name
    name
  end
end

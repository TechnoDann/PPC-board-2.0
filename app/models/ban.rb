class Ban < ApplicationRecord
  belongs_to :user, :optional => true

  validates :length, :reason, :presence => true

  def self.find_ban(conditions)
    ban = self.where(conditions).first
    # < is "is earlier in time than"
    if ban && ban.length != 0 && (ban.created_at + ban.length.seconds) < Time.now
      ban.destroy
      ban = nil
    end
    ban
  end
end

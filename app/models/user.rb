class User < ActiveRecord::Base
  attr_accessible :username, :photo_url

  validates_presence_of :username, :status
  has_many :statistics

  def to_param
    username
  end

  def build_stats!(access_token)
    if status != "done"
      self.status = "building"
      save!
    end
    # Statistic.get_total_length_for_user(self, access_token)
    # Statistic.get_most_common_pattern_type_for_user(self, access_token)
    # Statistic.get_favorite_brands(self, access_token)
    # Statistic.get_favorite_weight(self, access_token)
    Statistic.build_stats(self, access_token)
    self.status = "done"
    save!
  end

  def pending?
    status == "building"
  end

  def building?
    status == "building"
  end
end

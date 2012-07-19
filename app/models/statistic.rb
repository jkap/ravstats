class Statistic < ActiveRecord::Base
  attr_accessible :statistic_type, :statistic_value, :user
  belongs_to :user

  def self.get_total_length_for_user(user, access_token)
    @total_yards_stat = user.statistics.find_by_statistic_type("total_yards")
    if @total_yards_stat.nil? || Time.now - 1.day > @total_yards_stat.updated_at
      projects_json = JSON.parse(access_token.get("/projects/#{user.username}/list.json").body)
      total_yards = 0
      projects_json["projects"].each do |project|
        project_json = JSON.parse(access_token.get("/projects/#{user.username}/#{project['id']}.json").body)
        project_json["project"]["packs"].each do |pack|
          total_yards += pack["total_yards"] unless pack["total_yards"].nil?
        end
      end
      if @total_yards_stat.nil?
        user.statistics.create!(statistic_type: "total_yards", statistic_value: total_yards)
      else
        @total_yards_stat.statistic_value = total_yards
        @total_yards_stat.save!
      end
    end
  end

  def self.get_most_common_pattern_type_for_user(user, access_token)
    @statistic = user.statistics.find_by_statistic_type("most_common_pattern_types")
    if @statistic.nil? || Time.now - 1.day > @statistic.updated_at
      projects_json = JSON.parse(access_token.get("/projects/#{user.username}/list.json").body)
      types = {}
      projects_json["projects"].each do |project|
        unless project['pattern_id'].nil?
          pattern_json = JSON.parse(access_token.get("/patterns/#{project['pattern_id']}.json").body)
          type = pattern_json["pattern"]["pattern_type"]["name"]
          if types[type].nil?
            types[type] = 1
          else
            types[type] += 1
          end
        end
      end
      types = types.sort_by{|k,v|v}.reverse
      if @statistic.nil?
        user.statistics.create!(statistic_type: "most_common_pattern_types", statistic_value: types)
      else
        @statistic.statistic_value = types
        @statistic.save!
      end
    end
  end

  def self.get_favorite_brands(user, access_token)
    @statistic = user.statistics.find_by_statistic_type("favorite_brands")
    if @statistic.nil? || Time.now - 1.day > @statistic.updated_at
      projects_json = JSON.parse(access_token.get("/projects/#{user.username}/list.json").body)
      brands = {}
      projects_json["projects"].each do |project|
        project_json = JSON.parse(access_token.get("/projects/#{user.username}/#{project['id']}.json").body)
        project_json["project"]["packs"].each do |pack|
          unless pack["yarn"].nil?
            brand = pack["yarn"]["yarn_company_name"]
            if brands[brand].nil?
              brands[brand] = 1
            else
              brands[brand] += 1
            end
          end
        end
      end
      brands = brands.sort_by{|k,v|v}.reverse
      if @statistic.nil?
        user.statistics.create!(statistic_type: "favorite_brands", statistic_value: brands)
      else
        @statistic.statistic_value = brands
        @Statistic.save!
      end
    end
  end

  def self.get_favorite_weight(user, access_token)
    @statistic = user.statistics.find_by_statistic_type("favorite_weight")
    if @statistic.nil? || Time.now - 1.day > @statistic.updated_at
      projects_json = JSON.parse(access_token.get("/projects/#{user.username}/list.json").body)
      weights = {}
      projects_json["projects"].each do |project|
        project_json = JSON.parse(access_token.get("/projects/#{user.username}/#{project['id']}.json").body)
        project_json["project"]["packs"].each do |pack|
          unless pack["yarn_weight"].nil?
            weight = pack["yarn_weight"]["name"]
            if weights[weight].nil?
              weights[weight] = 1
            else
              weights[weight] += 1
            end
          end
        end
      end
      weights = weights.sort_by{|k,v|v}.reverse
      if @statistic.nil?
        user.statistics.create!(statistic_type: "favorite_weight", statistic_value: weights)
      else
        @statistic.statistic_value = brands
        @Statistic.save!
      end
    end
  end

end

class PeopleController < ApplicationController

  before_filter :require_access

  def show
    username = params[:id]
    @user = User.find_by_username(username)
    if @user.nil?
      build_user(username)
      render 'pending' and return
    elsif @user.pending?
      @user.delay.build_stats! access_token
      render 'pending' and return
    end
    @total_yards = @user.statistics.find_by_statistic_type("total_yards").statistic_value
    @most_common_pattern_types = YAML.load(@user.statistics.find_by_statistic_type("most_common_pattern_types").statistic_value)
    @favorite_brands = YAML.load(@user.statistics.find_by_statistic_type("favorite_brands").statistic_value)
    @favorite_weight = YAML.load(@user.statistics.find_by_statistic_type("favorite_weight").statistic_value)
  end

  def status
    username = params[:username]
    @user = User.find_by_username(username)
    respond_to do |format|
      format.json {render json: @user.to_json(only: [:id, :username, :status])}
      format.xml {render xml: @user.to_xml(only: [:id, :username, :status])}
    end
  end
  def create
    username = params[:user][:username]
    @user = User.find_by_username(username)
    if @user
      redirect_to person_path(username)
    else
      if build_user(username)
        redirect_to person_path(username)
      else
        render 'not_found'
      end
    end
  end

  private

  def build_user(username)
    token = access_token
    response = token.get("/people/#{username}.json")
    if response.class.ancestors.include? Net::HTTPSuccess
      photo_url = JSON.parse(response.body)["user"]["photo_url"]
      @user = User.create!(username: username, photo_url: photo_url)
      @user.delay.build_stats! token
      @user
      #redirect_to person_path(username) and return
    else
      false
    end
  end
end

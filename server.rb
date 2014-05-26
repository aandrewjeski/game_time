require 'sinatra'
require 'csv'
require 'pry'

def read_file
  scores = []
  CSV.foreach("game_time.csv", headers: true, header_converters: :symbol, converters: :integer ) do |row|
    scores << row.to_hash
  end
  scores
end

def load_teams
  teams = []
  CSV.foreach("teams.csv", headers: true, header_converters: :symbol) do |row|
    teams << row.to_hash
  end
  teams
end

get '/' do
  @team_name = load_teams
  @scores = read_file
  erb :index
end

get '/:leaderboard' do
  @scores = read_file
  @home_win = []
  @home_loss = []
  @away_win = []
  @away_loss = []
  @ranking = []
  @scores.each do |instance|
    if instance[:home_score] > instance[:away_score]
      @home_win << instance
    elsif instance[:home_score] < instance[:away_score]
      @home_loss << instance
    end
  end
  @scores.each do |instance|
    if instance[:away_score] > instance[:home_score]
      @away_win << instance
    elsif instance[:away_score] < instance[:home_score]
      @away_loss << instance
    end
  end

  binding.pry
  erb :leaderboard
end

get '/:teams/:team_name' do
@scores = load_teams

erb :teams
end

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

get '/' do
  @scores = read_file
  erb :index
end

get '/:leaderboard' do
  @scores = read_file
  @outcome = {}

  @scores.each do |row|
    unless @outcome.has_key?(row[:home_team])
      @outcome[row[:home_team]] = {"win" => 0, "loss" => 0}
    end
    unless @outcome.has_key?(row[:away_team])
      @outcome[row[:away_team]] = {"win" => 0, "loss" => 0}
    end
  end
  @outcome

  @scores.each do |row|
    if row[:home_score] > row[:away_score]
      @outcome[row[:home_team]]["win"] += 1
      @outcome[row[:away_team]]["loss"] += 1
    elsif row[:home_score] < row[:away_score]
      @outcome[row[:away_team]]["win"] += 1
      @outcome[row[:home_team]]["loss"] += 1
    end
  end

  def leaderboard(place)
    place.sort_by {|team, outcome| outcome["loss"]}
  end

  @outcome
  @ranking = leaderboard(@outcome)
  erb :leaderboard
end

get '/teams/:team_name' do

erb :teams
end

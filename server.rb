require 'sinatra'
require 'csv'
require 'pry'

set :views, File.dirname(__FILE__) + '/views'

#extract csv file and return array of game data
def export_csv(filename)
  game_matchups = []
  CSV.foreach(filename, headers: true) do |row|
    game_matchups << row.to_hash
  end
  game_matchups
end

#create a list of unique team names
def create_team_list(game_matchups)
  home_team_list = game_matchups.map{|game_info| game_info["home_team"]}
  away_team_list = game_matchups.map{|game_info| game_info["away_team"]}
  duplicate_team_list = home_team_list.concat(away_team_list)
  #remove dupicate team names from team list
  duplicate_team_list.map{|team| team}.uniq
end

#create scorecard_template; team key => empty hash of wins/losses/ties
def create_scorecard_template(game_matchups, team_list)
  scorecard_template = {}
  team_list.map{|team| scorecard_template[team] = {wins: 0, losses: 0, ties: 0}}.uniq
  scorecard_template
end

#TEAM_SCORECARD RETURN IS NOT A CORRECT========================
#calculate number of wins/losses/ties for each team
def calculate_team_scorecard(game_matchups, scorecard_template)
  team_scorecard = scorecard_template
  game_matchups.each do |game_info|
    if game_info["home_score"] > game_info["away_score"]
      #add 1 win to home_team and add 1 loss to away_team
      team_scorecard[game_info["home_team"]][:wins] += 1
      team_scorecard[game_info["away_team"]][:losses] += 1
    elsif game_info["home_score"] < game_info["away_score"]
      #add 1 win to away_team and add 1 loss to home_team
      team_scorecard[game_info["home_team"]][:losses] += 1
      team_scorecard[game_info["away_team"]][:wins] += 1
    else
      #add 1 tie to both home_team and away_team
      team_scorecard[game_info["home_team"]][:ties] += 1
      team_scorecard[game_info["away_team"]][:ties] += 1
    end
  end
  team_scorecard.to_a
end

#sort team_scoreboard create scoreboard array of hashes, team name key with
# an array of win/loss/tie values
def sort_team_scorecard(team_scorecard)
  team_scorecard
  #sort scorecard first by ties in decending order
  team_scorecard.sort_by! {|team_info| team_info[1][:ties]}.reverse!
  #sort scorecard second by wins in decending order
  team_scorecard.sort_by! {|team_info| team_info[1][:wins]}.reverse!
  #sort scorecard last by losses in ascending order
  team_scorecard.sort_by! {|team_info| team_info[1][:losses]}
end

#=====================================================

#game_matchups, team_list, scorecard_template, team_scorecard, sorted_scorecard

get '/' do
  redirect '/leaderboard'
end

get '/leaderboard' do
  game_matchups = export_csv('game_data.csv')
  #remove this when team_scorecard is fixed
  #team_scorecard = calculate_team_scorecard(game_matchups, scorecard_template)
  team_scorecard = [["Patriots", {:wins=>3, :losses=>0, :ties=>0}],
  ["Broncos", {:wins=>1, :losses=>1, :ties=>0}],
  ["Steelers", {:wins=>0, :losses=>1, :ties=>0}],
  ["Colts", {:wins=>0, :losses=>2, :ties=>0}]]

  @sorted_scorecard = sort_team_scorecard(team_scorecard)
  erb :index
end

get '/teams/:team_name' do
  @team_title = params[:team_name]
  @game_matchups = export_csv('game_data.csv')

  team_scorecard = [["Patriots", {:wins=>3, :losses=>0, :ties=>0}],
  ["Broncos", {:wins=>1, :losses=>1, :ties=>0}],
  ["Steelers", {:wins=>0, :losses=>1, :ties=>0}],
  ["Colts", {:wins=>0, :losses=>2, :ties=>0}]]
  @sorted_scorecard = sort_team_scorecard(team_scorecard)
  #array of hashes containing first_name, last_name, position for people on a specific team
  #@team_members = team_member_list(teams, @team_title)
  erb :show
end


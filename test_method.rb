#require 'sinatra'
require 'csv'
require 'pry'

#=====================================================

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

#TEAM_SCORECARD IS NOT A CORRECT========================
#calculate number of wins/losses/ties for each team
def calculate_team_scorecard(game_matchups, scorecard_template)
  team_scorecard = scorecard_template
  #based on game results, increase appropriate wins/losses/ties values

  game_matchups.each do |game_info|
    home_team = game_info["home_team"]
    away_team = game_info["away_team"]
    home_score = game_info["home_score"]
    away_score = game_info["away_score"]

    if home_score > away_score
      #add 1 win to home_team and add 1 loss to away_team
      team_scorecard[home_team][:wins] += 1
      team_scorecard[away_team][:losses] += 1
    elsif home_score < away_score
      #add 1 win to away_team and add 1 loss to home_team
      team_scorecard[home_team][:losses] += 1
      team_scorecard[away_team][:wins] += 1
    else
      #add 1 tie to both home_team and away_team
      team_scorecard[home_team][:ties] += 1
      team_scorecard[away_team][:ties] += 1
    end
    binding.pry

  end
  team_scorecard
end

#create scoreboard array of hashes, team name key with
# an array of win/loss/tie values
def create_scoreboard(team_list, team_scorecard)


end


#=====================================================

game_matchups = export_csv('game_data.csv')
puts game_matchups
puts

team_list = create_team_list(game_matchups)
puts team_list
puts

scorecard_template = create_scorecard_template(game_matchups, team_list)
puts scorecard_template
puts

#TEAM_SCORECARD IS NOT A CORRECT=========================
team_scorecard = calculate_team_scorecard(game_matchups, scorecard_template)
puts team_scorecard
puts

scoreboard = create_scoreboard(team_list, team_scorecard)
puts scoreboard
puts

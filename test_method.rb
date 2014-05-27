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

#calculate number of wins/losses/ties for each team
def calculate_team_scorecard(game_matchups, scorecard_template)
  team_scorecard = scorecard_template
  #based on game results, increase appropriate wins/losses/ties values
  game_matchups.each do |game_info|
    home_team = game_info["home_team"]
    away_team = game_info["away_team"]
    home_score = game_info["home_score"].to_i
    away_score = game_info["away_score"].to_i
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
  end
  team_scorecard.to_a
end

#sort team_scoreboard by wins, then ties, then losses
def create_leaderboard(team_scorecard)
  #sort scorecard first by wins in decending order
  #sort scorecard then by ties in decending order
  #sort scorecard last by losses in ascending order
  team_scorecard.sort_by! {|team_info| [team_info[1][:wins], team_info[1][:ties], -team_info[1][:losses]]}.reverse!
end


#=====================================================


game_matchups = export_csv('game_data.csv')
puts game_matchups
puts

#create list of unique team names
team_list = create_team_list(game_matchups)
puts team_list
puts

#create template where team key points to hash of wins/losses/ties
scorecard_template = create_scorecard_template(game_matchups, team_list)
puts scorecard_template
puts

#calculate the win/loss/tie scores for each team
team_scorecard = calculate_team_scorecard(game_matchups, scorecard_template)
puts team_scorecard
puts

#provide correct team_scorecard data
#team_scorecard is the output a working calculate_team_scorecard will output
team_scorecard = [["Broncos", {:wins=>1, :losses=>1, :ties=>0}],
 ["Steelers", {:wins=>0, :losses=>1, :ties=>0}],
 ["Patriots", {:wins=>3, :losses=>0, :ties=>0}],
 ["Packers", {:wins=>1, :losses=>0, :ties=>0}],
 ["Colts", {:wins=>0, :losses=>2, :ties=>0}],
 ["TEAM B", {:wins=>1, :losses=>2, :ties=>0}],
 ["TEAM C", {:wins=>3, :losses=>1, :ties=>0}]]
puts "edited scorecard"
puts team_scorecard
puts

#sort scorecard with best teams on top
leaderboard = create_leaderboard(team_scorecard)
puts scoreboard
puts

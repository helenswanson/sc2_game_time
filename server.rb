require 'sinatra'
require 'csv'
require 'pry'

#extract csv file and return array of game data
def export_csv(filename)
  game_matchups = []
  CSV.foreach(filename, headers: true) do |row|
    game_matchups << row.to_hash
  end
#{"home_team"=>"Patriots", "away_team"=>"Broncos", "home_score"=>"7", "away_score"=>"3"}
#{"home_team"=>"Broncos", "away_team"=>"Colts", "home_score"=>"3", "away_score"=>"0"}
#{"home_team"=>"Patriots", "away_team"=>"Colts", "home_score"=>"11", "away_score"=>"7"}
#{"home_team"=>"Steelers", "away_team"=>"Patriots", "home_score"=>"7", "away_score"=>"21"}
  game_matchups
end

#create a list of unique team names
def create_team_list(game_matchups)
  home_team_list = game_matchups.map{|game_info| game_info["home_team"]}
  away_team_list = game_matchups.map{|game_info| game_info["away_team"]}
  duplicate_team_list = home_team_list.concat(away_team_list)
  #remove dupicate team names from team list
  duplicate_team_list.map{|team| team}.uniq
#["Patriots", "Broncos", "Steelers", "Colts"]
end

#create array containing hashes where team name key points to hash containing team wins/losses/ties
def calculate_team_scores(game_matchups, team_list)
end


#=====================================================

#display homepage with clickable team links
get '/' do
  game_matchups = export_csv('game_data.csv')
  @team_list = create_team_list(game_matchups)


  #@team_list = unique_teams(teams)
  erb :index
end

get '/teams/:team_name' do
  @team_title = params[:team_name]
  game_matchups = export_csv('game_data.csv')



  #array of hashes containing first_name, last_name, position for people on a specific team
  #@team_members = team_member_list(teams, @team_title)
  erb :show
end











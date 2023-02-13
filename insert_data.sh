#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Read csv in
cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
# Insert into table teams
  if [[ $winner != 'winner' ]]
  then
    TEAM_ID=$($PSQL "select team_id from teams where name = '$winner'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$winner')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo INSERT TEAM, $winner
      fi
    fi
  fi

  if [[ $opponent != 'opponent' ]]
  then
    TEAM_ID=$($PSQL "select team_id from teams where name = '$opponent'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$opponent')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo INSERT TEAM, $opponent
      fi
    fi
  fi
done

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals
do
  if [[ $winner != 'winner' ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name = '$winner'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$opponent'")
    
    WINNER_NAME=$($PSQL "select name from teams where name = '$winner'")
    OPPONENT_NAME=$($PSQL "select name from teams where name = '$opponent'")
    
    # Insert into table games
    GAME_ID=$($PSQL "select game_id from games where year = $year and round = '$round' and '$WINNER_NAME'='$winner' and '$OPPONENT_ID'='$opponent'")
    if [[ -z $GAME_ID ]]
    then
      INSERT_GAME_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($year,'$round','$WINNER_ID','$OPPONENT_ID',$winner_goals,$opponent_goals)")
      if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
      then
        echo INSERT GAME, $winner vs $opponent
      fi
    fi
  fi
done



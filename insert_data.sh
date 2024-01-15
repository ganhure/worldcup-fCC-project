#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# to avoid inserting top line of csv
if [[ $WINNER != 'winner' ]]
then
# Get the team_id
TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

# Check if TEAM_ID is empty
if [[ -z $TEAM_ID ]]
then
# Since team id is empty insert team into teams table
INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
# showing result of insertion in the terminal in a readable way
if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
then
echo Inserted into teams table, $WINNER
fi


fi
fi

# Not all teams were winners so we will add all other teams that didn't win that were opponents

if [[ $OPPONENT != 'opponent' ]]
then
# Get the team_id
TEAM_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

# Check if TEAM_ID is empty
if [[ -z $TEAM_ID ]]
then
# Since team id is empty insert team into teams table
INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
# showing result of insertion in the terminal in a readable way
if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
then
echo Inserted into teams table, $OPPONENT
fi


fi
fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
# if statement to insert games data into its respective table

# ensuring we don't insert first line of dataset
if [[ $YEAR != 'year' ]]
then
# get winner id 
WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

# get opponent id
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

#check if winner id is empty
if [[ $WINNER_ID ]]
then
# if empty insert year, round, winner_id, opponent_id, winner_goals, opponent_goals
INSERT_GAMES_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"

# rewriting terminal result to make it more readable
if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
then
echo Inserted into games, $WINNER vs $OPPONENT: $WINNER_GOALS - $OPPONENT_GOALS $YEAR $ROUND
fi

fi






fi
done

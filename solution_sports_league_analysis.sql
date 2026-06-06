SELECT * FROM sports.games;

-- 1. Query to calculate the total points scored by each player 
SELECT player_id, SUM(points) AS total_points
FROM PlayerStats
GROUP BY player_id;

/*
Groups PlayerStats by player_id and sums points.
Each row = one player’s total points across all games.
*/


-- 2. Query to find players who scored points between 3 and 6
SELECT ps.player_id, p.player_name, ps.points
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
WHERE points BETWEEN 3 AND 6;
/*
Joins PlayerStats with Players for names.
Filters rows where points are between 3 and 6.
Shows per-game results.
*/


-- 3. Find players from the same team 
SELECT p.team_id, team_name, player_name, player_id
FROM Players p
JOIN Teams t ON p.team_id = t.team_id;
/*
Joins Players with Teams to show every player and their team.
Current dataset: one player per team, so no teammates appear.
*/



-- 4. Find games played in the last 30 days
SELECT game_id, game_date
FROM Games
WHERE game_date >= CURDATE() - INTERVAL 30 DAY     
ORDER BY game_date ;
/*
Uses CURDATE() - INTERVAL 30 DAY to get recent games.
Filters Games by game_date in that period.
Sample data (Nov 2024) returns 0 rows with today’s date.
*/


-- 5. Create a view to summarize player statistics
CREATE VIEW player_summary AS
SELECT 
ps.player_id,
p.player_name,
SUM(ps.points) AS total_points,
SUM(ps.assists) AS total_assists,
SUM(ps.rebounds) AS total_rebounds
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
GROUP BY ps.player_id, p.player_name;

SELECT * FROM player_summary;
/*
Creates a view summarizing total points, assists, rebounds per player.
JOIN adds player names; GROUP BY ensures one row per player.
View can be queried like a table.
*/


-- 6.Create a trigger to ensure points cannot be negative before inserting or updating
-- Trigger for INSERT
DELIMITER $$

CREATE TRIGGER check_points_before_insert
BEFORE INSERT ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Points cannot be negative';
    END IF;
END$$

DELIMITER ;

-- Trigger for UPDATE
DELIMITER $$

CREATE TRIGGER check_points_before_update
BEFORE UPDATE ON PlayerStats
FOR EACH ROW
BEGIN
    IF NEW.points < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Points cannot be negative';
    END IF;
END$$

DELIMITER ;
/*
BEFORE triggers on INSERT and UPDATE.
Checks NEW.points; if < 0, raises error with SIGNAL.
Enforces data integrity so negative points cannot be stored.
*/


-- 7. Fetch all players and their respective teams, including players without a team.
SELECT 
    p.player_id,
    p.player_name,
    t.team_name
FROM Players p
LEFT JOIN Teams t ON p.team_id = t.team_id
ORDER BY p.player_id;
/*
LEFT JOIN Players with Teams.
Keeps all players; if no team exists, team_name is NULL.
*/



-- 8. Total points scored by players, grouped by their teams 
SELECT 
    p.player_name,
    p.team_id,
    SUM(ps.points) AS total_points
FROM Players p
JOIN PlayerStats ps ON p.player_id = ps.player_id
GROUP BY p.player_id, p.player_name, p.team_id;
/*
Joins Players with PlayerStats.
Sums points per player and shows their team_id.
Group ensures one row per player.
*/



-- 9. Players who scored more than 5 points
SELECT 
    p.player_id,
    p.player_name,
    ps.points
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
WHERE ps.points > 5;
/*
Joins PlayerStats with Players for names.
Filters rows where points > 5.
Shows per-game results.
*/


-- 10.	Update and assign Sarah Moore to the team Green Sharks
UPDATE Players
SET team_id = 3
WHERE player_name = 'Sarah Moore';
/*
Updates Players table.
Sets team_id = 3 (Green Sharks) for player_name = 'Sarah Moore'.
*/



-- 11.	Deleting all records where the game id is 5
# Step 1: Delete from PlayerStats first
# Because PlayerStats depends on Games via a foreign key.
DELETE FROM PlayerStats
WHERE game_id = 5;

# Step 2: Delete from Games
# Now that no stats reference game_id = 5, you can safely remove the game itself:
DELETE FROM Games
WHERE game_id = 5;
/*
Delete PlayerStats rows with game_id = 5 (child).
Then delete Games row with game_id = 5 (parent).
Order avoids foreign key errors.
*/

-- 12.	Players who scored more than the average points in a specific game
# Step 1: Find the average points for that game
SELECT AVG(points) AS avg_points
FROM PlayerStats
WHERE game_id = 6;

# Step 2: Get players above that average
SELECT player_id, points
FROM PlayerStats
WHERE game_id = 6 AND points > 7.33;
/*
Step 1: Find AVG(points) for chosen game.
Step 2: Select players in that game with points above this value.
Simplest two-step method.
*/


-- 13.	Find the top 3 players who have scored the highest total points across all games
SELECT 
    p.player_name,
    SUM(ps.points) AS total_points
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
GROUP BY p.player_id, p.player_name
ORDER BY total_points DESC
LIMIT 3;
/*
SUM points per player, join with names.
Order by total_points DESC.
LIMIT 3 keeps only the top three scorers.
*/



-- 14.	Retrieve a list of teams that have won at least one game, considering a win as having a higher score than the opposing team.
-- Find teams that have won at least one game
SELECT DISTINCT t.team_name   -- show each winning team only once
FROM Teams t
JOIN Games g 
  -- Use CASE to select the winning team_id from each game
  ON t.team_id = CASE 
                   WHEN g.score_team1 > g.score_team2 THEN g.team1_id  -- team1 wins
                   WHEN g.score_team2 > g.score_team1 THEN g.team2_id  -- team2 wins
                 END;
/*
CASE picks winning team_id (team1 if score_team1 > score_team2, else team2).
JOIN maps winner to team_name.
DISTINCT ensures each team appears once even if multiple wins.
*/


-- 15.	Determine the average number of rebounds per player for each team and list the teams in descending order of average rebounds.
-- Average rebounds per player grouped by team
-- Find the average rebounds per player for each team
SELECT 
    p.team_id,                     -- show the team ID
    AVG(ps.rebounds) AS avg_rebounds  -- calculate average rebounds per team
FROM PlayerStats ps
JOIN Players p 
    ON ps.player_id = p.player_id   -- link stats to the players table
GROUP BY p.team_id                  -- group results by team
ORDER BY avg_rebounds DESC;         -- sort teams by average rebounds (highest first)
/*
Joins PlayerStats with Players.
Groups by team_id and averages rebounds.
Sorted by avg_rebounds DESC.
*/



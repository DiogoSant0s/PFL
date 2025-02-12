type Match = ((String,String), (Int,Int))
type MatchDay = [Match]
type League = [MatchDay]

myLeague :: League
myLeague = [
  [(("Porto","Sporting"),(2,2)),(("Benfica","Vitoria SC"),(4,0))],
  [(("Porto","Benfica"),(5,0)),(("Vitoria SC","Sporting"),(3,2))],
  [(("Vitoria SC","Porto"),(1,2)),(("Sporting","Benfica"),(2,1))]
  ]

-- Function to calculate matchday score for a team
matchDayScore :: String -> MatchDay -> Int
matchDayScore _ [] = 0
matchDayScore name (((x,y),(a,b)):xs)
    | name `elem` [x,y] && name == winner ((x,y),(a,b)) = 3
    | name `elem` [x,y] && "draw" == winner ((x,y),(a,b)) = 1
    | name `elem` [x,y] = 0
    | otherwise = matchDayScore name xs

-- Function to determine the winner of a match
winner :: Match -> String
winner ((x,y),(a,b))
    | a == b = "draw"
    | a > b = x
    | otherwise = y

-- Function to get the list of unique teams in a league
teamsInLeague :: League -> [String]
teamsInLeague league = removeDuplicates [team | matchDay <- league, ((home, away), _) <- matchDay, team <- [home, away]]

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (x:xs)
    | x `elem` xs = removeDuplicates xs
    | otherwise = x : removeDuplicates xs

-- Function to calculate league score for a team
leagueScore :: String -> League -> Int
leagueScore t = foldr ((+) . matchDayScore t) 0

-- Function to sort a list by a given condition
sortByCond :: [a] -> (a -> a -> Bool) -> [a]
sortByCond [] _ = []
sortByCond [x] _ = [x]
sortByCond l cmp = merge (sortByCond l1 cmp) (sortByCond l2 cmp) cmp
  where (l1 ,l2) = splitAt (div (length l) 2) l

merge :: [a] -> [a] -> (a -> a -> Bool) -> [a]
merge [] l _ = l
merge l [] _ = l
merge (x:xs) (y:ys) cmp
  | cmp x y = x : merge xs (y:ys) cmp
  | otherwise = y : merge (x:xs) ys cmp

-- Function to calculate ranking of teams
ranking :: League -> [(String,Int)]
ranking league = sortByCond scores compareRanking
  where
    teams = teamsInLeague league
    scores = [(team, leagueScore team league) | team <- teams]
    compareRanking (t1, s1) (t2, s2)
      | s1 == s2 = t1 < t2  -- Sort alphabetically if scores are the same
      | otherwise = s1 > s2  -- Sort by descending score

-- Function to count matchdays with at least one draw
numMatchDaysWithDraws :: League -> Int
numMatchDaysWithDraws league = length (filter (any (\match -> winner match == "draw")) league)

-- Function to find big wins in the league
bigWins :: League -> [(Int,[String])]
bigWins league = [(i, [winner match | match <- matchDay, let ((home, away), (goalsHome, goalsAway)) = match, abs (goalsHome - goalsAway) >= 3, winner match /= "draw"]) | (i, matchDay) <- zip [1..] league]

-- Function to find winning streaks
winningStreaks :: League -> [(String, Int, Int)]
winningStreaks league = concatMap findStreaks (teamsInLeague league)
  where
    teamWins = [(i, winner match) | (i, matchDay) <- zip [1..] league, match <- matchDay, winner match /= "draw"]
    findStreaks team = processStreaks [(i, t) | (i, t) <- teamWins, t == team]

    processStreaks [] = []
    processStreaks ((s, t):rest) = findConsecutive [(s, t)] rest
      where
        findConsecutive streak [] = [formatStreak streak | length streak >= 2]
        findConsecutive streak@((prev, _):_) ((i, t):xs)
          | i == prev + 1 = findConsecutive ((i, t) : streak) xs
          | length streak >= 2 = formatStreak streak : findConsecutive [(i, t)] xs
          | otherwise = findConsecutive [(i, t)] xs

        formatStreak streak = let indices = map fst streak in (t, minimum indices, maximum indices)

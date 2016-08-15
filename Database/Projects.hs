module Database.Projects (projects) where
import Import

import Data.Time.Clock

time:: Integer -> Integer -> UTCTime
time a b = UTCTime (fromGregorian a 1 1) (secondsToDiffTime b)

projects::[Project]
projects = [Project 1 "Project 1" "P1" $ time 0 0,
  Project 3 "Substantial" "P2"  $ time 1 0,
  Project 5 "What the hell" "WTH"  $ time 100 0,
  Project 10 "The last project" "TLP"  $ time 10 10]
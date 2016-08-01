module Handler.Project where
import Import

import Database.Projects
import Yesod.Bootstrap()

getProjectR :: Int -> Handler Html
getProjectR projectId = defaultLayout $ selectPage projectId

selectPage :: Int -> Widget
selectPage projectId = maybe notFound renderPage projectEntry
  where
    projectEntry = find (\x -> (fst x) == projectId) projects

renderPage :: (Int, Text) -> Widget
renderPage projectEntry = do
  setTitle $ ("Project " ++ projectTitle)
  $(widgetFile "project")
  where
    projectTitle = (toHtml projectId) ++ (toHtml projectName)
    projectName = snd projectEntry
    projectId = fst projectEntry


module Handler.Projects where
import Import

import Yesod.Bootstrap()
import Database.Projects(projects)

getProjectsR :: Handler Html
getProjectsR = defaultLayout $ do
  setTitle "Projects"
  $(widgetFile "projects")

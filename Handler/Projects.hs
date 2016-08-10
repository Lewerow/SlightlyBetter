module Handler.Projects where
import Import

import Yesod.Bootstrap()
import Database.Projects(projects)
import Domain.Project

getProjectsR :: Handler Html
getProjectsR = defaultLayout $ do
  setTitle "Projects"
  $(widgetFile "projects")

module Handler.Projects where
import Import

import Yesod.Bootstrap()


getProjectsR :: Handler Html
getProjectsR = defaultLayout $ do
  setTitle "Projects"
  $(widgetFile "projects")
    where
      projects = ["Project 1", "Project 2", "My extra project", "Project 10"]::[Text]

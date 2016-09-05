module Handler.Project where

import Import

import Data.Time.Clock()
import Yesod.Bootstrap()

getProjectR :: ProjectId -> Handler Html
getProjectR projectId = defaultLayout $ selectPage projectId

selectPage :: ProjectId -> Widget
selectPage projectId = do
  project <- handlerToWidget $ runDB $ get404 projectId
  renderPage projectId project

renderPage :: ProjectId -> Project -> Widget
renderPage projectId projectEntry = do
  app <- getYesod
  setTitle $ (toHtml $ (appName app)) ++ ": " ++ projectTitle
  $(widgetFile "project")
  $(widgetFile "back-to-projects")
  where
    projectTitle = (toHtml shortName)
    shortName = projectShortName projectEntry
    name = projectName projectEntry
    deadline = projectDeadline projectEntry

deleteProjectR :: ProjectId -> Handler Html
deleteProjectR projectId = do
  _ <- runDB $ delete projectId
  redirect ProjectsR

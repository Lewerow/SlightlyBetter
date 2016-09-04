module Handler.Project where

import Import

import Data.Time.Clock()
import Yesod.Bootstrap()

getProjectR :: Int -> Handler Html
getProjectR projectId = defaultLayout $ selectPage projectId

selectPage :: Int -> Widget
selectPage projectId = do
  (Entity _ project) <- handlerToWidget $ runDB $ getBy404 $ UID projectId
  renderPage project

renderPage :: Project -> Widget
renderPage projectEntry = do
  app <- getYesod
  setTitle $ (toHtml $ (appName app)) ++ ": " ++ projectTitle
  $(widgetFile "project")
  $(widgetFile "back-to-projects")
  where
    projectTitle = (toHtml shortName) ++ "(" ++ (toHtml projectId)  ++ ")"
    shortName = projectShortName projectEntry
    name = projectName projectEntry
    projectId = projectIdentifier projectEntry
    deadline = projectDeadline projectEntry
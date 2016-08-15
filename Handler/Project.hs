module Handler.Project where

import Import

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
    projectTitle = (toHtml projectName) ++ "(" ++ (toHtml projectId)  ++ ")"
    projectName = projectShortName projectEntry
    projectId = projectIdentifier projectEntry


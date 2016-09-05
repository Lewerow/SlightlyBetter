module Handler.ProjectEdit where

import Import

import Yesod.Form.Bootstrap3
import Data.Time.Clock

utcDayField :: Field Handler UTCTime
utcDayField = checkMMap (return . Right . toUTCTime :: (Day -> Handler (Either Text UTCTime))) utctDay dayField
  where
  toUTCTime x = UTCTime x (secondsToDiffTime 0)

postProjectEditR :: Maybe ProjectId -> Handler Html
postProjectEditR projectId = do
  project <- (runDB . get) `mapM` projectId
  renderForm projectId $ join project

postProjectEditIdR :: ProjectId -> Handler Html
postProjectEditIdR = postProjectEditR . Just

getProjectEditIdR :: ProjectId -> Handler Html
getProjectEditIdR = postProjectEditIdR

postProjectEditNoIdR :: Handler Html
postProjectEditNoIdR = postProjectEditR Nothing

getProjectEditNoIdR :: Handler Html
getProjectEditNoIdR = postProjectEditNoIdR

projectAForm :: Maybe Project ->AForm Handler Project
projectAForm project = Project
    <$> areq textField nameConfig (projectName <$> project)
    <*> areq textField shortNameConfig (projectShortName <$> project)
    <*> areq utcDayField timeFieldConfig (projectDeadline <$> project)
    <* bootstrapSubmit (maybe "Add" (const "Modify") project :: BootstrapSubmit Text)
    where
      nameConfig = withPlaceholder "Project name" $ bfs ("Project name" :: Text)
      shortNameConfig = withPlaceholder "Short project name" $ bfs ("Short project name" :: Text)
      timeFieldConfig = bfs ("Project deadline" :: Text)

projectForm :: Maybe Project -> Html -> MForm Handler (FormResult Project, Widget)
projectForm project = renderBootstrap3 BootstrapBasicForm $ projectAForm project

renderForm :: Maybe ProjectId -> Maybe Project -> Handler Html
renderForm projectId projectEntry = do
  ((result, formWidget), enctype) <- runFormPost (projectForm projectEntry)
  case result of
    FormSuccess project -> do
       upsertedId <- runDB $ updateCall project
       redirect $ ProjectR upsertedId
    _ -> defaultLayout $ do
      app <- getYesod
      setTitle $ (toHtml $ (appName app)) ++ ": editing projects"
      $(widgetFile "project-edition")
      $(widgetFile "back-to-projects")
      where
        backRoute = maybe ProjectsR ProjectR projectId
        postRoute = maybe ProjectEditNoIdR ProjectEditIdR projectId
    where
       updateCall = maybe insert (\pid val -> repsert pid val >> return pid) projectId

module Handler.ProjectEdit where

import Import

import Yesod.Form.Bootstrap3
import Data.Time.Clock

utcDayField = checkMMap (return . Right . toUTCTime :: (Day -> Handler (Either Text UTCTime))) utctDay dayField
  where
  toUTCTime x = UTCTime x (secondsToDiffTime 0)

postProjectEditR :: Int -> Handler Html
postProjectEditR projectId =  do
  project <- runDB $ getBy $ UID projectId
  renderForm projectId $ (\(Entity _ proj) -> proj) `fmap` project

getProjectEditR :: Int -> Handler Html
getProjectEditR = postProjectEditR

projectAForm :: Int -> Maybe Project -> AForm Handler Project
projectAForm projectId project = Project
    <$> areq hiddenField identifierConfig (pure projectId)
    <*> areq textField nameConfig (projectName <$> project)
    <*> areq textField shortNameConfig (projectShortName <$> project)
    <*> areq utcDayField timeFieldConfig (projectDeadline <$> project)
    <* bootstrapSubmit ("Modify" :: BootstrapSubmit Text)
    where
      identifierConfig = bfs ("" :: Text)
      nameConfig = withPlaceholder "Project name" $ bfs ("Project name" :: Text)
      shortNameConfig = withPlaceholder "Short project name" $ bfs ("Short project name" :: Text)
      timeFieldConfig = bfs ("Project deadline" :: Text)

projectForm :: Int -> Maybe Project -> Html -> MForm Handler (FormResult Project, Widget)
projectForm projectId project = renderBootstrap3 BootstrapBasicForm $ projectAForm projectId project

renderForm :: Int -> Maybe Project -> Handler Html
renderForm projectId projectEntry = do
  ((result, formWidget), enctype) <- runFormPost (projectForm projectId projectEntry)
  case result of
    FormSuccess project -> redirect $ ProjectR (projectIdentifier project)
    _ -> defaultLayout $ do
      app <- getYesod
      setTitle $ (toHtml $ (appName app)) ++ ": editing projects"
      $(widgetFile "project-edition")
      $(widgetFile "back-to-projects")

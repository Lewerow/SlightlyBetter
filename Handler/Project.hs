module Handler.Project where
import Import

import Yesod.Bootstrap()


getProjectR :: Int -> Handler Html
getProjectR projectId = defaultLayout $ do
  setTitle $ ("Project " ++ (toHtml projectId))
  $(widgetFile "project")
module Handler.Projects where
import Import

import Yesod.Bootstrap()

getProjectsR :: Handler Html
getProjectsR = do
    projects <- runDB $ selectList [] []
    defaultLayout $ do
        setTitle "Projects"
        $(widgetFile "projects")

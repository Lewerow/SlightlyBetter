module Handler.Projects where
import Import

import Yesod.Bootstrap()

getProjectsR :: Handler Html
getProjectsR = do
    projects <- runDB $ do
       dbProjects <- selectList [] []
       return $ map entityVal dbProjects
    defaultLayout $ do
        setTitle "Projects"
        $(widgetFile "projects")

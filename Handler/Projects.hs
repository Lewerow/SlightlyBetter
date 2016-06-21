module Handler.Projects where
import Import

import Yesod.Form.Bootstrap3()

getProjectsR :: Handler Html
getProjectsR = defaultLayout $ do
	setTitle "Projects"
	$(widgetFile "projects")

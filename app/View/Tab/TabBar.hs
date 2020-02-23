module View.Tab.TabBar where

import GI.Gtk.Declarative
import Optics.Core

import Data.Vector (fromList)
import qualified Data.Map as M


import View.Tab.Tab (showTab)
import Model.State
import Model.Action


tabBar :: M.Map TabId (Tab GameTab) -> Widget Action
tabBar gameTabs = notebook [] . fromList $ flip fmap (M.toAscList $ gameTabs) $ \(id', tab) ->
  page (tab ^. tabName) (showTab id' tab)

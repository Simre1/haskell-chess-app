module View.Panel.Panel where

import GI.Gtk.Declarative
import GI.Gtk (Label(..))
import Optics.Core
import Data.Text (Text)

import View.Tab.Utils

import Model.State
import Model.Action

import View.Panel.ChessBoard

showPanel :: TabId -> Tab x -> Panel x -> Widget Action
showPanel tabId' tab panel = case panel of
  PanelText text -> widget Label [#label := text]
  ChessBoard -> case (tab ^. tabType) of
    GameTabS gameTab -> showChessBoard tabId' (gameTab ^. selectedField) (gameTab ^. game % position)
    _ -> cannotShow

cannotShow :: Widget Action
cannotShow = widget Label [#label := "Cannot show this panel in this tab."]

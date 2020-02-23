module View.Tab.Tab where

import GI.Gtk.Declarative
import GI.Gtk (Label (..), Paned(..))
import Optics.Core

import Model.State
import Model.Action

import View.Panel.Panel

showTab :: TabId -> Tab x -> Widget Action
showTab tabId' tab = paned []
  (pane defaultPaneProperties $ showPanel tabId' tab (tab ^. mainPanel))
  (pane defaultPaneProperties $ widget Label [#label := "Nothing here yet."])

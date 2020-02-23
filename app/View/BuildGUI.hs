module View.BuildGUI where

import GI.Gtk.Declarative
import GI.Gtk.Declarative.Container.Grid

import GI.Gtk (Window(..), Label(..), Grid(..), Orientation(..), Align(..))
import Optics.Core

import Data.Vector (fromList)

import Model.State
import Model.Action

import View.Tab.TabBar (tabBar)
import View.Menu (menu)

buildGUI :: State -> Bin Window Action
buildGUI state = bin
      Window
      [ #title := "Lambda Chess"
      , on #deleteEvent $ const (True, CloseApp)
      ]
      $ container
              Grid
              [#rowSpacing := 1, #columnSpacing := 2, #margin := 0]
              ( fromList
                $ GridChild defaultGridChildProperties {leftAttach=0, topAttach=0} menu
                : [GridChild defaultGridChildProperties {leftAttach=0, topAttach=1} $ tabBar (state ^. gameTabs)]
              )

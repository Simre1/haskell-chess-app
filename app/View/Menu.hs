module View.Menu where

import GI.Gtk (Label(..), Menu(..), MenuItem(..), MenuBar(..), Button(..))
import GI.Gtk.Declarative

import Model.Action
import Model.State

menu :: Widget Action
menu = container
          MenuBar
          []
          [ subMenu
            "File"
            [ menuItem MenuItem [on #activate $ AddGameTab New]
              $ widget Label [#label := "New"]
            ]
          , menuItem MenuItem []
            $ widget Label [#label := "Help"]
          ]

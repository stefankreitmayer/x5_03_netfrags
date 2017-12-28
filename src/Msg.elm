module Msg exposing (..)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)


type Msg
  = ChangeSearchString String
  | ShowDetails Resource
  | HideDetails Resource
  | ToggleItemDropmenu Resource
  | ToggleItemOptional Resource Bool
  | ChangeAnnotation Resource String String
  | DislikeResult String
  | RevokeDislike
  | ConfirmDislike String
  | HoverRating (Rateable, Int)
  | UnHoverRating
  | EnterRating


subscriptions : Model -> Sub Msg
subscriptions {ui} =
  [] |> Sub.batch

module Msg exposing (..)

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)


type Msg
  = ChangeSearchString String
  | AddResourceToProject Resource
  | ShowDetails Resource
  | HideDetails Resource
  | ToggleItemDropmenu Resource
  | RemoveResourceFromProject Resource
  | ToggleItemOptional Resource Bool
  | ChangeAnnotation Resource String String
  | DislikeResult String
  | RevokeDislike
  | ConfirmDislike String
  | HoverRating (Rateable, Int)
  | UnHoverRating
  | EnterRating
  -- | AddRelevantTag String
  -- | RemoveRelevantTag String


subscriptions : Model -> Sub Msg
subscriptions {ui} =
  [] |> Sub.batch

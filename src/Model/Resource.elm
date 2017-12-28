module Model.Resource exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)

type alias Resource =
  { title : String
  , url : String
  , coverImageStub : String
  , date : String
  , tags : Set String
  , features : Dict String String }


workloadInHours model resource =
  if isItemOptional model resource then
    0
  else
      model.annotations
      |> Dict.get (resource.url, attrTextWorkload)
      |> Maybe.withDefault "0.5"
      |> String.toFloat
      |> Result.withDefault 0.5


isItemOptional model resource =
  model.optionalItems |> Set.member resource.url


attrTextWorkload =
  "Workload (hours)"

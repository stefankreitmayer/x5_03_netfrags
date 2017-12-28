module Model exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)
import Element.Input as Input

import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData


type alias Model =
  { ui : Ui
  , searchResults : List Resource
  , projectResources : List Resource
  , expandedSearchResults : List String
  , itemDropmenu : Maybe Resource
  , optionalItems : Set String
  , annotations : Dict (String, String) String
  , relevantTags : Set String
  , dislikedResult : Maybe String
  , enteredRatings : Dict Rateable Int
  , hoveringRating : Maybe (Rateable, Int)
  , errorMsg : Maybe String }


type alias Rateable =
  (String, String)


initialModel : Model
initialModel =
  { ui = initialUi
  , searchResults = Model.FakeData.exampleResources
  , projectResources = []
  , expandedSearchResults = []
  , itemDropmenu = Nothing
  , optionalItems = Set.empty
  , annotations = Dict.empty
  , relevantTags = Set.empty
  , dislikedResult = Nothing
  , enteredRatings = Dict.empty
  , hoveringRating = Nothing
  , errorMsg = Nothing }


getAnnotation model resource name =
  model.annotations |> Dict.get (resource.url, name) |> Maybe.withDefault ""


itemAnnotation =
  [ attrTextWorkload, "My Comments" ]

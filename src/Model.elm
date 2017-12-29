module Model exposing (..)

import Set exposing (Set)
import Dict exposing (Dict)
import Element.Input as Input

import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData


type alias Model =
  { ui : Ui
  , playlists : List Playlist
  , expandedSearchResults : List String
  , itemDropmenu : Maybe Resource
  , optionalItems : Set String
  , annotations : Dict (String, String) String
  , relevantTags : Set String
  , dislikedResult : Maybe String
  , enteredRatings : Dict Rateable Int
  , hoveringRating : Maybe (Rateable, Int)
  , selectedItem : Maybe (Resource, Playlist)
  , errorMsg : Maybe String }


type alias Rateable =
  (String, String)


type alias Playlist =
  { heading : String
  , items : List Resource }


initialModel : Model
initialModel =
  { ui = initialUi
  , playlists = Model.FakeData.exampleResources |> initialPlaylists
  , expandedSearchResults = []
  , itemDropmenu = Nothing
  , optionalItems = Set.empty
  , annotations = Dict.empty
  , relevantTags = Set.empty
  , dislikedResult = Nothing
  , enteredRatings = Dict.empty
  , hoveringRating = Nothing
  , selectedItem = Nothing
  , errorMsg = Nothing }


initialPlaylists resources =
  [ generatePlaylistFromTag resources "Videos" "video"
  , generatePlaylistFromTag resources "Books" "book"
  , generatePlaylistFromTag resources "Podcasts" "podcast"
  , generatePlaylistFromTag resources "Courses" "course"
  , generatePlaylistFromTag resources "Articles" "article"
  , generatePlaylistFromTag resources "Meetups" "meetup group"
  , generatePlaylistFromTag resources "Presentations" "presentation"
  , generatePlaylistFromTag resources "Related to python" "python"
  ]


generatePlaylistFromTag resources heading tag =
  Playlist heading (resources |> List.filter (\resource -> resource.tags |> Set.member tag))


getAnnotation model resource name =
  model.annotations |> Dict.get (resource.url, name) |> Maybe.withDefault ""


itemAnnotation =
  [ attrTextWorkload, "My Comments" ]

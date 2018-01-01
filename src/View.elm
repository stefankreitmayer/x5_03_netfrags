module View exposing (view)

import Html exposing (Html)
import Html.Attributes
import Color exposing (..)
import Set exposing (Set)
import Dict exposing (Dict)
-- import Debug exposing (log)
import Json.Encode

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onCheck, onMouseOver, onMouseOut)
import Element.Input as Input
import Element.Keyed as Keyed

import Style
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Shadow as Shadow

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData exposing (computeFakeRating, computeFakeNumberOfRatings, ratingsFromUsers, fakeRecommendationReasons)

import Msg exposing (..)


type MyStyles
  = NoStyle
  | DebugStyle
  | InvisibleStyle
  | ThinvisibleStyle
  | Opacity75Style
  | HeaderStyle
  | X5LogoStyle
  | ResourceStyle
  | ResourceTitleStyle
  | HintStyle
  | ExploreSectionStyle
  | EllipsisStyle
  | AnnotationsStyle
  | AnnotationInputStyle
  | PlaylistHeadingStyle
  | H4Style
  | TagStyle
  | AddButtonCircleStyle
  | CloseButtonStyle
  | ModalityDistributionStyle
  | ModalityStylePresent
  | ModalityStyleNotPresent
  | DislikeReasonStyle
  | StarStyle
  | StarHoverStyle
  | UrlStyle
  | ItemInspectorStyle
  | ItemInspectorImageStyle
  | StartedItemsSectionStyle
  | StartedItemsHeadingStyle
  | CompletedItemsSectionStyle
  | CompletedItemsHeadingStyle
  | ExploreHeadingStyle
  | GreetingSectionStyle
  | GreetingHeadingStyle
  | InspectedRatingsHeadingStyle
  | ItemInspectorProgressStyle
  | WhiteButtonStyle
  | BlueButtonStyle
  | AgreeButtonStyle
  | ModalOverlayStyle
  | ModalTextStyle


stylesheet =
  Style.styleSheet
    [ Style.style NoStyle []
    , Style.style DebugStyle
      [ Color.background <| Color.rgb 210 210 210
      , Border.all 2
      ]
    , Style.style InvisibleStyle
      [ Style.opacity 0
      ]
    , Style.style ThinvisibleStyle
      [ Style.opacity 0.2
      ]
    , Style.style Opacity75Style
      [ Style.opacity 0.75
      ]
    , Style.style HeaderStyle
      [ Color.background <| Color.white
      , Color.border <| gray100
      , Border.bottom 1
      ]
    , Style.style X5LogoStyle
      [ Color.text <| Color.rgb 0 100 180
      , Font.weight 900
      ]
    , Style.style ResourceStyle
      [ Color.background <| Color.white
      , Color.text <| Color.black
      , Shadow.simple
      ]
    , Style.style ResourceTitleStyle
      [ Color.text <| gray50
      , Font.size 16
      , Font.weight 600
      ]
    , Style.style HintStyle
      [ Color.text <| Color.rgb 120 120 120
      ]
    , Style.style ExploreSectionStyle
      [ Color.background <| gray230
      ]
    , Style.style EllipsisStyle
      [ Style.opacity 0.66
      ]
    , Style.style AnnotationsStyle
      [ Border.top 1
      , Border.left 1
      , Color.border <| Color.rgb 200 200 200
      , Color.background <| gray230
      ]
    , Style.style AnnotationInputStyle
      [ Border.bottom 1
      , Color.border <| Color.rgb 200 200 200
      , Shadow.simple
      ]
    , Style.style PlaylistHeadingStyle
      [ Color.text <| Color.rgb 40 40 40
      , Font.size 18
      ]
    , Style.style TagStyle
      [ Border.all 1
      , Border.rounded 2
      , Color.border <| Color.rgb 200 200 200
      , Font.size 13
      ]
    , Style.style H4Style
      [ Font.weight 600
      ]
    , Style.style AddButtonCircleStyle
      [ Color.border <| gray100
      , Border.all 1
      ]
    , Style.style CloseButtonStyle
      [ Color.text <| gray100
      , Color.background <| Color.white
      , Font.weight 100
      ]
    , Style.style ModalityDistributionStyle
      [ Color.background <| gray50
      ]
    , Style.style ModalityStylePresent
      [ Color.text <| Color.rgb 80 180 80
      ]
    , Style.style ModalityStyleNotPresent
      [ Color.text <| Color.rgb 180 180 180
      ]
    , Style.style DislikeReasonStyle
      [ Color.border <| gray100
      , Border.all 1
      ]
    , Style.style StarStyle
      [ Style.opacity 0.85
      ]
    , Style.style StarHoverStyle
      [ Style.opacity 0.5
      ]
    , Style.style UrlStyle
      -- [ Color.text <| Color.rgb 30 80 200
      [ Color.text <| Color.rgb 0 100 180
      , Font.weight 900
      ]
    , Style.style ItemInspectorStyle
      [ Color.border <| gray100
      , Color.background <| Color.rgb 255 255 255
      , Border.all 1
      , Shadow.simple
      ]
    , Style.style ItemInspectorImageStyle
      [ Color.border <| gray100
      , Border.all 1
      ]
    , Style.style StartedItemsSectionStyle
      [ Color.background <| colorStarted
      ]
    , Style.style StartedItemsHeadingStyle
      [ Color.text <| Color.white
      , Font.size sectionHeadingSize
      ]
    , Style.style CompletedItemsSectionStyle
      [ Color.background <| gray180
      ]
    , Style.style CompletedItemsHeadingStyle
      [ Color.text <| gray50
      , Font.size sectionHeadingSize
      ]
    , Style.style ExploreHeadingStyle
      [ Color.text <| gray50
      , Font.size sectionHeadingSize
      , Font.weight 600
      ]
    , Style.style GreetingSectionStyle
      [ Color.background <| Color.rgb 93 135 172
      ]
    , Style.style GreetingHeadingStyle
      [ Color.text <| Color.white
      , Font.size 32
      , Style.opacity 0.8
      ]
    , Style.style ItemInspectorProgressStyle
      [ Color.border <| gray180
      -- , Color.background <| gray230
      -- , Border.top 1
      , Border.bottom 1
      ]
    , Style.style InspectedRatingsHeadingStyle
      [ Color.text <| gray50
      , Font.size 15
      , Font.weight 600
      ]
    , Style.style WhiteButtonStyle
      [ Color.border <| gray100
      , Border.all 1
      ]
    , Style.style BlueButtonStyle
      [ Color.border <| gray100
      , Color.text <| Color.white
      , Color.background <| Color.rgb 32 107 162
      , Border.all 1
      ]
    , Style.style AgreeButtonStyle
      [ Color.border <| gray100
      , Border.all 1
      ]
    , Style.style ModalOverlayStyle
      [ Color.background <| Color.black
      , Style.opacity 0.75
      ]
    , Style.style ModalTextStyle
      [ Color.text <| Color.white
      , Font.size 24
      ]
    ]


gray50 = Color.rgb 50 50 50

gray100 = Color.rgb 100 100 100

gray180 = Color.rgb 180 180 180

gray230 = Color.rgb 230 230 230

colorStarted = Color.rgb 38 57 73

view : Model -> Html Msg
view ({ui} as model) =
  viewport stylesheet <|
  (column NoStyle [ height fill ] [ renderPageHeader model, renderPageBody model ]
  |> above [ renderModal model ]
  )


renderModal model =
 text "Not implemented"
 |> el ModalTextStyle [ center, verticalCenter ]
 |> el ModalOverlayStyle
      ([ moveDown (model.windowHeight |> toFloat)
      , width (model.windowWidth |> toFloat |> px)
      , height (model.windowHeight |> toFloat |> px)
      ] ++ (if popupVisible model then [] else [ hidden ]))

renderPageHeader model =
  row HeaderStyle [ padding 10, spacing 20 ]
    [ el X5LogoStyle [] (text "x5gon") ]
  |> below [ renderItemInspector model ]


renderPageBody model =
  [ renderGreetingSection model
  , renderStartedItemsSection model
  , renderExploreSection model
  , renderCompletedItemsSection model
  ]
  |> column NoStyle [ width fill, yScrollbar ]


renderGreetingSection model =
  el GreetingHeadingStyle [ verticalCenter, center ] (text "Welcome back, Yvonne")
  |> el GreetingSectionStyle [ height (model.windowHeight * 2 // 3 |> toFloat |> px) ]



renderStartedItemsSection : Model -> Element MyStyles variation Msg
renderStartedItemsSection ({startedItems} as model) =
  column StartedItemsSectionStyle ([ padding 10 ] ++ (if List.isEmpty startedItems then [ hidden ] else []))
    [ el StartedItemsHeadingStyle [] (text "Continue learning")
    , renderPlaylistItems model model.startedItems
    ]


renderCompletedItemsSection : Model -> Element MyStyles variation Msg
renderCompletedItemsSection ({completedItems} as model) =
  column CompletedItemsSectionStyle ([ padding 10 ] ++ (if List.isEmpty completedItems then [ hidden ] else []))
    -- [ el CompletedItemsHeadingStyle [] (text ("You have completed " ++ (items |> List.length |> toString) ++ " items"))
    [ el CompletedItemsHeadingStyle [] (text "Your completed items")
    , renderPlaylistItems model completedItems
    ]


renderExploreSection model =
  [ h2 ExploreHeadingStyle [] (text (if (model.startedItems |> List.isEmpty) && (model.completedItems |> List.isEmpty) then "Start exploring!" else "Explore"))
  , renderPlaylists model
  ]
  |> column ExploreSectionStyle [ width fill, padding 10, spacing 10 ]


renderPlaylists model =
  model.playlists
  |> List.filter (\playlist -> playlist.items |> List.isEmpty |> not)
  |> List.map (renderPlaylist model)
  |> column NoStyle [ width fill, spacing 10 ]


renderPlaylist : Model -> Playlist -> Element MyStyles variation Msg
renderPlaylist model ({heading, items} as playlist) =
  column NoStyle [ padding 10 ]
  [ el PlaylistHeadingStyle [] (text heading)
  , renderPlaylistItems model items
  ]


renderPlaylistItems model items =
  items
  |> List.map (renderPlaylistItem model)
  |> Keyed.row NoStyle [ width fill, height fill, spacing 10 ]
  |> List.singleton
  |> row NoStyle [ width fill, padding 10, spacing 10, xScrollbar ]


-- returns a Keyed element
renderPlaylistItem : Model -> Resource -> (String, Element MyStyles variation Msg)
renderPlaylistItem model resource =
  let
      image =
        decorativeImage NoStyle [ width (px 200), maxHeight (px 106) ] { src = "images/resource_covers/" ++ resource.coverImageStub ++ ".png" }
        |> el NoStyle [ minHeight (px 106) ]
      titleAndDate =
        column NoStyle [ spacing 3, width fill ]
          [ paragraph ResourceTitleStyle [] [ text resource.title ]
          , el HintStyle [ width fill ] (text resource.date)
          -- , renderTagList resource
          ]
        -- , column NoStyle [ spacing 10 ]
        --   [ decorativeImage EllipsisStyle [ width (px 20) ] { src = "images/icons/ellipsis.png" }
        --     |> button NoStyle [ onClick (ToggleItemDropmenu resource), alignRight ]
        --     |> renderItemDropmenu model resource
        --     |> el NoStyle []
        --   ]
      children =
        [ image, titleAndDate ]
      element =
        children
        |> column (if model.completedItems |> List.member resource then Opacity75Style else NoStyle) [ padding 10, spacing 10, maxWidth (px 220) ]
        |> button ResourceStyle [ onClick (InspectItem resource) ]
  in
      (resource.url, element)


renderItemInspector model =
  case model.selectedItem of
    Nothing ->
      (text "")
      |> el ItemInspectorStyle [ hidden ]

    Just resource ->
      let
          item =
            renderInspectedItem model resource
            |> List.singleton
            |> Keyed.row NoStyle [ spacing 10 ]
            |> el NoStyle []
          closeButton =
            button CloseButtonStyle [ onClick CloseItemInspector, alignLeft, padding 10 ] (text "×")
      in
          column ItemInspectorStyle [ width (px inspectorWidth), moveRight (model.windowWidth - inspectorWidth + 2 |> toFloat) ] [ closeButton, item ]


-- returns a Keyed element
renderInspectedItem : Model -> Resource -> (String, Element MyStyles variation Msg)
renderInspectedItem model resource =
  let
      isStarted =
        resource |> isItemStarted model
      image =
        if (resource.url |> String.contains "youtube.") && (resource.url |> String.contains "watch?v=") then
          embeddedYoutubePlayer resource.url
        else
          decorativeImage ItemInspectorImageStyle [ width (px 400), maxHeight (px 212) ] { src = "images/resource_covers/" ++ resource.coverImageStub ++ ".png" }
          |> el NoStyle [ minHeight (px 212) ]
      startButton =
        if isStarted then
          el HintStyle [ padding 10 ] (text "Started")
        else if resource |> isItemCompleted model then
          el HintStyle [ hidden ] (text "")
        else
          button BlueButtonStyle [ onClick (MarkItemAsStarted resource), paddingXY 12 10 ] (text "Start")
      completeButton =
        if resource |> isItemCompleted model then
          el HintStyle [ paddingXY 0 10 ] (text "Completed")
        else
          button (if isStarted then BlueButtonStyle else WhiteButtonStyle) [ onClick (MarkItemAsCompleted resource), paddingXY 12 10 ] (text "Mark as completed")
      actionButtons =
        row ItemInspectorProgressStyle [ paddingTop 5, paddingBottom 15, spacing 10 ] [ startButton, completeButton ]
      ratingsAndRationale =
        [ [ h3 InspectedRatingsHeadingStyle [ paddingBottom 2 ] (text "What other users said"), renderRatingsColumn model resource ratingsFromUsers ]
        , [ h3 InspectedRatingsHeadingStyle [ paddingBottom 2 ] (text "What the x5gon algorithm thought"), renderRecommendationReasons resource ]
        ]
        |> table NoStyle [ width fill, paddingTop 3, spacingXY 2 50 ]
      content =
        column NoStyle [ spacing 10, width fill ]
          [ h3 ResourceTitleStyle [] ( text resource.title )
          , image
          , el HintStyle ([ width fill ] ++ (if resource.date == "" then [ hidden ] else [])) (text resource.date)
          , renderItemDetails model resource
          , actionButtons
          , ratingsAndRationale
          ]
      element =
        [ content ]
        |> column NoStyle [ paddingLeft 10, paddingRight 10, paddingBottom 10, spacing 10, width fill, maxWidth (px (inspectorWidth - 23)) ]
  in
      (resource.url, element)


renderTagList resource =
  resource.tags
  |> Set.toList
  |> List.map renderTag
  |> row NoStyle [ spacing 5 ]


renderTag str =
  el TagStyle [ paddingXY 2 1 ] (text str)


renderItemDetails model resource =
  [ paragraph UrlStyle [] [ text resource.url ] |> newTab resource.url ]
  |> column NoStyle [ spacing 3 ]


-- renderItemAnnotations model resource =
--   let
--       renderAnnotationInput name =
--         Input.text AnnotationInputStyle (if name == attrTextWorkload then [ width (px 40) ] else [])
--           { onChange = ChangeAnnotation resource name
--           , value = getAnnotation model resource name
--           , label = Input.labelLeft <| el NoStyle [] (text name)
--           , options = []
--           }
--       renderAnnotation name =
--         if name == attrTextWorkload then
--           row NoStyle []
--           [ renderAnnotationInput name
--           , Input.checkbox NoStyle [ alignRight ]
--               { onChange = ToggleItemOptional resource
--               , checked = isItemOptional model resource
--               , label = el NoStyle [] (text "optional")
--               , options = []
--               }
--           ]
--         else
--           renderAnnotationInput name
--       ratingEditor =
--         renderRatingEditor model resource
--   in
--       column AnnotationsStyle [ spacing 3, padding 5 ]
--         ((itemAnnotation |> List.map renderAnnotation) ++ [ ratingEditor ])


renderRatingsColumn model resource ratings =
  ratings
  |> List.map (renderRating resource)
  |> (::) (button WhiteButtonStyle [ paddingXY 12 10, onClick UnimplementedAction ] (text "Rate this item") |> el NoStyle [ paddingTop 10 ])
  |> List.reverse
  |> column NoStyle [ spacing 2 ]


-- renderRatingEditor model resource =
--   [ ratingsFromUsers, ratingsFromAlgorithm ]
--   |> List.map (renderEditableRating model resource)
--   |> column NoStyle []


-- renderEditableRating model resource metric =
--   let
--       rateable = (resource.url, metric)
--   in
--       row NoStyle [ spacing 9 ]
--         [ renderStarGraphEditable model rateable ThinvisibleStyle (model.enteredRatings |> Dict.get rateable |> Maybe.withDefault 0)
--         , metric |> text |> el NoStyle [ ] |> el NoStyle [ width (percent 50)]
--         ]


-- renderRatings resource =
--   commonRatingMetrics
--   |> List.map (renderRating resource)
--   |> column NoStyle []


renderRating resource metric =
  row NoStyle [ spacing 5 ]
    [ renderStarGraphStatic InvisibleStyle (computeFakeRating resource metric)
    , metric |> text |> el NoStyle [ width fill ]
    -- , (computeFakeNumberOfRatings resource metric |> toString) ++ " users" |> text |> el NoStyle []
    ]


renderStarGraphStatic hiddenStyle n =
  List.range 1 5
  |> List.map (renderStarStatic n)
  |> row NoStyle []


renderStarGraphEditable model rateable hiddenStyle n =
  List.range 1 5
  |> List.map (renderStarEditable model rateable n)
  |> row NoStyle []


renderStarStatic nStarsOfResource starIndex =
  drawStar (if starIndex <= nStarsOfResource then StarStyle else InvisibleStyle) []


renderStarEditable model rateable nStarsOfResource starIndex =
  let
      isHovering =
        case model.hoveringRating of
          Nothing ->
            False

          Just (r, nStars) ->
            r == rateable && starIndex <= nStars
      style =
        if isHovering then
          StarHoverStyle
        else if starIndex <= nStarsOfResource then
          StarStyle
        else
          ThinvisibleStyle
  in
      drawStar style [ onMouseOver (HoverRating (rateable, starIndex)), onMouseOut UnHoverRating, onClick EnterRating ]


drawStar style events =
  decorativeImage style [ width (px 12), height (px 12) ] { src = "images/icons/star2.svg" }
  |> el NoStyle (events ++ [ paddingXY 0 2 ])


renderRecommendationReasons resource =
  let
      col1 =
        fakeRecommendationReasons
        |> List.map (\reason -> el NoStyle [ width fill ] (text reason) |> List.singleton |> paragraph NoStyle [ verticalCenter ] )
      col2 =
        fakeRecommendationReasons
        |> List.map (\reason -> button AgreeButtonStyle [ verticalCenter, padding 5, onClick UnimplementedAction ] (text "Agree") |> el NoStyle [])
      col3 =
        fakeRecommendationReasons
        |> List.map (\reason -> button AgreeButtonStyle [ verticalCenter, padding 5, onClick UnimplementedAction ] (text "Disagree") |> el NoStyle [])
  in
      [ col1, col2, col3 ]
      |> table NoStyle [ spacing 3 ]


renderDislikeMenu =
  column NoStyle [ spacing 10 ]
    [ paragraph ResourceTitleStyle [] [ text "Don't like this result? Tell us why - thanks!" ]
    , [ "Not an OER", "Not trustworthy", "Low quality", "Doesn't fit my needs", "Doesn't fit my preferences", "Other reason" ]
      |> List.map renderDislikeReasonOption
      |> column NoStyle [ spacing 5 ]
    , el NoStyle [] (text "Never mind, it's fine")
      |> button HintStyle [ onClick RevokeDislike ]
    ]


renderDislikeReasonOption reason =
  el NoStyle [] (text reason)
  |> button DislikeReasonStyle [ paddingXY 5 2, onClick (ConfirmDislike reason) ]


inspectorWidth = 600


embeddedYoutubePlayer url =
  case url |> String.split "watch?v=" |> List.reverse |> List.head of
    Nothing ->
      el NoStyle [] (text "Could not play video")

    Just id ->
      Html.iframe
      [ Html.Attributes.width 560
      , Html.Attributes.height 315
      , Html.Attributes.src ("https://www.youtube.com/embed/" ++ id)
      , Html.Attributes.property "frameborder" (Json.Encode.string "0")
      , Html.Attributes.property "allowfullscreen" (Json.Encode.string "true")
      ] []
      |> html


sectionHeadingSize = 20

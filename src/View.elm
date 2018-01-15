module View exposing (view)

import Html exposing (Html)
import Html.Attributes
import Color exposing (..)
import Set exposing (Set)
import Dict exposing (Dict)
-- import Debug exposing (log)
import Json.Encode
import Json.Decode

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, onCheck, onMouseOver, onMouseOut, onWithOptions)
import Element.Input as Input
import Element.Keyed as Keyed

import Style
import Style.Color as Color
import Style.Font as Font
import Style.Border as Border
import Style.Shadow as Shadow
import Style.Background as Background

import Model exposing (..)
import Model.Ui exposing (..)
import Model.Resource exposing (..)
import Model.FakeData exposing (computeFakeRating, computeFakeNumberOfRatings, ratingsFromUsers, fakeRecommendationReasons)

import Msg exposing (..)
import Util exposing (..)


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
  | StarStyle
  | StarHoverStyle
  | UrlStyle
  | ItemInspectorStyle
  | ItemInspectorImageStyle
  | StartedItemsSectionStyle
  | StartedItemsHeadingStyle
  | NextItemsSectionStyle
  | NextItemsHeadingStyle
  | CompletedItemsSectionStyle
  | CompletedItemsHeadingStyle
  | ExploreHeadingStyle
  | GreetingSectionStyle
  | GreetingHeadingStyle
  | InspectedRatingsHeadingStyle
  | WhiteButtonStyle
  | BlueButtonStyle
  | AgreeButtonStyle
  | ModalOverlayStyle
  | ModalTextStyle
  | MultilineInputStyle
  | InfoButtonStyle
  | InfoPopupStyle
  | TransparentBackgroundStyle


type Variation
  = Disabled
  | LargeFont

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
    , Style.style NextItemsSectionStyle
      [ Color.background <| Color.rgb 21 31 40
      ]
    , Style.style NextItemsHeadingStyle
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
      , Background.coverImage "images/bg8.jpg"
      ]
    , Style.style GreetingHeadingStyle
      [ Color.text <| Color.white
      , Font.size 32
      , Style.opacity 0.8
      ]
    , Style.style InspectedRatingsHeadingStyle
      [ Color.text <| gray50
      , Font.size 15
      , Font.weight 600
      ]
    , Style.style WhiteButtonStyle
      [ Color.border <| gray100
      , Border.all 1
      , Style.variation Disabled
        [-- Color.background Color.grey
          Style.opacity 0.5
        ]
      , Style.variation LargeFont
        [ Font.size 18
        ]
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
    , Style.style MultilineInputStyle
      [ Color.border <| gray100
      , Border.all 1
      ]
    , Style.style InfoButtonStyle
      [ Color.text <| Color.white
      , Color.border <| Color.white
      , Border.all 2
      ]
    , Style.style InfoPopupStyle
      [ Color.background <| Color.white
      , Color.border <| gray100
      , Color.text <| gray50
      , Font.size 13
      , Border.all 1
      ]
    , Style.style TransparentBackgroundStyle
      [ Color.background <| Color.rgba 0 0 0 0
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
 text "Not implemented yet"
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
  , renderNextItemsSection model
  , renderExploreSection model
  , renderCompletedItemsSection model
  ]
  |> column NoStyle [ width fill, yScrollbar, onClick ClickPageBody ]


renderGreetingSection model =
  el GreetingHeadingStyle [ verticalCenter, center ] (text "Welcome back, Stefan")
  |> el GreetingSectionStyle [ height (model.windowHeight - 370 |> toFloat |> px) ]



renderStartedItemsSection : Model -> Element MyStyles Variation Msg
renderStartedItemsSection model =
  let
      items = model.startedItems |> excludeDislikedItems model
      heading = headingStartedItems
  in
      column StartedItemsSectionStyle ([ padding 20 ] ++ (if List.isEmpty items then [ hidden ] else []))
        [ el StartedItemsHeadingStyle [] (text heading)
          |> onRight [ renderInfoButton model "These are the items you marked as started but haven't completed yet." ]
        , renderItemsWithPagination model heading items
        ]


renderNextItemsSection : Model -> Element MyStyles Variation Msg
renderNextItemsSection model =
  let
      items = nextItems model
      heading = headingNextItems
  in
      column NextItemsSectionStyle ([ padding 20 ] ++ (if List.isEmpty items then [ hidden ] else []))
        [ el NextItemsHeadingStyle [] (text heading)
          |> onRight [ renderInfoButton model "These are what the algorithm thinks you might want to check out next, based on your recently completed items, preferences, etc." ]
        , renderItemsWithPagination model heading items
        ]


renderCompletedItemsSection : Model -> Element MyStyles Variation Msg
renderCompletedItemsSection model =
  let
      items = model.completedItems |> excludeDislikedItems model
      heading = headingCompletedItems ++ (List.length items |> toString) ++ " item" ++ (if List.length items == 1 then "" else "s") ++ " - approx. " ++ (items |> List.map .workload |> List.sum |> workloadDisplayText)
  in
      column CompletedItemsSectionStyle ([ padding 20 ] ++ (if List.isEmpty items then [ hidden ] else []))
        [ el CompletedItemsHeadingStyle [] (text heading)
          |> onRight [ renderInfoButton model "These are the items you marked as completed." ]
        , renderItemsWithPagination model heading items
        ]


renderInfoButton model message =
  let
      popup =
        case model.infoPopup of
          Nothing ->
              el NoStyle [ hidden ] (text "")

          Just str ->
            if str == message then
              paragraph NoStyle [ width (px 300) ] [ text message ]
              |> el InfoPopupStyle [ padding 10, moveDown 33, moveRight 38 ]
            else
              el NoStyle [ hidden ] (text "")
  in
      text "?"
      |> circle 17 InfoButtonStyle [ paddingTop 5 ]
      |> button TransparentBackgroundStyle [ moveLeft 40, onClickStopPropagation (OpenInfoPopup message) ]
      |> onLeft [ popup ]

renderExploreSection model =
  [ h2 ExploreHeadingStyle [] (text "Explore")
  , renderPlaylists model
  ]
  |> column ExploreSectionStyle [ width fill, padding 10, spacing 10 ]


renderPlaylists model =
  model.playlists
  |> List.filter (\playlist -> playlist.items |> excludeDislikedItems model |> List.isEmpty |> not)
  |> List.map (renderPlaylist model)
  |> column NoStyle [ width fill, spacing 10 ]


renderPlaylist : Model -> Playlist -> Element MyStyles Variation Msg
renderPlaylist model ({heading} as playlist) =
  let
      items =
        playlist.items |> excludeDislikedItems model
  in
      column NoStyle [ padding 10 ]
      [ el PlaylistHeadingStyle [] (text (heading ++ " (" ++ (List.length items |> toString) ++ ")"))
      , renderItemsWithPagination model heading items
      ]


renderItemsWithPagination model heading allItems =
  let
      leftmostIndex =
        paginationIndex model heading
      nItems =
        allItems |> List.length
      itemsPart =
        allItems
        |> List.drop leftmostIndex
        |> List.take (nItemsPerPage model)
        |> List.map (renderPlaylistItem model)
        |> Keyed.row NoStyle [ padding 10, spacing 10 ]
      buttonStyles =
        [ vary LargeFont True, paddingXY 15 10, verticalCenter ]
      prevButton =
        if leftmostIndex > 0 then
          button WhiteButtonStyle (buttonStyles ++ [ onClick (ChangePageIndex heading (leftmostIndex - (nItemsPerPage model) |> max 0)) ]) (text "‹")
        else
          el NoStyle [] (text "")
      nextButton =
        if nItems > leftmostIndex + (nItemsPerPage model) then
          text "›"
          |> button WhiteButtonStyle (buttonStyles ++ [ onClick (ChangePageIndex heading (leftmostIndex + (nItemsPerPage model))) ])
          |> el NoStyle []
        else
          el NoStyle [] (text "")
  in
  [ prevButton |> el NoStyle [ width (px 40) ]
  , itemsPart
  , nextButton ]
  |> row NoStyle [ paddingXY 0 30, spacing 15 ]



-- returns a Keyed element
renderPlaylistItem : Model -> Resource -> (String, Element MyStyles Variation Msg)
renderPlaylistItem model item =
  let
      image =
        decorativeImage NoStyle [ width (px 200), maxHeight (px 106) ] { src = "images/resource_covers/" ++ item.coverImageStub ++ ".png" }
        |> el NoStyle [ minHeight (px 106) ]
      titleAndInfo =
        column NoStyle [ spacing 3, width fill, minHeight (px 80) ]
          [ paragraph ResourceTitleStyle [ height (px 75)] [ text item.title ]
          , renderItemDateAndTypeAndWorkload model item
          ]
        -- , column NoStyle [ spacing 10 ]
        --   [ decorativeImage EllipsisStyle [ width (px 20) ] { src = "images/icons/ellipsis.png" }
        --     |> button NoStyle [ onClick (ToggleItemDropmenu item), alignRight ]
        --     |> renderItemDropmenu model item
        --     |> el NoStyle []
        --   ]
      children =
        [ image, titleAndInfo ]
      element =
        children
        |> column (if model.completedItems |> List.member item then Opacity75Style else NoStyle) [ padding 10, spacing 10, maxWidth (px 220) ]
        |> button ResourceStyle [ onClickStopPropagation (InspectItem item) ]
  in
      (item.url, element)


renderItemInspector model =
  case model.inspectedItem of
    Nothing ->
      (text "")
      |> el ItemInspectorStyle [ hidden ]

    Just item ->
      let
          closeButton =
            button CloseButtonStyle [ onClick CloseItemInspector, alignLeft, padding 10 ] (text "×")
          content =
            case model.inspectorMode of
              ShowItem ->
                renderInspectedItem model item
                |> List.singleton
                |> Keyed.row NoStyle [ spacing 10 ]
                |> el NoStyle []

              AskReasonForHidingItem ->
                renderDislikeItemReasonsMenu item

              ThanksForReasonForHidingItem ->
                el ResourceTitleStyle [ center, verticalCenter ] (text "Thanks!")
                |> el NoStyle [ height (px 220), paddingBottom 40 ]
      in
          column ItemInspectorStyle [ width (px inspectorWidth), moveRight (model.windowWidth - inspectorWidth - 9 |> toFloat) ] [ closeButton, content ]


-- returns a Keyed element
renderInspectedItem : Model -> Resource -> (String, Element MyStyles Variation Msg)
renderInspectedItem model item =
  let
      isStarted =
        item |> isItemStarted model
      image =
        if (item.url |> String.contains "youtube.") && (item.url |> String.contains "watch?v=") then
          embeddedYoutubePlayer item.url
        else
          decorativeImage ItemInspectorImageStyle [ width (px 400), maxHeight (px 212) ] { src = "images/resource_covers/" ++ item.coverImageStub ++ ".png" }
          |> el NoStyle [ width fill, minHeight (px 212) ]
      startButton =
        if isStarted then
          el HintStyle [ padding 10, center ] (text "Started")
        else if item |> isItemCompleted model then
          el HintStyle [ hidden ] (text "")
        else
          button BlueButtonStyle [ onClick (MarkItemAsStarted item), paddingXY 12 10 ] (text "Mark as started")
      completeButton =
        if item |> isItemCompleted model then
          el HintStyle [ paddingXY 0 10 ] (text "Completed")
        else
          button (if isStarted then BlueButtonStyle else WhiteButtonStyle) [ onClick (MarkItemAsCompleted item), paddingXY 12 10 ] (text "Mark as completed")
      dislikeButton =
        button WhiteButtonStyle [ onClick (DislikeItem item), paddingXY 12 10 ] (text "Remove")
      actionButtons =
        [ startButton
        , completeButton
        , button WhiteButtonStyle [ onClick UnimplementedAction, paddingXY 12 10 ] (text "I need help here")
        , button WhiteButtonStyle [ onClick UnimplementedAction, paddingXY 12 10 ] (text "Too easy for me")
        , button WhiteButtonStyle [ onClick UnimplementedAction, paddingXY 12 10 ] (text "Recap in a week")
        , dislikeButton ]
        |> column NoStyle [ paddingLeft 15, spacing 3, width fill ]
        |> el NoStyle []
      myNotes =
        [ h3 InspectedRatingsHeadingStyle [ paddingTop 10 ] (text "Your notes")
        , Input.multiline MultilineInputStyle [ padding 3 ]
            { onChange = ChangeMyNotes item
            , value = model.myNotesForItems |> Dict.get item.url |> Maybe.withDefault ""
            , label = Input.labelAbove <| text ""
            , options = []
            }
        ]
        |> column NoStyle []
      ratingsAndRationale =
        [ [ h3 InspectedRatingsHeadingStyle [ paddingBottom 2 ] (text "What other users said"), renderRatingsColumn model item ratingsFromUsers ]
        , [ h3 InspectedRatingsHeadingStyle [ paddingBottom 2 ] (text "Why our system recommended this item to you"), renderRecommendationReasons item ]
        ]
        |> table NoStyle [ width fill, paddingTop 20, spacingXY 2 80 ]
      content =
        column NoStyle [ spacing 10, width fill ]
          [ h3 ResourceTitleStyle [] ( text item.title )
          , row NoStyle [] [ image, actionButtons ]
          , renderItemDateAndTypeAndWorkload model item
          -- , el HintStyle ([ width fill ] ++ (if item.date == "" then [ hidden ] else [])) (text item.date)
          , renderItemDetails model item
          , ratingsAndRationale
          , myNotes
          ]
      element =
        [ content ]
        |> column NoStyle [ paddingLeft 10, paddingRight 10, paddingBottom 10, spacing 10, width fill, maxWidth (px (inspectorWidth - 23)) ]
  in
      (item.url, element)


renderTagList item =
  item.tags
  |> Set.toList
  |> List.map renderTag
  |> row NoStyle [ spacing 5 ]


renderTag str =
  el TagStyle [ paddingXY 2 1 ] (text str)


renderItemDetails model item =
  [ paragraph UrlStyle [] [ text item.url ] |> newTab item.url ]
  |> column NoStyle [ spacing 3 ]


renderRatingsColumn model item ratings =
  ratings
  |> List.map (renderRating item)
  |> (::) (button WhiteButtonStyle [ paddingXY 12 10, onClick UnimplementedAction ] (text "Rate this item") |> el NoStyle [ paddingTop 10 ])
  |> List.reverse
  |> column NoStyle [ spacing 2 ]


-- renderRatingEditor model item =
--   [ ratingsFromUsers, ratingsFromAlgorithm ]
--   |> List.map (renderEditableRating model item)
--   |> column NoStyle []


-- renderEditableRating model item metric =
--   let
--       rateable = (item.url, metric)
--   in
--       row NoStyle [ spacing 9 ]
--         [ renderStarGraphEditable model rateable ThinvisibleStyle (model.enteredRatings |> Dict.get rateable |> Maybe.withDefault 0)
--         , metric |> text |> el NoStyle [ ] |> el NoStyle [ width (percent 50)]
--         ]


-- renderRatings item =
--   commonRatingMetrics
--   |> List.map (renderRating item)
--   |> column NoStyle []


renderRating item metric =
  row NoStyle [ spacing 5 ]
    [ renderStarGraphStatic InvisibleStyle (computeFakeRating item metric)
    , metric |> text |> el NoStyle [ width fill ]
    -- , (computeFakeNumberOfRatings item metric |> toString) ++ " users" |> text |> el NoStyle []
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


renderRecommendationReasons item =
  let
      col1 =
        fakeRecommendationReasons
        |> List.map (\reason -> el NoStyle [ width fill ] (text ("“"++reason++".”")) |> List.singleton |> paragraph NoStyle [ verticalCenter ] )
      col2 =
        fakeRecommendationReasons
        |> List.map (\reason -> button AgreeButtonStyle [ verticalCenter, padding 5, onClick UnimplementedAction ] (text "Agree") |> el NoStyle [])
      col3 =
        fakeRecommendationReasons
        |> List.map (\reason -> button AgreeButtonStyle [ verticalCenter, padding 5, onClick UnimplementedAction ] (text "Disagree") |> el NoStyle [])
  in
      [ col1, col2, col3 ]
      |> table NoStyle [ spacing 3 ]


renderDislikeItemReasonsMenu item =
  column NoStyle [ paddingLeft 10, paddingRight 10, paddingBottom 10, spacing 10 ]
    [ paragraph ResourceTitleStyle [] [ text "You won't see this item anymore. Please give feedback" ]
    , [ "Didn't fit my needs", "Didn't fit my preferences", "Not an open educational resource", "Not trustworthy", "Low quality", "Other reason" ]
      |> List.map renderReasonOptionForHidingItem
      |> column NoStyle [ spacing 5 ]
    , el NoStyle [] (text "Undo")
      |> button HintStyle [ onClick (UndoDislikeItem item) ]
    ]


renderReasonOptionForHidingItem reason =
  el NoStyle [] (text reason)
  |> button WhiteButtonStyle [ paddingXY 12 10, onClick (SelectReasonForHidingItem reason) ]
  |> el NoStyle []


inspectorWidth = 740


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
      |> el NoStyle []


sectionHeadingSize = 20


onClickStopPropagation message =
  onWithOptions "click" { stopPropagation = True, preventDefault = False } (Json.Decode.succeed message)


renderItemDateAndTypeAndWorkload model item =
  row NoStyle [ width fill ]
    [ text (item.mediaType |> capitalize) |> el HintStyle [ width fill ]
    , text (workloadDisplayText item.workload) |> el HintStyle [ width fill ]
    , text item.date |> el HintStyle [ width fill ]
    ]

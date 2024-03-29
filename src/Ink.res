/**
Construct your own bindings with a theme.

Colors in ink simply use chalk under the hood so hex-codes/rgb and color keywords are supported.

Often it's nicer to specify your own theme and call like this:
module InkWithTheme = MakeInkWithTheme({
type theme =
  | @as("#9860E5") Primary
  | @as("#FFBB2F") Secondary
  | @as("#6CBFEE") Info
  | @as("#FF8269") Danger
  | @as("#3B8C3D") Success
})

Now anywhere that uses a color will take your themed variant instead of a string
*/
module MakeInkWithTheme = (
  S: {
    type theme
  },
) => {
  module StyleTheme = Style.MakeStyleWithTheme(S)
  open StyleTheme
  type instance = {
    rerender: React.element => unit,
    unmount: unit => unit,
    waitUntilExit: unit => promise<unit>,
    clear: unit => unit,
  }
  type readableStream
  type writableStream
  type options = {
    stdout?: writableStream,
    stdin?: readableStream,
    exitOnCtrlC?: bool,
    patchConsole?: bool,
    debug?: bool,
  }
  @module("ink")
  external renderInternal: (React.element, ~options: option<options>) => instance = "render"

  let render = (~options=?, element) => {
    renderInternal(element, ~options)
  }
  type measurement = {width: int, height: int}

  @module("ink")
  external measureElement: React.ref<'a> => measurement = "measureElement"

  module Text = {
    type wrapOptions =
      | @as("wrap") Wrap
      | @as("truncate") Truncate
      | @as("truncate-start") TruncateStart
      | @as("truncate-middle") TruncateMiddle
      | @as("truncate-end") TruncateEnd

    /**
This component can display text, and change its style to make it bold, underline, italic or strikethrough.
Note: <Text> allows only text nodes and nested <Text> components inside of it. For example, <Box> component can't be used inside <Text>.
    */
    @module("ink")
    @react.component
    external make: (
      ~children: React.element,
      ~color: S.theme=?,
      ~backgroundColor: S.theme=?,
      ~dimColor: bool=?,
      ~bold: bool=?,
      ~italic: bool=?,
      ~underline: bool=?,
      ~strikethrough: bool=?,
      ~inverse: bool=?,
      ~wrap: wrapOptions=?,
    ) => React.element = "Text"
  }

  module Box = {
    /**
<Box> is an essential Ink component to build your layout. It's like <div style="display: flex"> in the browser.
    */
    @module("ink")
    @react.component
    external make: (
      ~children: React.element=?,
      ~width: numOrStr=?,
      ~height: numOrStr=?,
      ~minWidth: int=?,
      ~minHeight: int=?,
      ~padding: int=?,
      ~paddingTop: int=?,
      ~paddingBottom: int=?,
      ~paddingLeft: int=?,
      ~paddingRight: int=?,
      ~paddingX: int=?,
      ~paddingY: int=?,
      ~margin: int=?,
      ~marginTop: int=?,
      ~marginBottom: int=?,
      ~marginLeft: int=?,
      ~marginRight: int=?,
      ~marginX: int=?,
      ~marginY: int=?,
      ~gap: int=?,
      ~rowGap: int=?,
      ~flexGrow: int=?,
      ~flexShrink: int=?,
      ~flexBasis: numOrStr=?,
      ~flexDirection: flexDirection=?,
      ~flexWrap: flexDirection=?,
      ~alignItems: alignItems=?,
      ~alignSelf: alignSelf=?,
      ~justifyContent: justifyContent=?,
      ~display: display=?,
      ~overflow: overflow=?,
      ~overflowX: overflow=?,
      ~overflowY: overflow=?,
      ~borderStyle: borderStyle=?,
      ~borderColor: S.theme=?,
      ~borderTopColor: S.theme=?,
      ~borderRightColor: S.theme=?,
      ~borderBottomColor: S.theme=?,
      ~borderLeftColor: S.theme=?,
      ~borderDimColor: bool=?,
      ~borderTopDimColor: bool=?,
      ~borderRightDimColor: bool=?,
      ~borderBottomDimColor: bool=?,
      ~borderLeftDimColor: bool=?,
      ~borderTop: bool=?,
      ~borderRight: bool=?,
      ~borderBottom: bool=?,
      ~borderLeft: bool=?,
    ) => React.element = "Box"
  }

  module Newline = {
    /**
Adds one or more newline characters. Must be used within <Text> components.
  */
    @module("ink")
    @react.component
    external make: (~count: int=?) => React.element = "Newline"
  }

  module Spacer = {
    /**
A flexible space that expands along the major axis of its containing layout. It's useful as a shortcut for filling all the available spaces between elements.

For example, using <Spacer> in a <Box> with default flex direction (row) will position "Left" on the left side and will push "Right" to the right side.
  */
    @module("ink")
    @react.component
    external make: unit => React.element = "Spacer"
  }

  module Static = {
    /**
<Static> component permanently renders its output above everything else. It's useful for displaying activity like completed tasks or logs - things that are not changing after they're rendered (hence the name "Static").

It's preferred to use <Static> for use cases like these, when you can't know or control the amount of items that need to be rendered.
  */
    @module("ink")
    @react.component
    external make: (
      ~children: ('a, int) => React.element,
      ~items: array<'a>,
      ~style: styles=?,
    ) => React.element = "Static"
  }

  module Transform = {
    /**
  Transform a string representation of React components before they are written to output. For example, you might want to apply a gradient to text, add a clickable link or create some text effects. These use cases can't accept React nodes as input, they are expecting a string. That's what <Transform> component does, it gives you an output string of its child components and lets you transform it in any way.

  Note: <Transform> must be applied only to <Text> children components and shouldn't change the dimensions of the output, otherwise layout will be incorrect.
  */
    type outputLine = string
    type index = int
    @module("ink") @react.component
    external make: (
      ~children: string,
      ~tranform: (outputLine, index) => string,
      ~index: int=?,
    ) => React.element = "Transform"
  }

  module Hooks = {
    type key = {
      leftArrow: bool,
      rightArrow: bool,
      upArrow: bool,
      downArrow: bool,
      return: bool,
      escape: bool,
      ctrl: bool,
      shift: bool,
      tab: bool,
      backspace: bool,
      delete: bool,
      pageDown: bool,
      pageUp: bool,
      meta: bool,
    }
    type input = string
    type inputHandler = (input, key) => unit
    type options = {isActive?: bool}

    @module("ink") external useInput: (inputHandler, ~options: options=?) => unit = "useInput"

    type app = {exit: (~err: exn=?) => unit}
    @module("ink") external useApp: unit => app = "useApp"

    type stdin = {
      stdin: readableStream,
      isRawModeSupported: bool,
      setRawMode: bool => unit,
    }

    @module("ink") external useStdin: unit => stdin = "useStdin"

    type stdout = {
      stdout: writableStream,
      write: string => unit,
    }

    @module("ink") external useStdout: unit => stdout = "useStdout"

    type stderr = {
      stderr: writableStream,
      write: string => unit,
    }

    @module("ink") external useStderr: unit => stderr = "useStderr"

    type focusOptions = {autoFocus?: bool, isActive?: bool, id?: string}
    type focus = {isFocused: bool}
    @module("ink") external useFocus: (~options: focusOptions=?) => focus = "useFocus"

    type focusManager = {
      enableFocus: unit => unit,
      disableFocus: unit => unit,
      focusNext: unit => unit,
      focusPrevious: unit => unit,
      focusId: string => unit,
    }
    @module("ink")
    external useFocusManager: unit => focusManager = "useFocusManager"
  }

  module Link = {
    /**Note: Not built into "ink", please install package "ink-link"*/
    @module("ink-link")
    @react.component
    external make: (~children: React.element=?, ~url: string, ~fallback: bool=?) => React.element =
      "default"
  }

  module BigText = {
    type font =
      | @as("block") Block
      | @as("slick") Slick
      | @as("tiny") Tiny
      | @as("grid") Grid
      | @as("pallet") Pallet
      | @as("shade") Shade
      | @as("simple") Simple
      | @as("simpleBlock") SimpleBlock
      | @as("3d") D3
      | @as("simple3d") Simple3D
      | @as("chrome") Chrome
      | @as("huge") Huge
    type align =
      | @as("left") Left
      | @as("center") Center
      | @as("right") Right
    type backgroundColor =
      | @as("transparent") Transparent
      | @as("black") Black
      | @as("red") Red
      | @as("green") Green
      | @as("yellow") Yellow
      | @as("blue") Blue
      | @as("magenta") Magenta
      | @as("cyan") Cyan
      | @as("white") White

    /**Note: Not built into "ink", please install package "ink-big-text"*/
    @module("ink-big-text")
    @react.component
    external make: (
      ~text: string,
      ~font: font=?, //default block
      ~align: align=?, //default left
      ~colors: array<S.theme>=?, //default [system]
      ~backgroundColor: backgroundColor=?, //default transparent
      ~letterSpacing: int=?, //default 1
      ~lineHeight: int=?, //default 1
      ~space: bool=?, //default true
      ~maxLength: int=?,
    ) => React.element = "default"
  }
}

include MakeInkWithTheme({
  //Default bindings just use string theme
  type theme = string
})

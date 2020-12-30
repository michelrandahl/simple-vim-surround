# simple-vim-surround
A vim plugin with simplified vim-surround behavior.

### Motivation for the plugin
*I found some unexpected behavior in the classic vim-surround plugin while coding in Elm and trying to manipulate surrounding square brackets (see examples below). Being relative new to vim-scripting, I found the code in vim-surround plugin too complicated to understand, so I decided to write my own simplified version of the plugin.*

## Install
### SpaceVim
Add following to init.toml
```
[[custom_plugins]]
    repo = "michelrandahl/simple-vim-surround"
    merged = false
```

And under `[options]` add vim-surround to the list of disabled plugins, to make the keybindings available to simple-vim-surround.
```
[options]
    disabled_plugins = ["vim-surround"]
```

### Plug
Add `Plug 'michelrandahl/simple-vim-surround'`

---
## Other recommended options in Vim init file
### Selection in Haskell-style anonomous functions
By default Vim/Neovim cannot figure out the correct scope of parantheses if a backslash is involved. This is a problem if you are editing code with a Haskell-like-syntax for anonomous functions, for example:
```
(\(x,y) -> ...)
```
Luckily this can be solved with a Vim `cpoption` (lookup `:help cpoptions` and view existing cpoptions with `:set cpoptions?`). Add following to your init.vim, to solve the problem:
```
set cpoptions+=M
```

### Avoid selection of leading whitespace when selecting strings
By default Vim/Neovim will select any leading whitespace when selecting a string using `va`. For example, when standing on `f` in the following code and typing `va"` in normal mode, Vim will select `' "foobar"'`, -this can be quite annoying if you only intend to select `"foobar"`.
```
, "foobar"
```
If you don't want to include leading whitespace, you can add following remapings to your vim.init:
```
nnoremap va' v2i'
nnoremap va" v2i"
nnoremap va` v2i`
```


---

# Keybindings summary
* Delete surrounding: `ds<char>`
* Change surrounding: `cs<old_char><new_char>`
* Surround current line: `yss<char>`
* Surround visual selection: `S<char>`

---

## Delete surrounding chars
Delete surrounding chars by pressing `ds<char>`.

### Examples
#### Example 1
```
"lorum blablabla"
```
Press `ds"` to delete the surrounding `"`
```
lorum blablabla
```
#### Example 2
```
[ foobar
  , blabla
  , stuff [] [lorem ipsum]]
```
With the cursor at the word `foobar` press `ds[` to delete surrounding `[]`
```
 foobar
  , blabla
  , stuff [] [lorem ipsum]
```
#### Example 3
```
viewRelatedPhoto : String -> Html Msg
viewRelatedPhoto url =
    img
        [ class "related-photo"
        , onClick (ClickedPhoto url)
        , src (urlPrefix ++ "photos/" ++ url ++ "/thumb")
        ]
        []
```
With the cursor at the word `class` press `ds[` to delete surrounding `[]`
```
viewRelatedPhoto : String -> Html Msg
viewRelatedPhoto url =
    img
         class "related-photo"
        , onClick (ClickedPhoto url)
        , src (urlPrefix ++ "photos/" ++ url ++ "/thumb")
        
        []
```
### Current limitations and bugs
Deleting surrounding chars, where the chars are on different lines, only works for the chars `()[]{}`.

For example, pressing `ds"` to delete the `"` chars in the following text doesn't work:
```
"
foobar
"
```

## Change surrounding char
Change surrounding chars by pressing `cs<old_char><new_char>`

### Examples
#### Example 1
```
"lorum blablabla"
```
Press `cs"'` to change the surrounding `"` to `'`
```
'lorum blablabla'
```
#### Example 2
```
[ foobar
  , blabla
  , stuff [] [lorem ipsum]]
```
With the cursor at the word `foobar` press `cs[(` to change surrounding `[]` to `()`
```
( foobar
  , blabla
  , stuff [] [lorem ipsum])
```
#### Example 3
```
[ foobar
  , blabla
  , stuff [] [lorem ipsum]]
```
With the cursor at the word `lorem` press `cs[{` to delete surrounding `[]` to `{}`
```
[ foobar
  , blabla
  , stuff [] {lorem ipsum}]
```
### Current limitations and bugs
Changing surrounding chars, where the chars are on different lines, only works for the chars `()[]{}`.

For example, pressing `cs"'` to change the `"` chars to `'` in the following text doesn't work:
```
"
foobar
"
```

## Surround current line
Surround the current line with specific chars by pressing `yss<char>`

### Examples
#### Example 1
```
lorum blablabla
```
Press `yss(` to surround with `()`
```
(lorum blablabla)
```

## Surround visual selection
Surround the current visual selection with specific chars by pressing `S<char>`

### Examples
#### Example 1
With the cursor at the begining of the line, visual select following text with `vee`
```
lorum blablabla
```
Then press `S"` to surround with `"`
```
"lorum blablabla"
```
#### Example 2
With the cursor on foobar, first visual select with `vi[`
```
[ foobar
  , blabla
  , stuff [] [lorem ipsum]]
```
Then press `S{` to surround with `{}`
```
[{ foobar
  , blabla
  , stuff [] [lorem ipsum]}]
```
#### Example 3
With the cursor on foo, first visual select with `Vjjj`
```
foo
bar
lorem
ipsum
```
Then press `S(` to surround with `()`
```
(
foo
bar
lorem
ipsum
)
```


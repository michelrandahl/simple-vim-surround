# simple-vim-surround
A vim plugin with simplified vim-surround behavior

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
## Recommended options in Vim init file
By default Vim/Neovim cannot figure out the correct scope of parantheses if a backslash is involved. This is a problem if you are editing Code with a Haskell-like-syntax for anonomous functions, for example:
```
(\(x,y) -> ...)
```
Luckily this can be solved with a Vim `cpoption` (lookup `:help cpoptions` and view existing cpoptions with `:set cpoptions?`):
```
set cpoptions+=M
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

---

# Motivation for the plugin
The classic vim-surround didn't work the same way that I was used to with evil-mode in spacemacs, so I decided to write my own simplified version of vim-surround. Furthermore did I wish to learn vim scripting, so this is my first attempt ever at making a vim plugin.

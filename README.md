# gojson.vim
Imagine you have a struct:
```go
type MassiveStruct struct {
    coolField string
    helpfulField bool
    veryLong int
    TooLarge bool
    bigStruct bool
    cumbersome string
}
```
Now, if you wanted to export every single field into a JSON format, you'd have
to manually add field tags to make it look like this:
```go
type MassiveStruct struct {
    coolField string `json:"cool_field"`
    helpfulField bool `json:"helpful_field"`
    veryLong int `json:"very_long"`
    TooLarge bool `json:"too_large"`
    bigStruct bool `json:"big_struct"`
    Cumbersome string `json:"cumbersome"`
}
```
That can take quite some time. That's why gojson exists!
With gojson, all you have to do is visually select the struct, enter in
`:'<,'>Gojson`, click enter, and everything is done for you! 

If you want, you can opt-in to the `<leader>j` bindings. For example, instead of
typing Gojson as a command, all you have to do is select and click `<leader>j`!
You can even do `<leader>jip` if the struct is its own paragraph, which will do
everything above in just 4 keystrokes!

Enter `:help gojson` for more details.

## Installation 
Install with your favorite plugin manager! For example, with [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'dzfrias/vim-gojson'
```
Or just install it manually, of course.

## Customization
All key bindings are disabled by default. The `Gojson` command is the only thing
enabled by default. Enable all of the `<leader>j` bindings by putting
`let g:gojson_map_keys = 1` into your vimrc.

Alternatively, make your own using this set of `<Plug>` mappings:
```vim
n/x <Plug>Gojson
n   <Plug>GojsonLine
```
(n meaning normal mode compatible and x meaning visual mode compatible)
Again, enter `:help gojson` for more details!

## License
This plugin is licensed under MIT license.

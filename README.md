
# vim trade winds

The missing window movement.

<img src='https://user-images.githubusercontent.com/6655373/42728788-11285302-8791-11e8-9633-f9f5876a8560.jpg' width='300px' alt='we practically did'>

This plugin is best explained with a diagram.  In the following example,
suppose you are in "current win" and would like to move it beneath the
left most window.  This normally would require you to move to the left
window, split it, open the correct buffer, and then finally close the
original window.

trade winds simplifies this procedure by introducing a series of maps
which allow you to move windows into other windows, causing them to be
split.  They are `ctrl-w g` followed by the usual `hjkl` motions.

    +-------------+---------------+           +-------------+---------------+
    |             |               |           |             |               |
    |             |               |           |             |               |
    |             +---------------+           |             |               |
    |             |               | ctrl-w gh |             +---------------+
    |             |               |           |             |               |
    |             +---------------+           +-------------+               |
    |             |               | +-------> |             |               |
    |             |  current win  |           | current win |               |
    |             |               |           |             |               |
    +-------------+---------------+           +-------------+---------------+

This is referred to as a soft move, as opposed to vim's hard moves
`ctrl-w HJKL` which place windows as far as possible in the given
direction.

Likewise, if you would like to move windows down into a split,

    +-------------+-------+-------+           +-----------------+-----------+
    |             |       |       |           |                 |           |
    |             |       |       |           |                 |           |
    | current win |       |       |           |                 |           |
    |             |       |       | ctrl-w gj |                 |           |
    |             |       |       |           |                 |           |
    +-------------+-------+-------+           +-------------+---+-----------+
    |                             | +-------> |             |               |
    |                             |           | current win |               |
    |                             |           |             |               |
    +-----------------------------+           +-------------+---------------+

trade winds also locally converts horizontal splits into vertical ones and
vice-versa.

    +---+-----------------+-------+           +---+---------+-------+-------+
    |   |                 |       |           |   |         |       |       |
    |   |                 |   4   |           | 1 | current | some  |       |
    |   |   current win   |       |           |   | win     | buffer|       |
    |   |                 |       | ctrl-w gj |   |         |       |       |
    |   |                 |       |           |   |         |       |       |
    |   +-----------------+       |           +   |         |       |       |
    |   |                 |       | +-------> |   |         |       |       |
    |   |   some buffer   |       |           |   |         |       |       |
    |   |                 |       |           |   |         |       |       |
    +---+-----------------+-------+           +---+---------+-------+-------+

Of course, you may have to resize the windows yourself.  You may prefer
to use the option `equalalways`.

If the window is already touching a side of the tab page, `ctrl-w gh`
behaves just like `ctrl-w H` (etc).  This means if you use a soft move
repeatedly, a window will eventually end up all the way in a particular
direction.

    +-------------+-------+-------+           +-------------+-------+-------+
    |             |       |       |           |             |       |       |
    |             |       |       |           |             |       |       |
    | current win |       |       |           |             |       |       |
    |             |       |       | ctrl-w gh |             |       |       |
    |             |       |       |           | current win |       |       |
    |-------------+-------+-------|           |             +-------+-------+
    |                             | +-------> |             |               |
    |                             |           |             |               |
    |                             |           |             |               |
    +-----------------------------+           +-------------+---------------+

## Installation

Requires vim 8.0.1364 or neovim (exact version uncertain).

If you use [vim-plug](https://github.com/junegunn/vim-plug), then add the
following line to your vimrc file:

```vim
Plug 'andymass/vim-tradewinds'
```

and then use `:PlugInstall`.  Or, you can use vim's built-in plugin system
(`:help packadd`) or any other plugin manager.

## Maps

    <c-w>gh: soft move left
    <c-w>gj: soft move down
    <c-w>gk: soft move up
    <c-w>gl: soft move right

To disable all maps, use
```vim
let g:tradewinds_no_maps = 1
```

If you would like to change the map prefix from `ctrl-w g`, use for
instance,
```vim
let g:tradewinds_prefix = '<c-w>e'
```

If you want full control, make your own mappings
```vim
nmap <leader>h <plug>(tradewinds-h)
nmap <leader>j <plug>(tradewinds-j)
nmap <leader>k <plug>(tradewinds-k)
nmap <leader>l <plug>(tradewinds-l)
```

trade winds won't try to make its usual maps if you have made your own,
and it wont step on your existing maps.

Alternatively, you can make maps which use the `TradewindsMove` command:
```vim
let g:tradewinds_no_maps = 1

nnoremap <silent> <c-w>g<left>  :TradewindsMove h<cr>
nnoremap <silent> <c-w>g<down>  :TradewindsMove j<cr>
nnoremap <silent> <c-w>g<up>    :TradewindsMove k<cr>
nnoremap <silent> <c-w>g<right> :TradewindsMove l<cr>
```

## Customization

Before moving a window, trade winds looks for a variable named
`g:tradewinds#prepare`.  This can be set to a reference or name of a
function which takes two arguments: the current window number and the
target window number.  Returning 1 will cancel the movement.

After a window move is performed, trade winds fires the `User` autocmd
`TradeWindsAfterVoyage`.  This can be used, for example, to fix up
statuslines or other window properties:

    autocmd User TradeWindsAfterVoyage call DoSomething()

## Caveats

The windows are not actually moving.  Instead, a new window is created
containing the correct buffer and then old one is closed.  This could lead
to unpredictable results.  For example, plugins which rely on `w:`
variables being set in particular ways may have trouble.

If you notice any problems, please open an issue.

## Self-promotion

Check out my other plugin,
[match-up](https://github.com/andymass/vim-matchup).

## Acknowledgments

This plugin was inspired by Scott Pierce's [vim-window][1].  In that
plugin, the `ctrl-w g[hjkl]` are referred to as "glue window" and behave
very differently.

[1]: https://github.com/ddrscott/vim-window


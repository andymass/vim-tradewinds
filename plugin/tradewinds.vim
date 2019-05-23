" vim trade winds - the missing window movement
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

if !get(g:, 'tradewinds_enabled', 1) || &cp
  finish
endif

if !exists('*win_screenpos') && !exists('*nvim_win_get_position')
  echoerr 'trade winds does not support this version of vim'
  finish
endif

if exists('g:loaded_tradewinds')
  finish
endif
let g:loaded_tradewinds = 1

command! -nargs=1 TradewindsMove call tradewinds#softmove(<q-args>)

nnoremap <silent> <plug>(tradewinds-h) :<c-u>TradewindsMove h<cr>
nnoremap <silent> <plug>(tradewinds-j) :<c-u>TradewindsMove j<cr>
nnoremap <silent> <plug>(tradewinds-k) :<c-u>TradewindsMove k<cr>
nnoremap <silent> <plug>(tradewinds-l) :<c-u>TradewindsMove l<cr>

" terminal maps
if has('terminal')
  tnoremap <silent> <plug>(tradewinds-h) <c-w>:<c-u>TradewindsMove h<cr>
  tnoremap <silent> <plug>(tradewinds-j) <c-w>:<c-u>TradewindsMove j<cr>
  tnoremap <silent> <plug>(tradewinds-k) <c-w>:<c-u>TradewindsMove k<cr>
  tnoremap <silent> <plug>(tradewinds-l) <c-w>:<c-u>TradewindsMove l<cr>
endif

if !get(g:, 'tradewinds_no_maps', 0)
  function! s:map(mode, lhs, rhs, ...)
    if !hasmapto(a:rhs, a:mode)
          \ && ((a:0 > 0) || (maparg(a:lhs, a:mode) ==# ''))
      silent execute a:mode . 'map <silent> ' a:lhs a:rhs
    endif
  endfunction

  let s:pfx = get(g:, 'tradewinds_prefix', '<c-w>g')
  call s:map('n', s:pfx.'h', '<plug>(tradewinds-h)')
  call s:map('n', s:pfx.'j', '<plug>(tradewinds-j)')
  call s:map('n', s:pfx.'k', '<plug>(tradewinds-k)')
  call s:map('n', s:pfx.'l', '<plug>(tradewinds-l)')

  if has('terminal') && !get(g:, 'tradewinds_no_terminal_maps', 0)
    call s:map('t', s:pfx.'h', '<plug>(tradewinds-h)')
    call s:map('t', s:pfx.'j', '<plug>(tradewinds-j)')
    call s:map('t', s:pfx.'k', '<plug>(tradewinds-k)')
    call s:map('t', s:pfx.'l', '<plug>(tradewinds-l)')
    if s:pfx ==# '<c-w>g'
      call s:map('tnore', '<c-w><c-w>', '<c-w><c-w>')
    endif
  endif

  unlet s:pfx
endif

" vim: fdm=marker sw=2


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
  unlet s:pfx
endif

" vim: fdm=marker sw=2


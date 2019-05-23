" vim trade winds - the missing window movement
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! tradewinds#softmove(dir) abort
  if len(a:dir) != 1 || stridx('hjkl', a:dir) < 0
    return
  endif

  " if there is only one window just cause a beep
  if winnr('$') == 1
    execute 'wincmd' toupper(a:dir)
    return
  endif

  let l:bufnr = bufnr('')
  let l:winid = win_getid(winnr())
  let l:lastwinid = win_getid(winnr('#'))

  let l:vars = w:   " this is a reference!
  let l:view = winsaveview()
  let l:opts = getwinvar(0, '&')
  let l:save_stl = &l:statusline

  let l:pos = tradewinds#winindir#win_screenpos(0)

  " get window in target direction instead of using
  " wincmd because sizes might change when splitting
  if has('patch-8.1.1140')
    let l:target = winnr(a:dir)
  else
    let l:target = tradewinds#winindir#get(a:dir)
  endif

  " allow the user to cancel
  if exists('g:tradewinds#prepare')
    if call(g:tradewinds#prepare, [winnr(), l:target])
      return
    endif
  endif

  " hard HJKL movements can be used here
  if l:target == 0 || l:target == winnr()
    execute 'wincmd' toupper(a:dir)
    call s:AfterVoyage()
    return
  endif

  let l:targetid = win_getid(l:target)
  let l:targetpos = tradewinds#winindir#win_screenpos(l:target)
  let l:flags = ''

  " try to place the new window in the natural position
  " - if the current window is at least as big as the target then
  "   compare the cursor position and the midpoint of the target window
  " - if the current window is smaller than the target
  "   then compare the midpoints of the current and target windows
  if a:dir ==# 'h' || a:dir ==# 'l'
    if l:pos[0] +
          \ (winheight(0) >= winheight(target)
          \   ? winline()-1 : winheight(0) / 2)
          \ <= l:targetpos[0] + winheight(target) / 2
      let l:flags = 'leftabove'
    else
      let l:flags = 'rightbelow'
    endif
  else
    if l:pos[1] +
          \ (winwidth(0) >= winwidth(target)
          \   ? wincol()-1 : winwidth(0) / 2)
          \ <= l:targetpos[1] + winwidth(target) / 2
      let l:flags = 'leftabove vertical'
    else
      let l:flags = 'rightbelow vertical'
    endif
  endif

  " go to the target window
  call win_gotoid(l:targetid)

  " ..and make the split (and edit existing buffer)
  if !empty(bufname(l:bufnr))
    silent execute l:flags 'split #'.l:bufnr
  else
    let l:save_swb = &switchbuf
    set switchbuf=
    silent execute l:flags 'sbuffer' l:bufnr
    let &switchbuf=l:save_swb
  endif

  " restore window variables
  call extend(w:, l:vars)

  " now close the old window
  execute win_id2win(l:winid).'wincmd c'
  let l:winid = win_getid(winnr())

  " restore window options
  " but not statusline because it causes more trouble than it's worth
  for [l:o, l:v] in items(l:opts)
    if getwinvar(0, '&'.l:o) !=# l:v && l:o !=# 'statusline'
      call setwinvar(0, '&'.l:o, l:v)
    endif
  endfor

  " restore view
  call winrestview(l:view)

  " try to fix the prior window CTRL-W p
  if l:lastwinid > 0
    call win_gotoid(l:lastwinid)
    call win_gotoid(l:winid)
  endif

  call s:AfterVoyage()
endfunction

function! s:AfterVoyage()
  if exists('#User#TradeWindsAfterVoyage')
    doautocmd <nomodeline> User TradeWindsAfterVoyage
  endif
endfunction

let &cpo = s:save_cpo

" vim: fdm=marker sw=2


" vim trade winds - the missing window movement
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! s:WinRect(winnr)
  let l:pos = tradewinds#winindir#win_screenpos(a:winnr)
  return { 'top': l:pos[0],
        \ 'left': l:pos[1],
        \ 'bottom': l:pos[0] + winheight(a:winnr) - 1,
        \ 'right': l:pos[1] + winwidth(a:winnr) - 1,
        \}
endfunction

function! s:Between(a, b, x)
    return a:a <= a:x && a:x <= a:b
endfunction

function! s:WinIsInDir(winnr, dir)
  if a:winnr == winnr()
    return 0
  endif

  let l:this = s:WinRect(0)
  let l:other = s:WinRect(a:winnr)
  let l:curpos = [l:this.top + winline() - 1,
        \ l:this.left + wincol() - 1]

  let l:touches = 0
  let l:cursor = 0

  if a:dir ==# 'k'
    let l:touches = l:this.top == l:other.bottom + 2
    " extend one down for vertical separator
    let l:cursor = s:Between(l:other.left, l:other.right + 1, l:curpos[1])
  elseif a:dir ==# 'j'
    let l:touches = l:this.bottom == l:other.top - 2
    let l:cursor = s:Between(l:other.left, l:other.right, l:curpos[1])
  elseif a:dir ==# 'h'
    let l:touches = l:this.left == l:other.right + 2
    let l:cursor = s:Between(l:other.top, l:other.bottom, l:curpos[0])
  elseif a:dir ==# 'l'
    let l:touches = l:this.right == l:other.left - 2
    " extend one down for statusline
    let l:cursor = s:Between(l:other.top, l:other.bottom + 1, l:curpos[0])
  endif

  return l:touches && l:cursor
endfunction

function! tradewinds#winindir#get(dir) abort
  let l:w = filter(range(1,winnr('$')), 's:WinIsInDir(v:val, a:dir)')
  return len(l:w) ? l:w[0] : 0
endfunction

function! tradewinds#winindir#win_screenpos(win) abort
  if exists('*win_screenpos')
    return win_screenpos(a:win)
  else
    let l:pos = nvim_win_get_position(
          \ a:win < 1000 ? win_getid(a:win) : a:win)
    return [l:pos[0]+1, l:pos[1]+1]
  endif
endfunction

let &cpo = s:save_cpo

" vim: fdm=marker sw=2


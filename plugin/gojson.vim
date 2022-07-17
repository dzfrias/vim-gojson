" =============================================================================
" File: plugin/gojson.vim
" Description: Generate struct JSON tags with ease
" Author: Diego Frias <github.com/dzfrias>
" =============================================================================

if exists('g:loaded_gojson') || &compatible
  finish
endif

let g:loaded_gojson = 1

" field_regex matches a struct field (in golang)
const s:field_regex = '\v^\s*\w+\s+\w+$'

if !exists('g:gojson_map_keys')
  let g:gojson_map_keys = 1
endif

function! s:ApplyTags(count=0) abort
  " Count is applied if the user enters this as a command over selected text
  if a:count > 1
    " Get selected lines
    let lines = getline(line('.'), a:count)
    call s:ApplyTagsLoop(lines)
    return
  endif
  let lnum = line('.')
  let l = getline(lnum)
  if l !~? s:field_regex
    return
  endif
  let newl = s:AddJsonTag(l)
  call setline(lnum, newl)
endfunction

function! s:ApplyTagsOpFunc(type) abort
  " Only works if motion is linewise
  if a:type !=? 'line'
    return
  endif
  " Get text over motion
  let lines = getline("'[", "']")
  call s:ApplyTagsLoop(lines)
endfunction

function! s:ApplyTagsLoop(lines) abort
  let curline = line('.')
  " Loop over the lines and apply a tag to them if they match the regex
  for l in a:lines
    if l !~? s:field_regex
      let curline += 1
      continue
    endif
    let newl = s:AddJsonTag(l)
    call setline(curline, newl)
    let curline += 1
  endfor
endfunction

function! s:AddJsonTag(l) abort
  let lsplit = split(a:l, ' ')
  if len(lsplit) == 0
    return a:l
  endif
  let field_name = lsplit[0]
  " Makes field tag
  let tag = '`json:"' . s:ToSnakeCase(field_name) . '"`'
  return a:l . ' ' . tag
endfunction

function! s:ApplyTagsLine() abort
  call s:ApplyTags(1)
endfunction

function! s:ToSnakeCase(input) abort
  let str = a:input
  let str = substitute(str, '\v(\u+)(\u\l)', '\1_\2', 'g')
  let str = substitute(str, '\v(\l|\d)(\u)', '\1_\2', 'g')
  return tolower(str)
endfunction

autocmd Filetype go
      \ xnoremap <silent> <Plug>Gojson     :<C-u>'<,'>call <SID>ApplyTags()<CR>
      \ nnoremap <silent> <Plug>Gojson     :<C-u>set opfunc=<SID>ApplyTagsOpFunc<CR>g@
      \ nnoremap <silent> <Plug>GojsonLine :<C-u> call <SID>ApplyTagsLine()<CR>
      \ if g:gojson_map_keys
        \ xnoremap <leader>j  <Plug>Gojson
        \ nnoremap <leader>j  <Plug>Gojson
        \ nnoremap <leader>jj <Plug>GojsonLine
      \ endif
      \ autocmd Filetype go command! -range Gojson call <SID>ApplyTags(<count>)

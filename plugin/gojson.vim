" =============================================================================
" File: plugin/gojson.vim
" Description: Create struct field tags with ease
" Author: Diego Frias <github.com/dzfrias>
" =============================================================================

if exists('g:loaded_gojson') || &compatible
  finish
endif

let g:loaded_gojson = 1

const s:field_regex = '\v^\s*\w+\s+\w+$'

if !exists('g:gojson_map_keys')
  let g:gojson_map_keys = 1
endif

function! s:ApplyTags(count=0) abort
  if a:count > 1
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
  if a:type !=? 'line'
    return
  endif
  let lines = getline("'[", "']")
  call s:ApplyTagsLoop(lines)
endfunction

function! s:ApplyTagsLoop(lines) abort
  let curline = line('.')
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
  let tag = '`json:"' . s:ToSnakeCase(field_name) . '"`'
  return a:l . ' ' . tag
endfunction

function! s:ToSnakeCase(input) abort
  let str = a:input
  let str = substitute(str, '\v(\u+)(\u\l)', '\1_\2', 'g')
  let str = substitute(str, '\v(\l|\d)(\u)', '\1_\2', 'g')
  return tolower(str)
endfunction

" TODO: Provide number prefixable command
xnoremap <silent> <Plug>GoJson :<C-u>'<,'>call <SID>ApplyTags()<CR>
nnoremap <silent> <Plug>GoJson :<C-u>set opfunc=<SID>ApplyTagsOpFunc<CR>g@
if g:gojson_map_keys
  xnoremap <leader>j <Plug>GoJson
  nnoremap <leader>j <Plug>GoJson
endif

command! -range Gojson call <SID>ApplyTags(<count>)

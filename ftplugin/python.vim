if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

function IndentLines(lines, indent)
	let result = []
	for line in a:lines
		let finalstr = ""
		let i = 0
		while i < a:indent
			let finalstr = finalstr . " "
			let i = i + 1
		endwhile

		let finalstr = finalstr . line
		call add(result, finalstr)
	endfor
	return result
endfunction

function GetDocstringDef(line, indent)
	let splits_i = 0
	let splits = split(a:line, ' ')

	" get to after def
	while splits_i < len(splits)
		let splits_i = splits_i + 1
		if splits[splits_i-1] =~ "def"
			break	
		endif
	endwhile

	let methodsignature = []
	let tobreak = 0
	while splits_i < len(splits)
		if splits[splits_i] =~ ")"
			let tobreak = 1
		endif

		let str = substitute(splits[splits_i], "\s\+", "", "g")
		call add(methodsignature, str)
		let splits_i = splits_i + 1
		if tobreak == 1
			break
		endif 
	endwhile

	let methodstring = join(methodsignature, "")
	let methodstring = substitute(methodstring, "):", ")", "g")
	let methodstring = substitute(methodstring, "[(),]", " ", "g")
	" strip whitespace
	let methodstring = substitute(methodstring,'\v^\s*(.{-})\s*$','\1','')

	let argument_names = []
	let argument_types = []
	if methodstring =~ " "
		let methodparts = split(methodstring, " ")
		let method_name = methodparts[0]

		let i = 1
		while i < len(methodparts)
			let argparts = split(methodparts[i], ":")
			let argname = argparts[0]
			let argtype = ""	
			if len(argparts) >= 2
				let argtype = argparts[1]
			endif

			call add(argument_names, argname)
			call add(argument_types, argtype)
			let i = i + 1
		endwhile
	else
		let method_name = methodstring
	endif
	
	let lines =  ['"""' . g:googledocstrings_todo, '', g:googledocstrings_todo] 
	let arglines = ['', 'Args:'] 
	let original_arglines_len = len(arglines)
	let i = 0
	while i < len(argument_names)
		let argline = '    ' . argument_names[i]
		if len(argument_types[i]) > 0
			let argline = argline . " ("
			if argument_types[i] =~ "="
				let argtype = substitute(argument_types[i], "=.*", "", "g")
				let argline = argline . argtype . ", optional"
			else
				let argline = argline . argument_types[i]
			endif
		    let argline = argline . ")"
		endif
		let argline = argline . ": " . g:googledocstrings_todo
		call add(arglines, argline)
		let i = i + 1
	endwhile

	if len(arglines) != original_arglines_len
		let lines = lines + arglines
	endif

	let returnType = ""
	if splits_i < len(splits)
		if splits[splits_i] =~ "->"
			let returnType = splits[splits_i + 1] 
			let returnType = substitute(returnType, ":", "", "g")
		endif
	endif


	if returnType == ""
		let returnType = g:googledocstrings_todo
	endif

	call add(lines, '')
	call add(lines, 'Returns:')
	call add(lines, '    ' . returnType . ': ' . g:googledocstrings_todo)
	call add(lines, '"""')
	call add(lines, '')
	return IndentLines(lines, a:indent)
endfunction

function GetDocstringHeader()
	let lines = []
	call add(lines, '"""A short description.')
	call add(lines, '')
	call add(lines, 'Author: ' . g:googledocstrings_author)
	call add(lines, 'Email: ' . g:googledocstrings_email)
	call add(lines, 'Last Modified: ' . strftime('%x %X (%Z)')) 
	call add(lines, '"""')
	return lines
endfunction

function GoogleDocstringsGendoc()
	let begin = line('^')
	let end = line('$')

	if getline('^') !~ '"""'
		call append(line('^'), GetDocstringHeader())
		let end = line('$')
	endif

	" Scan for def docstrings.
	let i = begin
	while i < end
		let line = getline(i)
		let nextline = getline(i+1)
		if line =~ "def" && nextline !~ '"""'
			call append(i, GetDocstringDef(line, indent(i + 1)))
			let end = line('$')
		endif
		let i = i + 1
	endwhile
endfunction

define ['droplet-helper', 'droplet-parser'], (helper, parser) ->

  lexCSVLine = (line, f) ->
    if line.length == 0
      return
    field = ''
    quoted = false
    startColno = 0
    for i in [0..line.length-1]
      char = line.charAt(i)
      if !quoted && char == ","
        f(field, startColno)
        field = ''
        startColno = i + 1
        continue
      if char == '"'
        quoted = !quoted
      field += char
    f(field, startColno)

  class CSVParser extends parser.Parser
    LINE_COLOR = '#007777'

    markRoot: ->
      lineno = 0
      for line in @text.split '\n'
        @markLine line, lineno
        lineno++

    markLine: (line, lineno) ->
      @addBlock({
        bounds: {
          start: {line: lineno, column: 0}
          end: {line: lineno, column: line.length}
        }
        depth: 1
        color: LINE_COLOR
      })
      lexCSVLine(line, (field, colno) =>
        console.log(field, lineno, colno)
        @markField(field, lineno, colno)
      )

    markField: (field, lineno, colno) ->
      @addSocket({
        bounds: {
          start: {line: lineno, column: colno}
          end: {line: lineno, column: colno + field.length}
        }
        depth: 2
      })

  return parser.wrapParser CSVParser

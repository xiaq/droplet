readFile = (name) ->
  q = new XMLHttpRequest()
  q.open 'GET', name, false
  q.send()
  return q.responseText

require.config
  baseUrl: '../js'
  paths: JSON.parse readFile '../requirejs-paths.json'

require ['droplet'], (droplet) ->

  # Example palette
  window.editor = new droplet.Editor document.getElementById('editor'), {
    mode: 'csv'
    modeOptions: {
      functions: {
      }
    }
    palette: [
      {
        name: 'CSV Line'
        color: 'blue'
        blocks: [
          {block:'a', title:'one field'}
          {block:'a,b', title:'two fields'}
          {block:'"a,a",b,c', title:'three fields'}
          {block:'"a,a",b,c,d', title:'four fields'}
        ]
      }
    ]
    ## #
  }

  # Example program (fizzbuzz)
  examplePrograms = {
    fizzbuzz: '''
    fizz,buzz,fizzbuzz,fizz
    buzz,fizz,buzzfizz,buzz
    '''
    empty: ''
  }

  editor.setEditorState false
  editor.aceEditor.getSession().setUseWrapMode true

  # Initialize to starting text
  startingText = localStorage.getItem 'example'
  editor.setValue startingText or examplePrograms.fizzbuzz

  # Update textarea on ICE editor change
  onChange = ->
    localStorage.setItem 'example', editor.getValue()

  editor.on 'change', onChange

  editor.aceEditor.on 'change', onChange

  # Trigger immediately
  do onChange

  document.getElementById('which_example').addEventListener 'change', ->
    editor.setValue examplePrograms[@value]

  editor.clearUndoStack()

  messageElement = document.getElementById 'message'
  displayMessage = (text) ->
    messageElement.style.display = 'inline'
    messageElement.innerText = text
    setTimeout (->
      messageElement.style.display = 'none'
    ), 2000

  document.getElementById('toggle').addEventListener 'click', ->
    editor.toggleBlocks()

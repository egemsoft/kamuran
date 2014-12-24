#!
# kamuran
# Random suggestion helper.
# Unnecessary at all.
# @license MIT
# @author İsmail Demirbilek
#

do () ->
  request = require 'request'
  dashdash = require 'dashdash'
  fs = require 'fs'
  colors = require 'colors'
  pwuid = require 'pwuid'
  pkg = require '../package.json'

  mkDotDir = (callback) ->
    try
      fs.mkdir "#{pwuid().dir}/.kamuran", '0777', (err) ->
        throw new Error 'Home directory is not writable.' if err
        do callback
    catch e
      console.error 'kamuran: %s', e.stack
    

  updatePlaces = (callback) ->
    try
      fs.exists "#{pwuid().dir}/.kamuran", (exists) ->
        if !exists
          mkDotDir () ->
            updatePlaces callback
        else
          console.log 'Updating places...'.yellow
          request.get 'https://raw.githubusercontent.com/egemsoft/kamuran/master/places.json', (error, response, body) ->
            if !error and response.statusCode is 200
              fs.writeFile "#{pwuid().dir}/.kamuran/places.json", body, (err) ->
                throw new Error 'Places file is not writable.' if err
                console.log 'Places are updated successfully from github repo egemsoft/kamuran.'.green
                do callback if callback?
            else
              throw new Error 'Could not connect to github.' if error
    catch e
      console.error 'kamuran: %s', e.stack


  # return random responses
  suggestResponse = (place) ->
    responses =[
      "#{ place } hiç fena olmaz."
      "#{ place } nasıl fikir?"
      "Ne dersin, #{ place } uyar mı?"
      "#{ place } iyidir #{ do place.toLowerCase }"
      "Neden #{ place } olmasın?"
    ]
    responses[Math.floor Math.random()*responses.length]

  # suggest a random place
  suggest = (type) ->
    if type is undefined or places[type] is undefined
      date = new Date()
      type = if date.getHours() < 14 then 'lunch' else 'dinner'

    console.log suggestResponse places[type][Math.floor Math.random() * (places[type].length)]

  goygoy = ->
    console.log 'İyidir hacı, aynı bildiğin gibi.'

  # say how we are sorry
  unknownResponse = ->
    console.log 'Her şeyi bilmiyorum maalesef.'

    responses:
      suggest: suggest
      goygoy: goygoy

  # answers to the questions
  answers = [{
      answer: suggest
      questions: [
        'suggest'
        'nereye gidelim'
        'nereye gidelim?'
        'nereye gideyim'
        'nereye gideyim?'
        'ne dersin'
        'ne dersin?'
      ]
    }, {
      answer: goygoy
      questions: [
        'ne yaptın'
        'ne yaptın?'
      ]
    }
  ]

  # cli options
  options = [{
      names: ['version', 'v']
      type: 'bool'
      help: 'Print kamuran version, some shameless self promotion and exit.'
    }, {
      names: ['question', 'q']
      type: 'string'
      help: 'Ask question to kamuran. Such as: "nereye gidelim?"'
    }, {
      names: ['suggest', 's']
      type: 'bool'
      help: 'Ask kamuran to suggest a place.'
    }, {
      names: ['type', 't']
      type: 'string'
      help: 'Suggestion type. Can be lunch, dinner or dessert.'
    }, {
      names: ['update']
      type: 'bool'
      help: 'Update places.'
    }, {
      names: ['help', 'h']
      type: 'bool'
      help: 'Help.'
    }
  ]

  fireUp = () ->
    try
      parser = dashdash.createParser options: options
      opts = parser.parse process.argv
    catch e
      console.error 'kamuran: %s', e.stack
      process.exit 1

    if opts.version
      console.log " #{pkg.name} - v#{pkg.version}\n",
        "by #{pkg.author}\n",
        "#{pkg.description}\n"

    else if opts.suggest
      suggest opts.type

    else if opts.question
      question = opts.question
      found = false
      if opts._args.length > 0
        question += ' ' + opts._args.join ' '
      
      answers.forEach (answer) ->
        if answer.questions and typeof answer.questions is 'object' and answer.questions.indexOf(question) > -1
          found = true
          answer.answer opts.type
        else if answer.question and typeof answer.question is 'string' and answer.question is question
          found = true
          answer.answer opts.type
      if found is false
        do unknownResponse

    else if opts.update
      do updatePlaces

    else
      help = parser.help helpincludeEnv: true
        .trimRight()
      console.log 'usage: kamuran [OPTIONS]\n',
        'options:\n',
        help

  try
    places = require "#{pwuid().dir}/.kamuran/places.json"
    # concat common places
    places.lunch = places.lunch.concat places.common
    places.dinner = places.dinner.concat places.common

    # unchain kamuran
    do fireUp
  catch
    console.log 'Places file is not present will fetch it.'.yellow
    updatePlaces fireUp
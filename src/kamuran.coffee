#!
# kamuran
# Random suggestion helper.
# Unnecessary at all.
# @license MIT
# @author İsmail Demirbilek
#

request = require 'request'
dashdash = require 'dashdash'
pkg = require '../package.json'

places = require '../places.json'

request.get 'https://raw.githubusercontent.com/egemsoft/kamuran/master/places.json', (error, response, body) ->
  if !error and response.statusCode is 200
    places = JSON.parse body 

  places.lunch = places.common.concat places.lunch
  places.dinner = places.common.concat places.dinner

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
    names: ['help', 'h']
    type: 'bool'
    help: 'Help.'
  }
]

parser = dashdash.createParser options: options

try
  opts = parser.parse process.argv
catch e
  console.error 'kamuran: error: %s', e.message
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

else
  help = parser.help helpincludeEnv: true
    .trimRight()
  console.log 'usage: kamuran [OPTIONS]\n',
    'options:\n',
    help
#!
# kamuran
# Random suggestion helper.
# Unnecessary at all.
# @license MIT
# @author İsmail Demirbilek
#

request = require 'request'

places = require '../places.json'

request.get 'https://raw.githubusercontent.com/egemsoft/kamuran/master/places.json', (error, response, body) ->
	if !error and response.statusCode is 200
  	places = JSON.parse body 

  places.lunch = places.common.concat places.lunch
	places.dinner = places.common.concat places.dinner

	# unchain kamuran
	do understand

suggestParams = [
	'suggest'
	'nereye gidelim'
	'nereye gidelim?'
	'nereye gideyim'
	'nereye gideyim?'
	'ne dersin'
	'ne dersin?'
]

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

unknownResponse = ->
	console.log 'Her şeyi bilmiyorum maalesef.'

# suggest a random place
suggest = ->
	date = new Date()
	type = if date.getHours() < 14 then 'lunch' else 'dinner'
	console.log suggestResponse places[type][Math.floor Math.random() * (places[type].length)]

# understand the parameters
understand = ->
	return console.log 'Efendim?' if process.argv.length is 2
	return do suggest if process.argv.length is 3 and suggestParams.indexOf(process.argv[2]) isnt -1
	return do suggest if process.argv.length is 4 and suggestParams.indexOf(process.argv[2] + ' ' + process.argv[3]) isnt -1
	  	
	return do unknownResponse
'use strict'

app = angular.module('widgetPlayer')

app.config ['$provide', ($provide) ->
	$provide.value 'widgetMetadata',
		timeEstimateMinutes: "Forever",
		numPages: 3, # Total number of pages
		numSteps: 12, # Total number of steps
		# Some widgets have a feedback survey at the end. If there is a feedback survey at the end of your widget,
		# set this variable to true. Otherwise, leave it false.
		isThereAFeedbackSurvey: false #default is false

]

# Here is your widgetCtrl - this controller operates over all of your pages for
# this popup widget:
app.controller 'widgetCtrl', ['$scope', ($scope) ->
	
	$scope.index = 0
	$scope.ans = 
		correct: 0
	$scope.questions = 
		[
			# {
			# 	q: "Please enter your name",
			# 	correct: false 
			# },

			{
				q: "Click on the mark for inserting a letter.",
				id: "proofRead-insertLetter"
				
			},

			{
				q: "Click on the mark for transposing a group of words."
				id: "proofRead-transposeWords"
				 
			},

			{
				q: "Click on the mark for adding bold formatting."
				id: "proofRead-bold"			 
			},

			{
				q: "Click on the mark for deleting a word."
				id: "proofRead-delete"			 
			},

			{
				q: "Click on the mark for capitalizing a letter."
				id: "proofRead-capitalize"			 
			},
			{
				q: "Click on the mark for adding a hyphen."
				id: "proofRead-dash"			 
			},

			{
				q: "Click on the mark for closing up two paragraphs."
				id: "proofRead-closeParagraphs"			 
			},

			{
				q: "Click on the mark for transposing letters in a word."
				id: "proofRead-transposeLetters"			 
			},

			{
				q: "Click on the mark for ignoring a mark and leaving the 
					text as orginally written."
				id: "proofRead-original"			
			},

			{
				q: "Click on the mark for adding italics font formatting."
				id: "proofRead-italics"		
			}

		]
]


app.controller 'TaskCtrl', ['$scope', 'MateriaService', ($scope, MateriaService) ->
	$scope.currentQuestion = $scope.questions[$scope.index].q
	$scope.nextQuestion = false
	$scope.isCorrect = false
	
	$scope.switchQuestion = ->
		if $scope.index < 9
			$scope.index++
			$scope.counter++
			$scope.nextQuestion = false
			$scope.isCorrect = false
			$scope.currentQuestion = $scope.questions[$scope.index].q
			$scope.state.step++
		else 
			$scope.nextPage()
		
	$scope.checkAns = (id) ->
		if id == $scope.questions[$scope.index].id
			$scope.nextQuestion = true	
			$scope.isCorrect = false
			$scope.questions[$scope.index].correct = true
			$scope.ans.correct++
		else
			$scope.isCorrect = true
]


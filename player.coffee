proofread = angular.module 'proofread', ['ngSanitize']

proofread.controller "proofReadCtrl", ($scope) ->
	$scope.nextQuestion = false
	$scope.isCorrect = false
	$scope.finished = false
	$scope.index = 0
	$scope.showBtn = false
	$scope.el = document.getElementsByClassName("modal")

	$scope.ans =
		correct: 0
		wrong: 0
		wrongStmnt: "Incorrect. Please try again."
		correctStyle: {
					"-moz-box-shadow": "0 0 10px #383636",
					"-webkit-box-shadow": "0 0 10px #383636" ,
					"box-shadow": "0 0 10px #383636",
					"border-bottom":"3px solid #00B033"
				}

	$scope.questions =
		[

			{
				q: "Click on the mark for inserting a letter."
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
			{
				id: "proofRead-insertSpace"
			}
		]

	$scope.currentQuestion = $scope.questions[$scope.index].q
	$scope.displayModal = ->
		$scope.el[0].style.display = 'block'
		console.log($scope.el[0].style)

	$scope.closeModal = (className)->
		if className == 'modal' or className == 'close'
			$scope.el[0].style.display = 'none'
		else
			$scope.el[0].style.display = 'block'

	calculateScore = ->
		if $scope.ans.wrong <= 1
			$scope.ans.correct++

	clearStyle = ->
		for question, indx in $scope.questions
			question.style = {}

	$scope.switchQuestion = ->
		if $scope.index < $scope.questions.length - 2
			$scope.index++
			$scope.counter++
			$scope.nextQuestion = false
			$scope.isCorrect = false
			$scope.showBtn = false
			$scope.currentQuestion = $scope.questions[$scope.index].q
			$scope.ans.wrong = 0
			$scope.ans.wrongStmnt = "Incorrect. Please try again."
			clearStyle()
		else
			$scope.finished = true

	$scope.checkAns = (id, indx) ->
		if id == $scope.questions[$scope.index].id and $scope.ans.wrong < 2
			$scope.questions[indx].style = $scope.ans.correctStyle
			$scope.nextQuestion = true
			$scope.isCorrect = false
			$scope.showBtn = true
			calculateScore()
		else
			$scope.isCorrect = true
			$scope.ans.wrong+=1
			if $scope.ans.wrong == 2
				$scope.questions[$scope.index].style = $scope.ans.correctStyle
				$scope.ans.wrongStmnt = "Incorrect. The correct answer is highlighted."
				$scope.showBtn = true
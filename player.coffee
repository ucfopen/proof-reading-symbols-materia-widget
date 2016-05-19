proofread = angular.module 'proofread', ['ngSanitize']

proofread.controller "proofReadCtrl", ($scope) ->

	$scope.nextQuestion = false
	$scope.isCorrect = false
	$scope.finished = false
	$scope.index = 0
	$scope.showBtn = false
	$scope.ans = 
		correct: 0
		wrong: 1
		wrongStmnt: "Incorrect. Please try again."
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

		]
	$scope.currentQuestion = $scope.questions[$scope.index].q
	calculateScore = ->
		if $scope.ans.wrong == 0
			$scope.ans.correct++
	
	clearStyle = ->
		for test, indx in $scope.questions
			test.style = {}

	$scope.switchQuestion = ->
		if $scope.index < $scope.questions.length - 1
			$scope.index++
			$scope.counter++
			$scope.nextQuestion = false
			$scope.isCorrect = false
			$scope.showBtn = false
			$scope.currentQuestion = $scope.questions[$scope.index].q
			$scope.ans.wrong = 0
			clearStyle()
			
		else 
			$scope.finished = true
	
	$scope.checkAns = (id, indx) ->
		if $scope.ans.wrong != 2
			if id == $scope.questions[$scope.index].id
				$scope.questions[indx].style = {
					"-moz-box-shadow": "0 0 10px #383636", 
					"-webkit-box-shadow": "0 0 10px #383636" ,
					"box-shadow": "0 0 10px #383636", 
					"border-bottom":"3px solid green"
				}

				$scope.nextQuestion = true	
				$scope.isCorrect = false
				$scope.showBtn = true
			else
				$scope.questions[indx].style = {
					"-moz-box-shadow": "0 0 10px #383636", 
					"-webkit-box-shadow": "0 0 10px #383636" ,
					"box-shadow": "0 0 10px #383636", 
					"border-bottom":"3px solid red"
				}
				$scope.isCorrect = true
				$scope.ans.wrong++
		else
			$scope.questions[indx].style = {
				"-moz-box-shadow": "0 0 10px #383636", 
				"-webkit-box-shadow": "0 0 10px #383636" ,
				"box-shadow": "0 0 10px #383636", 
				"border-bottom":"3px solid red"
			}
			$scope.questions[$scope.index].style = {
				"-moz-box-shadow": "0 0 10px #383636", 
				"-webkit-box-shadow": "0 0 10px #383636" ,
				"box-shadow": "0 0 10px #383636", 
				"border-bottom":"3px solid green"
			}
			$scope.ans.wrongStmnt = "Incorrect. The correct answer is highlighted."
			$scope.showBtn = true	

		calculateScore()

				

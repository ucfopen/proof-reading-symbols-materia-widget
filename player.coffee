proofread = angular.module 'proofread', ['ngSanitize']

proofread.controller "proofReadCtrl", ($scope) ->

	$scope.nextQuestion = false
	$scope.isCorrect = false
	$scope.finished = false
	$scope.index = 0
	$scope.ans = 
		correct: 0
		wrong: 0
	$scope.questions = 
		[
			
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
	$scope.currentQuestion = $scope.questions[$scope.index].q
	calculateScore = ->
		if $scope.ans.wrong == 0
			$scope.ans.correct++
		return $scope.ans.correct

	$scope.switchQuestion = ->
		if $scope.index < $scope.questions.length - 1
			$scope.index++
			$scope.counter++
			$scope.nextQuestion = false
			$scope.isCorrect = false
			$scope.currentQuestion = $scope.questions[$scope.index].q
			$scope.ans.wrong = 0
			
		else 
			$scope.finished = true
			
	$scope.checkAns = (id) ->
		if id == $scope.questions[$scope.index].id
			$scope.nextQuestion = true	
			$scope.isCorrect = false
			$scope.questions[$scope.index].correct = true
			calculateScore()
		else
			$scope.isCorrect = true
			$scope.ans.wrong++

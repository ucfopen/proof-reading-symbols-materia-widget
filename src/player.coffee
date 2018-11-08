proofread = angular.module 'proofread', ['ngSanitize']

proofread.controller "proofReadCtrl", ['$scope', ($scope) ->
	$scope.showCorrect = false
	$scope.showModal = false
	$scope.finished = false
	$scope.index = 0
	$scope.showNextBtn = false
	$scope.el = document.getElementsByClassName("modal")
	$scope.ans =
		correct: 0
		wrong: 0
		wrongStmnt: false

	$scope.questions = [
		{
			q: "Click on the mark for inserting a letter."
			id: "proofRead-insertLetter"
			alt: "The word web based with carrot symbol below and two lines above it"
		},

		{
			q: "Click on the mark for transposing a group of words."
			id: "proofRead-transposeWords"
			alt: "The word for with three lines under the first letter"
		},

		{
			q: "Click on the mark for adding bold formatting."
			id: "proofRead-bold"
			alt: "a line going over the word academic and under classroom-based "
		},

		{
			q: "Click on the mark for deleting a word."
			id: "proofRead-delete"
			alt: "The word includes with top/bottom carrot symbol, colon in the middle and the word stet circled above"
		},

		{
			q: "Click on the mark for capitalizing a letter."
			id: "proofRead-capitalize"
			alt: "a line going from the end of the  first paragraph to the beginning of the second paragraph."
		},
		{
			q: "Click on the mark for adding a hyphen."
			id: "proofRead-dash"
			alt: "A line drawn down the middle of the words does and not with a hashtag symbol at the top"
		},

		{
			q: "Click on the mark for closing up two paragraphs."
			id: "proofRead-closeParagraphs"
			alt: "A line drawn over the word very"
		},

		{
			q: "Click on the mark for transposing letters in a word."
			id: "proofRead-transposeLetters"
			alt: "The word interventin with the carrot symbol at the bottom and the letter o at the top"
		},

		{
			q: "Click on the mark for ignoring a mark and leaving the text as orginally written."
			id: "proofRead-original"
			alt: "A wavy line drawn over the word taem"
		},

		{
			q: "Click on the mark for adding italics font formatting."
			id: "proofRead-italics"
			alt: "A single solid line drawn under the words in loco professor"
		}
	]

	# hash map for looking up the index of a question based on it's id
	# key is the value of id, value is the question object
	idHashMap = {}

	$scope.currentQuestion = $scope.questions[$scope.index]


	$scope.start = (instance, qset, version) ->
			for item, index in $scope.questions
				idHashMap[item.id] = item

	$scope.displayModal = ->
		$scope.showModal = true

	$scope.closeModal = ->
		$scope.showModal = false

	calculateScore = ->
		if $scope.ans.wrong <= 1
			$scope.ans.correct++

	clearStyle = ->
		for question in $scope.questions
			correctEl = document.getElementById(question.id)
			correctEl.classList.remove 'highlighted-image'

	$scope.switchQuestion = ->
		if $scope.index < $scope.questions.length - 1
			$scope.index++
			$scope.counter++
			$scope.showCorrect = false
			$scope.showNextBtn = false
			$scope.currentQuestion = $scope.questions[$scope.index]
			$scope.ans.wrong = 0
			$scope.ans.wrongStmnt = false
			clearStyle()
		else
			$scope.finished = true

	$scope.checkAns = (clickedElement, indx) ->
		return if $scope.showNextBtn

		correctEl = document.getElementById($scope.currentQuestion.id)

		if clickedElement.id == $scope.currentQuestion.id
			correctEl.classList.add 'highlighted-image'
			$scope.currentQuestion.style = $scope.ans.highlightStyle
			$scope.showCorrect = true
			$scope.showNextBtn = true
			$scope.ans.wrongStmnt = false
			calculateScore()
			Materia.Score.submitQuestionForScoring $scope.currentQuestion.q, $scope.currentQuestion.alt, idHashMap[clickedElement.id].alt

		else
			$scope.ans.wrong++
			$scope.ans.wrongStmnt = "Incorrect. Please try again."

		if $scope.ans.wrong >= 2
			correctEl.classList.add 'highlighted-image'
			$scope.ans.wrongStmnt = "Incorrect. The correct answer is highlighted."
			$scope.showNextBtn = true
			Materia.Score.submitQuestionForScoring $scope.currentQuestion.q, $scope.currentQuestion.alt, idHashMap[clickedElement.id].alt


	$scope.viewScores = ->
		Materia.Engine.end true

	Materia.Engine.start($scope)
]

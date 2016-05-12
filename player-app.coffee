'use strict'
# ==================== APP ====================

app = angular.module('widgetPlayer', [])

# ==================== CONTROLLERS ====================

app.controller 'popupCtrl', ['$scope', 'MateriaService', 'widgetMetadata', ($scope, MateriaService, widgetMetadata) ->

	$scope.safeApply = (fn) ->
		phase = @$root.$$phase
		if phase is "$apply" or phase is "$digest"
			@$eval fn
		else
			@$apply fn
		return

	$scope.shuffle = (a) ->
		for i in [a.length-1..1]
			j = Math.floor Math.random() * (i + 1)
			[a[i], a[j]] = [a[j], a[i]]
		a

	$scope.state =
		page: -1,
		step: 0,
		error: false,
		phase: 'loading' # loading, running, inTask, paused

	$scope.listeners = {}

	# widgetMetadata should be defined in the widget angular config
	$scope.widget = widgetMetadata

	$scope.start = ->
		$scope.state.phase = "running"

		$scope.state.step = 1
		$scope.state.page = 1

	$scope.prevPage = ->
		return if $scope.state.phase is "paused"

		$scope.state.step--
		$scope.state.page--

	$scope.nextPage = ->
		return if $scope.state.phase is "paused"

		$scope.state.step++
		$scope.state.page++

	$scope.incrementStep = ->
		return if $scope.state.phase is "paused"

		$scope.state.step++

	$scope.decrementStep = ->
		return if $scope.state.phase is "paused"

		$scope.state.step--

	$scope.startTask = ->
		return if $scope.state.phase is "paused"

		$scope.state.phase = "inTask"

	$scope.stopTask = ->
		$scope.state.phase = "running"

	$scope.pause = ->
		return if $scope.state.phase is "inTask"

		$scope.state.phase = "paused"

	$scope.unpause = ->
		$scope.state.phase = "running"

	# allow our directive to set this property. we need to hold on to any
	# listener function so that we can remove it later with removeEventListener
	$scope.setListener = (eventType, fn) ->
		$scope.listeners[eventType] = fn

	$scope.removeListener = (eventType) ->
		delete $scope.listeners[eventType]

	$scope.showError = (message) ->
		if message?
			$scope.state.error = true
			$scope.state.errorMessage = message

	# Call start on Materia, when we get a response start the widget:
	MateriaService.init -> $scope.$apply($scope.start())

	# Variables used for the feedback survey
	$scope.surveys = {
		arrScales: [
			"Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"
		]

		arrNumScales: [
			"1","2","3","4","5"
		]

		arrQuestions: [
		# first group
			"The experiment was fun.",
			"The experiment was interactive.",
			"I would like to see this type of project in all of my classes.",
			"I found the experiment to be informative.",
			"The experiment made me more interested in this type of research.",
		# second group
			"I learned a lot from this experiment.",
			"I have a better understanding of the research process.",
			"This experiment taught me something new.",
			"The instructions for this project were clearly stated.",
			"There were no bugs or issues while performing the experiment."
		]

		arrAnswers: []
	}

	$scope.feedbackState =
		page: 1
		finished: false

]


# ==================== SERVICES ====================

# MateriaService abstracts Materia API methods to call start/end and
# create/save/retrieve storage data tables
app.factory 'MateriaService', ['$location', ($location) ->
	_initCalled = _ready = _instance = _qset = _version = _callback = null

	init: (callback) ->
		if _initCalled then throw 'MateriaService.init already called'

		_initCalled = true
		_callback = callback

		Materia.Engine.start
			start: (instance, qset, version = '1') ->
				_ready    = yes
				_instance = instance
				_qset     = qset
				_version  = version

				_callback()

				_callback = null

# Complete widget
	widgetCompleted: ->
		Materia.Engine.end(false)

# send logs without completing widget
	sendLogs: ->
		Materia.Engine.sendPendingLogs()

	getWidgetData: ->
		ready : _ready
		instance: _instance
		qset: _qset
		version: _version

	createStorageTable: (tableName, columns) ->
		args = columns
		args.splice(0, 0, tableName)
		Materia.Storage.Manager.addTable.apply(this, args)

	insertStorageRow: (tableName, values) ->
		args = values
		args.splice(0, 0, tableName)
		Materia.Storage.Manager.insert.apply(this, args)

	getStorageTableValues: (tableName) ->
		Materia.Storage.Manager.getTable(tableName).getValues()
]


# Stopwatch can be used to record reaction times.
# Call recordTime at the beginning of the event you want to record,
# then call it again at the end of the event - the return value
# is the number of seconds that have passed since the last time
# you called recordTime
app.factory 'Stopwatch', ->
	lastTime = 0

	recordTime: ->
		newTime = (new Date()).getTime()
		diff = newTime - lastTime
		lastTime = newTime

		diff


# KeyEventService stores keyboard events (if your popup-page has specified
# a key-listener attribute). If you are attempting to capture a "printable character"
# like 'A', 'Space', etc then you probably want to use the keypress event.
# If you need to capture other keys that won't print a character (like the
# arrow keys, shift keys, etc) then you should probably use the keydown event.
#
# Usage:
#	Html template:
#		<popup-page ... [on-keypress="onKeypress()"] [on-keydown="onKeydown()"] [on-keyup="onKeyup()"]>...
#	Your controller:
#		app.controller 'myCtrl', ($scope, KeyEventService, ...) ->
#			$scope.onKeypress = ->
#				console.log( KeyEventService.char() )
app.factory 'KeyEventService', ->
	event = null

	setEvent: (newEvent) ->
		event = newEvent

	getEvent: ->
		event

	# keyCode is defined ONLY for keyup and keydown events
	keyCode: ->
		event.keyCode

	# Return true if the event keyCode is one of the codes in the arguments
	# usage: KeyEventService.keyCodeIs(13, 14, ...)
	keyCodeIs: (keyCode1, keyCode2, etc) ->
		for code in arguments
			return true if event.keyCode is code

		false

	# charCode is defined ONLY for keypress events
	charCode: ->
		event.charCode

	char: ->
		String.fromCharCode(event.charCode)

	# Return true if the event char is one of the characters in the arguments
	# usage: KeyEventService.charIs('a', 'A', ...)
	charIs: (char1, char2, etc) ->
		for char in arguments
			return true if String.fromCharCode(event.charCode) is char

		false

	# Case-insensitive version of charIs. Useful if you don't care to differentiate
	# between lowercase and uppercase keys
	# example: KeyEventService.lcharIs('a') returns true if 'a' OR 'A' is pressed
	lcharIs: (char1, char2, etc) ->
		for char in arguments
			return true if String.fromCharCode(event.charCode).toLowerCase() is char.toLowerCase()

		false


# ==================== DIRECTIVES ====================

# Usage:
# <popup-page [in-task] [init-step="N"] [on-keydown="f()"] [on-keypress="f()"] [on-keyup="f()"]>...</popup-page>
#
# in-task: Sets the state to 'inTask'
# init-step: Sets the step count to the given number
# on-keydown: Sets the callback function for the keydown event
# on-keypress: Sets the callback function for the keypress event
# on-keyup: Sets the callback function for the keyup event
app.directive('popupPage', ['KeyEventService', (KeyEventService) ->
	restrict: 'E',
	scope:
		onKeydown:'&'
		onKeypress:'&'
		onKeyup:'&'
	controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
		if $attrs.inTask?
			$scope.$parent.startTask()
		else
			$scope.$parent.stopTask()

		if $attrs.initStep?
			$scope.$parent.state.step = $attrs.initStep
	]
	link: (scope, element, attrs) ->
		if scope.$parent.listeners.keydown?
			document.removeEventListener('keydown', scope.$parent.listeners.keydown, false)
			scope.$parent.removeListener 'keydown'

		if attrs.onKeydown?
			scope.$parent.setListener 'keydown', (event) ->
				KeyEventService.setEvent(event)
				scope.$apply(scope.onKeydown())

			document.addEventListener('keydown', scope.$parent.listeners.keydown, false)


		if scope.$parent.listeners.keypress?
			document.removeEventListener('keypress', scope.$parent.listeners.keypress, false)
			scope.$parent.removeListener 'keypress'

		if attrs.onKeypress?
			scope.$parent.setListener 'keypress', (event) ->
				KeyEventService.setEvent(event)
				scope.$apply(scope.onKeypress())

			document.addEventListener('keypress', scope.$parent.listeners.keypress, false)


		if scope.$parent.listeners.keyup?
			document.removeEventListener('keyup', scope.$parent.listeners.keyup, false)
			scope.$parent.removeListener 'keyup'

		if attrs.onKeyup?
			scope.$parent.setListener 'keyup', (event) ->
				KeyEventService.setEvent(event)
				scope.$apply(scope.onKeyup())

			document.addEventListener('keyup', scope.$parent.listeners.keyup, false)
])

# Usage:
# <footer popup-nav [begin-task] [prev="expr"] [prev-hide-if="expr"] [prev-disabled-if="expr"] [prev-disabled-message="..."] [next="expr"] [next-hide-if="expr"] [next-disabled-if="expr"] [next-disabled-message="..."]></footer>
#
# begin-task: Styles the next button as a Begin Task button
# prev: Expression to execute when clicking previous button. Calls prevPage() if not supplied
# prev-hide-if: If expression is true the previous button is not shown
# prev-disabled-if: If expression is true the previous button is disabled
# prev-disabled-message: Popup message to show if the previous button is disabled and clicked
# next: Expression to execute when clicking next button. Calls nextPage() if not supplied
# next-hide-if: If expression is true the next button is not shown
# next-disabled-if: If expression is true the next button is disabled
# next-disabled-message: Popup message to show if the next button is disabled and clicked
app.directive('popupNav', ->
	restrict: 'A'
	scope:
		prev: '&'
		prevHideIf: '&'
		prevDisabledIf: '&'
		prevDisabledMessage: '@'
		next: '&'
		nextHideIf: '&'
		nextDisabledIf: '&'
		nextDisabledMessage: '@'
	templateUrl: 'popup-nav.html'
	controller: ['$scope', '$element', '$attrs', ($scope, $element, $attrs) ->
		$scope.beginTask = $attrs.beginTask?


		$scope.isFirstPage = ->
			$scope.$parent.state.page <= 1

		$scope.isLastPage = ->
			$scope.$parent.state.page >= $scope.$parent.widget.numPages


		if not $attrs.prev then $scope.prev = $scope.$parent.prevPage
		if not $attrs.next then $scope.next = $scope.$parent.nextPage

		$scope.onPrev = ->
			if $scope.prevDisabledIf()
				$scope.$parent.showError $scope.prevDisabledMessage
				return

			$scope.prev()

		$scope.onNext = ->
			if $scope.nextDisabledIf()
				$scope.$parent.showError $scope.nextDisabledMessage
				return

			$scope.next()


		if $attrs.prevHideIf?
			$scope.isPrevHidden = ->
				$scope.prevHideIf() or $scope.isFirstPage()
		else
			$scope.isPrevHidden = $scope.isFirstPage

		if $attrs.nextHideIf?
			$scope.isNextHidden = ->
				$scope.nextHideIf() or $scope.isLastPage()
		else
			$scope.isNextHidden = $scope.isLastPage


		if not $attrs.prevDisabledIf then $scope.prevDisabledIf = ->
			false

		if not $attrs.nextDisabledIf then $scope.nextDisabledIf = ->
			false


		$scope.nextButtonLabel = if $scope.beginTask then 'Begin Task' else 'Continue'
	]
)

# Usage (example):
# <popup-google-chart
#	packages="['corechart']"
#	type="PieChart"
#	chart-data-array="chart.data" | chart-data-table="chart.data"
#	options="{title: 'My Daily Activities'}"
#	version="1"
# >
#	Chart goes here
#</popup-google-chart>
#
# You must include either chart-data-array or chart-data-table.
# These can either be functions that return the needed data
# or just variables that store the data
app.directive('popupGoogleChart', ->
	restrict: 'E',
	scope:
		packages: '=',
		options: '=',
		chartDataArray: '=',
		chartDataTable: '=',
	link: ($scope, $element, $attrs) ->
		google.load 'visualization', $attrs.version,
			packages: $scope.packages,
			callback: ->
				if $scope.chartDataArray?
					if typeof $scope.chartDataArray is "function"
						data = google.visualization.arrayToDataTable $scope.chartDataArray()
					else
						data = google.visualization.arrayToDataTable $scope.chartDataArray
				else
					if typeof $scope.chartDataTable is "function"
						data = $scope.chartDataTable()
					else
						data = $scope.chartDataTable

				options = $scope.options
				chart = new google.visualization[$attrs.type]($element[0])
				chart.draw(data, options)
)

# For widgets that have a Feedback Survey.
# Some of the variables form this are stored in the popupCtrl controller.
app.controller 'feedbackSurveyCtrl', ['$scope', 'MateriaService', ($scope, MateriaService) ->

	$scope.surveyDeclined =
		response: false

	$scope.$watch "form.$valid", (validity) ->
		$scope.feedbackState.finished = validity

	$scope.nextFeedbackPage = ->
		$scope.feedbackState.page++

	$scope.prevFeedbackPage = ->
		$scope.feedbackState.page--

	$scope.advancer = ->
		if $scope.feedbackState.page == 2
			$scope.nextFeedbackPage()
		else if $scope.feedbackState.page == 3 and $scope.feedbackState.finished == true
			saveSurvey()
			MateriaService.widgetCompleted()
			$scope.nextFeedbackPage()

	$scope.declineFeedbackSurvey = ->
		try
			MateriaService.widgetCompleted()
		catch e
			alert 'Unable to save storage data'

		$scope.feedbackState.page = null
		$scope.surveyDeclined.response = true

	saveSurvey = ->
		try
			MateriaService.createStorageTable("SurveyTable", ["Fun?", "Interactive?", "More?", "Informative?", "Interested?",
				"Learned?","Understand?","Taught you?","Instructions","Bugs?"])

			MateriaService.insertStorageRow("SurveyTable", [$scope.surveys.arrAnswers[1], $scope.surveys.arrAnswers[2], $scope.surveys.arrAnswers[3],
				$scope.surveys.arrAnswers[4], $scope.surveys.arrAnswers[5], $scope.surveys.arrAnswers[6], $scope.surveys.arrAnswers[7], $scope.surveys.arrAnswers[8],
				$scope.surveys.arrAnswers[9], $scope.surveys.arrAnswers[10]])

		catch e
			alert 'Unable to save storage data'

		return

	return
]
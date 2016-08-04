ProofRead = angular.module( 'proofReadCreator', [] )

ProofRead.controller 'proofReadCtrl', ['$scope', ($scope) ->
	_title = _qset = _scope = null
	$scope.widget =
		engineName: ""
		title     : ""
		questions: [
			{
				q: "Click on the mark for inserting a letter."
				ansText: 'Intervention'
				id: 1
			},
			{
				q: "Click on the mark for transposing a group of words."
				ansText: 'Academic Classroom-based'
				id: 2
			},
			{
				q: "Click on the mark for adding bold formatting."
				ansText: 'Apples and Oranges'
				id: 3
			},
			{
				q: "Click on the mark for deleting a word."
				ansText: 'Very'
				id: 4
			},
			{
				q: "Click on the mark for capitalizing a letter."
				ansText: 'For'
				id: 5
			},
			{
				q: "Click on the mark for adding a hyphen."
				ansText: 'Web based'
				id: 6
			},
			{
				q: "Click on the mark for closing up two paragraphs."
				ansText: 'End of first paragraph and beginning of second paragraph'
				id: 7
			},
			{
				q: "Click on the mark for transposing letters in a word."
				ansText: 'Team'
				id: 8
			},
			{
				q: "Click on the mark for ignoring a mark and leaving the
					text as orginally written."
				ansText: 'Includes'
				id: 9
			},
			{
				q: "Click on the mark for adding italics font formatting."
				ansText: 'In loco professor'
				id: 10
			}
			{
				q:''
				ansText: 'Does not'
				id: 11
			}
		]
	# $scope.state =
	# 	isEditingExistingWidget: false

	$scope.initNewWidget = (widget,qset, version) ->
		# _items = _qset.items[0].items
		$scope.$apply ->
			$scope.widget.engineName = $scope.widget.title = widget.name

	$scope.initExistingWidget = (title, widget, qset, version, baseUrl) ->
		# $scope.state.isEditingExistingWidget = true
		$scope.$apply ->
			$scope.widget.engineName = widget.name
			$scope.widget.title     = title

	$scope.onSaveClicked = (mode = 'save') ->
		if _buildSaveData() then Materia.CreatorCore.save _title, _qset
		else Materia.CreatorCore.cancelSave 'Widget not ready to save.'
	$scope.onSaveComplete = (title, widget, qset, version) -> true

	$scope.onMediaImportComplete = (media) -> null

	# Private methods
	_buildSaveData = ->
		if !_qset? then _qset = {}
		_qset.options = {}
		_qset.assets  = []
		_qset.rand    = false
		_qset.name    = ''
		_title        = $scope.widget.title
		_okToSave     = if _title? && _title != '' then true else false

		_items      = []
		_widgetData  = $scope.widget.questions
		_items.push( _process _widgetData[i] ) for i in [0.._widgetData.length-1]
		_qset = { items: _items }
		_okToSave

	_process = (data) ->
		questionObj =
			text  : data.q
		answerObj =
			text  : data.ansText
			value : '100',
			id    : ''

		qsetItem           = {}
		qsetItem.questions = [questionObj]
		qsetItem.answers   = [answerObj]
		qsetItem.type      = 'QA'
		qsetItem.id        = data.id
		qsetItem

	Materia.CreatorCore.start $scope
]
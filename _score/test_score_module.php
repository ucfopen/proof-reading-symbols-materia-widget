<?php
/**
 * @group App
 * @group Materia
 * @group Score
 * @group HelloWidget
 */
class Test_Score_Modules_ProofReadingSymbols extends \Basetest
{

	protected function _get_qset()
	{

		return json_decode('');
	}

	protected function _makeWidget($partial = 'false')
	{
		$this->_asAuthor();

		$title = 'PROOF READING SYMBOLS MODULE';
		$widget_id = $this->_find_widget_id('ProofReadingSymbols');
		$qset = (object) ['version' => 1, 'data' => $this->_get_qset()];
		return \Materia\Api::widget_instance_save($widget_id, $title, $qset, false);
	}

	public function test_check_answer()
	{
		$inst = $this->_makeWidget('false');
		$play_session = \Materia\Api::session_play_create($inst->id);
		$qset = \Materia\Api::question_set_get($inst->id, $play_session);

		$logs = array();

		$logs[] = json_decode('{
			"text":"50",
			"type":1004,
			"value":"",
			"item_id":"'.$qset->data['items'][0]['items'][0]['id'].'",
			"game_time":10
		}');
		$logs[] = json_decode('{
			"text":"ONE HUNDRED5",
			"type":1004,
			"value":"",
			"item_id":"'.$qset->data['items'][0]['items'][1]['id'].'",
			"game_time":10
		}');

		$logs[] = json_decode('{
			"text":"",
			"type":2,
			"value":"",
			"item_id":0,
			"game_time":12
		}');

		$output = \Materia\Api::play_logs_save($play_session, $logs);

		$scores = \Materia\Api::widget_instance_scores_get($inst->id);

		$this_score = \Materia\Api::widget_instance_play_scores_get($play_session);

		$this->assertInternalType('array', $this_score);
		$this->assertEquals(25, $this_score[0]['overview']['score']);
	}
}
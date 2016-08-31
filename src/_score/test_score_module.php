<?php
/**
 * @group App
 * @group Materia
 * @group Score
 * @group HelloWidget
 */
class Test_Score_Modules_Sequencer extends \Basetest
{

	protected function _makeWidget($partial = 'false')
	{
		$this->_asAuthor();

		$title = 'SEQUENCER SCORE MODULE TEST';
		$widget_id = $this->_find_widget_id('Sequencer');
		$qset = (object) ['version' => 1, 'data' => $this->_get_qset()];
		return \Materia\Api::widget_instance_save($widget_id, $title, $qset, false);
	}

	public function test_check_answer()
	{
		$this->_test_full_credit();
		$this->_test_partial_credit();
	}

	function _test_full_credit() {
		$inst = $this->_makeWidget('false');
		$play_session = \Materia\Api::session_play_create($inst->id);
		$qset = \Materia\Api::question_set_get($inst->id, $play_session);

		$logs = array();

		for ($i=1;$i<10;$i++) {
			$logs[] = json_decode('{
				"text":"'.$i.'",
				"type":1004,
				"value":"",
				"item_id":"'.$qset->data['qset']['data']['items'][$i - 1]['id'].'",
				"game_time":10
			}');
		}

		$output = \Materia\Api::play_logs_save($play_session, $logs);

		$scores = \Materia\Api::widget_instance_scores_get($inst->id);

		$this_score = \Materia\Api::widget_instance_play_scores_get($play_session);

		$this->assertInternalType('array', $this_score);
		$this->assertEquals(100, $this_score[0]['overview']['score']);
	}

	function _test_partial_credit() {
		$inst = $this->_makeWidget('false');
		$play_session = \Materia\Api::session_play_create($inst->id);
		$qset = \Materia\Api::question_set_get($inst->id, $play_session);

		$logs = array();

		# Test to make sure that multiple attempts will dock the score
		for ($i=1;$i<10;$i++) {
			$logs[] = json_decode('{
				"text":"'.$i.'",
				"type":1004,
				"value":"",
				"item_id":"'.$qset->data['qset']['data']['items'][$i - 1]['id'].'",
				"game_time":10
			}');
		}
		for ($i=0;$i<3;$i++) {
			$logs[] = json_decode('{
				"text":"attempt_penalty",
				"type":1001,
				"value":-'.$qset->data['qset']['data']['options']['penalty'].',
				"item_id":null,
				"game_time":'.(10 + $i).'
			}');
		}

		$output = \Materia\Api::play_logs_save($play_session, $logs);

		$scores = \Materia\Api::widget_instance_scores_get($inst->id);

		$this_score = \Materia\Api::widget_instance_play_scores_get($play_session);

		$this->assertInternalType('array', $this_score);
		$this->assertEquals(70, $this_score[0]['overview']['score']);
	}
}

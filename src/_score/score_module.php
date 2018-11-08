<?php

namespace Materia;

class Score_Modules_ProofReadingSymbols extends Score_Module
{

	public function check_answer($log)
	{
		if (isset($this->questions[$log->item_id]))
		{
			$q = $this->questions[$log->item_id];
			foreach ($q->answers as $answer)
			{
				if (trim($log->text) == trim($answer['text'])) return $answer['value'];
			}
		}

		return 0;
	}

	protected function details_for_question_answered($log)
	{
		// old version of qset uses default details_for_question_answered function
		if (isset($this->questions[$log->item_id])){
			return parent::details_for_question_answered($log);
		}

		// new version uses responses in the log
		$score = $log->value === $log->text ? 100 : 0;

		return [
			'data' => [
				$log->item_id,
				$log->text
			],
			'data_style'    => ['question', 'response', 'answer'],
			'score'         => $score,
			'type'          => $log->type,
			'style'         => $this->get_detail_style($score),
			'tag'           => 'div',
			'symbol'        => '%',
			'graphic'       => 'score',
			'display_score' => true
		];
	}

	protected function get_score_details()
	{
		$details = [];

		foreach ($this->logs as $log)
		{
			switch ($log->type)
			{
				case Session_Log::TYPE_QUESTION_ANSWERED:
					$details[] = $this->details_for_question_answered($log);
					break;
			}
		}

		if (count($details[0]) && count($details[0]['data']) === 2)
		{
			// new scores only have 2 data points
			$headers = ['Question Score', 'The Question', 'You Selected'];
		}
		else
		{
			// old scores have 3 data points
			$headers = $this->_ss_table_headers;
		}

		return [[
				'title'  => $this->_ss_table_title,
				'header' => $headers,
				'table'  => $details
		]];
	}
}

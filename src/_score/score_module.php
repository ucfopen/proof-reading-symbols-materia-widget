<?php
/**
 * Materia
 * It's a thing
 *
 * @package	    Materia
 * @version    1.0
 * @author     UCF New Media
 * @copyright  2011 New Media
 * @link       http://kogneato.com
 */


/**
 * NEEDS DOCUMENTATION
 *
 * The widget managers for the Materia package.
 *
 * @package	    Main
 * @subpackage  scoring
 * @category    Modules
  * @author     ADD NAME HERE
 */

namespace Materia;

class Score_Modules_ProofReadingSymbols extends Score_Module
{

	private $new_logs = [];
	private $q_ids = null;

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
}
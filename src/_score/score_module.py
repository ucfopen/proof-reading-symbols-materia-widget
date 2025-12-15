from scoring.module import ScoreModule
from core.models import Log

class ProofReadingSymbols(ScoreModule):
    
    def check_answer(self, log):
        score = 100 if log.value.strip() == log.text.strip() else 0
        return score

    def details_for_question_answered(self, log):
        score = 100 if log.value.strip() == log.text.strip() else 0
        
        return {
			"data": [
				log.item_id,
				log.text
			],
			"data_style": ["question", "response", "answer"],
			"score": score,
			"type": log.log_type,
			"style": self.get_detail_style(score),
			"tag": "div",
			"symbol": "%",
			"graphic": "score",
			"display_score": True,
		}

    def get_score_details(self):
        table = []
        for log in self.logs:
            if log.log_type == Log.LogType.SCORE_QUESTION_ANSWERED:
                row = self.details_for_question_answered(log)
                table.append(row)

        if table and len(table[0].get('data', [])) == 2:
            headers = ['Question Score', 'The Question', 'You Selected']
        else:
             headers = self._ss_table_headers

        return [
            {
				"title": self._ss_table_title,
				"headers": headers,
                "table": table,
            }
        ]

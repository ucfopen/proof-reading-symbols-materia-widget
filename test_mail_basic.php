<html>
<head>
<title>Copy Editing</title>
</head>
<body>
<?php

if (isset($_POST['score'], $_POST['first_name'], $_POST['last_name']))
{
	$to         = "cavanagh@ucf.edu";
	$subject    = "ENC 6217-Module 3: Copyediting Grade";
	$name       = trim($_POST['first_name']) . ' ' . trim($_POST['last_name']);
	$body       = str_replace('/', '', "$name received: {$_POST['score']} out of 10.");

	if ( mail($to, $subject, $body) )
	{
		echo "Thank you. Your score has been submitted to the instructor. You may close this window.";
	}
	else
	{
		echo "Mailer Error";
	}
}

?>
</body>
</html>

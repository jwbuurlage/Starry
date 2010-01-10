<?
$xml = '<?xml version="1.0" ?><stars>';
$host = 'localhost';
$user = 'root';
$pass = 'root';
$db = 'sterren';

$connect = mysql_connect($host, $user, $pass);
if(!$connect) {
	echo "Couldn't establish connection.";
}

$select = mysql_select_db($db);
if(!$select) {
	echo "Couldn't select database.";
}

//echo "Start";

$query = mysql_query("SELECT * FROM hyg ORDER BY Mag LIMIT 8000");
//echo mysql_error();
$i=0;

while($fetch = mysql_fetch_object($query)) {
	//echo"Ster ".$fetch->StarID." begonnen<br />";
	$ra = (M_PI/12)*preg_replace('/\s+/','',$fetch->RA);
	$dec = deg2rad(preg_replace('/\s+/','',$fetch->XDec));
	$dec = M_PI/2 - $dec;
	
	$x = 20*sin($dec)*cos($ra);
	$y = 20*sin($dec)*sin($ra);
	$z = 20*cos($dec);
	
	if(preg_replace('/\s+/','',$fetch->bayerFlamsteed) != "" && preg_replace('/\s+/','',$fetch->bayerFlamsteed) != "-" ) {
		mysql_query('UPDATE hyg SET bayerFlamsteed="'.preg_replace('/\s+/','',$fetch->bayerFlamsteed).'" WHERE StarID='.$fetch->StarID.'');
	}
	else {
		mysql_query('UPDATE hyg SET bayerFlamsteed="" WHERE StarID='.$fetch->StarID.'');
	}
	
	$succes = mysql_query('UPDATE hyg SET x='.$x.' AND y='.$y.' AND z='.$z.' WHERE StarID='.$fetch->StarID.'');
	if ($succes) {
		echo"Ster ".$fetch->StarID." gedaan";
	}
	else {
		echo"Ster ".$fetch->StarID." failed".mysql_error();
	}
	
	$i++;
}

echo $i;
?>
<?
$xml = '<?xml version="1.0" ?><constellations>';
$host = 'localhost';
$user = 'root';
$pass = 'root';
$db = 'hyg';

$connect = mysql_connect($host, $user, $pass);
if(!$connect) {
	echo "Couldn't establish connection.";
}

$select = mysql_select_db($db);
if(!$select) {
	echo "Couldn't select database.";
}

$myFile = "constellation_lines.txt";
$fh = fopen($myFile, 'r') or die("can't open file");
$contents = '';
while ( ($buf=fread( $fh, 8192 )) != '' ) {
    $contents .= $buf;
}
if($buf===FALSE) {
    echo "THERE WAS AN ERROR READING\n";
}

$constellations = explode("\n",$contents);
//echo count($constellations)."\n";

foreach($constellations as $constellation) {
	$xml .= '<constellation>';
	$constellationArray = explode(' ',$constellation);
	$xml .=  '<name>'.$constellationArray[0].'</name>';
	$linePoints = $constellationArray[1];
	//echo $linePoints;

	$i = 0;
	while($i < $linePoints) {
		$xml .=  '<line>';
		
		$queryString = "SELECT Hip,RA,XDec FROM hyg WHERE Hip = ".$constellationArray[($i * 2) + 2];
		$query = mysql_query($queryString);
		$fetch = mysql_fetch_object($query);
		
		$ra = (M_PI/12)*preg_replace('/\s+/','',$fetch->RA);
		$dec = deg2rad(preg_replace('/\s+/','',$fetch->XDec));
		$dec = M_PI/2 - $dec;

		$x = 21*sin($dec)*cos($ra);
		$y = 21*sin($dec)*sin($ra);
		$z = 21*cos($dec);
		
		$xml .=  '<point><x>'.$x.'</x><y>'.$y.'</y><z>'.$z.'</z></point>';
		
		$queryString = "SELECT Hip,RA,XDec FROM hyg WHERE Hip = ".$constellationArray[($i * 2) + 3];
		$query = mysql_query($queryString);
		$fetch = mysql_fetch_object($query);
		
		$ra = (M_PI/12)*preg_replace('/\s+/','',$fetch->RA);
		$dec = deg2rad(preg_replace('/\s+/','',$fetch->XDec));
		$dec = M_PI/2 - $dec;

		$x = 21*sin($dec)*cos($ra);
		$y = 21*sin($dec)*sin($ra);
		$z = 21*cos($dec);
		
		$xml .=  '<point><x>'.$x.'</x><y>'.$y.'</y><z>'.$z.'</z></point>';
		$xml .=  '</line>';

		$i += 1; 
	}
	$xml .=  '</constellation>';
}

$xml .= '</constellations>';

$myFile = "../constellations.xml";
$fh = fopen($myFile, 'w') or die("can't open file");
fwrite($fh, $xml);
fclose($fh);

echo 'xml opgeslagen'; 

?>
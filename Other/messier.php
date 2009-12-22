<?
$xml = '<?xml version="1.0" ?><messier>';

$myFile = "messier_data.txt";
$fh = fopen($myFile, 'r') or die("can't open file");
$contents = '';
while ( ($buf=fread( $fh, 8192 )) != '' ) {
    $contents .= $buf;
}
if($buf===FALSE) {
    echo "THERE WAS AN ERROR READING\n";
}

$messier = explode("\n",$contents);
//echo count($constellations)."\n";

foreach($messier as $object) {
	$xml .= '<object>';
	$messierArray = explode(' ',$object);
	$xml .=  '<name>'.$messierArray[0].'</name>';
	    
		$ra = (M_PI/12)*($messierArray[5] + ($messierArray[6] / 60));
		$dec = deg2rad($messierArray[7] + ($messierArray[8] / 60));

		$dec = M_PI/2 - $dec;
		
		$x = 20*sin($dec)*cos($ra);
		$y = 20*sin($dec)*sin($ra);
		$z = 20*cos($dec);
		
		$xml .=  '<point><x>'.$x.'</x><y>'.$y.'</y><z>'.$z.'</z></point>';
        $xml .= '<mag>'.$messierArray[9].'</mag>';
		$xml .= '<constellation>'.$messierArray[3].'</constellation>';
		$xml .= '<distance>'.$messierArray[11].'</distance>';
		$xml .= '<type>'.$messierArray[4].'</type>';
		$xml .= '<ra>'.$messierArray[5].' '.$messierArray[6]."'</ra>";
		$xml .= '<dec>'.$messierArray[7].' '.$messierArray[8]."'</dec>";

	$xml .= '</object>';
}

$xml .= '</messier>';

$myFile = "../messier.xml";
$fh = fopen($myFile, 'w') or die("can't open file");
fwrite($fh, $xml);
fclose($fh);

echo 'xml opgeslagen';

echo $xml; 

?>
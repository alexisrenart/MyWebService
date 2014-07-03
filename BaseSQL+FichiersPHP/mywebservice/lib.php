<?

//setup db connection ("server adress","USER","PASSWORD")
$link = mysqli_connect("localhost","root","");
mysqli_select_db($link,"database") or die("Could not selected database");

//executes a given sql query with the params and returns an array as result
function query() {
	global $link;
	$debug = false;
	
	//get the sql query
	$args = func_get_args();
	$sql = array_shift($args);

	//secure the input
	for ($i=0;$i<count($args);$i++) {
		$args[$i] = urldecode($args[$i]);
		$args[$i] = mysqli_real_escape_string($link, $args[$i]);
	}
	
	//build the final query
	$sql = vsprintf($sql, $args);
	
	if ($debug) print $sql;
	
	//execute and fetch the results
	$result = mysqli_query($link, $sql);
	if (mysqli_errno($link)==0 && $result) {
		
		$rows = array();

		if ($result!==true)
		while ($d = mysqli_fetch_assoc($result)) {
			array_push($rows,$d);
		}
		
		//return json
		return array('result'=>$rows);
		
	} else {
	
		//error
		return array('error'=>'Database error');
	}
}


//loads up the source image, resizes it and saves with -thumb in the file name
function thumb($srcFile, $sideInPx) {
    
    $image = imagecreatefromjpeg($srcFile);
    $width = imagesx($image);
    $height = imagesy($image);
    
    $thumb = imagecreatetruecolor($sideInPx, $sideInPx);
    
    imagecopyresized($thumb,$image,0,0,0,0,$sideInPx,$sideInPx,$width,$height);
    
    imagejpeg($thumb, str_replace(".jpg","-thumb.jpg",$srcFile), 85);
    
    imagedestroy($thumb);
    imagedestroy($image);
}


?>
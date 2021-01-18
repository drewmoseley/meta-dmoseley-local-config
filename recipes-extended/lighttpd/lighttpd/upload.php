<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
  if (is_uploaded_file($_FILES['firmware_image']['tmp_name'])) {
  	if(empty($_FILES['firmware_image']['name'])) {
  		echo "<p>File name is empty!<p>";
  		exit;
  	}
    
  	$upload_file_name = $_FILES['firmware_image']['name'];
  	if (strlen ($upload_file_name)>100) {
  		echo "<p>File name is too long!<p> ";
  		exit;
  	}

  	//replace any non-alpha-numeric cracters in th file name
  	$upload_file_name = preg_replace("/[^A-Za-z0-9 \.\-_]/", '', $upload_file_name);

  	if ($_FILES['firmware_image']['size'] > 1000000) {
		echo "<p>File is too big<p>";
  		exit;        
    }

    $dest=__DIR__.'/uploads/'.$upload_file_name;
    if (move_uploaded_file($_FILES['firmware_image']['tmp_name'], $dest)) {
    	echo '<p>File Has Been Uploaded!<p>';
    }
  }
}
?>

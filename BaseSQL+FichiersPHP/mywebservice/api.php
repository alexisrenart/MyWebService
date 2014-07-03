<?
//API implementation to come here

function errorJson($msg){
	print json_encode(array('error'=>$msg));
	exit();
}




function register($user, $pass, $name1, $name2, $mail, $birthday, $adress1, $adress2, $country, $city, $zipcode) {
	//check if username exists
	$login = query("SELECT username FROM users WHERE username='%s' limit 1", $user);
	if (count($login['result'])>0) {
		errorJson('Username already exists');
	}
    //try to register the user
    $result = query("INSERT INTO users(username, password, firstname, lastname, email, birthdate, adress1, adress2, country, city, zipcode) VALUES('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s')", $user, $pass, $name1, $name2, $mail, $birthday, $adress1, $adress2, $country, $city, $zipcode);
    if (!$result['error']) {
        //success
        $result = query("SELECT iduser, username FROM users WHERE username='%s' limit 1", $user);
        print json_encode($result);
        
    } else {
        //error
        errorJson('Registration failed');
    }
    
}


function login($user, $pass) {
	$result = query("SELECT iduser, username, connected FROM users WHERE username='%s' AND password='%s' limit 1", $user, $pass);
    
    
    
        if (count($result['result'])>0) {
            // Authorized
            $_SESSION['iduser'] = $result['result'][0]['iduser'];
            print json_encode($result);
        
            // Last Connection DateTime
            $date = date('Y-m-d H:i:s');
            $datesql = query("UPDATE users SET lastconnection = '%s' WHERE iduser = '%d'", $date, $_SESSION['iduser']);
            
            if ($result['result'][0]['connected'] == 0) {
            
            $connected = query("UPDATE users SET connected = '1' WHERE iduser = '%d'", $_SESSION['iduser']);
                
            }
        
        } else {
            // Not authorized
            errorJson("Authorization failed! \nTry again or sign in...");
        }
        

}



function checkpass($id, $pass) {
	$result = query("SELECT iduser, username FROM users WHERE iduser='%d' AND password='%s' limit 1", $id, $pass);
    
	if (count($result['result'])>0) {
		//authorized
        print json_encode($result);
        
	} else {
		//not authorized
		errorJson("Wrong password!");
	}
}

function logout() {
    $disconnected = query("UPDATE users SET connected = '0' WHERE iduser = '%d'", $_SESSION['iduser']);
	$_SESSION = array();
	session_destroy();
}


function onoffline($state) {
    
    $onoffline = query("UPDATE users SET connected = '%d' WHERE iduser = '%d'", $state ,$_SESSION['iduser']);
    
    if (!$onoffline['error']) {
        //success
        
        // Last Connection DateTime
        $date = date('Y-m-d H:i:s');
        $datesql = query("UPDATE users SET lastconnection = '%s' WHERE iduser = '%d'", $date, $_SESSION['iduser']);
        
    } else {
        //error
        errorJson('State changes not possible');
    }
}

function readmyprofil($id) {
   
    $result = query("SELECT username, firstname, lastname, email, birthdate, adress1, adress2, country, city, zipcode FROM users WHERE iduser='%s' ", $id);
    if (!$result['error']) {
        //success
        print json_encode($result);
        
    } else {
        //error
        errorJson('Unable SQL request');
    }
}

function updateprofil($id, $name1, $name2, $mail, $adress1, $adress2, $country, $city, $zipcode, $birthday) {
	//check if a user ID is passed
	if (!$id) errorJson('Authorization required');

    // try to update the profil
    $result = query("UPDATE users SET firstname = '%s', lastname = '%s', email = '%s', birthdate = '%s', adress1 = '%s', adress2 = '%s', country = '%s', city = '%s', zipcode = '%s' WHERE iduser = '%d'", $name1, $name2, $mail, $birthday, $adress1, $adress2, $country, $city, $zipcode, $id);
    if (!$result['error']) {
        //success
        
        $result = query("SELECT username, firstname, lastname, email, birthdate, adress1, adress2, country, city, zipcode FROM users WHERE iduser='%s' ", $id);
        if (!$result['error']) {
            //success
            print json_encode($result);
            
        } else {
            //error
            errorJson('Unable SQL request');
        }
        
    } else {
        //error
        errorJson('Save failed');
    }
    
}

function changepass($id, $pass) {
	//check if a user ID is passed
	if (!$id) errorJson('Authorization required');
 
    $result = query("UPDATE users SET password = '%s' WHERE iduser = '%d'", $pass, $id);
    if (!$result['error']) {
        //success
        
        $result = query("SELECT username FROM users WHERE iduser='%s' ", $id);
        if (!$result['error']) {
            //success
            print json_encode($result);
            
        } else {
            //error
            errorJson('Unable SQL request');
        }
        
    } else {
        //error
        errorJson('Save failed');
    }
    
}

function deleteprofil($id, $user) {
    
    // Delete the upload directory of the user
    $folder = "upload/".$user;
    
    if (file_exists($folder)) {
        
        $dossier = $folder;
        $dir_iterator = new RecursiveDirectoryIterator($dossier);
        $iterator = new RecursiveIteratorIterator($dir_iterator, RecursiveIteratorIterator::CHILD_FIRST);
        
        // Delete each directory and each file
        foreach($iterator as $fichier){
            $fichier->isDir() ? rmdir($fichier) : unlink($fichier);
        }
        
        // Delete directory
        rmdir($dossier);
        
        // Delete user and photos from database SQL
        $result = query("DELETE users , photos  FROM users  INNER JOIN photos WHERE users.iduser = photos.iduser AND users.iduser = '%s'", $id);
        
    } else {
        // Delete user and photos from database SQL
        $result = query("DELETE users FROM users WHERE iduser = '%s'", $id);
        
    }
    
    if (!$result['error']) {
        //success
        print json_encode($result);
        
    } else {
        //error
        errorJson('Unabled SQL request');
    }
}

function upload($id, $pseudo, $photoData, $title, $group) {
	//check if a user ID is passed
	if (!$id) errorJson('Authorization required');
    
    
	//check if there was no error during the file upload
	if ($photoData['error']==0) {
        
        $folder = "upload/".$pseudo;
        
        if (!file_exists($folder)) {
            mkdir($folder);
        }
        
        switch ($group) {
            case "profil":
                
                $resultidphoto = query("SELECT idphoto FROM photos WHERE type='%s' AND iduser='%d' limit 1", $group, $id);
                
                if (count($resultidphoto['result'])>0) {
                    if (!$result['error']) {
                        $result = query("UPDATE photos SET title = '%s' WHERE type = 'profil' AND iduser = '%d' AND idphoto = '%d' ", $title, $id, $resultidphoto['result'][0]['idphoto'] );
                    } else {
                        errorJson('Problem SQL UPDATE');
                    }
                } else {
                    if (!$result['error']) {
                        $result = query("INSERT INTO photos(iduser,title,type) VALUES('%d','%s','%s')", $id, $title, $group);
                    } else {
                        errorJson('Problem SQL INSERT');
                    }
                }
                
                $folder = "upload/".$pseudo."/".$group;
                
                if (!file_exists($folder)) {
                    mkdir($folder);
                }
                
                //move the temporarily stored file to a convenient location
                if (move_uploaded_file($photoData['tmp_name'], "upload/".$pseudo."/".$group."/"."profil.jpg")) {
                    //file moved, all good, generate thumbnail
                    thumb("upload/".$pseudo."/".$group."/"."profil.jpg", 180);
                    print json_encode(array('successful'=>1));
                } else {
                    errorJson('Upload on server problem');
                };
                
                break;
                
                
            case "public":
                
                
                break;
                
                
            case "private":
                
                
                break;
        }
        exit();
        
    } else {
		errorJson('Upload malfunction');
	}
}

function erasephoto($id, $user, $group) {
	//check if a user ID is passed
	if (!$id) errorJson('Authorization required');
    
	//check if there was no error during the file upload
	if ($photoData['error']==0) {
        
        $folder = "upload/".$user;
        
        if (!file_exists($folder)) {
            mkdir($folder);
        }
        
        switch ($group) {
            case "profil":
                
                $result = query("SELECT idphoto, title, u.iduser, username FROM photos p JOIN users u ON (u.iduser = p.iduser) WHERE p.type='profil' AND u.username='%s' LIMIT 1", $user);
                
                if (!$result['error']) {
                    
                    if ($result['result'][0]['idphoto']>0) {
                        //print json_encode($result);
                        
                        $result2 = query("DELETE FROM photos WHERE idphoto = '%d'", $result['result'][0]['idphoto']);
                        
                        $folder1 = $folder."/".$group;
                        
                        if (!file_exists($folder1)) {
                            mkdir($folder1);
                        }
                        
                        $folder2 = $folder1."/profil.jpg";
                        if (file_exists($folder2)) {
                            unlink ($folder2);
                        }
                        
                        $folder3 = $folder1."/profil-thumb.jpg";
                        if (file_exists($folder3)) {
                            unlink ($folder3);
                        }
                        
                        
                    }
                    
                    
                } else {
                    errorJson('Database problem');
                }
                
                break;
                
                
            case "public":
                
                
                break;
                
                
            case "private":
                
                
                break;
        }
        exit();
        
    } else {
		errorJson('Erasing malfunction');
	}
}

function myphoto($id, $user, $group) {
    //check if a user ID is passed
	if (!$id) errorJson('Authorization required');
    
    
    switch ($group) {
            
        case "profil":
            
            $result = query("SELECT idphoto, title, u.iduser, username FROM photos p JOIN users u ON (u.iduser = p.iduser) WHERE p.type='profil' AND u.username='%s' LIMIT 1", $user);
            
            if (!$result['error']) {
                if ($result['result'][0]['idphoto']>0) {
                    print json_encode($result);
                }
                
            } else {
                errorJson('Photo loading failed!');
            }
            
            break;
            
        case "public":
            
            
            break;
            
            
        case "private":
            
            
            break;
            
    }
    exit();
    
    
}

function allprofiles($id, $sortby) {
    //check if a user ID is passed
	if (!$id) errorJson('Authorization required');
    
    
    
    
    if ($sortby == "alphab") {
        $result = query("SELECT username, firstname, lastname, country, email, birthdate, adress1, adress2, zipcode, city, lastconnection FROM users ORDER BY username");
    }
    
    if ($sortby == "date") {
        $result = query("SELECT username, firstname, lastname, country, email, birthdate, adress1, adress2, zipcode, city, lastconnection FROM users ORDER BY lastconnection DESC");
    }
    
    if ($sortby == "online") {
        $result = query("SELECT username, firstname, lastname, country, email, birthdate, adress1, adress2, zipcode, city, lastconnection FROM users WHERE connected='1' ORDER BY lastconnection DESC");
        
    }
    
	if (!$result['error']) {
		//authorized
		print json_encode($result);
	} else {
		//not authorized
		errorJson("SQL error");
	}
}



?>
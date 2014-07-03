<?
session_start();
require("lib.php");
require("api.php");

header("Content-Type: application/json");

switch ($_POST['command']) {
    case "login":
		login($_POST['username'], $_POST['password']); break;
        
	case "register":
		register($_POST['username'], $_POST['password'], $_POST['firstname'], $_POST['lastname'], $_POST['email'], $_POST['birthdate'], $_POST['adress1'], $_POST['adress2'], $_POST['country'], $_POST['city'], $_POST['zipcode']); break;
    
    case "logout":
        logout();break;
        
    case "readmyprofil":
		readmyprofil($_POST['iduser']); break;
        
    case "updateprofil":
        updateprofil($_SESSION['iduser'], $_POST['firstname'], $_POST['lastname'], $_POST['email'], $_POST['adress1'], $_POST['adress2'], $_POST['country'], $_POST['city'], $_POST['zipcode'], $_POST['birthdate']); break;
        
    case "checkpass":
		checkpass($_SESSION['iduser'], $_POST['password']); break;
        
    case "changepass":
		changepass($_SESSION['iduser'], $_POST['password']); break;
        
    case "deleteprofil":
		deleteprofil($_POST['iduser'], $_POST['username']); break;
        
    case "upload":
        upload($_SESSION['iduser'], $_POST['username'], $_FILES['file'], $_POST['title'], $_POST['group']); break;
        
    case "erasephotoprofil":
        erasephoto($_SESSION['iduser'], $_POST['username'], $_POST['group']); break;
        
    case "myphoto":
		myphoto($_SESSION['iduser'], $_POST['username'], $_POST['group']); break;
        
    case "allprofiles":
        allprofiles($_SESSION['iduser'], $_POST['sort']); break;

    case "onoffline":
        onoffline($_POST['state']); break;
        
}

exit();
?>
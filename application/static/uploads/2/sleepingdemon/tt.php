
<?php
error_reporting(-1);
ini_set('display_errors', 'On');
class user{
	//inniating variables to be used in db_connect method.
	// Database assess values. 
	
		 public $db_host= "localhost";
		 public $username="root";
		 public $password= "ooo";
		 public $db_name="php_database";
		 public $dbc;
		 public $sql;
		public $row; 
		public $result; 
		public $something;

	function __construct(){
       
        $this->connect();
    }
	
	// method to connect to database
	function connect(){
		try{
			
			$this->dbc= new PDO("mysql:host=$this->db_host; dbname=$this->db_name;charset=utf8", $this->username, $this->password);
		}
		catch (PDOException $e){
			echo "failed to connect to database pdo ";
			echo $e->getmessage();
			exit();
					}
		return $this->dbc;
	}
	
	
	

	public function dbr(){
		$this->sql="SELECT  username, id FROM users";
		
		$stmt=$this->dbc->query($this->sql);
		return $stmt;
		return  $stmt->fetchAll(PDO::FETCH_ASSOC);
   		
		
		
	
	}
}
$usermanagment= new user();



echo "you are an OOP genius";
 echo "<br>";
 try {
  $answer=$usermanagment->dbr();

		 foreach ($answer as $row) {
        print $row['id'] . "\t";
          print $row['username'] . "\n";
		
	  }
} catch(PDOException $ex) {
	echo $ex->getmessage();
   //handle me.
}
  echo "<br>";
 echo $usermanagment->sql;


?>
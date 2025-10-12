<?php
	$id = $_POST["id"];
	$pwd =$_POST["pwd"];

//	$get_id = $_GET["id"];
//	$get_pwd = $_GET["pwd"];
	$db_addr = "localhost";
	$db_id = "root";
	$db_pwd = "MANdky1223!";
	$db_name = "test";
	$conn = new mysqli($db_addr, $db_id, $db_pwd, $db_name);

	if($conn){
	//	echo "접속 성공<br> id=.$get_id.<br>";
	} else {
		echo "접속 실패<br>";
	}

	$sql = "select * from test_table1 where id='".$id."' and pwd='".$pwd."';";
//	echo $sql;

	$result = mysqli_query($conn, $sql);

	while($row = mysqli_fetch_array($result)){
	//	$pkey = $row["pkey"];
	//	$id = $row["id"];
	//	echo "pkey=".$pkey." id=".$id."<br>";
		$login_result=1;
	}

	echo $login_result;
?>

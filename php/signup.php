<?php
	$id = $_POST["id"] ?? "";
	$pwd = $_POST["pwd"] ?? "";
	$birth = $_POST["birth"] ?? "";
	$gender = $_POST["gender"] ?? "";

	if (empty($id) || empty($pwd) || empty($birth) || empty($gender)) {
    		echo "필수 입력값 누락";
    		exit;
	}

	$db_addr = "localhost";
	$db_id = "root";
	$db_pwd = "MANdky1223!";
	$db_name = "test";

	$conn = new mysqli($db_addr, $db_id, $db_pwd, $db_name);

    if ($conn->connect_error) {
        echo "DB 연결 실패: " . $conn->connect_error;
        exit;
    }

    $check_sql = "SELECT * FROM users WHERE id = ?";
    $stmt = $conn->prepare($check_sql);
    $stmt->bind_param("s", $id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        echo "이미 존재하는 ID입니다.";
        $stmt->close();
        $conn->close();
        exit;
    }
    $stmt->close();

    $hashed_pwd = password_hash($pwd, PASSWORD_DEFAULT);
    $sql = "INSERT INTO users (id, pwd, birth, gender) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssss", $id, $hashed_pwd, $birth, $gender);

    if ($stmt->execute()) {
        echo "1";
    } else {
        echo "회원가입 실패: " . $stmt->error;
    }

    $stmt->close();
    $conn->close();
?>


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<form id="signUpForm" method="post" action="/user/sign_up">
	<div class="container col-5 pt-4">
	<h1>회원가입</h1>
		<table class="table border text-center">
			<tr>
				<td class="border">아이디</td>
				<td>
					<div class="d-flex">
						<input type="text" name="loginId" id="loginId" class="form-control mr-1">
						<button type="button" id="idCheckBtn" class="btn btn-success">중복확인</button>
					</div>
					<div id="idCheckLength" class="text-left id d-none"><small class="text-warning">4자 이상 사용하세요.</small></div>
					<div id="idCheckDuplicated" class="text-left id d-none"><small class="text-danger">중복된 아이디입니다.</small></div>
					<div id="idCheckOk" class="text-left id d-none"><small class="text-info">사용가능한 아이디입니다.</small></div>
				</td>
			</tr>
			<tr>
				<td class="border">비밀번호</td>
				<td><input type="password" name="password" id="password" class="form-control"></td>
			</tr>
			<tr>
				<td class="border">비밀번호 확인</td>
				<td><input type="password" id="passwordCol" class="form-control"></td>
			</tr>
			<tr>
				<td class="border">이름</td>
				<td><input type="text" name="name" id="name" class="form-control"></td>
			</tr>
			<tr>
				<td class="border">이메일</td>
				<td><input type="text" name="email" id="email" class="form-control"></td>
			</tr>
		</table>
		<div class="d-flex justify-content-end">
			<button type="submit" id="loginBtn" class="btn btn-primary">회원가입</button>
		</div>
	</div>
</form>

<script>
	$(document).ready(function() {
		// 중복확인 버튼 클릭
		$('#idCheckBtn').on('click', function() {
			// alert(111);
			// 초기화
			$('#idCheckLength').addClass('d-none');
			$('#idCheckDuplicated').addClass('d-none');
			$('#idCheckOk').addClass('d-none');
			
			let loginId = $('#loginId').val().trim();
			
			if (loginId.length < 4) {
				$('#idCheckLength').removeClass('d-none');
				return;
			}
			
			$.ajax({
				url:"/user/is_duplicated_id"
				, data:{"loginId":loginId}
			
				, success:function(data) {
					if (data.code == 1) {
						// 데이터 통신 성공
						if (data.result) {
							// 중복
							$('#idCheckDuplicated').removeClass('d-none');
						} else {
							// 사용가능
							$('#idCheckOk').removeClass('d-none');
						}
					} else {
						// 실패
						alert(data.errorMessage);
					}
				}
				, error:function(e) {
					alert("중복확인에 실패했습니다.");
				}
			});
		});
		
		$('#signUpForm').on('submit', function(e) {
			e.preventDefault(); // 서브밋 기능 중단
			
			// validation
			let loginId = $('#loginId').val().trim();
			let password = $('#password').val();
			let passwordCol = $('#passwordCol').val();
			let name = $('#name').val().trim();
			let email = $('#email').val().trim();
			
			if (loginId.length < 1) {
				alert("아이디를 입력하세요");
				return false;
			}
			if (password.length < 1) {
				alert("비밀번호를 입력하세요");
				return false;
			}
			if (password != passwordCol) {
				alert("비밀번호 확인이 잘못됐습니다.");
				return false;
			}
			if (name.length < 1) {
				alert("이름을 입력하세요");
				return false;
			}
			if (email.length < 1) {
				alert("이메일을 입력하세요");
				return false;
			}
			
			// 아이디 중복확이 완료 됐는지 확인 -> idCheckOk d-none을 갖고 있으면 alert
			if ($('#idCheckOk').hasClass('d-none')) {
				alert("아이디 중복확인을 다시 해주세요.");
				return false;
			}
			
			// 서버로 보내는 방법
			// 1) submit
			//$(this)[0].submit(); // 화면이 넘어간다
			
			// 2) ajax
			let url = $(this).attr('action');
			let params = $(this).serialize();	// form태그에 있는 name으로 파라미터들 구성
			
			$.post(url, params)	// request
			.done(function(data) {
				// response
				if (data.code == 1) {
					// 성공
					alert("가입을 환영합니다.");
					location.href = "/user/sign_in_view";
				} else {
					// 실패
					alert(data.errorMessage);
				}
			});
		});
	});
</script>
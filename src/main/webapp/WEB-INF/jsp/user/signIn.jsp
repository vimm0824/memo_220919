<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<form method="post" action="/user/sign_in" id="loginForm">
	<div class="container col-4 border pt-4 mt-4">
		<div>
			<input type="text" name="loginId" id="loginId" class="form-control"
				placeholder="아이디를 입력하세요.">
		</div>
		<div class="mt-2">
			<input type="password" name="password" id="password"
				class="form-control" placeholder="비밀번호를 입력하세요.">
		</div>
		<div class="mt-2">
			<button type="submit" id="signIn" class="btn btn-primary col-12">로그인</button>
		</div>
		<div class="mt-2">
			<a href="/user/sign_up_view" type="button" id="signUp" class="btn btn-secondary col-12">회원가입</a>
		</div>
	</div>
</form>

<script>
	$(document).ready(function() {
		$('#loginForm').on('submit', function(e) {
			// 서브밋 기능 중단
			e.preventDefault();
			
			// validation
			let loginId = $('#loginId').val().trim();
			let password = $('#password').val();
			
			if (loginId.length < 1) {
				alert("아이디를 입력하세요.");
				return false;
			}
			if (password.length < 1) {
				alert("비밀번호를 입력하세요.");
				return false;
			}
			
			// ajax
			let url = $(this).attr('action');
			//console.log(url);
			let params = $(this).serialize();
			//console.log(params);
			
			$.post(url, params)
			.done(function(data) {
				if (data.code == 1) { // 성공
					document.location.href = "/post/post_list_view";
				} else { // 실패
					alert(data.errorMessage);
				}
			});
			
		});
	});
</script>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<form method="post" action="/user/sign_in">
	<div class="container col-4 border pt-4 mt-4">
		<div>
			<input type="text" name="userId" id="userId" class="form-control"
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
			<a href="/user/sign_up_view" type="button" id="signUp"
				class="btn btn-secondary col-12">회원가입</a>
		</div>
	</div>
</form>
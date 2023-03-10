<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="col-12 d-flex">
	<div class="p-4 col-3">
		<a href="/post/post_list_view" class="logo"><h1>메모 게시판</h1></a>
	</div>
	
	<c:if test="${not empty userId}">
		<div class="col-9 d-flex justify-content-end align-items-center">
			<span>${userName}님 안녕하세요.</span>
			<a href="/user/sign_out" class="font-weight-bold">로그아웃</a>
		</div>
	</c:if>
	
	<c:if test="${empty userId}">
		<div class="d-flex justify-content-end align-items-center col-8">
			<a href="/user/sign_in_view" class="btn btn-info">로그인</a>
			<a href="/user/sign_up_view" class="btn btn-secondary">회원가입</a>
		</div>
	</c:if>
</div>
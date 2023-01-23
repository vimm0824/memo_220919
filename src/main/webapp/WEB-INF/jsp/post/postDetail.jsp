<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div class="d-flex justify-content-center">
	<div class="container">
		<input type="text" id="subject" class="form-control"
			placeholder="제목을 입력하세요." value="${post.subject}">
		<textarea class="form-control" id="content" rows="15"
			placeholder="내용을 입력하세요.">${post.content}</textarea>
			
		<%-- 이미지가 있을때만 이미지 영역 추가 --%>
		<c:if test="${not empty post.imagePath}">
		<div class="mt-3">
			<img alt="업로드 이미지" src="${post.imagePath}" width="300">
		</div>
		</c:if>
		<div class="d-flex justify-content-end">
			<input type="file" id="file" accept=".jpg,.jpeg,.png,.gif">
		</div>
		
		<div class="d-flex justify-content-between mt-3">
			<button type="button" id="postListBtn" class="btn btn-dark">삭제</button>
			
			<div>
				<a href="/post/post_list_view" class="btn btn-secondary">목록으로</a>
				<button type="button" id="postCreateBtn" class="btn btn-info">수정</button>
			</div>
		</div>
	</div>
</div>
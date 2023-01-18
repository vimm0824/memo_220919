<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="d-flex justify-content-center">
	<div class="w-50">
		<h1>글 목록</h1>
		
		<table class="table border text-center">
			<thead>
				<tr>
					<th>No.</th>
					<th>제목</th>
					<th>작성날짜</th>
					<th>수정날짜</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="post" items="${result}" varStatus="status">
				<tr>
					<td>${status.count}</td>
					<td>
						<a href="/post/post_detail_view?postId=${post.id}" class="text-dark">${post.subject}</a>
					</td>
					<td>
						<fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd a hh:mm:ss"/>
					</td>
					<td>
						<fmt:formatDate value="${post.updatedAt}" pattern="yyyy-MM-dd a hh:mm:ss"/>
					</td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
		
		<div class="d-flex justify-content-end">
			<a href="/post/post_create_view" class="btn btn-info">글쓰기</a>
		</div>
	</div>
</div>
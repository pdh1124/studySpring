<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- jstl core 쓸때 태그에 c 로 표시. -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- jstl fmt 쓸때 위와 같음. fmt : formatter 형식 맞춰서 표시 -->

<%@ include file="includes/header.jsp"%>
<!-- 헤더를 include 함 -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<h1>로그인처리</h1>
			<h2>${error }</h2>
			<h2>${logout }</h2>
			
			<form method="post" action="/login">
				<div class="form-group">
					<input type="text" name="username" placeholder="userid" class="form-control">
				</div>
				<div class="form-group">
					<input type="password" name="password" placeholder="password" class="form-control">
				</div>
				<div class="form-group">
					<input type="checkbox" name="remember-me"> 자동 로그인
				</div>
				<div class="form-group">
					<input type="submit" value="login">
				</div>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"> 		
			</form>
		</div>
	</div>
</div>

<%@ include file="includes/footer.jsp"%>
<!-- 푸터를 include 함 -->
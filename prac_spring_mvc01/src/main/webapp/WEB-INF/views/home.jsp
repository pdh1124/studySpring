<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- jstl core 쓸때 태그에 c 로 표시. -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- jstl fmt 쓸때 위와 같음. fmt : formatter 형식 맞춰서 표시 -->

<%@ include file="includes/header.jsp"%>
<!-- 헤더를 include 함 -->

<script>
	self.location = "/board/list";
	//home.jsp 로 넘어온다면, 다시 /board/list로 이동
</script>

<%@ include file="includes/footer.jsp"%>
<!-- 푸터를 include 함 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- jstl core 쓸때 태그에 c 로 표시. -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- jstl fmt 쓸때 위와 같음. fmt : formatter 형식 맞춰서 표시 -->
<%@ include file="../includes/header.jsp"%>



<!-- DataTales Example -->
<div class="card shadow mb-4">
   <div class="card-body">
      <div class="table-responsive">
         <div class="panel-heading">Board reding</div>
         <div class="panel-body">
         
         	<div class="form-group">
         		게시물 번호<input class="form-control" name="bno" value='<c:out value="${board.bno}"/>' readonly="readonly">
         	</div>
            
            <div class="form-group">
            	<label>Title</label>
         		<input class="form-control" name="title" value='<c:out value="${board.title}"/>' readonly="readonly">
         	</div>
         	
         	<div class="form-group">
            	<label>Text area</label>
         		<textarea row="3" class="form-control" name="content" readonly="readonly"><c:out value="${board.content}"/></textarea>
         	</div>
         	
         	<div class="form-group">
            	<label>Writer</label>
         		<input class="form-control" name="writer" value='<c:out value="${board.writer}"/>' readonly="readonly">
         	</div>
			
			<button data-oper="modify" class="btn btn-warning">수정</button>
			<button data-oper="list" class="btn btn-info">목록</button>
			
			<!-- 게시물의 번호를 전달하기 위해 폼의 hidden으로 전달 -->
			<form id="operForm" action="/board/modify" method="get">
				<input type="hedden" id="bno" name="bno" value="${board.bno }" /> 
			</form>
			
         </div>
         
      </div>
   </div>
</div>


<%@ include file="../includes/footer.jsp"%>

<script>
	$(document).ready(function() {
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on("click", function(e) {
			operForm.attr("action","/board/modify").submit();
		});
		
		$('button[data-oper="list"]').on("click", function(e) {
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list").submit();
		});
	});
</script>
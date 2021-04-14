<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!-- jstl core 쓸때 태그에 c 로 표시. -->

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!-- jstl fmt 쓸때 위와 같음. fmt : formatter 형식 맞춰서 표시 -->

<%@ include file="../includes/header.jsp"%>
<!-- 헤더를 include 함 -->


<!-- DataTales Example -->
<div class="card shadow mb-4">
    <div class="card-body">
    
    	<div class="card-header py-3" align="right">
    		<button id="regBtn" style="color:green;">write</button>
    	</div>
    
        <div class="table-responsive">
            <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>#번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>수정일</th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach var="board" items="${list }">
	                    <tr>
	                        <td><c:out value="${board.bno }" /></td>
	                        <td><c:out value="${board.title }" /></td>
	                        <td><c:out value="${board.writer }" /></td>
	                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate }" /></td>
	                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }" /></td>
	                    </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header"></div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<button class="btn btn-primary" type="button" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		$('#dataTable').DataTable({
			"order" : [ [0, "desc"] ], //정렬 0컬럼의 내림차순으로
			"paging" : false, //페이지 표시 안함.
			"bFilter" : false, //검색창 표시 안함.
			"info" : false //안내창 표시 안함
		});
		
		$('#regBtn').on("click", function() {
			self.location = "/board/register";
			/*아이디 regBtn을 클릭한다면 현재창의 url를 쓰기로 변경*/
		});
		
		var result = '<c:out value="${result}" />';
		//자바스크립트는 형추론 이용. => 변수를 지정할때 자료형(int, long 등등)을 따로 지정하지 않음
		checkModal(result);
		//게시물 번호를 매개변수로 전달하면서 checkModal 메소드 호출
		
		function checkModal(result) {
			if (result === '') {
				// == 는 값만 비교, === 은 값과 형식도 비교
				return;
			}
			if (parseInt(result) > 0) { //전달된 문자값을 숫자화, 자바의 Integer.parseInt와 비슷함.
				$(".modal-body").html("게시글" + parseInt(result) + "번이 등록"); //표시할 내용 만들기
			}
			$("#myModal").modal("show"); //모달창 표시
		}
	});
</script>

<%@ include file="../includes/footer.jsp"%>
<!-- 푸터를 include 함 -->
                
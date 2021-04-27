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
         <div class="panel-heading">Board Register</div>
         <div class="panel-body">
            <form role="form" action="/board/register" 
            method="post">
            
               <div class="form-group">
                  <label>Title</label> 
                  <input class="form-control" name='title'>
               </div>

               <div class="form-group">
                  <label>Text area</label>
                  <textarea class="form-control" rows="3" 
                  name='content'></textarea>
               </div>
               
               <div class="form-group">
                  <label>Writer</label> 
                  <input class="form-control" name="writer">
               </div>
               
               <button type="submit" class="btn btn-default">
               Submit Button</button>
               <button type="reset" class="btn btn-default">
               Reset Button</button>
            
            </form>
         </div>
         
      </div>
   </div>
</div>

<br />
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading"></div>
			<div class="panel-body">
				<!-- 파일을 입력(첨부)하는 부분 -->
				<div clss="form-group uploadDiv">
					파일 첨부 : <input type="file" name="uploadFile" multiple>
				</div>
				<!-- 파일 첨부한 것을 보여주는 부분 -->
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>

<%@ include file="../includes/footer.jsp"%>
/**
 * 
 */console.log("Reply module.....55");

//ajax처리
var replyService = (function() { //자바스크립트는 함수를 변수에 할당 가능.
	function add(reply, callback, error) {
	// reply : 댓글 객체,
	// callback : 댓글 등록후 수행할 메소드 . 비동기
	// 주문과 동시에 처리할 내용도 전달. 페이지 이동없이 새로운 내용 갱신.
	console.log("add reply......");
	
		$.ajax({
			type: 'post',
			url: '/replies/new',
			data: JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr) {
				if (callback) {
					callback(result)
				}
				// result와 status 차이는? 없음
				// xhr 이 다 가지고 있음. status 와 responseText
				// xhr : XMLHttpReuqest의 약자
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}	
		});
	}
	
	//댓글 목록 가져오기
	function getList(param, callback, error) {
		console.log("getList......");
		var bno = param.bno;
		var page = param.page || 1;
		//페이지 번호가 있으면 페이지 번호 전달 없으면 1 전달.
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",				
				function(data) {	
					if (callback) {
						callback(data.replyCnt, data.list);
					}
				}).fail(function(xhr, status, err) {
			// xhr : xml http request의 약자.
			// 현재는 사용되지 않고, 형식만 맞춰줌.
			if (error) {
				error(er);
			}
		});
	}
	
	//gmt를 년월일시분초로 바꾸는 함수
	function displayTime(timeValue) {
		var today = new Date();  //현재시간
		var gap = today.getTime() - timeValue; //시간차이 연산
		var dateObj = new Date(timeValue); //댓글이 등록된 시간을 변수에 할당
		var str = ""; //화면에 꾸릴 준비
		
		if(gap<(1000*60*60*24)) {
			//시간차이가 24시간이 넘어가지 않았다면, 시분초 표시
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh>9?'':'0')+hh, ':', (mi>9?'':'0')+mi, ':',(ss>9?'':'0')+ss].join('');
			//join :배열 요소를 문자열로 변환. 문자열로 해야 01에 0을 표시 할 수 있음
			//시간에 포맷을 맞추기 위해서
			//0~9까지는 앞에 0을 추가 표시. 1시 -> 01시, 8분-> 08분 으로 만들기
		} else {
			//시간차이가 24시간이 넘어갔다면, 년월일 표시
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth()+1;
			var dd = dateObj.getDate();
			
			return [yy,'/',(mm>9?'':'0')+mm,'/',(dd>9?'':'0')+dd].join('');
		}
	}
	
	// 댓글 수정.
	function update(reply, callback, error) {
		console.log("rno: " + reply.rno);
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json;charset=utf-8",
			success : function(result, status, xhr) {
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if(error) {
					error(er);
				}
			}
		});
	}
	
	//댓글 읽기
	function get(rno, callback, error) {
		$.get("/replies/" + rno + ".json", function(result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, er) {
			if(error) {
				error(er);
			}
		})
	}
	
	//댓글 삭제
	function remove(rno, replyer, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			data:JSON.stringify({rno:rno,replyer:replyer}),
			contentType : "application/json; charset=utf-8",
			success : function(deleteResult, status, xhr) {
				if(callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}
	
	return {
	// 변수명,호출명 예) replyService.add
	// 함수를 지정해주고 호출해줘야 실행이 된다.
		add: add,
		getList: getList,
		displayTime: displayTime,
		update: update,
		get: get,
		remove : remove
	};
})(); // 즉시 실행 함수 : 끝부분이 ();식으로 끝나면 명시하는 것과 동시에 메모리에 등록

// 자바 스크립트는 함수도 변수에 할당 가능함.
// 자바 람다식도 함수를 변수에 할당
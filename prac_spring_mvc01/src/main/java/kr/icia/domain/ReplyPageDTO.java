package kr.icia.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

//@Getter 위치가 중요함 : 초기화 후 호출해야하기 때문에. 생략하면 호출하고 초기화하여 오류가 발생함
@Data
@AllArgsConstructor
@Getter
public class ReplyPageDTO {
	private int replyCnt; //댓글의 갯수 replyTotalCnt가 더 어울림.
	private List<ReplyVO> list; //댓글의 목록
	
	// setter나 getter의 위치는 사실 관계없음.
	// 하지만, 호출 타이밍이 달라진다면 관계 있음.
	// 어느테이션이 위에서 부터 순차적으로 적용 된다면,
	// 잭체의 초기화와 호출 타이밍이 달라짐.
}

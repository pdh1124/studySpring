package kr.icia.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import kr.icia.domain.Criteria;
import kr.icia.domain.ReplyVO;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	private Long[] bnoArr = {161L, 162L, 163L, 164L, 165L};
	// 실제 게시물의 번호 5개 할당.
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
//	@Test
//	public void testCreate() {
//		//게시물 1개당 2개의 댓글 자동 등록.
//		//IntStream.rangeClosed(1, 10) : 정수형을 스트림 형태로 전환. 범위 1~10
//		//1에서 10까지 i값에 대입해서 반복해라
//		IntStream.rangeClosed(1, 10).forEach(i -> {
//			ReplyVO vo = new ReplyVO();
//			
//			vo.setBno(bnoArr[i % 5]); // 0 ~ 4
//			vo.setReply("댓글 테스트" + i);
//			vo.setReplyer("replyer" + i);
//			
//			mapper.insert(vo);
//		});
//	}
	
	@Test
	public void testList2() {
		Criteria cri = new Criteria(2,10); //(1,2)
		
		List<ReplyVO> replies = mapper.getListWithPaging(cri, 1L);
		//1L 은 게시물 번호.
		
		replies.forEach(reply->log.info(reply));
	}
}

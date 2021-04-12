package kr.icia.mapper;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.Setter;


public class BoardMapperTests {
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Test
	public void testGetList() {
		mapper.getList().forEach(board -> log.info(board));
		// 향상된 for : 배열과 배열 1개를 담을 변수
		// 담다식 : -> 를 기준으로 좌항은 전달값, 우항은 처리
		// 목록은 게시물 여러개(배열), 그중 1개를 board에 담은 다음에 해당 내용을 로그로 출력. 배열 원소가 끝날때 까지 반복
	}
}
